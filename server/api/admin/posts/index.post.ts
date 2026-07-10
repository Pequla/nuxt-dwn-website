import { requireAdmin } from '../../../utils/auth'
import { slugify } from '../../../utils/slug'
import { normalizeEmbedHtml } from '../../../utils/embed'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
  const body = await readBody<Record<string, any>>(event)
  const title = String(body.title || '').trim()

  if (!title) {
    throw createError({ statusCode: 400, statusMessage: 'Title is required' })
  }

  const slug = String(body.slug || slugify(title)).trim()

  await dbQuery(
    `INSERT INTO posts
      (slug, title, excerpt, body, image_media_id, embed_html, category, emoji, read_time, published_at, show_home, published, sort_order)
     VALUES
      (:slug, :title, :excerpt, :body, :imageMediaId, :embedHtml, :category, :emoji, :readTime, :publishedAt, :showHome, :published, :sortOrder)`,
    {
      slug,
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
      published: body.published === false ? 0 : 1,
      sortOrder: Number(body.sort_order || 0)
    }
  )

  return { ok: true }
})
