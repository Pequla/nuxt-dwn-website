import { requireAdmin } from '../../utils/auth'

export default defineEventHandler(async (event) => {
  const user = await requireAdmin(event)
  return { user }
})
