<script setup lang="ts">
const { data } = await useFetch('/api/public/posts')
const posts = computed(() => data.value?.posts || [])
const featured = computed(() => posts.value[0])
const rest = computed(() => posts.value.slice(1))
</script>

<template>
  <div>
    <AppHeader />
    <main>
      <section class="page-hero">
        <div class="container">
          <div class="eyebrow">DWN blog</div>
          <h1 class="section-title">Neuromarketing i digitalni marketing <em>bez magle</em>.</h1>
          <p class="section-copy">Tekstovi o pažnji, kreativama, kampanjama i strategiji napisani tako da odmah mogu da se primene.</p>
        </div>
      </section>

      <section class="section">
        <div class="container">
          <BlogCard v-if="featured" :post="featured" featured />
          <div class="grid three post-grid">
            <BlogCard v-for="post in rest" :key="post.id" :post="post" />
          </div>
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

.post-grid {
  margin-top: 28px;
}
</style>
