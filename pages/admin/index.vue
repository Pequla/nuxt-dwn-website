<script setup lang="ts">
const user = ref<any>(null)
const login = reactive({ username: '', password: '' })
const error = ref('')
const loading = ref(false)

async function loadMe() {
  try {
    const res = await $fetch<{ user: any }>('/api/auth/me')
    user.value = res.user
  } catch {
    user.value = null
  }
}

async function submitLogin() {
  loading.value = true
  error.value = ''
  try {
    await $fetch('/api/auth/login', { method: 'POST', body: login })
    await navigateTo('/admin/dashboard')
  } catch (err: any) {
    error.value = err?.statusMessage || 'Login nije uspeo'
  } finally {
    loading.value = false
  }
}

onMounted(loadMe)
</script>

<template>
  <div class="login-page">
    <div class="login-card card">
      <img src="/brand/logo-nav.png" alt="DWN logo">
      <h1>Admin panel</h1>
      <p>Prijavite se korisničkim imenom i lozinkom.</p>

      <NuxtLink v-if="user" to="/admin/dashboard" class="btn">Idi na dashboard</NuxtLink>

      <form v-else class="form" @submit.prevent="submitLogin">
        <div class="field">
          <label>Korisničko ime</label>
          <input v-model="login.username" autocomplete="username">
        </div>
        <div class="field">
          <label>Lozinka</label>
          <input v-model="login.password" type="password" autocomplete="current-password">
        </div>
        <p v-if="error" class="error">{{ error }}</p>
        <button class="btn" :disabled="loading">{{ loading ? 'Prijava...' : 'Prijavi se' }}</button>
      </form>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  display: grid;
  min-height: 100vh;
  place-items: center;
  padding: 24px;
  background:
    radial-gradient(circle at 70% 20%, rgba(61, 184, 168, 0.18), transparent 34%),
    var(--bg);
}

.login-card {
  width: min(100%, 430px);
  padding: 34px;
}

img {
  width: 210px;
  height: 74px;
  object-fit: contain;
  object-position: left center;
}

h1 {
  margin: 18px 0 8px;
  font-family: Syne, Inter, sans-serif;
}

p {
  margin: 0 0 24px;
  color: var(--muted);
}

.error {
  margin: 0;
  color: var(--pink);
  font-size: 0.86rem;
}
</style>
