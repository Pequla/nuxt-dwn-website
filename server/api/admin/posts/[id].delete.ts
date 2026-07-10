import { requireAdmin } from '../../../utils/auth'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
  const id = Number(getRouterParam(event, 'id'))

  if (!id) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid post' })
  }

  await dbQuery('DELETE FROM posts WHERE id = :id', { id })
  return { ok: true }
})
