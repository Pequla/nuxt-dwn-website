USE dwn_site;

CREATE TABLE IF NOT EXISTS media_files (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  filename VARCHAR(255) NOT NULL,
  mime_type VARCHAR(120) NOT NULL,
  size_bytes INT UNSIGNED NOT NULL,
  data MEDIUMBLOB NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

ALTER TABLE posts
  ADD COLUMN image_media_id INT UNSIGNED NULL AFTER body,
  ADD COLUMN embed_html MEDIUMTEXT NULL AFTER image_media_id;

ALTER TABLE posts
  ADD KEY idx_posts_image (image_media_id);

ALTER TABLE posts
  ADD CONSTRAINT fk_posts_image
    FOREIGN KEY (image_media_id) REFERENCES media_files(id)
    ON DELETE SET NULL;

ALTER TABLE case_studies
  ADD COLUMN image_media_id INT UNSIGNED NULL AFTER body,
  ADD COLUMN embed_html MEDIUMTEXT NULL AFTER image_media_id;

ALTER TABLE case_studies
  ADD KEY idx_case_studies_image (image_media_id);

ALTER TABLE case_studies
  ADD CONSTRAINT fk_case_studies_image
    FOREIGN KEY (image_media_id) REFERENCES media_files(id)
    ON DELETE SET NULL;

ALTER TABLE content_items
  ADD COLUMN image_media_id INT UNSIGNED NULL AFTER url;

ALTER TABLE content_items
  ADD KEY idx_content_items_image (image_media_id);

ALTER TABLE content_items
  ADD CONSTRAINT fk_content_items_image
    FOREIGN KEY (image_media_id) REFERENCES media_files(id)
    ON DELETE SET NULL;
