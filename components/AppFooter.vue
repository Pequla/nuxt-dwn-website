<template>
  <footer class="footer">
    <div class="container footer-inner">
      <img src="/brand/logo-nav.png" alt="DWN logo" class="footer-logo">
      <div class="footer-links">
        <NuxtLink to="/cases">Case studije</NuxtLink>
        <NuxtLink to="/blog">Blog</NuxtLink>
        <NuxtLink to="/clients">Klijenti</NuxtLink>
        <a href="https://www.instagram.com/digital_with_neuro/" target="_blank" rel="noreferrer">Instagram</a>
        <a href="https://www.linkedin.com/company/digital-with-neuro" target="_blank" rel="noreferrer">LinkedIn</a>
      </div>
      <p>© 2026 DWN Reklamna Agencija</p>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  border-top: 1px solid var(--border);
  background: var(--navy);
  padding: 28px 0;
}

.footer-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  flex-wrap: wrap;
}

.footer-logo {
  width: 156px;
  height: 50px;
  object-fit: contain;
  object-position: left center;
}

.footer-links {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
  color: rgba(255, 255, 255, 0.48);
  font-size: 0.82rem;
}

p {
  margin: 0;
  color: rgba(255, 255, 255, 0.36);
  font-size: 0.8rem;
}
</style>
