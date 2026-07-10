import { requireAdmin } from '../../utils/auth'
import { useDb } from '../../utils/db'

const ALLOWED_IMAGE_TYPES = new Set([
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/gif',
  'image/svg+xml'
])

export default defineEventHandler(async (event) => {
  await requireAdmin(event)

  const form = await readMultipartFormData(event)
  const file = form?.find(part => part.name === 'file')

  if (!file?.data?.length) {
    throw createError({ statusCode: 400, statusMessage: 'File is required' })
  }

  const mimeType = file.type || 'application/octet-stream'
  if (!ALLOWED_IMAGE_TYPES.has(mimeType)) {
    throw createError({ statusCode: 400, statusMessage: 'Only image files are allowed' })
  }

  if (file.data.length > 5 * 1024 * 1024) {
    throw createError({ statusCode: 400, statusMessage: 'Image must be smaller than 5 MB' })
  }

  const filename = file.filename || 'upload'

  const [result] = await useDb().execute(
    `INSERT INTO media_files (filename, mime_type, size_bytes, data)
     VALUES (:filename, :mimeType, :sizeBytes, :data)`,
    {
      filename,
      mimeType,
      sizeBytes: file.data.length,
      data: file.data
    }
  )

  const insertId = (result as any).insertId

  return { id: insertId, url: `/api/media/${insertId}` }
})
