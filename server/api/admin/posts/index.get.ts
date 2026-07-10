import { requireAdmin } from '../../../utils/auth'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)

  const posts = await dbQuery(
    `SELECT id, slug, title, excerpt, body, image_media_id, embed_html, category, emoji, read_time,
            DATE_FORMAT(published_at, '%Y-%m-%d') AS published_at,
            show_home, published, sort_order
     FROM posts
     ORDER BY sort_order ASC, id DESC`
  )

  return { posts }
})
