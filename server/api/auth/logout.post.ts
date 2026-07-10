import { SESSION_COOKIE, hashToken } from '../../utils/auth'

export default defineEventHandler(async (event) => {
  const token = getCookie(event, SESSION_COOKIE)

  if (token) {
    await dbQuery('DELETE FROM admin_sessions WHERE token_hash = :tokenHash', {
      tokenHash: hashToken(token)
    })
  }

  deleteCookie(event, SESSION_COOKIE, { path: '/' })
  return { ok: true }
})
