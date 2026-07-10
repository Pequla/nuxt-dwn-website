export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const homeOnly = query.home === '1'
  const category = String(query.category || '')

  const rows = await dbQuery(
    `SELECT id, slug, client, title, excerpt, body, image_media_id, embed_html, category, secondary_category,
            metric1_value, metric1_label, metric2_value, metric2_label,
            featured, show_home, published, sort_order
     FROM case_studies
     WHERE published = 1
       AND (:homeOnly = 0 OR show_home = 1)
       AND (:category = '' OR category = :category OR secondary_category = :category)
     ORDER BY featured DESC, sort_order ASC, id DESC`,
    { homeOnly: homeOnly ? 1 : 0, category }
  )

  return { cases: rows }
})
