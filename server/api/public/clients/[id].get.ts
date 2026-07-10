export default defineEventHandler(async (event) => {
  const rawId = String(getRouterParam(event, 'id') || '')
  const id = Number(rawId.split('-')[0])

  if (!id) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid client id' })
  }

  const rows = await dbQuery(
    `SELECT id, section_key, title, subtitle, body, icon, label, value, url, image_media_id, meta_json, enabled, sort_order
     FROM content_items
     WHERE id = :id AND section_key = 'clients' AND enabled = 1
     LIMIT 1`,
    { id }
  )

  if (!rows.length) {
    throw createError({ statusCode: 404, statusMessage: 'Client not found' })
  }

  return { client: rows[0] }
})
