<script setup lang="ts">
const route = useRoute()
const { data } = await useFetch(`/api/public/posts/${route.params.slug}`)
const post = computed(() => data.value?.post)

useHead({
  script: [
    { src: 'https://www.instagram.com/embed.js', async: true },
    { src: 'https://www.tiktok.com/embed.js', async: true }
  ]
})

onMounted(() => {
  nextTick(() => {
    ;(window as any).instgrm?.Embeds?.process?.()
    ;(window as any).tiktokEmbed?.load?.()
  })
})
</script>

<template>
  <div>
    <AppHeader />
    <main v-if="post">
      <section class="detail-hero">
        <div class="container">
          <div class="eyebrow">{{ post.category }}</div>
          <h1>{{ post.title }}</h1>
          <p>{{ post.excerpt }}</p>
        </div>
      </section>

      <section class="section">
        <div class="container detail-grid">
          <img v-if="post.image_media_id" :src="`/api/media/${post.image_media_id}`" :alt="post.title" class="detail-image">
          <article class="detail-body">
            <div v-if="post.body" class="prose" v-html="post.body.replaceAll('\n', '<br>')" />
            <div v-if="post.embed_html" class="embed-box" v-html="post.embed_html" />
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


.detail-body :deep(img) {
  display: block;
  width: 100%;
  max-height: 560px;
  object-fit: cover;
  border-radius: 18px;
  margin: 28px 0;
}

.detail-body :deep(iframe),
.embed-box :deep(iframe) {
  display: block;
  width: 100%;
  min-height: 420px;
  border: 0;
  border-radius: 18px;
  background: var(--bg2);
}

.detail-body :deep(video),
.embed-box :deep(video) {
  display: block;
  width: 100%;
  border-radius: 18px;
  background: #000;
}

.embed-box :deep(.tiktok-embed),
.embed-box :deep(.instagram-media) {
  margin: 0 auto !important;
}

@media (max-width: 640px) {
  .detail-body :deep(iframe),
  .embed-box :deep(iframe) {
    min-height: 260px;
  }
}
</style>
