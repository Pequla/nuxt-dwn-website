<script setup lang="ts">
const { data } = await useFetch('/api/public/cases')
const cases = computed(() => data.value?.cases || [])
const featured = computed(() => cases.value.find((item: any) => item.featured) || cases.value[0])
const rest = computed(() => cases.value.filter((item: any) => item.id !== featured.value?.id))
</script>

<template>
  <div>
    <AppHeader />
    <main>
      <section class="page-hero">
        <div class="container">
          <div class="eyebrow">Case studije</div>
          <h1 class="section-title">Kampanje sa jasnim <em>rezultatom</em>.</h1>
          <p class="section-copy">Primeri strategija, kreativa i kanala koji su pomogli brendovima da povećaju vidljivost i prodaju.</p>
        </div>
      </section>

      <section class="section">
        <div class="container">
          <CaseCard v-if="featured" :item="featured" featured />
          <div class="grid three case-grid">
            <CaseCard v-for="item in rest" :key="item.id" :item="item" />
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

.case-grid {
  margin-top: 28px;
}
</style>
