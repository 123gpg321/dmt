-- Migration: add_phone_to_users_table
-- ====  UP  ====
ALTER TABLE users ADD phone INT(10);

-- ====  DOWN  ====
