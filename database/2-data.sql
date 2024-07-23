
-- Populando a tabela Users
INSERT INTO Users (name, email, password, role, profession)
VALUES 
    ('Alice Silva', 'alice@example.com', crypt('password123', gen_salt('bf')), 'admin', 'Diretor'),
    ('Bob Santos', 'bob@example.com', crypt('password456', gen_salt('bf')), 'user', 'Enfermeiro'),
    ('Carlos Pereira', 'carlos@example.com', crypt('password789', gen_salt('bf')), 'collector', 'Farmacêutico'),
    ('Daniela Lima', 'daniela@example.com', crypt('password321', gen_salt('bf')), 'manager', 'Gerente');

-- Populando a tabela Pyxis
INSERT INTO Pyxis (label)
VALUES 
    ('Pyxis A'),
    ('Pyxis B'),
    ('Pyxis C');

-- Populando a tabela Blocked_users
-- Primeiro, precisamos de IDs válidos de usuários existentes
DO $$
DECLARE
    alice_id UUID;
    bob_id UUID;
BEGIN
    SELECT id INTO alice_id FROM Users WHERE email = 'alice@example.com';
    SELECT id INTO bob_id FROM Users WHERE email = 'bob@example.com';
    
    INSERT INTO Blocked_users (user_id, blocked_by, reason)
    VALUES 
        (bob_id, alice_id, 'Inappropriate behavior');
END
$$;

-- Populando a tabela Medicines
INSERT INTO Medicines (batch, name, stripe)
VALUES 
    ('BATCH001', 'Paracetamol', 'red'),
    ('BATCH002', 'Ibuprofen', 'yellow'),
    ('BATCH003', 'Aspirin', 'black');

-- Populando a tabela Orders
-- Primeiro, precisamos de IDs válidos de usuários, medicamentos e Pyxis existentes
DO $$
DECLARE
    alice_id UUID;
    carlos_id UUID;
    paracetamol_id UUID;
    ibuprofen_id UUID;
    pyxis_id UUID;
BEGIN
    SELECT id INTO pyxis_id FROM Pyxis WHERE label = 'Pyxis A';
    SELECT id INTO alice_id FROM Users WHERE email = 'alice@example.com';
    SELECT id INTO carlos_id FROM Users WHERE email = 'carlos@example.com';
    SELECT id INTO paracetamol_id FROM Medicines WHERE name = 'Paracetamol';
    SELECT id INTO ibuprofen_id FROM Medicines WHERE name = 'Ibuprofen';
    
    INSERT INTO Orders (priority, user_id, observation, status, medicine_id, order_group_id, pyxis_id)
    VALUES 
        ('red', alice_id, 'Urgent request', 'pending', paracetamol_id, '64773e82-385e-4cb3-aba9-73cbbce2c901', pyxis_id),
        ('yellow', carlos_id, 'Routine request', 'ongoing', ibuprofen_id, '64773e82-385e-4cb3-aba9-73cbbce2c901', pyxis_id);
END
$$;

-- Populando a tabela User_Order_responsibility
-- Primeiro, precisamos de IDs válidos de usuários e pedidos existentes
DO $$
DECLARE
    alice_id UUID;
    bob_id UUID;
    order_id UUID;
BEGIN
    SELECT id INTO alice_id FROM Users WHERE email = 'alice@example.com';
    SELECT id INTO bob_id FROM Users WHERE email = 'bob@example.com';
    SELECT id INTO order_id FROM Orders LIMIT 1;  -- Pega um ID de pedido válido
    
    INSERT INTO User_Order_responsibility (user_id, order_id)
    VALUES 
        (alice_id, order_id),
        (bob_id, order_id);
END
$$;

