import { requireAdmin } from '../../../utils/auth'
import { slugify } from '../../../utils/slug'
import { normalizeEmbedHtml } from '../../../utils/embed'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
  const id = Number(getRouterParam(event, 'id'))
  const body = await readBody<Record<string, any>>(event)
  const title = String(body.title || '').trim()

  if (!id || !title) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid case study' })
  }

  await dbQuery(
    `UPDATE case_studies
     SET slug = :slug,
         client = :client,
         title = :title,
         excerpt = :excerpt,
         body = :body,
         image_media_id = :imageMediaId,
         embed_html = :embedHtml,
         category = :category,
         secondary_category = :secondaryCategory,
         metric1_value = :metric1Value,
         metric1_label = :metric1Label,
         metric2_value = :metric2Value,
         metric2_label = :metric2Label,
         featured = :featured,
         show_home = :showHome,
         published = :published,
         sort_order = :sortOrder
     WHERE id = :id`,
    {
      id,
      slug: String(body.slug || slugify(title)).trim(),
      client: String(body.client || ''),
      title,
      excerpt: String(body.excerpt || ''),
      body: String(body.body || ''),
      imageMediaId: body.image_media_id || null,
      embedHtml: normalizeEmbedHtml(body.embed_html),
      category: String(body.category || 'TikTok'),
      secondaryCategory: body.secondary_category || null,
      metric1Value: body.metric1_value || null,
      metric1Label: body.metric1_label || null,
      metric2Value: body.metric2_value || null,
      metric2Label: body.metric2_label || null,
      featured: body.featured ? 1 : 0,
      showHome: body.show_home ? 1 : 0,
      published: body.published ? 1 : 0,
      sortOrder: Number(body.sort_order || 0)
    }
  )

  return { ok: true }
})
