CREATE DATABASE IF NOT EXISTS dwn_site
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE dwn_site;

CREATE TABLE admin_users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(80) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(120) NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_admin_users_username (username)
);

CREATE TABLE admin_sessions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  admin_user_id INT UNSIGNED NOT NULL,
  token_hash CHAR(64) NOT NULL,
  expires_at DATETIME NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_admin_sessions_token_hash (token_hash),
  KEY idx_admin_sessions_user (admin_user_id),
  CONSTRAINT fk_admin_sessions_user
    FOREIGN KEY (admin_user_id) REFERENCES admin_users(id)
    ON DELETE CASCADE
);

CREATE TABLE media_files (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  filename VARCHAR(255) NOT NULL,
  mime_type VARCHAR(120) NOT NULL,
  size_bytes INT UNSIGNED NOT NULL,
  data MEDIUMBLOB NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  slug VARCHAR(180) NOT NULL,
  title VARCHAR(220) NOT NULL,
  excerpt TEXT NOT NULL,
  body MEDIUMTEXT NULL,
  image_media_id INT UNSIGNED NULL,
  embed_html MEDIUMTEXT NULL,
  category VARCHAR(80) NOT NULL,
  emoji VARCHAR(16) NULL,
  read_time INT UNSIGNED NOT NULL DEFAULT 5,
  published_at DATE NULL,
  show_home TINYINT(1) NOT NULL DEFAULT 0,
  published TINYINT(1) NOT NULL DEFAULT 1,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_posts_slug (slug),
  KEY idx_posts_public (published, show_home, sort_order),
  KEY idx_posts_image (image_media_id),
  CONSTRAINT fk_posts_image
    FOREIGN KEY (image_media_id) REFERENCES media_files(id)
    ON DELETE SET NULL
);

CREATE TABLE case_studies (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  slug VARCHAR(180) NOT NULL,
  client VARCHAR(160) NOT NULL,
  title VARCHAR(220) NOT NULL,
  excerpt TEXT NOT NULL,
  body MEDIUMTEXT NULL,
  image_media_id INT UNSIGNED NULL,
  embed_html MEDIUMTEXT NULL,
  category VARCHAR(80) NOT NULL,
  secondary_category VARCHAR(80) NULL,
  metric1_value VARCHAR(40) NULL,
  metric1_label VARCHAR(80) NULL,
  metric2_value VARCHAR(40) NULL,
  metric2_label VARCHAR(80) NULL,
  featured TINYINT(1) NOT NULL DEFAULT 0,
  show_home TINYINT(1) NOT NULL DEFAULT 0,
  published TINYINT(1) NOT NULL DEFAULT 1,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_case_studies_slug (slug),
  KEY idx_case_studies_public (published, show_home, featured, sort_order),
  KEY idx_case_studies_image (image_media_id),
  CONSTRAINT fk_case_studies_image
    FOREIGN KEY (image_media_id) REFERENCES media_files(id)
    ON DELETE SET NULL
);

CREATE TABLE content_sections (
  section_key VARCHAR(80) NOT NULL,
  eyebrow VARCHAR(180) NULL,
  title VARCHAR(255) NOT NULL,
  subtitle TEXT NULL,
  body MEDIUMTEXT NULL,
  cta_label VARCHAR(160) NULL,
  cta_url VARCHAR(255) NULL,
  enabled TINYINT(1) NOT NULL DEFAULT 1,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (section_key),
  KEY idx_content_sections_public (enabled, sort_order)
);

CREATE TABLE content_items (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  section_key VARCHAR(80) NOT NULL,
  title VARCHAR(255) NOT NULL,
  subtitle VARCHAR(255) NULL,
  body MEDIUMTEXT NULL,
  icon VARCHAR(40) NULL,
  label VARCHAR(120) NULL,
  value VARCHAR(120) NULL,
  url VARCHAR(255) NULL,
  image_media_id INT UNSIGNED NULL,
  meta_json JSON NULL,
  enabled TINYINT(1) NOT NULL DEFAULT 1,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_content_items_section (section_key, enabled, sort_order),
  KEY idx_content_items_image (image_media_id),
  CONSTRAINT fk_content_items_section
    FOREIGN KEY (section_key) REFERENCES content_sections(section_key)
    ON DELETE CASCADE,
  CONSTRAINT fk_content_items_image
    FOREIGN KEY (image_media_id) REFERENCES media_files(id)
    ON DELETE SET NULL
);

INSERT INTO posts
  (slug, title, excerpt, body, category, emoji, read_time, published_at, show_home, published, sort_order)
VALUES
  ('zasto-95-odluka-o-kupovini-donosi-podsvest', 'Zašto 95% odluka o kupovini donosi podsvest', 'Decenije istraživanja pokazuju da svesni um igra manju ulogu u procesu kupovine nego što mislimo.', 'Dodajte kompletan tekst iz admin panela.', 'Neuromarketing', '🧠', 8, '2025-06-01', 1, 1, 10),
  ('eye-tracking-i-vizuelna-paznja', 'Eye-tracking i vizuelna pažnja', 'Šta korisnici stvarno gledaju na reklami i kako taj podatak menja kreativnu strategiju.', 'Dodajte kompletan tekst iz admin panela.', 'Neuromarketing', '👁️', 6, '2025-05-10', 1, 1, 20),
  ('roas-vs-cpa', 'ROAS vs. CPA: koji KPI zaista meri uspeh kampanja', 'Kratak vodič kroz metrike koje imaju smisla kada prodajni ciklus nije jednostavan.', 'Dodajte kompletan tekst iz admin panela.', 'Paid Media', '📊', 5, '2025-05-01', 1, 1, 30);

INSERT INTO case_studies
  (slug, client, title, excerpt, body, category, secondary_category, metric1_value, metric1_label, metric2_value, metric2_label, featured, show_home, published, sort_order)
VALUES
  ('knedly-tiktok-sadrzaj', 'Knedly', 'Viralni TikTok sadržaj koji je izgradio zajednicu od nule', 'Kompletna content i reklamna strategija za TikTok bazirana na neuromarketing principima.', 'Dodajte kompletan tekst iz admin panela.', 'TikTok', 'Video produkcija', 'Viral', 'Doseg videa', 'Organski', 'Rast pratilaca', 1, 1, 1, 10),
  ('lumiere-instagram-transformacija', 'Lumiere.rs', 'Transformacija Instagram prisustva luksuznog brenda', 'Visual storytelling pristup koji je doneo rast organskog dosega i engagementa.', 'Dodajte kompletan tekst iz admin panela.', 'Instagram', 'Visual storytelling', '+320%', 'Organski doseg', '5x', 'Engagement', 0, 1, 1, 20);

INSERT INTO content_sections
  (section_key, eyebrow, title, subtitle, body, cta_label, cta_url, enabled, sort_order)
VALUES
  ('hero', 'Reklamna & digitalna agencija · Beograd', 'Reklamna agencija koja govori jezikom vašeg mozga.', 'DWN – Digital With Neuro je reklamna i digitalna marketing agencija iz Beograda. Kreiramo reklame, paid media kampanje i brend strategije zasnovane na neuromarketingu.', NULL, 'Besplatna konsultacija', 'mailto:digitaloffice@digitalwithneuro.com', 1, 10),
  ('bento', 'Ko smo mi', 'Reklamna agencija vođena naukom o mozgu.', 'Kombinujemo neuromarketing istraživanja sa paid media, produkcijom i strategijom — za brendove koji žele merljiv rast.', NULL, 'Zakažite poziv', '#kontakt', 1, 20),
  ('services', 'Reklamna agencija · Digitalni marketing · Beograd', 'Kreativnost vođena naukom o mozgu.', 'Kao reklamna i digitalna agencija iz Beograda, kreiramo reklame i strategije koje ne samo privlače pažnju — nego pokreću akciju.', 'DWN je reklamna agencija u Beogradu koja sistematski primenjuje neuromarketing u procesu kreiranja reklama i digitalnih strategija.', NULL, NULL, 1, 30),
  ('process', 'Naš proces', 'Od ideje do merljive reklame', 'Četiri koraka koja svaki projekat pretvaraju u dugoročni rast vašeg brenda.', NULL, NULL, NULL, 1, 40),
  ('team', 'Naš tim · Stručnjaci', 'Mozgovi iza naše agencije.', 'Akademska ekspertiza + terenska praksa = rezultati koji se mere. Upoznajte ljude koji pokreću DWN.', NULL, NULL, NULL, 1, 50),
  ('faq', 'FAQ · Česta pitanja o reklamnoj agenciji', 'Sve što želite da znate o DWN agenciji.', 'Odgovori na najčešća pitanja o digitalnom marketingu, reklamama i saradnji sa DWN.', NULL, NULL, NULL, 1, 60),
  ('testimonials', 'Testimonijali · Klijenti o nama', 'Šta klijenti kažu o DWN agenciji.', NULL, NULL, NULL, NULL, 1, 70),
  ('clients', 'Naši klijenti · Reference reklamne agencije', 'Brendovi koji nam veruju.', 'Radili smo sa brendovima iz oblasti hrane, mode, zdravlja, sporta, tehnologije i zabave — u Srbiji i inostranstvu.', NULL, NULL, NULL, 1, 80),
  ('cta', NULL, 'Spremni za reklame koje zaista funkcionišu?', 'Zakažite besplatnu 30-minutnu sesiju sa DWN timom. Bez obaveza — samo konkretan plan za vaš brend.', NULL, 'Zakažite poziv', 'mailto:digitaloffice@digitalwithneuro.com', 1, 90);

INSERT INTO content_items
  (section_key, title, subtitle, body, icon, label, value, meta_json, enabled, sort_order)
VALUES
  ('hero', 'Brendova', NULL, NULL, NULL, 'Brendova', '47+', NULL, 1, 10),
  ('hero', 'Prosečni ROAS', NULL, NULL, NULL, 'Prosečni ROAS', '3.8x', NULL, 1, 20),
  ('hero', 'Prihod klijenata', NULL, NULL, NULL, 'Prihod klijenata', '€12M+', NULL, 1, 30),
  ('bento', 'Klijenti', NULL, NULL, NULL, '+ brendova', '47', NULL, 1, 10),
  ('bento', 'Prosečni ROAS', NULL, 'Na svakom evru uloženom u reklame.', NULL, 'x povrat', '3.8', NULL, 1, 20),
  ('bento', 'Prihod generisan za klijente', NULL, 'Ukupno generisan prihod od 2021. do danas kroz naše kampanje.', NULL, 'M+', '€12', NULL, 1, 30),
  ('bento', 'Naša prednost', '95% odluka donosi podsvest.', 'Mi kreiramo reklame koje komuniciraju direktno sa limbičkim sistemom — tamo gde se donose kupovne odluke.', '🧠', 'Naučno utemeljeno', NULL, NULL, 1, 40),
  ('services', 'Community Management · Srbija', '01', 'Upravljamo profilima na svim društvenim mrežama, moderiramo zajednicu i gradimo lojalnu publiku.', '💬', NULL, NULL, NULL, 1, 10),
  ('services', 'Paid Media · Facebook, Instagram & Google Ads', '02', 'Kreiramo i optimizujemo reklamne kampanje. Svaka reklama je zasnovana na neuromarketing principima za maksimalni ROI.', '📢', NULL, NULL, NULL, 1, 20),
  ('services', 'Produkcija reklama · TikTok, Instagram & YouTube', '03', 'Snimamo i editujemo video reklame i kreativni sadržaj koji zaustavlja skrolovanje.', '🎬', NULL, NULL, NULL, 1, 30),
  ('services', 'Strateški konsalting · Brend strategija', '04', 'Razvijamo prilagođene strategije zasnovane na istraživanjima ponašanja potrošača.', '📊', NULL, NULL, NULL, 1, 40),
  ('process', 'Razgovor', '01', 'Upoznajemo vaš brend, ciljnu grupu, konkurenciju i željene poslovne ishode.', NULL, NULL, NULL, NULL, 1, 10),
  ('process', 'Strategija', '02', 'Analiziramo trendove i neuromarketing podatke za kreiranje prilagođene reklamne strategije.', NULL, NULL, NULL, NULL, 1, 20),
  ('process', 'Kreacija & lansiranje', '03', 'Produkujemo reklame i pokrećemo kampanje na svim relevantnim platformama.', NULL, NULL, NULL, NULL, 1, 30),
  ('process', 'Optimizacija', '04', 'Pratimo analitiku, optimizujemo performanse i izveštavamo vas svake nedelje.', NULL, NULL, NULL, NULL, 1, 40),
  ('team', 'Prof. Slavko Alčaković', 'Ko-osnivač · Akademski direktor', 'Vanredni profesor marketinga i istraživač u oblastima neuromarketinga, digitalnog advertajzinga i ponašanja potrošača.', 'SA', NULL, NULL, JSON_OBJECT('tags', JSON_ARRAY('Neuromarketing', 'Digitalni marketing', 'Singidunum', 'Advertajzing')), 1, 10),
  ('team', 'Ognjen Živanović', 'Ko-osnivač · Neuromarketing specijalista', 'Master ekonomista sa specijalizacijom iz neuromarketinga i fokusom na social media strategiju i copywriting koji konvertuje.', 'OŽ', NULL, NULL, JSON_OBJECT('tags', JSON_ARRAY('Neuromarketing', 'Social Media', 'Copywriting')), 1, 20),
  ('team', 'Tina Jovanović', 'Ko-osnivač · Kreativna direktorka', 'Kreativna direktorka i content strategist sa iskustvom u produkciji digitalnih reklama, brendiranju i kampanjama za TikTok i Instagram.', 'TJ', NULL, NULL, JSON_OBJECT('tags', JSON_ARRAY('Creative Direction', 'Video produkcija', 'Brend identitet')), 1, 30),
  ('faq', 'Šta je DWN i čime se bavi kao reklamna agencija?', NULL, 'DWN – Digital With Neuro je reklamna i digitalna marketing agencija iz Beograda. Kombinujemo neuromarketing istraživanja sa produkcijom reklama, paid media kampanjama i community managementom.', NULL, NULL, NULL, NULL, 1, 10),
  ('faq', 'Koje platforme pokriva vaša reklamna agencija?', NULL, 'Upravljamo reklamnim kampanjama na Facebook Ads, Instagram Ads, Google Ads, TikTok Ads i LinkedIn Ads.', NULL, NULL, NULL, NULL, 1, 20),
  ('faq', 'Da li kreirate i produkujete reklame ili samo upravljate kampanjama?', NULL, 'Radimo oboje — kreiramo kreativni koncept, produkujemo video reklame i vizuele, pa ih zatim pokrećemo kroz paid media kampanje.', NULL, NULL, NULL, NULL, 1, 30),
  ('faq', 'Koliko košta saradnja sa DWN reklamnom agencijom?', NULL, 'Cene prilagođavamo veličini projekta i budžetu klijenta. Zakažite besplatnu konsultaciju za ponudu prilagođenu vašem brendu.', NULL, NULL, NULL, NULL, 1, 40),
  ('testimonials', 'Ivana Jovičić', 'CMO · Lumiere.rs', 'Oduševljena sam saradnjom sa DWN. Agencija je transformisala naše prisustvo na Instagramu — strateški i rezultatski.', 'IJ', NULL, NULL, NULL, 1, 10),
  ('testimonials', 'Milan Janković', 'CMO · Sportzin', 'DWN zaista razume zašto neka reklama funkcioniše. Svaki video je naučno utemeljen i vizuelno moćan.', 'MJ', NULL, NULL, NULL, 1, 20),
  ('clients', 'Lumiere.rs', NULL, NULL, NULL, NULL, NULL, NULL, 1, 10),
  ('clients', 'Sportzin', NULL, NULL, NULL, NULL, NULL, NULL, 1, 20),
  ('clients', 'Jack & Jones Beograd', NULL, NULL, NULL, NULL, NULL, NULL, 1, 30),
  ('clients', 'Knedly', NULL, NULL, NULL, NULL, NULL, NULL, 1, 40),
  ('clients', 'FTB Perfumes', NULL, NULL, NULL, NULL, NULL, NULL, 1, 50),
  ('clients', 'Vucko Vet', NULL, NULL, NULL, NULL, NULL, NULL, 1, 60),
  ('clients', 'Petar Centar', NULL, NULL, NULL, NULL, NULL, NULL, 1, 70),
  ('clients', 'Kolibri NYC', NULL, NULL, NULL, NULL, NULL, NULL, 1, 80),
  ('clients', 'Sound River Studios NYC', NULL, NULL, NULL, NULL, NULL, NULL, 1, 90),
  ('clients', 'Zen Car', NULL, NULL, NULL, NULL, NULL, NULL, 1, 100);
