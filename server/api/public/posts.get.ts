export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const homeOnly = query.home === '1'
  const category = String(query.category || '')

  const rows = await dbQuery(
    `SELECT id, slug, title, excerpt, body, image_media_id, embed_html, category, emoji, read_time,
            DATE_FORMAT(published_at, '%Y-%m-%d') AS published_at,
            show_home, published, sort_order
     FROM posts
     WHERE published = 1
       AND (:homeOnly = 0 OR show_home = 1)
       AND (:category = '' OR category = :category)
     ORDER BY sort_order ASC, published_at DESC, id DESC`,
    { homeOnly: homeOnly ? 1 : 0, category }
  )

  return { posts: rows }
})
