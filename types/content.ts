export type Post = {
  id: number
  slug: string
  title: string
  excerpt: string
  body?: string | null
  image_media_id?: number | null
  embed_html?: string | null
  category: string
  emoji?: string | null
  read_time: number
  published_at?: string | null
  show_home: boolean | number
  published: boolean | number
  sort_order: number
}

export type CaseStudy = {
  id: number
  slug: string
  client: string
  title: string
  excerpt: string
  body?: string | null
  image_media_id?: number | null
  embed_html?: string | null
  category: string
  secondary_category?: string | null
  metric1_value?: string | null
  metric1_label?: string | null
  metric2_value?: string | null
  metric2_label?: string | null
  featured: boolean | number
  show_home: boolean | number
  published: boolean | number
  sort_order: number
}
