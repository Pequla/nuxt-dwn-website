import { requireAdmin } from '../../utils/auth'
import { groupSections, type ContentItemRow, type ContentSectionRow } from '../../utils/content'

export default defineEventHandler(async (event) => {
  await requireAdmin(event)

  const sections = await dbQuery<ContentSectionRow>(
    `SELECT section_key, eyebrow, title, subtitle, body, cta_label, cta_url, enabled, sort_order
     FROM content_sections
     ORDER BY sort_order ASC`
  )

  const items = await dbQuery<ContentItemRow>(
    `SELECT id, section_key, title, subtitle, body, icon, label, value, url, image_media_id, meta_json, enabled, sort_order
     FROM content_items
     ORDER BY section_key ASC, sort_order ASC, id ASC`
  )

  return { sections: groupSections(sections, items) }
})
