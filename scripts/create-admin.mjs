import mysql from 'mysql2/promise'
import { randomBytes, scryptSync } from 'node:crypto'
import readline from 'node:readline/promises'
import { stdin as input, stdout as output } from 'node:process'

const rl = readline.createInterface({ input, output })

const username = (await rl.question('Admin username: ')).trim()
const password = await rl.question('Admin password: ')
const name = (await rl.question('Display name: ')).trim()
rl.close()

if (!username || !password) {
  console.error('Username and password are required.')
  process.exit(1)
}

const connection = await mysql.createConnection({
  host: process.env.DB_HOST || '127.0.0.1',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'dwn_site'
})

const salt = randomBytes(16).toString('hex')
const passwordHash = `scrypt$${salt}$${scryptSync(password, salt, 64).toString('hex')}`

await connection.execute(
  `INSERT INTO admin_users (username, password_hash, name)
   VALUES (?, ?, ?)
   ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash), name = VALUES(name), active = 1`,
  [username, passwordHash, name || username]
)

await connection.end()
console.log('Admin user saved.')
