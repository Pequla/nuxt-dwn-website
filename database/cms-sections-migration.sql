USE dwn_site;

CREATE TABLE IF NOT EXISTS content_sections (
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

CREATE TABLE IF NOT EXISTS content_items (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  section_key VARCHAR(80) NOT NULL,
  title VARCHAR(255) NOT NULL,
  subtitle VARCHAR(255) NULL,
  body MEDIUMTEXT NULL,
  icon VARCHAR(40) NULL,
  label VARCHAR(120) NULL,
  value VARCHAR(120) NULL,
  url VARCHAR(255) NULL,
  meta_json JSON NULL,
  enabled TINYINT(1) NOT NULL DEFAULT 1,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_content_items_section (section_key, enabled, sort_order),
  CONSTRAINT fk_content_items_section
    FOREIGN KEY (section_key) REFERENCES content_sections(section_key)
    ON DELETE CASCADE
);

INSERT IGNORE INTO content_sections
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
SELECT section_key, title, subtitle, body, icon, label, value, meta_json, enabled, sort_order
FROM (
  SELECT 'hero' section_key, 'Brendova' title, NULL subtitle, NULL body, NULL icon, 'Brendova' label, '47+' value, NULL meta_json, 1 enabled, 10 sort_order
  UNION ALL SELECT 'hero', 'Prosečni ROAS', NULL, NULL, NULL, 'Prosečni ROAS', '3.8x', NULL, 1, 20
  UNION ALL SELECT 'hero', 'Prihod klijenata', NULL, NULL, NULL, 'Prihod klijenata', '€12M+', NULL, 1, 30
  UNION ALL SELECT 'bento', 'Klijenti', NULL, NULL, NULL, '+ brendova', '47', NULL, 1, 10
  UNION ALL SELECT 'bento', 'Prosečni ROAS', NULL, 'Na svakom evru uloženom u reklame.', NULL, 'x povrat', '3.8', NULL, 1, 20
  UNION ALL SELECT 'bento', 'Prihod generisan za klijente', NULL, 'Ukupno generisan prihod od 2021. do danas kroz naše kampanje.', NULL, 'M+', '€12', NULL, 1, 30
  UNION ALL SELECT 'bento', 'Naša prednost', '95% odluka donosi podsvest.', 'Mi kreiramo reklame koje komuniciraju direktno sa limbičkim sistemom.', '🧠', 'Naučno utemeljeno', NULL, NULL, 1, 40
  UNION ALL SELECT 'services', 'Community Management · Srbija', '01', 'Upravljamo profilima na svim društvenim mrežama, moderiramo zajednicu i gradimo lojalnu publiku.', '💬', NULL, NULL, NULL, 1, 10
  UNION ALL SELECT 'services', 'Paid Media · Facebook, Instagram & Google Ads', '02', 'Kreiramo i optimizujemo reklamne kampanje zasnovane na neuromarketing principima.', '📢', NULL, NULL, NULL, 1, 20
  UNION ALL SELECT 'services', 'Produkcija reklama · TikTok, Instagram & YouTube', '03', 'Snimamo i editujemo video reklame i kreativni sadržaj koji zaustavlja skrolovanje.', '🎬', NULL, NULL, NULL, 1, 30
  UNION ALL SELECT 'services', 'Strateški konsalting · Brend strategija', '04', 'Razvijamo strategije zasnovane na istraživanjima ponašanja potrošača.', '📊', NULL, NULL, NULL, 1, 40
  UNION ALL SELECT 'process', 'Razgovor', '01', 'Upoznajemo vaš brend, ciljnu grupu, konkurenciju i željene poslovne ishode.', NULL, NULL, NULL, NULL, 1, 10
  UNION ALL SELECT 'process', 'Strategija', '02', 'Analiziramo trendove i neuromarketing podatke za kreiranje prilagođene reklamne strategije.', NULL, NULL, NULL, NULL, 1, 20
  UNION ALL SELECT 'process', 'Kreacija & lansiranje', '03', 'Produkujemo reklame i pokrećemo kampanje na relevantnim platformama.', NULL, NULL, NULL, NULL, 1, 30
  UNION ALL SELECT 'process', 'Optimizacija', '04', 'Pratimo analitiku, optimizujemo performanse i izveštavamo vas svake nedelje.', NULL, NULL, NULL, NULL, 1, 40
  UNION ALL SELECT 'team', 'Prof. Slavko Alčaković', 'Ko-osnivač · Akademski direktor', 'Vanredni profesor marketinga i istraživač u oblastima neuromarketinga, digitalnog advertajzinga i ponašanja potrošača.', 'SA', NULL, NULL, JSON_OBJECT('tags', JSON_ARRAY('Neuromarketing', 'Digitalni marketing', 'Singidunum')), 1, 10
  UNION ALL SELECT 'team', 'Ognjen Živanović', 'Ko-osnivač · Neuromarketing specijalista', 'Master ekonomista sa specijalizacijom iz neuromarketinga i fokusom na social media strategiju.', 'OŽ', NULL, NULL, JSON_OBJECT('tags', JSON_ARRAY('Neuromarketing', 'Social Media', 'Copywriting')), 1, 20
  UNION ALL SELECT 'team', 'Tina Jovanović', 'Ko-osnivač · Kreativna direktorka', 'Kreativna direktorka i content strategist sa iskustvom u produkciji digitalnih reklama i brendiranju.', 'TJ', NULL, NULL, JSON_OBJECT('tags', JSON_ARRAY('Creative Direction', 'Video produkcija', 'Brend identitet')), 1, 30
  UNION ALL SELECT 'faq', 'Šta je DWN i čime se bavi kao reklamna agencija?', NULL, 'DWN je reklamna i digitalna marketing agencija iz Beograda.', NULL, NULL, NULL, NULL, 1, 10
  UNION ALL SELECT 'faq', 'Koje platforme pokriva vaša reklamna agencija?', NULL, 'Upravljamo kampanjama na Facebook Ads, Instagram Ads, Google Ads, TikTok Ads i LinkedIn Ads.', NULL, NULL, NULL, NULL, 1, 20
  UNION ALL SELECT 'faq', 'Da li kreirate i produkujete reklame ili samo upravljate kampanjama?', NULL, 'Radimo oboje — od kreativnog koncepta i produkcije do paid media kampanja.', NULL, NULL, NULL, NULL, 1, 30
  UNION ALL SELECT 'testimonials', 'Ivana Jovičić', 'CMO · Lumiere.rs', 'Oduševljena sam saradnjom sa DWN. Agencija je transformisala naše prisustvo na Instagramu.', 'IJ', NULL, NULL, NULL, 1, 10
  UNION ALL SELECT 'testimonials', 'Milan Janković', 'CMO · Sportzin', 'DWN zaista razume zašto neka reklama funkcioniše. Rezultati su govorili sami za sebe.', 'MJ', NULL, NULL, NULL, 1, 20
  UNION ALL SELECT 'clients', 'Lumiere.rs', NULL, NULL, NULL, NULL, NULL, NULL, 1, 10
  UNION ALL SELECT 'clients', 'Sportzin', NULL, NULL, NULL, NULL, NULL, NULL, 1, 20
  UNION ALL SELECT 'clients', 'Jack & Jones Beograd', NULL, NULL, NULL, NULL, NULL, NULL, 1, 30
  UNION ALL SELECT 'clients', 'Knedly', NULL, NULL, NULL, NULL, NULL, NULL, 1, 40
  UNION ALL SELECT 'clients', 'FTB Perfumes', NULL, NULL, NULL, NULL, NULL, NULL, 1, 50
  UNION ALL SELECT 'clients', 'Vucko Vet', NULL, NULL, NULL, NULL, NULL, NULL, 1, 60
  UNION ALL SELECT 'clients', 'Petar Centar', NULL, NULL, NULL, NULL, NULL, NULL, 1, 70
  UNION ALL SELECT 'clients', 'Kolibri NYC', NULL, NULL, NULL, NULL, NULL, NULL, 1, 80
  UNION ALL SELECT 'clients', 'Sound River Studios NYC', NULL, NULL, NULL, NULL, NULL, NULL, 1, 90
  UNION ALL SELECT 'clients', 'Zen Car', NULL, NULL, NULL, NULL, NULL, NULL, 1, 100
) seed
WHERE NOT EXISTS (SELECT 1 FROM content_items LIMIT 1);
