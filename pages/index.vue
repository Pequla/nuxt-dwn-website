<script setup lang="ts">
const [{ data: postsData }, { data: casesData }, { data: sectionsData }] = await Promise.all([
  useFetch('/api/public/posts', { query: { home: '1' } }),
  useFetch('/api/public/cases', { query: { home: '1' } }),
  useFetch('/api/public/sections')
])

const posts = computed(() => postsData.value?.posts || [])
const cases = computed(() => casesData.value?.cases || [])
const sections = computed(() => sectionsData.value?.sections || [])
const section = (key: string) => computed(() => sections.value.find((item: any) => item.section_key === key) || { items: [] })

const hero = section('hero')
const bento = section('bento')
const services = section('services')
const process = section('process')
const team = section('team')
const faq = section('faq')
const testimonials = section('testimonials')
const clients = section('clients')
const cta = section('cta')

function itemTags(item: any) {
  return item?.meta_json?.tags || []
}
</script>

<template>
  <div>
    <AppHeader />

    <main>
      <section class="hero">
        <div class="container hero-grid">
          <div>
            <div class="eyebrow">{{ hero.eyebrow || 'Digital With Neuro' }}</div>
            <h1>{{ hero.title }}</h1>
            <p>
              {{ hero.subtitle }}
            </p>
            <div class="hero-actions">
              <a :href="hero.cta_url || '#kontakt'" class="btn">{{ hero.cta_label || 'Zakaži konsultaciju' }}</a>
              <NuxtLink to="/cases" class="btn secondary">Pogledaj rezultate</NuxtLink>
            </div>
            <div class="hero-stats">
              <div v-for="item in hero.items" :key="item.id">
                <strong>{{ item.value }}</strong>
                <span>{{ item.label || item.title }}</span>
              </div>
            </div>
          </div>
          <div class="logo-panel">
            <img src="/brand/logo-hero.png" alt="DWN logo">
          </div>
        </div>
      </section>

      <section v-if="bento.enabled" class="section bento-band">
        <div class="container">
          <div class="bento-grid">
            <article class="bento-main card">
              <div class="eyebrow">{{ bento.eyebrow }}</div>
              <h2>{{ bento.title }}</h2>
              <p>{{ bento.subtitle }}</p>
              <div class="bento-pills">
                <span>Neuromarketing</span>
                <span>Paid Media</span>
                <span>Produkcija</span>
                <span>Strategija</span>
              </div>
            </article>
            <article v-for="item in bento.items" :key="item.id" class="bento-stat card">
              <div class="bento-icon">{{ item.icon }}</div>
              <small>{{ item.title }}</small>
              <strong v-if="item.value">{{ item.value }}<span>{{ item.label }}</span></strong>
              <h3 v-else>{{ item.subtitle }}</h3>
              <p>{{ item.body }}</p>
            </article>
          </div>
        </div>
      </section>

      <section id="usluge" class="section">
        <div class="container">
          <div class="eyebrow">{{ services.eyebrow }}</div>
          <h2 class="section-title">{{ services.title }}</h2>
          <p class="section-copy">{{ services.subtitle }}</p>
          <div class="services">
            <article v-for="item in services.items" :key="item.id" class="card">
              <div class="service-top">
                <span>{{ item.subtitle }}</span>
                <b>{{ item.icon }}</b>
              </div>
              <h3>{{ item.title }}</h3>
              <p>{{ item.body }}</p>
            </article>
          </div>
          <div v-if="services.body" class="seo-block card">{{ services.body }}</div>
        </div>
      </section>

      <section id="proces" class="section muted-band">
        <div class="container center">
          <div class="eyebrow">{{ process.eyebrow }}</div>
          <h2 class="section-title">{{ process.title }}</h2>
          <p class="section-copy">{{ process.subtitle }}</p>
          <div class="process-grid">
            <article v-for="item in process.items" :key="item.id" class="process-step">
              <div>{{ item.subtitle }}</div>
              <h3>{{ item.title }}</h3>
              <p>{{ item.body }}</p>
            </article>
          </div>
        </div>
      </section>

      <section class="section muted-band">
        <div class="container">
          <div class="eyebrow">Case studije</div>
          <h2 class="section-title">Rezultati koji mogu da se <em>izmere</em>.</h2>
          <div class="grid three">
            <CaseCard v-for="item in cases.slice(0, 3)" :key="item.id" :item="item" />
          </div>
        </div>
      </section>

      <section id="tim" class="section">
        <div class="container">
          <div class="eyebrow">{{ team.eyebrow }}</div>
          <h2 class="section-title">{{ team.title }}</h2>
          <p class="section-copy">{{ team.subtitle }}</p>
          <div class="team-grid">
            <article v-for="member in team.items" :key="member.id" class="team-card card">
              <img v-if="member.image_media_id" :src="`/api/media/${member.image_media_id}`" :alt="member.title" class="team-photo">
              <div v-else class="avatar">{{ member.icon || member.title?.slice(0, 2) }}</div>
              <div class="role">{{ member.subtitle }}</div>
              <h3>{{ member.title }}</h3>
              <p>{{ member.body }}</p>
              <div class="tag-row">
                <span v-for="tag in itemTags(member)" :key="tag">{{ tag }}</span>
              </div>
            </article>
          </div>
        </div>
      </section>

      <section id="faq" class="section muted-band">
        <div class="container">
          <div class="eyebrow">{{ faq.eyebrow }}</div>
          <h2 class="section-title">{{ faq.title }}</h2>
          <p class="section-copy">{{ faq.subtitle }}</p>
          <div class="faq-list">
            <details v-for="item in faq.items" :key="item.id" class="faq-item">
              <summary>{{ item.title }}</summary>
              <p>{{ item.body }}</p>
            </details>
          </div>
        </div>
      </section>

      <section class="section">
        <div class="container center">
          <div class="eyebrow">{{ testimonials.eyebrow }}</div>
          <h2 class="section-title">{{ testimonials.title }}</h2>
          <div class="testimonial-grid">
            <article v-for="item in testimonials.items" :key="item.id" class="testimonial card">
              <blockquote>{{ item.body }}</blockquote>
              <div class="testimonial-author">
                <span>{{ item.icon }}</span>
                <div>
                  <strong>{{ item.title }}</strong>
                  <small>{{ item.subtitle }}</small>
                </div>
              </div>
            </article>
          </div>
        </div>
      </section>

      <section id="klijenti" class="section muted-band">
        <div class="container">
          <div class="eyebrow">{{ clients.eyebrow }}</div>
          <h2 class="section-title">{{ clients.title }}</h2>
          <p class="section-copy">{{ clients.subtitle }}</p>
          <div class="client-pills">
            <span v-for="item in clients.items" :key="item.id">{{ item.title }}</span>
          </div>
        </div>
      </section>

      <section class="section">
        <div class="container">
          <div class="eyebrow">Blog</div>
          <h2 class="section-title">Kratko, korisno, <em>primenljivo</em>.</h2>
          <div class="grid three">
            <BlogCard v-for="post in posts.slice(0, 3)" :key="post.id" :post="post" />
          </div>
        </div>
      </section>

      <section id="kontakt" class="cta-section">
        <div class="container center">
          <h2>{{ cta.title }}</h2>
          <p>{{ cta.subtitle }}</p>
          <a :href="cta.cta_url || 'mailto:digitaloffice@digitalwithneuro.com'" class="btn">
            {{ cta.cta_label || 'Zakažite poziv' }}
          </a>
        </div>
      </section>
    </main>

    <AppFooter />
  </div>
</template>

<style scoped>
.hero {
  position: relative;
  overflow: hidden;
  padding: 96px 0 88px;
  border-bottom: 1px solid var(--brand-border);
  background:
    radial-gradient(circle at 78% 18%, rgba(61, 184, 168, 0.16), transparent 35%),
    linear-gradient(180deg, #131e35, #162236);
}

.hero::before {
  content: "";
  position: absolute;
  inset: 0;
  pointer-events: none;
  background-image:
    linear-gradient(rgba(61, 184, 168, 0.035) 1px, transparent 1px),
    linear-gradient(90deg, rgba(61, 184, 168, 0.035) 1px, transparent 1px);
  background-size: 56px 56px;
}

.hero-grid {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: 1.05fr 0.95fr;
  gap: 56px;
  align-items: center;
}

h1 {
  margin: 18px 0 22px;
  font-family: Syne, Inter, sans-serif;
  font-size: clamp(2.7rem, 6vw, 5.4rem);
  line-height: 0.96;
  letter-spacing: -0.06em;
}

h1 em {
  color: var(--teal);
  font-style: normal;
}

.hero p {
  max-width: 590px;
  margin: 0;
  color: var(--muted);
  font-size: 1.08rem;
  line-height: 1.82;
}

.hero-actions {
  display: flex;
  gap: 14px;
  margin-top: 34px;
  flex-wrap: wrap;
}

.hero-stats {
  display: flex;
  gap: 28px;
  flex-wrap: wrap;
  margin-top: 34px;
}

.hero-stats div {
  min-width: 116px;
}

.hero-stats strong {
  display: block;
  color: var(--lime);
  font-family: Syne, Inter, sans-serif;
  font-size: 1.6rem;
  letter-spacing: -0.04em;
}

.hero-stats span {
  color: var(--soft);
  font-size: 0.76rem;
}

.logo-panel {
  display: grid;
  place-items: center;
  min-height: 390px;
  border: 1px solid var(--border);
  border-radius: 18px;
  background:
    radial-gradient(circle at center, rgba(232, 52, 90, 0.12), transparent 46%),
    rgba(255, 255, 255, 0.03);
}

.logo-panel img {
  width: min(92%, 520px);
  max-height: 310px;
  object-fit: contain;
}

.bento-band {
  background: var(--bg);
}

.bento-grid {
  display: grid;
  grid-template-columns: 1.45fr 0.8fr 0.8fr;
  gap: 18px;
}

.bento-main,
.bento-stat {
  min-height: 220px;
  padding: 28px;
}

.bento-main {
  grid-row: span 2;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  background:
    radial-gradient(circle at 18% 20%, rgba(61, 184, 168, 0.18), transparent 46%),
    var(--card);
}

.bento-main h2,
.cta-section h2 {
  margin: 16px 0;
  font-family: Syne, Inter, sans-serif;
  font-size: clamp(2rem, 4vw, 3.7rem);
  line-height: 1.02;
  letter-spacing: -0.05em;
}

.bento-main p,
.bento-stat p {
  color: var(--muted);
  line-height: 1.72;
}

.bento-pills,
.tag-row,
.client-pills {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.bento-pills span,
.tag-row span,
.client-pills span {
  border: 1px solid var(--brand-border);
  border-radius: 999px;
  color: var(--teal);
  font-size: 0.76rem;
  font-weight: 700;
  padding: 7px 12px;
}

.bento-stat small {
  display: block;
  color: var(--soft);
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.bento-stat strong {
  display: block;
  margin-top: 18px;
  color: var(--lime);
  font-family: Syne, Inter, sans-serif;
  font-size: 2.4rem;
}

.bento-stat strong span {
  display: block;
  color: var(--muted);
  font-family: Inter, sans-serif;
  font-size: 0.82rem;
  letter-spacing: 0;
}

.bento-icon {
  min-height: 34px;
  font-size: 2rem;
}

.services {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 22px;
  margin-top: 36px;
}

.services .card {
  padding: 28px;
}

.service-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}

.service-top span {
  color: var(--soft);
  font-weight: 800;
}

.service-top b {
  font-size: 2rem;
}

.services h3 {
  margin: 0 0 12px;
  font-family: Syne, Inter, sans-serif;
  font-size: 1.24rem;
}

.services p {
  margin: 0;
  color: var(--muted);
  line-height: 1.74;
}

.seo-block {
  margin-top: 24px;
  padding: 24px;
  color: var(--muted);
  line-height: 1.74;
}

.center {
  text-align: center;
}

.center .eyebrow,
.center .section-copy {
  justify-content: center;
  margin-left: auto;
  margin-right: auto;
}

.process-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 18px;
  margin-top: 40px;
  text-align: left;
}

.process-step {
  position: relative;
  padding: 28px 22px;
  border: 1px solid var(--border);
  border-radius: 16px;
  background: var(--card);
}

.process-step div {
  display: grid;
  width: 46px;
  height: 46px;
  place-items: center;
  border-radius: 999px;
  background: rgba(61, 184, 168, 0.12);
  color: var(--teal);
  font-weight: 800;
}

.process-step h3,
.team-card h3 {
  margin: 18px 0 10px;
  font-family: Syne, Inter, sans-serif;
}

.process-step p,
.team-card p,
.faq-item p,
.testimonial blockquote {
  color: var(--muted);
  line-height: 1.72;
}

.team-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 22px;
  margin-top: 36px;
}

.team-card {
  padding: 26px;
}

.avatar,
.testimonial-author span {
  display: grid;
  width: 72px;
  height: 72px;
  place-items: center;
  border-radius: 22px;
  background:
    radial-gradient(circle at 30% 30%, rgba(232, 52, 90, 0.22), transparent 48%),
    rgba(61, 184, 168, 0.12);
  color: white;
  font-family: Syne, Inter, sans-serif;
  font-weight: 800;
  font-size: 1.4rem;
}

.team-photo {
  width: 100%;
  aspect-ratio: 4 / 3;
  object-fit: cover;
  border-radius: 14px;
  border: 1px solid var(--border);
  background: var(--bg2);
}

.role {
  margin-top: 18px;
  color: var(--teal);
  font-size: 0.76rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.faq-list {
  display: grid;
  gap: 12px;
  margin-top: 32px;
}

.faq-item {
  border: 1px solid var(--border);
  border-radius: 14px;
  background: var(--card);
  padding: 0 20px;
}

.faq-item summary {
  cursor: pointer;
  padding: 20px 0;
  color: var(--text);
  font-weight: 800;
}

.faq-item p {
  margin-top: 0;
  padding-bottom: 20px;
}

.testimonial-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 22px;
  margin-top: 36px;
  text-align: left;
}

.testimonial {
  padding: 28px;
}

.testimonial blockquote {
  margin: 0 0 24px;
  font-size: 1.02rem;
}

.testimonial-author {
  display: flex;
  align-items: center;
  gap: 14px;
}

.testimonial-author span {
  width: 48px;
  height: 48px;
  border-radius: 16px;
  font-size: 1rem;
}

.testimonial-author strong,
.testimonial-author small {
  display: block;
}

.testimonial-author small {
  color: var(--soft);
  margin-top: 3px;
}

.client-pills {
  margin-top: 32px;
}

.client-pills span {
  color: var(--text);
  background: rgba(255, 255, 255, 0.03);
}

.cta-section {
  padding: 86px 0;
  background:
    radial-gradient(circle at 50% 0%, rgba(61, 184, 168, 0.22), transparent 45%),
    var(--navy);
}

.cta-section p {
  max-width: 600px;
  margin: 0 auto 26px;
  color: rgba(255, 255, 255, 0.68);
  line-height: 1.72;
}

.muted-band {
  background: var(--bg2);
}

@media (max-width: 900px) {
  .hero-grid,
  .bento-grid,
  .services,
  .process-grid,
  .team-grid,
  .testimonial-grid {
    grid-template-columns: 1fr;
  }

  .logo-panel {
    min-height: 260px;
  }
}
</style>
