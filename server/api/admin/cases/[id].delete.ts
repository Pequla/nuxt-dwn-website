import { requireAdmin } from '../../../utils/auth'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)
  const id = Number(getRouterParam(event, 'id'))

  if (!id) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid case study' })
  }

  await dbQuery('DELETE FROM case_studies WHERE id = :id', { id })
  return { ok: true }
})
