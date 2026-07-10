export default defineNuxtConfig({
  compatibilityDate: '2026-06-20',
  devServer: {
    port: 3301
  },
  css: ['~/assets/css/main.css'],
  app: {
    head: {
      title: 'DWN :: Reklamna Agencija',
      link: [
        { rel: 'icon', href: '/favicon.ico', sizes: 'any' },
        { rel: 'icon', type: 'image/png', href: '/favicon.png' },
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Syne:wght@400;700;800&display=swap'
        }
      ]
    }
  },
  runtimeConfig: {
    dbHost: process.env.DB_HOST || '127.0.0.1',
    dbPort: Number(process.env.DB_PORT || 3306),
    dbUser: process.env.DB_USER || 'root',
    dbPassword: process.env.DB_PASSWORD || '',
    dbName: process.env.DB_NAME || 'dwn_site',
    sessionDays: Number(process.env.SESSION_DAYS || 14),
    public: {
      siteUrl: process.env.NUXT_PUBLIC_SITE_URL || 'http://localhost:3000'
    }
  }
})
