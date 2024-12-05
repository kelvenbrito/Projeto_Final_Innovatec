INSERT INTO machine (id, description, name)
VALUES
    (1, 'Máquina de Corte Industrial', 'Cortadora X1000'),
    (2, 'Máquina de Solda Automática', 'Soldadora Z2000'),
    (3, 'Máquina de Embalagem Rápida', 'Embaladora Q3000');

INSERT INTO spare_part (id, code, description, quantity_available, machine_id)
VALUES
    -- Peças para a Máquina 1
    (1, 'X1P001', 'Lâmina de Corte', 50, 1),
    (2, 'X1P002', 'Motor de Reserva', 20, 1),
    (3, 'X1P003', 'Sensor de Proximidade', 30, 1),
    (4, 'X1P004', 'Correia de Transmissão', 15, 1),

    -- Peças para a Máquina 2
    (5, 'Z2P001', 'Eletrodo de Solda', 40, 2),
    (6, 'Z2P002', 'Cabos de Alta Tensão', 25, 2),
    (7, 'Z2P003', 'Controlador de Temperatura', 10, 2),
    (8, 'Z2P004', 'Ventoinha de Refrigeração', 12, 2),

    -- Peças para a Máquina 3
    (9, 'Q3P001', 'Bandeja de Suporte', 60, 3),
    (10, 'Q3P002', 'Cilindro Pneumático', 18, 3),
    (11, 'Q3P003', 'Sensor de Peso', 8, 3),
    (12, 'Q3P004', 'Painel de Controle', 5, 3);
