export function slugify(input: string) {
  const map: Record<string, string> = {
    š: 's', đ: 'dj', č: 'c', ć: 'c', ž: 'z',
    Š: 's', Đ: 'dj', Č: 'c', Ć: 'c', Ž: 'z'
  }

  return input
    .replace(/[šđčćžŠĐČĆŽ]/g, char => map[char] || char)
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 180)
}
