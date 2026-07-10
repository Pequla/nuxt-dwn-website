import { requireAdmin } from '../../../utils/auth'
import { slugify } from '../../../utils/slug'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
  const body = await readBody<Record<string, any>>(event)
  const title = String(body.title || '').trim()

  if (!title) {
    throw createError({ statusCode: 400, statusMessage: 'Title is required' })
  }

  await dbQuery(
    `INSERT INTO case_studies
      (slug, client, title, excerpt, body, image_media_id, embed_html, category, secondary_category,
       metric1_value, metric1_label, metric2_value, metric2_label,
       featured, show_home, published, sort_order)
     VALUES
      (:slug, :client, :title, :excerpt, :body, :imageMediaId, :embedHtml, :category, :secondaryCategory,
       :metric1Value, :metric1Label, :metric2Value, :metric2Label,
       :featured, :showHome, :published, :sortOrder)`,
    {
      slug: String(body.slug || slugify(title)).trim(),
      client: String(body.client || ''),
      title,
      excerpt: String(body.excerpt || ''),
      body: String(body.body || ''),
      imageMediaId: body.image_media_id || null,
      embedHtml: body.embed_html || null,
      category: String(body.category || 'TikTok'),
      secondaryCategory: body.secondary_category || null,
      metric1Value: body.metric1_value || null,
      metric1Label: body.metric1_label || null,
      metric2Value: body.metric2_value || null,
      metric2Label: body.metric2_label || null,
      featured: body.featured ? 1 : 0,
      showHome: body.show_home ? 1 : 0,
      published: body.published === false ? 0 : 1,
      sortOrder: Number(body.sort_order || 0)
    }
  )

  return { ok: true }
})
