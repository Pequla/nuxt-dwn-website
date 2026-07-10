export default defineEventHandler(async (event) => {
  const slug = String(getRouterParam(event, 'slug') || '')
  const id = Number(slug.split('-')[0])

  const rows = await dbQuery(
    `SELECT id, slug, client, title, excerpt, body, image_media_id, embed_html, category, secondary_category,
            metric1_value, metric1_label, metric2_value, metric2_label,
            featured, show_home, published, sort_order
     FROM case_studies
     WHERE (slug = :slug OR (:id > 0 AND id = :id)) AND published = 1
     LIMIT 1`,
    { slug, id: Number.isFinite(id) ? id : 0 }
  )

  if (!rows.length) {
    throw createError({ statusCode: 404, statusMessage: 'Case study not found' })
  }

  return { caseStudy: rows[0] }
})
