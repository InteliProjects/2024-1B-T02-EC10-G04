CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Functions
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar tipos ENUM
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'role_type') THEN
        CREATE TYPE role_type AS ENUM ('admin', 'user', 'collector', 'manager');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'stripe_type') THEN
        CREATE TYPE stripe_type AS ENUM ('red', 'yellow', 'black');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'priority_type') THEN
        CREATE TYPE priority_type AS ENUM ('green', 'yellow', 'red', 'white');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'status_type') THEN
        CREATE TYPE status_type AS ENUM ('pending', 'ongoing', 'completed', 'refused');
    END IF;
END
$$;

-- Tabela de Usuários
CREATE TABLE IF NOT EXISTS Users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password TEXT NOT NULL,
    role role_type NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    on_duty BOOLEAN DEFAULT true,
    profession VARCHAR(255) NOT NULL
);

-- Pyxis Table
CREATE TABLE IF NOT EXISTS Pyxis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    label VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de usuários bloqueados
CREATE TABLE IF NOT EXISTS Blocked_users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    blocked_by UUID NOT NULL,
    reason TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (blocked_by) REFERENCES Users(id)
);

-- Tabela de Medicamentos
CREATE TABLE IF NOT EXISTS Medicines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    stripe stripe_type NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Pedidos
CREATE TABLE IF NOT EXISTS Orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    priority priority_type NOT NULL,
    user_id UUID NOT NULL,
    observation TEXT,
    status status_type NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    medicine_id UUID NOT NULL,
    responsible_id UUID,
    order_group_id UUID NOT NULL,
    pyxis_id UUID NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(id),
    FOREIGN KEY (responsible_id) REFERENCES Users(id),
    FOREIGN KEY (pyxis_id) REFERENCES Pyxis(id)
);

-- Tabela de Responsabilidade de Pedidos de Usuário
CREATE TABLE IF NOT EXISTS User_Order_responsibility (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    order_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (order_id) REFERENCES Orders(id)
);

CREATE TABLE Medicine_Pyxis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pyxis_id UUID NOT NULL,
    medicine_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pyxis_id) REFERENCES Pyxis(id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(id)
);

-- Função para criar triggers se não existirem
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_before_update_medices'
    ) THEN
        CREATE TRIGGER set_updated_at_before_update_medices
        BEFORE UPDATE ON Medicines
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_before_update_orders'
    ) THEN
        CREATE TRIGGER set_updated_at_before_update_orders
        BEFORE UPDATE ON Orders 
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_before_update_blocked_users'
    ) THEN
        CREATE TRIGGER set_updated_at_before_update_blocked_users
        BEFORE UPDATE ON Blocked_users 
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_before_update_pyxis'
    ) THEN
        CREATE TRIGGER set_updated_at_before_update_pyxis
        BEFORE UPDATE ON Pyxis 
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'set_updated_at_before_update_users'
    ) THEN
        CREATE TRIGGER set_updated_at_before_update_users
        BEFORE UPDATE ON Users 
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;
END
$$;
