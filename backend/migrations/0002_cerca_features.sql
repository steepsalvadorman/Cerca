-- Migrations file for all Cerca features

-- 1. Technician Profiles table
CREATE TABLE IF NOT EXISTS technician_profiles (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    oficio TEXT NOT NULL,
    rating DOUBLE PRECISION NOT NULL DEFAULT 5.0,
    reviews INT NOT NULL DEFAULT 0,
    distance TEXT NOT NULL DEFAULT '0.5 km',
    price_label TEXT NOT NULL DEFAULT 'Desde $15.000',
    pin_top DOUBLE PRECISION NOT NULL,
    pin_left DOUBLE PRECISION NOT NULL,
    coverage_km INT NOT NULL DEFAULT 5,
    available_days TEXT[] NOT NULL DEFAULT '{}',
    categories TEXT[] NOT NULL DEFAULT '{}',
    is_verified BOOLEAN NOT NULL DEFAULT FALSE
);

-- 2. Technician Documents table
CREATE TABLE IF NOT EXISTS technician_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    technician_profile_id INT NOT NULL REFERENCES technician_profiles(id) ON DELETE CASCADE,
    document_key TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('uploaded', 'pending')),
    UNIQUE(technician_profile_id, document_key)
);

-- 3. Tech Teams table
CREATE TABLE IF NOT EXISTS tech_teams (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    mono TEXT NOT NULL,
    oficio TEXT NOT NULL,
    rating DOUBLE PRECISION NOT NULL DEFAULT 5.0,
    reviews INT NOT NULL DEFAULT 0,
    distance TEXT NOT NULL DEFAULT '3.0 km',
    price_label TEXT NOT NULL,
    pin_top DOUBLE PRECISION NOT NULL,
    pin_left DOUBLE PRECISION NOT NULL,
    crew INT NOT NULL DEFAULT 1,
    projects INT NOT NULL DEFAULT 0,
    labor_cost INT NOT NULL,
    materials_cost INT NOT NULL,
    mobility_cost INT NOT NULL
);

-- 4. Client Profiles table
CREATE TABLE IF NOT EXISTS client_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    profile_saved BOOLEAN NOT NULL DEFAULT FALSE
);

-- 5. Client Addresses table
CREATE TABLE IF NOT EXISTS client_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    label TEXT NOT NULL,
    detail TEXT NOT NULL
);

-- 6. Client Payment Methods table
CREATE TABLE IF NOT EXISTS client_payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    label TEXT NOT NULL,
    detail TEXT NOT NULL
);

-- 7. Job Requests table
CREATE TABLE IF NOT EXISTS job_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    technician_profile_id INT REFERENCES technician_profiles(id) ON DELETE SET NULL,
    tech_team_id INT REFERENCES tech_teams(id) ON DELETE SET NULL,
    job_kind TEXT NOT NULL CHECK (job_kind IN ('direct', 'bidding', 'project')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'completed', 'cancelled')),
    timeline_step INT NOT NULL DEFAULT 0,
    fee_type TEXT NOT NULL CHECK (fee_type IN ('direct', 'bidding', 'project')),
    fee_paid BOOLEAN NOT NULL DEFAULT FALSE,
    payment_method TEXT,
    payment_done BOOLEAN NOT NULL DEFAULT FALSE,
    rating INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 8. Job Offers (Bidding) table
CREATE TABLE IF NOT EXISTS job_offers (
    id SERIAL PRIMARY KEY,
    job_request_id UUID NOT NULL REFERENCES job_requests(id) ON DELETE CASCADE,
    technician_profile_id INT NOT NULL REFERENCES technician_profiles(id) ON DELETE CASCADE,
    price INT NOT NULL,
    eta TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 9. Chat Messages table
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_request_id UUID NOT NULL REFERENCES job_requests(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sender_role TEXT NOT NULL CHECK (sender_role IN ('client', 'technician')),
    text TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 10. Tracking Locations table
CREATE TABLE IF NOT EXISTS tracking_locations (
    job_request_id UUID PRIMARY KEY REFERENCES job_requests(id) ON DELETE CASCADE,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- SEED DATA

-- Insert seed users
-- The hash below is for 'password123'
INSERT INTO users (id, email, name, role, password_hash, created_at)
VALUES
    ('00000000-0000-0000-0000-000000000001', 'marcelo@cerca.com', 'Marcelo Reyes', 'technician', '$argon2id$v=19$m=19456,t=2,p=1$k8CqEmfoRpEwkTszAlG5Hw$0r40UshfbvLQaYGu0089358JjzidfPdV/aebyH3MaPA', now()),
    ('00000000-0000-0000-0000-000000000002', 'ana@cerca.com', 'Ana Fuentes', 'technician', '$argon2id$v=19$m=19456,t=2,p=1$k8CqEmfoRpEwkTszAlG5Hw$0r40UshfbvLQaYGu0089358JjzidfPdV/aebyH3MaPA', now()),
    ('00000000-0000-0000-0000-000000000003', 'jorge@cerca.com', 'Jorge Salinas', 'technician', '$argon2id$v=19$m=19456,t=2,p=1$k8CqEmfoRpEwkTszAlG5Hw$0r40UshfbvLQaYGu0089358JjzidfPdV/aebyH3MaPA', now()),
    ('00000000-0000-0000-0000-000000000004', 'patricia@cerca.com', 'Patricia Vega', 'technician', '$argon2id$v=19$m=19456,t=2,p=1$k8CqEmfoRpEwkTszAlG5Hw$0r40UshfbvLQaYGu0089358JjzidfPdV/aebyH3MaPA', now()),
    ('00000000-0000-0000-0000-000000000005', 'client@cerca.com', 'Cliente Demo', 'client', '$argon2id$v=19$m=19456,t=2,p=1$k8CqEmfoRpEwkTszAlG5Hw$0r40UshfbvLQaYGu0089358JjzidfPdV/aebyH3MaPA', now())
ON CONFLICT (id) DO NOTHING;

-- Insert technician profiles
INSERT INTO technician_profiles (id, user_id, oficio, rating, reviews, distance, price_label, pin_top, pin_left, coverage_km, available_days, categories, is_verified)
VALUES
    (1, '00000000-0000-0000-0000-000000000001', 'Gasfitero', 4.9, 132, '0.6 km', 'Desde $15.000', 0.30, 0.60, 10, ARRAY['lun','mar','mie','jue','vie'], ARRAY['gasfiteria'], TRUE),
    (2, '00000000-0000-0000-0000-000000000002', 'Electricista', 4.8, 97, '1.1 km', 'Desde $18.000', 0.55, 0.25, 8, ARRAY['lun','mar','mie','jue','vie','sab'], ARRAY['electricidad'], TRUE),
    (3, '00000000-0000-0000-0000-000000000003', 'Carpintero', 4.7, 64, '1.4 km', 'Desde $20.000', 0.20, 0.20, 12, ARRAY['lun','mar','mie','jue','vie'], ARRAY['carpinteria'], TRUE),
    (4, '00000000-0000-0000-0000-000000000004', 'Cerrajera', 4.9, 210, '2.0 km', 'Desde $12.000', 0.65, 0.75, 15, ARRAY['lun','mar','mie','jue','vie','sab','dom'], ARRAY['cerrajeria'], TRUE)
ON CONFLICT (id) DO NOTHING;

-- Insert tech teams
INSERT INTO tech_teams (id, name, mono, oficio, rating, reviews, distance, price_label, pin_top, pin_left, crew, projects, labor_cost, materials_cost, mobility_cost)
VALUES
    (1, 'Equipo AquaBuild', 'AB', 'Piscinas y obras de agua', 4.9, 41, '3.2 km', 'Desde $850.000', 0.35, 0.58, 5, 118, 780000, 420000, 65000),
    (2, 'Equipo Terra Sur', 'TS', 'Pozos y conexiones', 4.8, 29, '5.8 km', 'Desde $420.000', 0.22, 0.28, 4, 76, 340000, 150000, 90000),
    (3, 'Equipo Muro Firme', 'MF', 'Tarrajeo y construcción', 4.7, 53, '4.1 km', 'Desde $310.000', 0.62, 0.70, 6, 94, 260000, 110000, 55000)
ON CONFLICT (id) DO NOTHING;

-- Insert default client profile, addresses, payment methods
INSERT INTO client_profiles (user_id, profile_saved) VALUES ('00000000-0000-0000-0000-000000000005', TRUE) ON CONFLICT (user_id) DO NOTHING;

INSERT INTO client_addresses (id, client_id, label, detail)
VALUES
    ('a0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', 'Casa', 'Av. Providencia 1234, depto 502'),
    ('a0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000005', 'Oficina', 'Av. Apoquindo 4500, piso 8')
ON CONFLICT (id) DO NOTHING;

INSERT INTO client_payment_methods (id, client_id, label, detail)
VALUES
    ('f0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', 'Tarjeta terminada en 4231', 'Visa · vence 08/28'),
    ('f0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000005', 'Efectivo', 'Pago directo al técnico')
ON CONFLICT (id) DO NOTHING;
