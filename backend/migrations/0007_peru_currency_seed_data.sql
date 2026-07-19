-- The seed demo technicians/teams and the price_label column default were
-- priced in Chilean pesos ($) from the original prototype. The real target
-- market is Peru (soles, S/) — fixes the currency symbol and rough scale on
-- demo/placeholder data only (roughly divides CLP amounts by ~250 to land
-- on plausible sol figures; not a researched pricing decision).
ALTER TABLE technician_profiles ALTER COLUMN price_label SET DEFAULT 'Desde S/ 15';

UPDATE technician_profiles SET price_label = 'Desde S/ 60' WHERE price_label = 'Desde $15.000';
UPDATE technician_profiles SET price_label = 'Desde S/ 70' WHERE price_label = 'Desde $18.000';
UPDATE technician_profiles SET price_label = 'Desde S/ 80' WHERE price_label = 'Desde $20.000';
UPDATE technician_profiles SET price_label = 'Desde S/ 50' WHERE price_label = 'Desde $12.000';

UPDATE tech_teams SET price_label = 'Desde S/ 3,450', labor_cost = 3150, materials_cost = 1700, mobility_cost = 260 WHERE id = 1;
UPDATE tech_teams SET price_label = 'Desde S/ 1,700', labor_cost = 1360, materials_cost = 600, mobility_cost = 360 WHERE id = 2;
UPDATE tech_teams SET price_label = 'Desde S/ 1,250', labor_cost = 1040, materials_cost = 440, mobility_cost = 220 WHERE id = 3;
