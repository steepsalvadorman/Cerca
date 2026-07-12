-- 0002's seed data inserted explicit ids into technician_profiles and
-- tech_teams (both SERIAL primary keys) without advancing the backing
-- sequence, so the very next auto-assigned insert collides with a seeded
-- row (e.g. POST /technician/profile for a brand-new technician fails
-- with "duplicate key value violates unique constraint
-- technician_profiles_pkey"). Resync both sequences to the current max id.
SELECT setval('technician_profiles_id_seq', (SELECT COALESCE(MAX(id), 1) FROM technician_profiles));
SELECT setval('tech_teams_id_seq', (SELECT COALESCE(MAX(id), 1) FROM tech_teams));
