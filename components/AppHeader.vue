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

    <a href="mailto:digitaloffice@digitalwithneuro.com" class="btn">Kontakt</a>
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

@media (max-width: 820px) {
  .site-header {
    padding: 10px 16px;
  }

  .nav-links {
    display: none;
  }

  .logo-link {
    width: 154px;
    min-width: 154px;
  }
}
</style>
