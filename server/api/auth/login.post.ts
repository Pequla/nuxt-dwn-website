import { SESSION_COOKIE, createSessionToken, hashToken } from '../../utils/auth'
import { verifyPassword } from '../../utils/password'

export default defineEventHandler(async (event) => {
  const body = await readBody<{ username?: string; password?: string }>(event)
  const username = String(body.username || '').trim()
  const password = String(body.password || '')

  if (!username || !password) {
    throw createError({ statusCode: 400, statusMessage: 'Username and password are required' })
  }

  const users = await dbQuery<{ id: number; username: string; password_hash: string; name: string | null }>(
    'SELECT id, username, password_hash, name FROM admin_users WHERE username = :username AND active = 1 LIMIT 1',
    { username }
  )

  const user = users[0]
  if (!user || !verifyPassword(password, user.password_hash)) {
    throw createError({ statusCode: 401, statusMessage: 'Wrong username or password' })
  }

  const config = useRuntimeConfig()
  const token = createSessionToken()
  const expires = new Date(Date.now() + Number(config.sessionDays) * 24 * 60 * 60 * 1000)

  await dbQuery(
    'INSERT INTO admin_sessions (admin_user_id, token_hash, expires_at) VALUES (:userId, :tokenHash, :expiresAt)',
    { userId: user.id, tokenHash: hashToken(token), expiresAt: expires }
  )

  setCookie(event, SESSION_COOKIE, token, {
    httpOnly: true,
    sameSite: 'lax',
    secure: process.env.NODE_ENV === 'production',
    path: '/',
    expires
  })

  return { ok: true, user: { id: user.id, username: user.username, name: user.name } }
})
