import { createHash, randomBytes } from 'node:crypto'
import type { H3Event } from 'h3'

export const SESSION_COOKIE = 'dwn_admin_session'

export function hashToken(token: string) {
  return createHash('sha256').update(token).digest('hex')
}

export function createSessionToken() {
  return randomBytes(32).toString('hex')
}

export async function requireAdmin(event: H3Event) {
  const token = getCookie(event, SESSION_COOKIE)
  if (!token) {
    throw createError({ statusCode: 401, statusMessage: 'Not logged in' })
  }

  const rows = await dbQuery<{ id: number; username: string; name: string | null }>(
    `SELECT u.id, u.username, u.name
     FROM admin_sessions s
     JOIN admin_users u ON u.id = s.admin_user_id
     WHERE s.token_hash = :tokenHash
       AND s.expires_at > NOW()
       AND u.active = 1
     LIMIT 1`,
    { tokenHash: hashToken(token) }
  )

  if (!rows.length) {
    deleteCookie(event, SESSION_COOKIE, { path: '/' })
    throw createError({ statusCode: 401, statusMessage: 'Session expired' })
  }

  return rows[0]
}
