-- Migration: add_address_to_users_table
-- ====  UP  ====
ALTER TABLE users ADD address VARCHAR(60);

-- ====  DOWN  ====
