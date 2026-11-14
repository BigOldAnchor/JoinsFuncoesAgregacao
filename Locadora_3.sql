-- Script inicial feito com IA para agilizar (Com exceção das Consultas)
CREATE DATABASE Locadora_3;
GO
USE Locadora_3;
GO
-- =============================================
-- 1. CRIAÇÃO DAS TABELAS (DDL)
-- =============================================

CREATE TABLE Filme (
    ID INT PRIMARY KEY,
    Filme NVARCHAR(80) NOT NULL,
    Ano INT NOT NULL,

    CONSTRAINT CK_Filme_Ano
    CHECK (Ano <= 2021)
);


CREATE TABLE Estrela (
    ID INT PRIMARY KEY,
    Nome NVARCHAR(50) NOT NULL,
    Nome_Real NVARCHAR(50) NULL
);


CREATE TABLE Filme_Estrela (
    FilmeId INT NOT NULL,
    EstrelaId INT NOT NULL,

    CONSTRAINT PK_Filme_Estrela
    PRIMARY KEY (FilmeId, EstrelaId),

    CONSTRAINT FK_FE_Filme
    FOREIGN KEY (FilmeId) REFERENCES Filme(ID),

    CONSTRAINT FK_FE_Estrela
    FOREIGN KEY (EstrelaId) REFERENCES Estrela(ID)
);


CREATE TABLE DVD (
    Num INT PRIMARY KEY,
    Data_Fabricacao DATE NOT NULL,
    FilmeId INT NOT NULL,

    CONSTRAINT CK_DVD_Data
    CHECK (Data_Fabricacao < CONVERT(DATE, GETDATE())),

    CONSTRAINT FK_DVD_Filme
    FOREIGN KEY (FilmeId) REFERENCES Filme(ID)
);


CREATE TABLE Cliente (
    Num_Cadastro INT PRIMARY KEY,
    Nome NVARCHAR(50) NOT NULL,
    Logradouro NVARCHAR(100) NOT NULL,
    Num INT NOT NULL,
    CEP CHAR(8) NULL,

    CONSTRAINT CK_Cliente_Num
    CHECK (Num > 0),

    CONSTRAINT CK_Cliente_CEP
    CHECK (CEP IS NULL OR LEN(CEP) = 8)
);


CREATE TABLE Locacao (
    DVDnum INT NOT NULL,
    ClienteNum_Cadastro INT NOT NULL,
    Data_Locacao DATE NOT NULL
        CONSTRAINT DF_Locacao_Data
        DEFAULT (CONVERT(DATE, GETDATE())),
    Data_Devolucao DATE NOT NULL,
    Valor DECIMAL(6,2) NOT NULL,

    CONSTRAINT PK_Locacao
    PRIMARY KEY (DVDnum, ClienteNum_Cadastro, Data_Locacao),

    CONSTRAINT CK_Locacao_Devolucao
    CHECK (Data_Devolucao > Data_Locacao),

    CONSTRAINT CK_Locacao_Valor
    CHECK (Valor > 0),

    CONSTRAINT FK_Locacao_DVD
    FOREIGN KEY (DVDnum) REFERENCES DVD(Num),

    CONSTRAINT FK_Locacao_Cliente
    FOREIGN KEY (ClienteNum_Cadastro)
    REFERENCES Cliente(Num_Cadastro)
);


-- =============================================
-- 2. INSERÇÃO DOS DADOS (INSERT)
-- =============================================

-- FILME

INSERT INTO Filme (ID, Filme, Ano)
VALUES
(1001, N'Whiplash', 2015),
(1002, N'Birdman', 2015),
(1003, N'Interestelar', 2014),
(1004, N'A Culpa é das estrelas', 2014),
(1005, N'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, N'Sing', 2016);


-- ESTRELA

INSERT INTO Estrela (ID, Nome, Nome_Real)
VALUES
(9901, N'Michael Keaton', N'Michael John Douglas'),
(9902, N'Emma Stone', N'Emily Jean Stone'),
(9903, N'Miles Teller', NULL),
(9904, N'Steve Carell', N'Steven John Carell'),
(9905, N'Jennifer Garner', N'Jennifer Anne Garner');


-- FILME_ESTRELA

INSERT INTO Filme_Estrela (FilmeId, EstrelaId)
VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905);


-- DVD

INSERT INTO DVD (Num, Data_Fabricacao, FilmeId)
VALUES
(10001, '2020-12-02', 1001),
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003);


-- CLIENTE

INSERT INTO Cliente
(Num_Cadastro, Nome, Logradouro, Num, CEP)
VALUES
(5501, N'Matilde Luz', N'Rua Síria', 150, '03086040'),
(5502, N'Carlos Carreiro', N'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, N'Daniel Ramalho', N'Rua Itajutiba', 169, NULL),
(5504, N'Roberta Bento', N'Rua Jayme Von Rosenburg', 36, NULL),
(5505, N'Rosa Cerqueira', N'Rua Arnaldo Simões Pinto', 235, '02917110');


-- LOCACAO

INSERT INTO Locacao
(DVDnum, ClienteNum_Cadastro, Data_Locacao, Data_Devolucao, Valor)
VALUES
(10001, 5502, '2021-02-18', '2021-02-21', 3.50),
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50);


-- =============================================
-- 3. ALTERAÇÃO DOS DADOS (UPDATE)
-- =============================================

-- Atualizar CEP dos clientes 5503 e 5504

UPDATE Cliente
SET CEP = '08411150'
WHERE Num_Cadastro = 5503;

UPDATE Cliente
SET CEP = '02918190'
WHERE Num_Cadastro = 5504;


-- Atualizar o valor das locações do cliente 5502
-- na data 18/02/2021 para 3.25

UPDATE Locacao
SET Valor = 3.25
WHERE ClienteNum_Cadastro = 5502
AND Data_Locacao = '2021-02-18';


-- Atualizar o valor das locações do cliente 5501
-- na data 24/02/2021 para 3.10

UPDATE Locacao
SET Valor = 3.10
WHERE ClienteNum_Cadastro = 5501
AND Data_Locacao = '2021-02-24';


-- Atualizar data de fabricação do DVD 10005

UPDATE DVD
SET Data_Fabricacao = '2019-07-14'
WHERE Num = 10005;


-- Atualizar nome real de Miles Teller

UPDATE Estrela
SET Nome_Real = N'Miles Alexander Teller'
WHERE ID = 9903;


-- =============================================
-- 4. EXCLUSÃO DOS DADOS (DELETE)
-- =============================================

-- Excluir o filme Sing

DELETE FROM Filme
WHERE Filme = N'Sing';


-- =============================================
-- FIM DO SCRIPT IA
-- =============================================

-- =============================================
-- CONSULTAS
-- =============================================

SELECT
    c.Num_Cadastro,
    c.Nome,
    f.Filme,
    d.Data_Fabricacao,
    l.Valor
FROM Cliente c
INNER JOIN Locacao l
    ON c.Num_Cadastro = l.ClienteNum_Cadastro
INNER JOIN DVD d
    ON l.DVDnum = d.Num
INNER JOIN Filme f
    ON d.FilmeId = f.ID
WHERE d.Data_Fabricacao = (SELECT MAX(Data_Fabricacao) FROM DVD);

SELECT 
    c.Num_Cadastro,
    c.Nome, 
    CONVERT(CHAR(10), l.Data_Locacao, 103) as data_locacao,
    COUNT(d.Num) as qtd
FROM Cliente c
INNER JOIN Locacao l
    ON c.Num_Cadastro = l.ClienteNum_Cadastro
INNER JOIN DVD d
    on d.Num = l.DVDnum
GROUP BY c.Num_Cadastro, c.Nome, l.Data_Locacao
ORDER BY l.Data_Locacao;

SELECT 
    c.Num_Cadastro,
    c.Nome, 
    CONVERT(CHAR(10), l.Data_Locacao, 103) as data_locacao,
    SUM(l.Valor) as valor_total
FROM Cliente c
INNER JOIN Locacao l
    ON c.Num_Cadastro = l.ClienteNum_Cadastro
INNER JOIN DVD d
    on d.Num = l.DVDnum
GROUP BY c.Num_Cadastro, c.Nome, l.Data_Locacao
ORDER BY l.Data_Locacao;

SELECT 
    c.Num_Cadastro,
    c.Nome, 
    c.Num + ', ' + c.Logradouro as Endereço,
    CONVERT(CHAR(10), l.Data_Locacao, 103) as data_locacao,
    COUNT(d.Num) as qtd
FROM Cliente c
INNER JOIN Locacao l
    ON c.Num_Cadastro = l.ClienteNum_Cadastro
INNER JOIN DVD d
    on d.Num = l.DVDnum
GROUP BY c.Num_Cadastro, c.nome, c.Num, c.Logradouro, l.Data_Locacao
HAVING COUNT(d.Num) > 2;

