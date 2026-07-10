# DWN Nuxt 4 Website

Quick Nuxt 4 + MySQL website with:

- public homepage
- blog listing
- case studies listing
- admin login
- admin CRUD for blog posts and case studies
- admin CMS for homepage sections: hero, bento/stats, services, process, team, FAQ, testimonials, clients and CTA
- image upload stored in MySQL `media_files` as `MEDIUMBLOB`
- full detail pages for blog posts and case studies
- `Klijenti` category page for backlink/client articles
- separate `Klijenti` admin tab for editing homepage client pills
- embed HTML field for YouTube/iframe/Instagram/TikTok embeds
- favicon generated from the navbar logo
- dynamic `/sitemap.xml`
- MySQL queries through `mysql2`
- secure admin password hashing with Node `crypto.scrypt`

## 1. Create the app

If you are starting from this folder:

```bash
cd dwn-nuxt-app
npm install
cp .env.example .env
```

If you want to create it manually from zero:

```bash
npx nuxi@latest init dwn-nuxt-app
cd dwn-nuxt-app
npm install mysql2
```

Then copy the files from this scaffold into the new project.

## 2. Create the database

Open MySQL and run:

```bash
mysql -u root -p < database/schema.sql
```

If your MySQL user/password/database are different, edit `.env`.

```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=root
DB_NAME=dwn_site
SESSION_DAYS=14
NUXT_PUBLIC_SITE_URL=http://localhost:3000
```

If you already created the old database before the homepage CMS tables existed, run only this migration:

```bash
mysql -u root -p dwn_site < database/cms-sections-migration.sql
```

If your DB already exists and you are adding image uploads/detail pages now, run:

```bash
mysql -u root -p dwn_site < database/media-and-detail-migration.sql
```

## 3. Create admin user

```bash
npm run seed:admin
```

Enter username, password and display name.

## 4. Run development server

```bash
npm run dev
```

Open:

- `http://localhost:3000`
- `http://localhost:3000/blog`
- `http://localhost:3000/cases`
- `http://localhost:3000/admin`

## 5. Production build

```bash
npm run build
npm run preview
```

For deployment with PM2:

```bash
npm run build
pm2 start .output/server/index.mjs --name dwn-site
```

## File map

```text
assets/css/main.css                  Global design system and responsive styles
components/AppHeader.vue             Public navigation with cleaned logo
components/AppFooter.vue             Footer
components/BlogCard.vue              Blog preview card
components/CaseCard.vue              Case study preview card
pages/index.vue                      Homepage
pages/blog/index.vue                 Blog listing page
pages/blog/[slug].vue                Blog detail page
pages/cases/index.vue                Case studies page
pages/cases/[slug].vue               Case study detail page
pages/clients/index.vue              Client/backlink article category page
pages/clients/[id].vue               Client detail/backlink article page
pages/admin/index.vue                Admin login page
pages/admin/dashboard.vue            Admin editor
public/logo.png                      Cropped transparent logo from uploaded image
public/brand/logo-nav.png            New navbar/footer logo
public/brand/logo-hero.png           New homepage hero logo
public/favicon.ico                   Browser favicon
public/favicon.png                   PNG favicon
database/schema.sql                  MySQL schema and seed content
database/cms-sections-migration.sql  Adds homepage CMS to an existing DB
database/media-and-detail-migration.sql Adds media upload/detail/embed fields
server/utils/db.ts                   mysql2 pool
server/utils/auth.ts                 Session cookie and admin guard
server/utils/password.ts             Password hashing and verification
server/utils/slug.ts                 Serbian Latin slug helper
server/utils/content.ts              Homepage CMS grouping helper
server/api/auth/login.post.ts        Login endpoint
server/api/auth/logout.post.ts       Logout endpoint
server/api/auth/me.get.ts            Current admin endpoint
server/api/media/[id].get.ts         Serves uploaded media from DB
server/api/admin/media.post.ts       Admin image upload endpoint
server/api/public/posts.get.ts       Public posts endpoint
server/api/public/cases.get.ts       Public cases endpoint
server/api/public/sections.get.ts    Public homepage CMS endpoint
server/api/admin/posts/*             Admin post CRUD
server/api/admin/cases/*             Admin case CRUD
server/api/admin/sections*           Admin homepage CMS CRUD
server/routes/sitemap.xml.get.ts     Dynamic sitemap
scripts/create-admin.mjs             CLI admin user creator
```

## Editing clients

There are two client-related areas:

- `Admin → Klijenti`: adds/edits clients from the `clients` CMS section. These appear on `/clients`, on the homepage client section, and each item opens as `/clients/<id>-<client-name>`.
- `Admin → Blog`: regular blog posts. Use this for general articles, not client pages.

## Why no Google Auth?

For a small friend website, username/password is faster and easier:

- no Google Cloud app setup
- no callback URL/domain issues
- no OAuth consent screen
- easy to move between localhost and production

If Google Auth is needed later, keep the same `admin_users` table and add an `allowed_email` column.
