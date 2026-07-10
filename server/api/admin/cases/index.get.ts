import { requireAdmin } from '../../../utils/auth'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)

  const cases = await dbQuery(
    `SELECT id, slug, client, title, excerpt, body, image_media_id, embed_html, category, secondary_category,
            metric1_value, metric1_label, metric2_value, metric2_label,
            featured, show_home, published, sort_order
     FROM case_studies
     ORDER BY sort_order ASC, id DESC`
  )

  return { cases }
})
