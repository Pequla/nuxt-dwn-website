function escapeAttr(value: string) {
  return value.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

function isLikelyHtml(value: string) {
  return /<\s*(iframe|blockquote|script|video|blockquote|div|p|blockquote|blockquote)/i.test(value)
}

function getYoutubeId(url: URL) {
  if (url.hostname.includes('youtu.be')) return url.pathname.replace('/', '').split(/[?&]/)[0]
  if (url.hostname.includes('youtube.com')) {
    if (url.pathname.startsWith('/shorts/')) return url.pathname.split('/')[2]
    if (url.pathname.startsWith('/embed/')) return url.pathname.split('/')[2]
    return url.searchParams.get('v')
  }
  return null
}

export function normalizeEmbedHtml(input: unknown) {
  const raw = String(input || '').trim()
  if (!raw) return null

  if (isLikelyHtml(raw)) return raw

  try {
    const url = new URL(raw)
    const href = escapeAttr(url.toString())
    const host = url.hostname.replace(/^www\./, '')

    if (host.includes('tiktok.com')) {
      return `<blockquote class="tiktok-embed" cite="${href}" data-video-id="" style="max-width: 605px; min-width: 325px;"><section><a target="_blank" rel="noreferrer" href="${href}">TikTok video</a></section></blockquote>`
    }

    if (host.includes('instagram.com')) {
      return `<blockquote class="instagram-media" data-instgrm-permalink="${href}" data-instgrm-version="14" style="background:#fff; border:0; border-radius:12px; box-shadow:none; margin: 1px; max-width:540px; min-width:326px; padding:0; width:100%;"></blockquote>`
    }

    const youtubeId = getYoutubeId(url)
    if (youtubeId) {
      const safeId = escapeAttr(youtubeId)
      return `<iframe src="https://www.youtube.com/embed/${safeId}" title="YouTube video" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>`
    }

    if (host.includes('vimeo.com')) {
      const id = url.pathname.split('/').filter(Boolean).pop()
      if (id) return `<iframe src="https://player.vimeo.com/video/${escapeAttr(id)}" title="Vimeo video" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>`
    }

    if (/\.(mp4|webm|ogg)(\?.*)?$/i.test(url.pathname + url.search)) {
      return `<video src="${href}" controls playsinline></video>`
    }

    return `<a href="${href}" target="_blank" rel="noreferrer">${href}</a>`
  } catch {
    return raw
  }
}
