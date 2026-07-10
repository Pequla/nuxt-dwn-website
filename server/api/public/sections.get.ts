import { groupSections, type ContentItemRow, type ContentSectionRow } from '../../utils/content'

export default defineEventHandler(async () => {
  const sections = await dbQuery<ContentSectionRow>(
    `SELECT section_key, eyebrow, title, subtitle, body, cta_label, cta_url, enabled, sort_order
     FROM content_sections
     WHERE enabled = 1
     ORDER BY sort_order ASC`
  )

  const items = await dbQuery<ContentItemRow>(
    `SELECT id, section_key, title, subtitle, body, icon, label, value, url, image_media_id, meta_json, enabled, sort_order
     FROM content_items
     WHERE enabled = 1
     ORDER BY section_key ASC, sort_order ASC, id ASC`
  )

  return { sections: groupSections(sections, items) }
})
