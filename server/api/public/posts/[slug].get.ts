export default defineEventHandler(async (event) => {
  const slug = String(getRouterParam(event, 'slug') || '')

  const rows = await dbQuery(
    `SELECT id, slug, title, excerpt, body, image_media_id, embed_html, category, emoji,
            read_time, DATE_FORMAT(published_at, '%Y-%m-%d') AS published_at,
            show_home, published, sort_order
     FROM posts
     WHERE slug = :slug AND published = 1
     LIMIT 1`,
    { slug }
  )

  if (!rows.length) {
    throw createError({ statusCode: 404, statusMessage: 'Post not found' })
  }

  return { post: rows[0] }
})
