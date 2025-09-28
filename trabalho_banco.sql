CREATE DATABASE IF NOT EXISTS MeuAssistentePetDB;
USE MeuAssistentePetDB;

CREATE TABLE Pessoa (
    id_pessoa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Pessoa_Telefone (
    id_pessoa INT NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_pessoa, telefone),
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Dono (
    id_pessoa INT PRIMARY KEY,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Veterinario (
    id_pessoa INT PRIMARY KEY,
    CRMV VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Treinador (
    id_treinador INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    numero_certificacao_profissional VARCHAR(50) UNIQUE
);

CREATE TABLE Clinica (
    id_clinica INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    rua VARCHAR(100),
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    CEP VARCHAR(10)
);

CREATE TABLE Pet (
    id_pet INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    raca VARCHAR(50),
    data_nasc DATE
);

CREATE TABLE Possui (
    id_dono INT NOT NULL,
    id_pet INT NOT NULL,
    PRIMARY KEY (id_dono, id_pet),
    FOREIGN KEY (id_dono) REFERENCES Dono(id_pessoa),
    FOREIGN KEY (id_pet) REFERENCES Pet(id_pet)
);

CREATE TABLE Animal_de_Servico (
    id_pet INT PRIMARY KEY,
    numero_registro_oficial VARCHAR(50) UNIQUE,
    status ENUM('Ativo', 'Em Treinamento', 'Aposentado') NOT NULL,
    FOREIGN KEY (id_pet) REFERENCES Pet(id_pet)
);

CREATE TABLE Vacina (
    id_vacina INT PRIMARY KEY AUTO_INCREMENT,
    nome_vacina VARCHAR(100) NOT NULL,
    tipo VARCHAR(50)
);

CREATE TABLE CertificadoVacina (
    id_certificado_vac INT PRIMARY KEY AUTO_INCREMENT,
    data_aplicacao DATE NOT NULL,
    lote VARCHAR(50),
    proxima_dose DATE,
    id_pet INT NOT NULL,
    id_vacina INT NOT NULL,
    id_veterinario INT NOT NULL,
    id_clinica INT,
    FOREIGN KEY (id_pet) REFERENCES Pet(id_pet),
    FOREIGN KEY (id_vacina) REFERENCES Vacina(id_vacina),
    FOREIGN KEY (id_veterinario) REFERENCES Veterinario(id_pessoa),
    FOREIGN KEY (id_clinica) REFERENCES Clinica(id_clinica)
);

CREATE TABLE Habilidade (
    id_habilidade INT PRIMARY KEY AUTO_INCREMENT,
    descricao_habilidade VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Credencial_Servico (
    id_credencial INT PRIMARY KEY AUTO_INCREMENT,
    data_emissao DATE NOT NULL,
    data_validade DATE NOT NULL,
    id_animal_servico INT UNIQUE NOT NULL, 
    id_treinador INT NOT NULL,
    FOREIGN KEY (id_animal_servico) REFERENCES Animal_de_Servico(id_pet),
    FOREIGN KEY (id_treinador) REFERENCES Treinador(id_treinador)
);

CREATE TABLE Credencial_Habilidade (
    id_credencial INT NOT NULL,
    id_habilidade INT NOT NULL,
    PRIMARY KEY (id_credencial, id_habilidade),
    FOREIGN KEY (id_credencial) REFERENCES Credencial_Servico(id_credencial),
    FOREIGN KEY (id_habilidade) REFERENCES Habilidade(id_habilidade)
);

INSERT INTO Pessoa (nome, cpf, email) VALUES
('Ana Silva', '111.111.111-11', 'ana.silva@email.com'), 
('Carlos Mendes', '222.222.222-22', 'carlos@email.com'), 
('Dr. João Souza', '333.333.333-33', 'joao.vet@email.com'), 
('Dra. Maria Lima', '444.444.444-44', 'maria.vet@email.com'); 

INSERT INTO Pessoa_Telefone (id_pessoa, telefone) VALUES
(1, '9999-1111'),
(1, '9888-1111'),
(3, '9777-3333');

INSERT INTO Dono (id_pessoa) VALUES (1), (2);

INSERT INTO Veterinario (id_pessoa, CRMV) VALUES
(3, 'CRMV-DF 1234'),
(4, 'CRMV-GO 5678');

INSERT INTO Treinador (nome, cpf, numero_certificacao_profissional) VALUES
('Pedro Rocha', '555.555.555-55', 'TC-BR-9001'); 

INSERT INTO Clinica (nome, email, cidade, CEP) VALUES
('Pet Saude Central', 'contato@petsaude.com', 'Brasilia', '70000-000'); 

INSERT INTO Pet (nome, especie, raca, data_nasc) VALUES
('Max', 'Cachorro', 'Labrador', '2019-05-15'), 
('Fifi', 'Gato', 'Siamês', '2020-01-20'), 
('Buddy', 'Cachorro', 'Golden', '2021-11-10'); 


INSERT INTO Possui (id_dono, id_pet) VALUES
(1, 1), 
(1, 2), 
(2, 3); 

INSERT INTO Animal_de_Servico (id_pet, numero_registro_oficial, status) VALUES
(1, 'AS-BR-001', 'Ativo');

INSERT INTO Vacina (nome_vacina, tipo) VALUES
('V8', 'Viral'), 
('Raiva', 'Inativada'); 

INSERT INTO CertificadoVacina (data_aplicacao, lote, proxima_dose, id_pet, id_vacina, id_veterinario, id_clinica) VALUES
('2024-03-01', 'LTV-001', '2025-03-01', 1, 1, 3, 1), 
('2024-04-10', 'LRA-002', '2025-04-10', 2, 2, 4, NULL); 

INSERT INTO Habilidade (descricao_habilidade) VALUES
('Guiar em via pública'), 
('Alerta de hipoglicemia'), 
('Abrir portas'); 

INSERT INTO Credencial_Servico (data_emissao, data_validade, id_animal_servico, id_treinador) VALUES
('2024-06-01', '2025-06-01', 1, 1); 

INSERT INTO Credencial_Habilidade (id_credencial, id_habilidade) VALUES
(1, 1),
(1, 3);

SELECT
    P.nome AS Dono,
    PT.nome AS Pet_Nome,
    PT.especie,
    PT.raca
FROM Dono D
JOIN Pessoa P ON D.id_pessoa = P.id_pessoa
JOIN Possui PS ON D.id_pessoa = PS.id_dono
JOIN Pet PT ON PS.id_pet = PT.id_pet
WHERE P.nome = 'Ana Silva';

SELECT
    P.nome AS Nome_Animal,
    CS.data_emissao,
    CS.data_validade,
    T.nome AS Nome_Treinador,
    H.descricao_habilidade
FROM Animal_de_Servico ASV
JOIN Pet P ON ASV.id_pet = P.id_pet
JOIN Credencial_Servico CS ON ASV.id_pet = CS.id_animal_servico
JOIN Treinador T ON CS.id_treinador = T.id_treinador
JOIN Credencial_Habilidade CH ON CS.id_credencial = CH.id_credencial
JOIN Habilidade H ON CH.id_habilidade = H.id_habilidade;

SELECT
    P.nome AS Pet_Nome,
    V.nome_vacina,
    CV.data_aplicacao,
    CV.proxima_dose,
    PE.nome AS Veterinario,
    C.nome AS Clinica_Aplicadora
FROM Pet P
JOIN CertificadoVacina CV ON P.id_pet = CV.id_pet
JOIN Vacina V ON CV.id_vacina = V.id_vacina
JOIN Veterinario VET ON CV.id_veterinario = VET.id_pessoa
JOIN Pessoa PE ON VET.id_pessoa = PE.id_pessoa
LEFT JOIN Clinica C ON CV.id_clinica = C.id_clinica
WHERE P.nome = 'Max';

UPDATE Animal_de_Servico
SET status = 'Aposentado'
WHERE id_pet = 1;

UPDATE CertificadoVacina
SET proxima_dose = '2025-05-10'
WHERE id_pet = 2 AND id_vacina = 2; 
SELECT * FROM Animal_de_Servico WHERE id_pet = 1;
SELECT * FROM CertificadoVacina WHERE id_pet = 2 AND id_vacina = 2;