import { slugify } from '../utils/slug'

function escapeXml(value: string) {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;')
}

function urlEntry(baseUrl: string, path: string, priority = '0.7') {
  return [
    '  <url>',
    `    <loc>${escapeXml(`${baseUrl}${path}`)}</loc>`,
    `    <priority>${priority}</priority>`,
    '  </url>'
  ].join('\n')
}

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const baseUrl = String(config.public.siteUrl || 'https://new.digitalwithneuro.com').replace(/\/$/, '')

  const posts = await dbQuery<{ slug: string }>(
    'SELECT slug FROM posts WHERE published = 1 ORDER BY sort_order ASC, id DESC'
  )
  const cases = await dbQuery<{ id: number; title: string; slug: string | null }>(
    'SELECT id, title, slug FROM case_studies WHERE published = 1 ORDER BY sort_order ASC, id DESC'
  )
  const clients = await dbQuery<{ id: number; title: string }>(
    `SELECT id, title
     FROM content_items
     WHERE section_key = 'clients' AND enabled = 1
     ORDER BY sort_order ASC, id ASC`
  )

  const entries = [
    urlEntry(baseUrl, '/', '1.0'),
    urlEntry(baseUrl, '/blog', '0.8'),
    urlEntry(baseUrl, '/cases', '0.8'),
    urlEntry(baseUrl, '/clients', '0.7'),
    ...posts.map(post => urlEntry(baseUrl, `/blog/${post.slug}`, '0.7')),
    ...cases.map(item => urlEntry(baseUrl, `/cases/${item.id}-${slugify(item.title || item.slug || 'case')}`, '0.7')),
    ...clients.map(item => urlEntry(baseUrl, `/clients/${item.id}-${slugify(item.title)}`, '0.7'))
  ]

  setHeader(event, 'Content-Type', 'application/xml; charset=utf-8')

  return [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">',
    entries.join('\n'),
    '</urlset>'
  ].join('\n')
})
