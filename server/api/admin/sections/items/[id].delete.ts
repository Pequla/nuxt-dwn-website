import { requireAdmin } from '../../../../utils/auth'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
  const id = Number(getRouterParam(event, 'id'))

  if (!id) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid item' })
  }

  await dbQuery('DELETE FROM content_items WHERE id = :id', { id })
  return { ok: true }
})
