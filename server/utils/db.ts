import mysql from 'mysql2/promise'

let pool: mysql.Pool | null = null

export function useDb() {
  if (pool) return pool

  const config = useRuntimeConfig()
  pool = mysql.createPool({
    host: config.dbHost,
    port: Number(config.dbPort),
    user: config.dbUser,
    password: config.dbPassword,
    database: config.dbName,
    waitForConnections: true,
    connectionLimit: 10,
    namedPlaceholders: true,
    timezone: 'Z'
  })

  return pool
}

export async function dbQuery<T>(sql: string, params: Record<string, unknown> = {}) {
  const [rows] = await useDb().execute(sql, params)
  return rows as T[]
}
