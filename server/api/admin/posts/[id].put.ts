import { requireAdmin } from '../../../utils/auth'
import { slugify } from '../../../utils/slug'
import { normalizeEmbedHtml } from '../../../utils/embed'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
  const id = Number(getRouterParam(event, 'id'))
  const body = await readBody<Record<string, any>>(event)
  const title = String(body.title || '').trim()

  if (!id || !title) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid post' })
  }

  await dbQuery(
    `UPDATE posts
     SET slug = :slug,
         title = :title,
         excerpt = :excerpt,
         body = :body,
         image_media_id = :imageMediaId,
         embed_html = :embedHtml,
         category = :category,
         emoji = :emoji,
         read_time = :readTime,
         published_at = :publishedAt,
         show_home = :showHome,
         published = :published,
         sort_order = :sortOrder
     WHERE id = :id`,
    {
      id,
      slug: String(body.slug || slugify(title)).trim(),
      title,
      excerpt: String(body.excerpt || ''),
      body: String(body.body || ''),
      imageMediaId: body.image_media_id || null,
      embedHtml: normalizeEmbedHtml(body.embed_html),
      category: String(body.category || 'Neuromarketing'),
      emoji: String(body.emoji || '🧠'),
      readTime: Number(body.read_time || 5),
      publishedAt: body.published_at || null,
      showHome: body.show_home ? 1 : 0,
      published: body.published ? 1 : 0,
      sortOrder: Number(body.sort_order || 0)
    }
  )

  return { ok: true }
})
