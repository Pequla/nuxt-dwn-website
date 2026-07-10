<script setup lang="ts">
import type { CaseStudy } from '~/types/content'

defineProps<{ item: CaseStudy; featured?: boolean }>()

function slugify(value: string) {
  const map: Record<string, string> = { š: 's', đ: 'dj', č: 'c', ć: 'c', ž: 'z' }

  return value
    .toLowerCase()
    .replace(/[šđčćž]/g, char => map[char] || char)
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function casePath(item: CaseStudy) {
  return `/cases/${item.id}-${slugify(item.title || item.slug || 'case')}`
}
</script>

<template>
  <a :href="casePath(item)" class="case-card" :class="{ featured }">
    <div class="visual" aria-hidden="true">
      <img v-if="item.image_media_id" :src="`/api/media/${item.image_media_id}`" :alt="item.title">
      <template v-else>
        <div v-for="height in [34, 58, 46, 78, 52, 96]" :key="height" class="bar" :style="{ height: `${height}%` }" />
      </template>
    </div>
    <div class="body">
      <div class="client">{{ item.client }}</div>
      <div class="pill">{{ item.category }}</div>
      <h3>{{ item.title }}</h3>
      <p>{{ item.excerpt }}</p>
      <div class="metrics">
        <div>
          <strong>{{ item.metric1_value || '-' }}</strong>
          <span>{{ item.metric1_label }}</span>
        </div>
        <div>
          <strong>{{ item.metric2_value || '-' }}</strong>
          <span>{{ item.metric2_label }}</span>
        </div>
      </div>
    </div>
  </a>
</template>

<style scoped>
.case-card {
  display: block;
  overflow: hidden;
  border: 1px solid var(--border);
  border-radius: 18px;
  background: var(--card);
  transition: transform 0.2s, border-color 0.2s;
}

.case-card:hover {
  transform: translateY(-4px);
  border-color: rgba(61, 184, 168, 0.34);
}

.featured {
  display: grid;
  grid-template-columns: 0.9fr 1.1fr;
}

.visual {
  position: relative;
  display: flex;
  align-items: end;
  gap: 8px;
  min-height: 172px;
  padding: 28px;
  background:
    radial-gradient(circle at 70% 20%, rgba(232, 52, 90, 0.14), transparent 44%),
    linear-gradient(135deg, #131e35, #223050);
}

.bar {
  flex: 1;
  min-height: 28px;
  border-radius: 7px 7px 0 0;
  background: var(--teal);
}

.bar:nth-child(odd) {
  background: rgba(61, 184, 168, 0.18);
}

.visual img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.body {
  padding: 24px;
}

.client {
  margin-bottom: 7px;
  color: var(--soft);
  font-size: 0.72rem;
  font-weight: 800;
  letter-spacing: 0.09em;
  text-transform: uppercase;
}

.pill {
  display: inline-flex;
  margin-bottom: 14px;
  padding: 5px 12px;
  border-radius: 999px;
  background: rgba(232, 52, 90, 0.1);
  color: var(--pink);
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

h3 {
  margin: 0 0 12px;
  font-family: Syne, Inter, sans-serif;
  font-size: 1.18rem;
  line-height: 1.23;
}

p {
  margin: 0 0 20px;
  color: var(--muted);
  font-size: 0.9rem;
  line-height: 1.72;
}

.metrics {
  display: flex;
  gap: 28px;
}

strong {
  display: block;
  color: var(--lime);
  font-family: Syne, Inter, sans-serif;
  font-size: 1.45rem;
}

span {
  color: var(--soft);
  font-size: 0.76rem;
}

@media (max-width: 800px) {
  .featured {
    grid-template-columns: 1fr;
  }
}
</style>
