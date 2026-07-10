import { requireAdmin } from '../../../utils/auth'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
  const sectionKey = String(getRouterParam(event, 'key') || '')
  const body = await readBody<Record<string, any>>(event)

  if (!sectionKey || !body.title) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid section' })
  }

  await dbQuery(
    `UPDATE content_sections
     SET eyebrow = :eyebrow,
         title = :title,
         subtitle = :subtitle,
         body = :body,
         cta_label = :ctaLabel,
         cta_url = :ctaUrl,
         enabled = :enabled,
         sort_order = :sortOrder
     WHERE section_key = :sectionKey`,
    {
      sectionKey,
      eyebrow: body.eyebrow || null,
      title: String(body.title || ''),
      subtitle: body.subtitle || null,
      body: body.body || null,
      ctaLabel: body.cta_label || null,
      ctaUrl: body.cta_url || null,
      enabled: body.enabled ? 1 : 0,
      sortOrder: Number(body.sort_order || 0)
    }
  )

  const items = Array.isArray(body.items) ? body.items : []

  for (const item of items) {
    const payload = {
      sectionKey,
      title: String(item.title || ''),
      subtitle: item.subtitle || null,
      body: item.body || null,
      icon: item.icon || null,
      label: item.label || null,
      value: item.value || null,
      url: item.url || null,
      imageMediaId: item.image_media_id || null,
      metaJson: item.meta_json ? JSON.stringify(item.meta_json) : null,
      enabled: item.enabled ? 1 : 0,
      sortOrder: Number(item.sort_order || 0)
    }

    if (item.id) {
      await dbQuery(
        `UPDATE content_items
         SET title = :title,
             subtitle = :subtitle,
             body = :body,
             icon = :icon,
             label = :label,
             value = :value,
             url = :url,
             image_media_id = :imageMediaId,
             meta_json = :metaJson,
             enabled = :enabled,
             sort_order = :sortOrder
         WHERE id = :id AND section_key = :sectionKey`,
        { ...payload, id: Number(item.id) }
      )
    } else if (payload.title) {
      await dbQuery(
        `INSERT INTO content_items
          (section_key, title, subtitle, body, icon, label, value, url, image_media_id, meta_json, enabled, sort_order)
         VALUES
          (:sectionKey, :title, :subtitle, :body, :icon, :label, :value, :url, :imageMediaId, :metaJson, :enabled, :sortOrder)`,
        payload
      )
    }
  }

  return { ok: true }
})
