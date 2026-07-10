<script setup lang="ts">
const { data } = await useFetch('/api/public/sections')
const clientsSection = computed(() => data.value?.sections?.find((section: any) => section.section_key === 'clients') || { items: [] })
const clients = computed(() => clientsSection.value.items || [])

function slugify(value: string) {
  const map: Record<string, string> = { š: 's', đ: 'dj', č: 'c', ć: 'c', ž: 'z' }

  return value
    .toLowerCase()
    .replace(/[šđčćž]/g, char => map[char] || char)
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function clientPath(item: any) {
  return `/clients/${item.id}-${slugify(item.title)}`
}
</script>

<template>
  <div>
    <AppHeader />
    <main>
      <section class="page-hero">
        <div class="container">
          <div class="eyebrow">Klijenti</div>
          <h1 class="section-title">{{ clientsSection.title || 'Priče o klijentima i saradnjama.' }}</h1>
          <p class="section-copy">{{ clientsSection.subtitle || 'Tekstovi namenjeni predstavljanju klijenata, saradnji i backlinkovanju.' }}</p>
        </div>
      </section>

      <section class="section">
        <div class="container grid three">
          <a v-for="item in clients" :key="item.id" :href="clientPath(item)" class="client-card card">
            <img v-if="item.image_media_id" :src="`/api/media/${item.image_media_id}`" :alt="item.title">
            <div v-else class="client-avatar">{{ item.icon || item.title?.slice(0, 2) }}</div>
            <div class="client-body">
              <div class="eyebrow mini">{{ item.subtitle || 'Klijent' }}</div>
              <h2>{{ item.title }}</h2>
            </div>
          </a>
        </div>
      </section>
    </main>
    <AppFooter />
  </div>
</template>

<style scoped>
.page-hero {
  padding: 86px 0 64px;
  border-bottom: 1px solid var(--brand-border);
  background: var(--bg2);
}

.client-card {
  overflow: hidden;
  transition: transform 0.18s, border-color 0.18s;
}

.client-card:hover {
  transform: translateY(-4px);
  border-color: rgba(61, 184, 168, 0.34);
}

.client-card img,
.client-avatar {
  width: 100%;
  aspect-ratio: 16 / 10;
  object-fit: cover;
  background: var(--bg2);
}

.client-avatar {
  display: grid;
  place-items: center;
  color: var(--teal);
  font-family: Syne, Inter, sans-serif;
  font-size: 3rem;
  font-weight: 800;
}

.client-body {
  padding: 22px;
}

.mini {
  font-size: 0.66rem;
}

h2 {
  margin: 12px 0;
  font-family: Syne, Inter, sans-serif;
  line-height: 1.15;
}

p {
  color: var(--muted);
  line-height: 1.72;
}
</style>
