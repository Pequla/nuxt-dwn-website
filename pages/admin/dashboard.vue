<script setup lang="ts">
const activeTab = ref<'sections' | 'clients' | 'posts' | 'cases'>('sections')
const sections = ref<any[]>([])
const posts = ref<any[]>([])
const cases = ref<any[]>([])
const message = ref('')
const visibleSections = computed(() => {
  if (activeTab.value === 'clients') {
    return sections.value.filter(section => section.section_key === 'clients')
  }

  return sections.value.filter(section => section.section_key !== 'clients')
})

async function guardedFetch<T>(url: string, options: any = {}) {
  try {
    return await $fetch<T>(url, options)
  } catch (err: any) {
    if (err?.statusCode === 401) await navigateTo('/admin')
    throw err
  }
}

async function uploadImage(file: File) {
  const body = new FormData()
  body.append('file', file)
  return await guardedFetch<{ id: number; url: string }>('/api/admin/media', {
    method: 'POST',
    body
  })
}

async function uploadTo(target: any, event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  const media = await uploadImage(file)
  target.image_media_id = media.id
  message.value = 'Slika je uploadovana.'
  input.value = ''
}

async function loadAll() {
  const [sectionRes, postRes, caseRes] = await Promise.all([
    guardedFetch<{ sections: any[] }>('/api/admin/sections'),
    guardedFetch<{ posts: any[] }>('/api/admin/posts'),
    guardedFetch<{ cases: any[] }>('/api/admin/cases')
  ])
  sections.value = sectionRes.sections.map(section => ({
    ...section,
    items: section.items.map((item: any) => ({
      ...item,
      tags_text: (item.meta_json?.tags || []).join(', ')
    }))
  }))
  posts.value = postRes.posts
  cases.value = caseRes.cases
}

function addSectionItem(section: any) {
  section.items.unshift({
    section_key: section.section_key,
    title: 'Nova stavka',
    subtitle: '',
    body: '',
    icon: '',
    label: '',
    value: '',
    url: '',
    image_media_id: null,
    meta_json: {},
    tags_text: '',
    enabled: 1,
    sort_order: 0
  })
}

async function saveSection(section: any) {
  const payload = {
    ...section,
    items: section.items.map((item: any) => ({
      ...item,
      meta_json: item.tags_text
        ? { tags: item.tags_text.split(',').map((tag: string) => tag.trim()).filter(Boolean) }
        : item.meta_json || {}
    }))
  }

  await guardedFetch(`/api/admin/sections/${section.section_key}`, { method: 'PUT', body: payload })
  message.value = 'Sekcija je sačuvana.'
  await loadAll()
}

async function deleteSectionItem(section: any, item: any) {
  if (!item.id) {
    section.items = section.items.filter((row: any) => row !== item)
    return
  }

  await guardedFetch(`/api/admin/sections/items/${item.id}`, { method: 'DELETE' })
  message.value = 'Stavka je obrisana.'
  await loadAll()
}

function addPost() {
  posts.value.unshift({
    title: 'Novi blog tekst',
    slug: '',
    excerpt: '',
    body: '',
    image_media_id: null,
    embed_html: '',
    category: 'Neuromarketing',
    emoji: '🧠',
    read_time: 5,
    published_at: new Date().toISOString().slice(0, 10),
    show_home: 0,
    published: 1,
    sort_order: 0
  })
}

function addCase() {
  cases.value.unshift({
    client: '',
    title: 'Nova case studija',
    slug: '',
    excerpt: '',
    body: '',
    image_media_id: null,
    embed_html: '',
    category: 'TikTok',
    secondary_category: '',
    metric1_value: '',
    metric1_label: '',
    metric2_value: '',
    metric2_label: '',
    featured: 0,
    show_home: 0,
    published: 1,
    sort_order: 0
  })
}

async function savePost(post: any) {
  const method = post.id ? 'PUT' : 'POST'
  const url = post.id ? `/api/admin/posts/${post.id}` : '/api/admin/posts'
  await guardedFetch(url, { method, body: post })
  message.value = 'Blog tekst je sačuvan.'
  await loadAll()
}

async function deletePost(post: any) {
  if (!post.id) {
    posts.value = posts.value.filter(item => item !== post)
    return
  }
  await guardedFetch(`/api/admin/posts/${post.id}`, { method: 'DELETE' })
  message.value = 'Blog tekst je obrisan.'
  await loadAll()
}

async function saveCase(item: any) {
  const method = item.id ? 'PUT' : 'POST'
  const url = item.id ? `/api/admin/cases/${item.id}` : '/api/admin/cases'
  await guardedFetch(url, { method, body: item })
  message.value = 'Case studija je sačuvana.'
  await loadAll()
}

async function deleteCase(item: any) {
  if (!item.id) {
    cases.value = cases.value.filter(row => row !== item)
    return
  }
  await guardedFetch(`/api/admin/cases/${item.id}`, { method: 'DELETE' })
  message.value = 'Case studija je obrisana.'
  await loadAll()
}

async function logout() {
  await $fetch('/api/auth/logout', { method: 'POST' })
  await navigateTo('/admin')
}

onMounted(loadAll)
</script>

<template>
  <div>
    <header class="admin-header">
      <NuxtLink to="/" class="admin-logo"><img src="/brand/logo-nav.png" alt="DWN logo"></NuxtLink>
      <div class="admin-actions">
        <NuxtLink to="/" class="btn secondary">Sajt</NuxtLink>
        <button class="btn secondary" @click="logout">Odjavi se</button>
      </div>
    </header>

    <main class="container admin-main">
      <div class="topline">
        <div>
          <h1>Upravljanje sadržajem</h1>
          <p>Blog tekstovi i case studije se čuvaju u MySQL bazi.</p>
        </div>
        <p v-if="message" class="message">{{ message }}</p>
      </div>

      <div class="tabs">
        <button :class="{ on: activeTab === 'sections' }" @click="activeTab = 'sections'">Sekcije sajta</button>
        <button :class="{ on: activeTab === 'clients' }" @click="activeTab = 'clients'">Klijenti</button>
        <button :class="{ on: activeTab === 'posts' }" @click="activeTab = 'posts'">Blog</button>
        <button :class="{ on: activeTab === 'cases' }" @click="activeTab = 'cases'">Case studije</button>
      </div>

      <section v-if="activeTab === 'sections' || activeTab === 'clients'" class="admin-section">
        <article v-for="section in visibleSections" :key="section.section_key" class="editor card section-editor">
          <div class="section-editor-head">
            <div>
              <div class="section-key">{{ section.section_key }}</div>
              <h2>{{ section.title }}</h2>
            </div>
            <button class="btn" @click="saveSection(section)">Sačuvaj sekciju</button>
          </div>

          <div class="form-row">
            <div class="field"><label>Eyebrow / oznaka</label><input v-model="section.eyebrow"></div>
            <div class="field"><label>Naslov</label><input v-model="section.title"></div>
          </div>
          <div class="field"><label>Podnaslov</label><textarea v-model="section.subtitle"></textarea></div>
          <div class="field"><label>Dodatni tekst / SEO blok</label><textarea v-model="section.body"></textarea></div>
          <div class="form-row">
            <div class="field"><label>CTA tekst</label><input v-model="section.cta_label"></div>
            <div class="field"><label>CTA link</label><input v-model="section.cta_url"></div>
          </div>
          <div class="check-row">
            <label><input v-model="section.enabled" type="checkbox" :true-value="1" :false-value="0"> Prikazuj sekciju</label>
            <label>Redosled <input v-model.number="section.sort_order" class="small-input" type="number"></label>
          </div>

          <div class="items-head">
            <h3>Stavke sekcije</h3>
            <button class="btn secondary" @click="addSectionItem(section)">Dodaj stavku</button>
          </div>

          <div v-for="item in section.items" :key="item.id || item.title" class="nested-item">
            <div class="form-row">
              <div class="field"><label>Naslov</label><input v-model="item.title"></div>
              <div class="field"><label>Podnaslov / uloga / broj</label><input v-model="item.subtitle"></div>
            </div>
            <div class="form-row">
              <div class="field"><label>Ikonica / inicijali</label><input v-model="item.icon"></div>
              <div class="field"><label>Vrednost</label><input v-model="item.value"></div>
            </div>
            <div class="form-row">
              <div class="field"><label>Labela</label><input v-model="item.label"></div>
              <div class="field"><label>Link</label><input v-model="item.url"></div>
            </div>
            <div class="field"><label>Tekst</label><textarea v-model="item.body"></textarea></div>
            <div class="field">
              <label>Slika</label>
              <div class="upload-row">
                <img v-if="item.image_media_id" :src="`/api/media/${item.image_media_id}`" alt="">
                <input type="file" accept="image/*" @change="uploadTo(item, $event)">
              </div>
            </div>
            <div class="field"><label>Tagovi, odvojeni zarezom</label><input v-model="item.tags_text"></div>
            <div class="bottom-row">
              <div class="check-row">
                <label><input v-model="item.enabled" type="checkbox" :true-value="1" :false-value="0"> Prikazuj stavku</label>
                <label>Redosled <input v-model.number="item.sort_order" class="small-input" type="number"></label>
              </div>
              <button class="btn secondary" @click="deleteSectionItem(section, item)">Obriši stavku</button>
            </div>
          </div>
        </article>
      </section>

      <section v-else-if="activeTab === 'posts'" class="admin-section">
        <button class="btn" @click="addPost">Dodaj blog tekst</button>
        <article v-for="post in posts" :key="post.id || post.title" class="editor card">
          <div class="form-row">
            <div class="field"><label>Naslov</label><input v-model="post.title"></div>
            <div class="field"><label>Slug</label><input v-model="post.slug" placeholder="automatski ako ostane prazno"></div>
          </div>
          <div class="form-row">
            <div class="field"><label>Kategorija</label><input v-model="post.category"></div>
            <div class="field"><label>Emoji / oznaka</label><input v-model="post.emoji"></div>
          </div>
          <div class="form-row">
            <div class="field"><label>Datum</label><input v-model="post.published_at" type="date"></div>
            <div class="field"><label>Minuta čitanja</label><input v-model.number="post.read_time" type="number"></div>
          </div>
          <div class="field"><label>Kratak opis</label><textarea v-model="post.excerpt"></textarea></div>
          <div class="field"><label>Tekst</label><textarea v-model="post.body"></textarea></div>
          <div class="field">
            <label>Slika</label>
            <div class="upload-row">
              <img v-if="post.image_media_id" :src="`/api/media/${post.image_media_id}`" alt="">
              <input type="file" accept="image/*" @change="uploadTo(post, $event)">
            </div>
          </div>
          <div class="field"><label>Embed HTML / iframe / Instagram / TikTok</label><textarea v-model="post.embed_html"></textarea></div>
          <div class="bottom-row">
            <div class="check-row">
              <label><input v-model="post.show_home" type="checkbox" :true-value="1" :false-value="0"> Na početnoj</label>
              <label><input v-model="post.published" type="checkbox" :true-value="1" :false-value="0"> Objavljeno</label>
              <label>Redosled <input v-model.number="post.sort_order" class="small-input" type="number"></label>
            </div>
            <div class="row-actions">
              <button class="btn secondary" @click="deletePost(post)">Obriši</button>
              <button class="btn" @click="savePost(post)">Sačuvaj</button>
            </div>
          </div>
        </article>
      </section>

      <section v-else class="admin-section">
        <button class="btn" @click="addCase">Dodaj case studiju</button>
        <article v-for="item in cases" :key="item.id || item.title" class="editor card">
          <div class="form-row">
            <div class="field"><label>Klijent</label><input v-model="item.client"></div>
            <div class="field"><label>Naslov</label><input v-model="item.title"></div>
          </div>
          <div class="form-row">
            <div class="field"><label>Slug</label><input v-model="item.slug" placeholder="automatski ako ostane prazno"></div>
            <div class="field"><label>Kategorija</label><input v-model="item.category"></div>
          </div>
          <div class="field"><label>Druga kategorija</label><input v-model="item.secondary_category"></div>
          <div class="field"><label>Kratak opis</label><textarea v-model="item.excerpt"></textarea></div>
          <div class="field"><label>Tekst</label><textarea v-model="item.body"></textarea></div>
          <div class="field">
            <label>Slika</label>
            <div class="upload-row">
              <img v-if="item.image_media_id" :src="`/api/media/${item.image_media_id}`" alt="">
              <input type="file" accept="image/*" @change="uploadTo(item, $event)">
            </div>
          </div>
          <div class="field"><label>Embed HTML / iframe / Instagram / TikTok</label><textarea v-model="item.embed_html"></textarea></div>
          <div class="form-row">
            <div class="field"><label>Metrika 1 vrednost</label><input v-model="item.metric1_value"></div>
            <div class="field"><label>Metrika 1 opis</label><input v-model="item.metric1_label"></div>
          </div>
          <div class="form-row">
            <div class="field"><label>Metrika 2 vrednost</label><input v-model="item.metric2_value"></div>
            <div class="field"><label>Metrika 2 opis</label><input v-model="item.metric2_label"></div>
          </div>
          <div class="bottom-row">
            <div class="check-row">
              <label><input v-model="item.featured" type="checkbox" :true-value="1" :false-value="0"> Istaknuto</label>
              <label><input v-model="item.show_home" type="checkbox" :true-value="1" :false-value="0"> Na početnoj</label>
              <label><input v-model="item.published" type="checkbox" :true-value="1" :false-value="0"> Objavljeno</label>
              <label>Redosled <input v-model.number="item.sort_order" class="small-input" type="number"></label>
            </div>
            <div class="row-actions">
              <button class="btn secondary" @click="deleteCase(item)">Obriši</button>
              <button class="btn" @click="saveCase(item)">Sačuvaj</button>
            </div>
          </div>
        </article>
      </section>
    </main>
  </div>
</template>

<style scoped>
.admin-header {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px max(24px, calc((100vw - 1120px) / 2));
  border-bottom: 1px solid var(--brand-border);
  background: rgba(19, 30, 53, 0.9);
  backdrop-filter: blur(18px);
}

.admin-logo img {
  width: 178px;
  height: 54px;
  object-fit: contain;
  object-position: left center;
}

.admin-actions,
.row-actions {
  display: flex;
  gap: 10px;
}

.admin-main {
  padding: 48px 0 80px;
}

.topline {
  display: flex;
  align-items: start;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 28px;
}

h1 {
  margin: 0 0 8px;
  font-family: Syne, Inter, sans-serif;
  font-size: 2.2rem;
}

p {
  margin: 0;
  color: var(--muted);
}

.message {
  color: var(--teal);
  font-weight: 700;
}

.tabs {
  display: flex;
  gap: 10px;
  margin-bottom: 24px;
  border-bottom: 1px solid var(--border);
}

.tabs button {
  border: 0;
  border-bottom: 2px solid transparent;
  background: transparent;
  color: var(--muted);
  padding: 14px 18px;
  cursor: pointer;
}

.tabs button.on {
  border-color: var(--teal);
  color: var(--teal);
}

.admin-section {
  display: grid;
  gap: 18px;
}

.admin-section > .btn {
  justify-self: start;
}

.editor {
  display: grid;
  gap: 14px;
  padding: 22px;
}

.section-editor {
  gap: 18px;
}

.section-editor-head,
.items-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  flex-wrap: wrap;
}

.section-editor h2,
.items-head h3 {
  margin: 0;
  font-family: Syne, Inter, sans-serif;
}

.section-key {
  margin-bottom: 6px;
  color: var(--teal);
  font-size: 0.72rem;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}

.nested-item {
  display: grid;
  gap: 14px;
  border: 1px solid var(--border);
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.025);
  padding: 18px;
}

.upload-row {
  display: flex;
  align-items: center;
  gap: 14px;
  flex-wrap: wrap;
}

.upload-row img {
  width: 92px;
  height: 72px;
  object-fit: cover;
  border: 1px solid var(--border);
  border-radius: 10px;
  background: var(--bg2);
}

.bottom-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  flex-wrap: wrap;
  padding-top: 4px;
}

.small-input {
  width: 80px;
  margin-left: 8px;
}

@media (max-width: 700px) {
  .admin-header,
  .topline,
  .bottom-row {
    align-items: stretch;
    flex-direction: column;
  }
}
</style>
