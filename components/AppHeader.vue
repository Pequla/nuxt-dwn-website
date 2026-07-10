<script setup lang="ts">
const mobileOpen = ref(false)
const route = useRoute()

watch(() => route.fullPath, () => {
  mobileOpen.value = false
})

const mobilePageLinks = [
  { label: 'Case studije', to: '/cases' },
  { label: 'Blog', to: '/blog' },
  { label: 'Klijenti', to: '/clients' }
]

const mobileExternalLinks = [
  { label: 'Instagram', href: 'https://www.instagram.com/digital_with_neuro/' },
  { label: 'LinkedIn', href: 'https://www.linkedin.com/company/digital-with-neuro' }
]
</script>

<template>
  <header class="site-header">
    <NuxtLink to="/" class="logo-link" aria-label="DWN početna">
      <img src="/brand/logo-nav.png" alt="DWN logo" class="logo-image">
    </NuxtLink>

    <nav class="nav-links" aria-label="Glavna navigacija">
      <NuxtLink to="/#usluge">Usluge</NuxtLink>
      <NuxtLink to="/cases">Case studije</NuxtLink>
      <NuxtLink to="/#tim">Tim</NuxtLink>
      <NuxtLink to="/#faq">FAQ</NuxtLink>
      <NuxtLink to="/blog">Blog</NuxtLink>
      <NuxtLink to="/clients">Klijenti</NuxtLink>
    </nav>

    <div class="header-actions">
      <a href="mailto:digitaloffice@digitalwithneuro.com" class="btn">Kontakt</a>
      <button
        class="hamburger"
        type="button"
        :aria-expanded="mobileOpen"
        aria-controls="mobile-menu"
        aria-label="Otvori meni"
        @click="mobileOpen = !mobileOpen"
      >
        <span />
        <span />
        <span />
      </button>
    </div>

    <div v-if="mobileOpen" id="mobile-menu" class="mobile-menu">
      <NuxtLink v-for="link in mobilePageLinks" :key="link.label" :to="link.to">
        {{ link.label }}
      </NuxtLink>
      <a
        v-for="link in mobileExternalLinks"
        :key="link.label"
        :href="link.href"
        target="_blank"
        rel="noreferrer"
      >
        {{ link.label }}
      </a>
    </div>
  </header>
</template>

<style scoped>
.site-header {
  position: sticky;
  top: 0;
  z-index: 20;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 28px;
  min-height: 76px;
  padding: 10px max(24px, calc((100vw - 1120px) / 2));
  border-bottom: 1px solid var(--brand-border);
  background: rgba(19, 30, 53, 0.88);
  backdrop-filter: blur(18px);
}

.logo-link {
  display: inline-flex;
  align-items: center;
  width: 188px;
  min-width: 188px;
}

.logo-image {
  width: 100%;
  height: 52px;
  object-fit: contain;
  object-position: left center;
}

.nav-links {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 26px;
  color: var(--muted);
  font-size: 0.86rem;
}

.nav-links a {
  transition: color 0.18s;
}

.nav-links a:hover,
.router-link-active {
  color: var(--teal);
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.hamburger {
  display: none;
  width: 44px;
  height: 44px;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  gap: 5px;
  border: 1px solid var(--brand-border);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.035);
  color: var(--text);
  cursor: pointer;
}

.hamburger span {
  width: 17px;
  height: 2px;
  border-radius: 999px;
  background: currentColor;
}

.mobile-menu {
  position: absolute;
  top: calc(100% + 8px);
  right: max(16px, calc((100vw - 1120px) / 2));
  display: grid;
  gap: 4px;
  min-width: 220px;
  padding: 12px;
  border: 1px solid var(--brand-border);
  border-radius: 18px;
  background: rgba(19, 30, 53, 0.98);
  box-shadow: 0 18px 60px rgba(0, 0, 0, 0.32);
}

.mobile-menu a {
  padding: 12px 14px;
  border-radius: 12px;
  color: var(--muted);
  font-weight: 700;
}

.mobile-menu a:hover {
  background: rgba(61, 184, 168, 0.1);
  color: var(--teal);
}

@media (max-width: 820px) {
  .site-header {
    padding: 10px 16px;
    gap: 12px;
  }

  .nav-links {
    display: none;
  }

  .logo-link {
    width: 154px;
    min-width: 154px;
  }

  .hamburger {
    display: inline-flex;
  }

  .header-actions .btn {
    min-height: 40px;
    padding: 0 16px;
    font-size: 0.82rem;
  }
}

@media (max-width: 420px) {
  .logo-link {
    width: 132px;
    min-width: 132px;
  }

  .header-actions .btn {
    padding: 0 13px;
  }
}
</style>
