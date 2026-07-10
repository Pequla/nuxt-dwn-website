<script setup lang="ts">
import type { Post } from '~/types/content'

defineProps<{ post: Post; featured?: boolean }>()

function formatDate(value?: string | null) {
  if (!value) return 'Bez datuma'
  return value.includes('T') ? value.split('T')[0] : value
}
</script>

<template>
  <a :href="`/blog/${post.slug}`" class="blog-card" :class="{ featured }">
    <div class="visual">
      <img v-if="post.image_media_id" :src="`/api/media/${post.image_media_id}`" :alt="post.title">
      <span v-else>{{ post.emoji || 'DWN' }}</span>
    </div>
    <div class="body">
      <div class="pill">{{ post.category }}</div>
      <h3>{{ post.title }}</h3>
      <p>{{ post.excerpt }}</p>
      <div class="meta">
        <span>{{ formatDate(post.published_at) }}</span>
        <span>{{ post.read_time }} min čitanja</span>
      </div>
    </div>
  </a>
</template>

<style scoped>
.blog-card {
  display: block;
  overflow: hidden;
  border: 1px solid var(--border);
  border-radius: 18px;
  background: var(--card);
  transition: transform 0.2s, border-color 0.2s;
}

.blog-card:hover {
  transform: translateY(-4px);
  border-color: rgba(61, 184, 168, 0.34);
}

.featured {
  display: grid;
  grid-template-columns: 0.9fr 1.1fr;
}

.visual {
  display: grid;
  min-height: 170px;
  place-items: center;
  background:
    radial-gradient(circle at 30% 30%, rgba(61, 184, 168, 0.18), transparent 50%),
    linear-gradient(135deg, #131e35, #223050);
}

.visual span {
  font-size: 4rem;
  filter: drop-shadow(0 12px 28px rgba(61, 184, 168, 0.22));
}

.visual img {
  width: 100%;
  height: 100%;
  min-height: 170px;
  object-fit: cover;
}

.body {
  padding: 24px;
}

.pill {
  display: inline-flex;
  margin-bottom: 14px;
  padding: 5px 12px;
  border-radius: 999px;
  background: rgba(61, 184, 168, 0.1);
  color: var(--teal);
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

h3 {
  margin: 0 0 12px;
  font-family: Syne, Inter, sans-serif;
  font-size: 1.2rem;
  line-height: 1.22;
  letter-spacing: -0.02em;
}

p {
  margin: 0 0 18px;
  color: var(--muted);
  font-size: 0.9rem;
  line-height: 1.72;
}

.meta {
  display: flex;
  gap: 14px;
  color: var(--soft);
  font-size: 0.76rem;
}

@media (max-width: 800px) {
  .featured {
    grid-template-columns: 1fr;
  }
}
</style>
