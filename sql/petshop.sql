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

INSERT INTO cliente (nome, cpf, data_nascimento, telefone, endereco, bairro, cidade, estado, cep)
SELECT dados.nome, dados.cpf, dados.nascimento, dados.telefone, dados.endereco, dados.bairro, dados.cidade, dados.estado, dados.cep
FROM (
    SELECT 'Carlos Almeida' AS nome, '52998224725' AS cpf, '1985-03-12' AS nascimento, '(12) 99111-2233' AS telefone, 'Rua das Flores, 120' AS endereco, 'Centro' AS bairro, 'São José dos Campos' AS cidade, 'SP' AS estado, '12210-000' AS cep
    UNION ALL SELECT 'Mariana Souza', '11144477735', '1992-11-25', '(12) 99222-3344', 'Av. Cassiano Ricardo, 800', 'Jardim Aquarius', 'São José dos Campos', 'SP', '12246-870'
    UNION ALL SELECT 'Roberto Lima', '12345678909', '1978-03-30', '(12) 99333-4455', 'Rua Sete de Setembro, 45', 'Vila Industrial', 'São José dos Campos', 'SP', '12220-100'
) dados
WHERE NOT EXISTS (SELECT 1 FROM cliente c WHERE c.cpf = dados.cpf);

INSERT INTO raca (nome_raca, tipo_animal)
SELECT dados.nome, dados.tipo FROM (
    SELECT 'Labrador' AS nome, 'Cachorro' AS tipo
    UNION ALL SELECT 'Poodle', 'Cachorro'
    UNION ALL SELECT 'SRD', 'Cachorro'
    UNION ALL SELECT 'Siamês', 'Gato'
    UNION ALL SELECT 'Persa', 'Gato'
    UNION ALL SELECT 'SRD', 'Gato'
) dados
WHERE NOT EXISTS (SELECT 1 FROM raca r WHERE r.nome_raca = dados.nome AND r.tipo_animal = dados.tipo);

INSERT INTO animal (nome, data_nascimento, sexo, cor, observacoes, id_cliente, id_raca)
SELECT dados.nome, dados.nascimento, dados.sexo, dados.cor, dados.observacoes, c.id_cliente, r.id_raca
FROM (
    SELECT 'Thor' AS nome, '2019-03-05' AS nascimento, 'M' AS sexo, 'Caramelo' AS cor, 'Muito brincalhão' AS observacoes, '52998224725' AS cpf, 'Labrador' AS raca, 'Cachorro' AS tipo
    UNION ALL SELECT 'Luna', '2021-11-10', 'F', 'Branca', 'Alérgica a shampoo comum', '11144477735', 'Poodle', 'Cachorro'
    UNION ALL SELECT 'Mia', '2020-03-20', 'F', 'Cinza', NULL, '11144477735', 'Siamês', 'Gato'
    UNION ALL SELECT 'Bob', '2018-07-14', 'M', 'Preto', 'Idoso', '12345678909', 'SRD', 'Cachorro'
    UNION ALL SELECT 'Nina', '2022-11-02', 'F', 'Tigrada', NULL, '52998224725', 'SRD', 'Gato'
) dados
JOIN cliente c ON c.cpf = dados.cpf
JOIN raca r ON r.nome_raca = dados.raca AND r.tipo_animal = dados.tipo
WHERE NOT EXISTS (SELECT 1 FROM animal a WHERE a.id_cliente = c.id_cliente AND a.nome = dados.nome AND a.data_nascimento = dados.nascimento);
