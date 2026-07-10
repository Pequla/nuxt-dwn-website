<script setup lang="ts">
const route = useRoute()
const { data } = await useFetch(`/api/public/clients/${route.params.id}`)
const client = computed(() => data.value?.client)
</script>

<template>
  <div>
    <AppHeader />
    <main v-if="client">
      <section class="detail-hero">
        <div class="container">
          <div class="eyebrow">{{ client.subtitle || 'Klijent' }}</div>
          <h1>{{ client.title }}</h1>
          <p v-if="client.label">{{ client.label }}</p>
        </div>
      </section>

      <section class="section">
        <div class="container detail-grid">
          <img v-if="client.image_media_id" :src="`/api/media/${client.image_media_id}`" :alt="client.title" class="detail-image">
          <article class="detail-body">
            <div v-if="client.body" v-html="client.body.replaceAll('\n', '<br>')" />
            <p v-if="client.url" class="client-link">
              <a :href="client.url" target="_blank" rel="noreferrer">Poseti sajt klijenta</a>
            </p>
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

.client-link a {
  color: var(--teal);
  font-weight: 800;
}
</style>
