CREATE DATABASE IF NOT EXISTS petshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE petshop;

CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE,
    telefone VARCHAR(20),
    endereco VARCHAR(150),
    bairro VARCHAR(80),
    cidade VARCHAR(80),
    estado VARCHAR(2),
    cep VARCHAR(9),
    status BOOLEAN NOT NULL DEFAULT TRUE,
    data_alteracao TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raca (
    id_raca INT AUTO_INCREMENT PRIMARY KEY,
    nome_raca VARCHAR(80) NOT NULL,
    tipo_animal VARCHAR(10) NOT NULL,
    status BOOLEAN NOT NULL DEFAULT TRUE,
    data_alteracao TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_raca_tipo UNIQUE (nome_raca, tipo_animal),
    CONSTRAINT ck_tipo_animal CHECK (tipo_animal IN ('Cachorro', 'Gato'))
);

CREATE TABLE IF NOT EXISTS animal (
    id_animal INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    sexo CHAR(1),
    cor VARCHAR(50),
    observacoes VARCHAR(255),
    id_cliente INT NOT NULL,
    id_raca INT NOT NULL,
    status BOOLEAN NOT NULL DEFAULT TRUE,
    data_alteracao TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_animal_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
    CONSTRAINT fk_animal_raca FOREIGN KEY (id_raca) REFERENCES raca (id_raca),
    CONSTRAINT ck_sexo CHECK (sexo IN ('M', 'F'))
);

INSERT INTO cliente (nome, cpf, data_nascimento, telefone, endereco, bairro, cidade, estado, cep) VALUES
('Carlos Almeida', '52998224725', '1985-03-12', '(12) 99111-2233', 'Rua das Flores, 120', 'Centro', 'São José dos Campos', 'SP', '12210-000'),
('Mariana Souza', '11144477735', '1992-11-25', '(12) 99222-3344', 'Av. Cassiano Ricardo, 800', 'Jardim Aquarius', 'São José dos Campos', 'SP', '12246-870'),
('Roberto Lima', '12345678909', '1978-03-30', '(12) 99333-4455', 'Rua Sete de Setembro, 45', 'Vila Industrial', 'São José dos Campos', 'SP', '12220-100')
ON DUPLICATE KEY UPDATE cpf = cliente.cpf;

INSERT INTO raca (nome_raca, tipo_animal) VALUES
('Labrador', 'Cachorro'),
('Poodle', 'Cachorro'),
('SRD', 'Cachorro'),
('Siamês', 'Gato'),
('Persa', 'Gato'),
('SRD', 'Gato')
ON DUPLICATE KEY UPDATE nome_raca = raca.nome_raca;

INSERT INTO animal (nome, data_nascimento, sexo, cor, observacoes, id_cliente, id_raca)
SELECT 'Thor', '2019-03-05', 'M', 'Caramelo', 'Muito brincalhão', c.id_cliente, r.id_raca
FROM cliente c, raca r
WHERE c.cpf = '52998224725' AND r.nome_raca = 'Labrador' AND r.tipo_animal = 'Cachorro'
AND NOT EXISTS (
    SELECT 1 FROM animal a
    WHERE a.id_cliente = c.id_cliente AND a.nome = 'Thor' AND a.data_nascimento = '2019-03-05'
);

INSERT INTO animal (nome, data_nascimento, sexo, cor, observacoes, id_cliente, id_raca)
SELECT 'Luna', '2021-11-10', 'F', 'Branca', 'Alérgica a shampoo comum', c.id_cliente, r.id_raca
FROM cliente c, raca r
WHERE c.cpf = '11144477735' AND r.nome_raca = 'Poodle' AND r.tipo_animal = 'Cachorro'
AND NOT EXISTS (
    SELECT 1 FROM animal a
    WHERE a.id_cliente = c.id_cliente AND a.nome = 'Luna' AND a.data_nascimento = '2021-11-10'
);

INSERT INTO animal (nome, data_nascimento, sexo, cor, observacoes, id_cliente, id_raca)
SELECT 'Mia', '2020-03-20', 'F', 'Cinza', NULL, c.id_cliente, r.id_raca
FROM cliente c, raca r
WHERE c.cpf = '11144477735' AND r.nome_raca = 'Siamês' AND r.tipo_animal = 'Gato'
AND NOT EXISTS (
    SELECT 1 FROM animal a
    WHERE a.id_cliente = c.id_cliente AND a.nome = 'Mia' AND a.data_nascimento = '2020-03-20'
);

INSERT INTO animal (nome, data_nascimento, sexo, cor, observacoes, id_cliente, id_raca)
SELECT 'Bob', '2018-07-14', 'M', 'Preto', 'Idoso', c.id_cliente, r.id_raca
FROM cliente c, raca r
WHERE c.cpf = '12345678909' AND r.nome_raca = 'SRD' AND r.tipo_animal = 'Cachorro'
AND NOT EXISTS (
    SELECT 1 FROM animal a
    WHERE a.id_cliente = c.id_cliente AND a.nome = 'Bob' AND a.data_nascimento = '2018-07-14'
);

INSERT INTO animal (nome, data_nascimento, sexo, cor, observacoes, id_cliente, id_raca)
SELECT 'Nina', '2022-11-02', 'F', 'Tigrada', NULL, c.id_cliente, r.id_raca
FROM cliente c, raca r
WHERE c.cpf = '52998224725' AND r.nome_raca = 'SRD' AND r.tipo_animal = 'Gato'
AND NOT EXISTS (
    SELECT 1 FROM animal a
    WHERE a.id_cliente = c.id_cliente AND a.nome = 'Nina' AND a.data_nascimento = '2022-11-02'
);
