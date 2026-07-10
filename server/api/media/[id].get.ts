export default defineEventHandler(async (event) => {
  const id = Number(getRouterParam(event, 'id'))

  if (!id) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid media id' })
  }

  const rows = await dbQuery<{ filename: string; mime_type: string; data: Buffer }>(
    'SELECT filename, mime_type, data FROM media_files WHERE id = :id LIMIT 1',
    { id }
  )

  const media = rows[0]
  if (!media) {
    throw createError({ statusCode: 404, statusMessage: 'Media not found' })
  }

  setHeader(event, 'Content-Type', media.mime_type)
  setHeader(event, 'Cache-Control', 'public, max-age=31536000, immutable')
  setHeader(event, 'Content-Disposition', `inline; filename="${media.filename.replace(/"/g, '')}"`)

  return media.data
})
