<script setup lang="ts">
const route = useRoute()
const { data } = await useFetch(`/api/public/cases/${route.params.slug}`)
const item = computed(() => data.value?.caseStudy)

useHead({
  script: [
    { src: 'https://www.instagram.com/embed.js', async: true },
    { src: 'https://www.tiktok.com/embed.js', async: true }
  ]
})
</script>

<template>
  <div>
    <AppHeader />
    <main v-if="item">
      <section class="detail-hero">
        <div class="container">
          <div class="eyebrow">{{ item.client }}</div>
          <h1>{{ item.title }}</h1>
          <p>{{ item.excerpt }}</p>
          <div class="metrics">
            <div><strong>{{ item.metric1_value }}</strong><span>{{ item.metric1_label }}</span></div>
            <div><strong>{{ item.metric2_value }}</strong><span>{{ item.metric2_label }}</span></div>
          </div>
        </div>
      </section>

      <section class="section">
        <div class="container detail-grid">
          <img v-if="item.image_media_id" :src="`/api/media/${item.image_media_id}`" :alt="item.title" class="detail-image">
          <article class="detail-body">
            <div v-if="item.body" v-html="item.body.replaceAll('\n', '<br>')" />
            <div v-if="item.embed_html" class="embed-box" v-html="item.embed_html" />
          </article>
        </div>
      </section>
    </main>
    <AppFooter />
  </div>
</template>

<style scoped>
.detail-hero {
  padding: 86px 0 64px;
  border-bottom: 1px solid var(--brand-border);
  background: var(--bg2);
}

h1 {
  max-width: 900px;
  margin: 16px 0;
  font-family: Syne, Inter, sans-serif;
  font-size: clamp(2.1rem, 5vw, 4.5rem);
  line-height: 1.02;
}

.detail-hero p {
  max-width: 720px;
  color: var(--muted);
  line-height: 1.75;
}

.metrics {
  display: flex;
  gap: 34px;
  flex-wrap: wrap;
  margin-top: 28px;
}

.metrics strong {
  display: block;
  color: var(--lime);
  font-family: Syne, Inter, sans-serif;
  font-size: 1.8rem;
}

.metrics span {
  color: var(--soft);
}

.detail-grid {
  max-width: 900px;
}

.detail-image {
  width: 100%;
  max-height: 520px;
  object-fit: cover;
  border-radius: 18px;
  margin-bottom: 28px;
}

.detail-body {
  color: var(--muted);
  font-size: 1.03rem;
  line-height: 1.86;
}

.embed-box {
  margin-top: 32px;
}
</style>
