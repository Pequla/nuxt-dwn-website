export type ContentSectionRow = {
  section_key: string
  eyebrow: string | null
  title: string
  subtitle: string | null
  body: string | null
  cta_label: string | null
  cta_url: string | null
  enabled: number
  sort_order: number
}

export type ContentItemRow = {
  id: number
  section_key: string
  title: string
  subtitle: string | null
  body: string | null
  icon: string | null
  label: string | null
  value: string | null
  url: string | null
  image_media_id: number | null
  meta_json: any
  enabled: number
  sort_order: number
}

export function groupSections(sections: ContentSectionRow[], items: ContentItemRow[]) {
  return sections.map(section => ({
    ...section,
    items: items
      .filter(item => item.section_key === section.section_key)
      .map(item => ({
        ...item,
        meta_json: typeof item.meta_json === 'string'
          ? JSON.parse(item.meta_json || '{}')
          : item.meta_json
      }))
  }))
}
