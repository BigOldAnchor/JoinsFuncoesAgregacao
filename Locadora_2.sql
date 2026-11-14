CREATE DATABASE Locadora_2;
GO
USE Locadora_2;
GO
CREATE TABLE Filme (
    id INT NOT NULL,
    titulo VARCHAR(40) NOT NULL,
    ano INT NULL CHECK(ano <= 2021),

    CONSTRAINT PK_Filme PRIMARY KEY (id)
);
CREATE TABLE Estrela (
    id INT NOT NULL,
    nome VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Estrela PRIMARY KEY (id)
);
CREATE TABLE Cliente (
    num_cadastro INT NOT NULL,
    nome VARCHAR(70) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    num INT NOT NULL CHECK(num > 0),
    cep CHAR(8) NULL,

    CONSTRAINT PK_Cliente PRIMARY KEY (num_cadastro)
);
CREATE TABLE Filme_Estrela (
    Filmeid INT NOT NULL,
    Estrelaid INT NOT NULL,

    CONSTRAINT PK_Filme_Estrela
        PRIMARY KEY (Filmeid, Estrelaid),

    CONSTRAINT FK_Filme_Estrela_Filme
        FOREIGN KEY (Filmeid) REFERENCES Filme(id),

    CONSTRAINT FK_Filme_Estrela_Estrela
        FOREIGN KEY (Estrelaid) REFERENCES Estrela(id)
);
CREATE TABLE DVD (
    num INT NOT NULL,
    data_fabricacao DATE NOT NULL CHECK(data_fabricacao < GETDATE()),
    Filmeid INT NOT NULL,

    CONSTRAINT PK_DVD PRIMARY KEY (num),

    CONSTRAINT FK_DVD_Filme
        FOREIGN KEY (Filmeid) REFERENCES Filme(id)
);
CREATE TABLE Locacao (
    DVDnum INT NOT NULL,
    Clientenum_cadastro INT NOT NULL,
    data_locacao DATE NOT NULL DEFAULT(GETDATE()),
    data_devolucao DATE NOT NULL,
    valor DECIMAL(7,2) NOT NULL CHECK(valor > 0),

    CONSTRAINT PK_Locacao
        PRIMARY KEY (DVDnum, Clientenum_cadastro, data_locacao),

    CONSTRAINT FK_Locacao_DVD
        FOREIGN KEY (DVDnum) REFERENCES DVD(num),

    CONSTRAINT FK_Locacao_Cliente
        FOREIGN KEY (Clientenum_cadastro)
        REFERENCES Cliente(num_cadastro),

    CONSTRAINT chk_data 
        CHECK(data_devolucao > data_locacao)
);

-- Esquema
ALTER TABLE Filme
ALTER COLUMN titulo VARCHAR(80);

ALTER TABLE Estrela
ADD nome_real VARCHAR(100) NULL;

-- Inserção de dados

INSERT INTO Filme (id, titulo, ano)
VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das Estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, 'Sing', 2016);

INSERT INTO Estrela (id, nome, nome_real)
VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', NULL),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner');


INSERT INTO Filme_Estrela (Filmeid, Estrelaid)
VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905);


INSERT INTO DVD (num, data_fabricacao, Filmeid)
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


INSERT INTO Cliente
(num_cadastro, nome, logradouro, num, cep)
VALUES
(5501, 'Matilde Luz', 'Rua Siria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simoes Pinto', 235, '02917110');


INSERT INTO Locacao
(DVDnum, Clientenum_cadastro, data_locacao, data_devolucao, valor)
VALUES
(10001, 5502, '2021-02-18', '2021-02-21', 3.50),
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50);

-- Operações
UPDATE Cliente
SET CEP = '08411150'
WHERE num_cadastro = 5503;

UPDATE Cliente
SET CEP = '02918190'
WHERE num_cadastro = 5504;

UPDATE Locacao
SET valor = 3.25 
WHERE data_locacao = '2021-02-18';

UPDATE Locacao
SET valor = 3.10 
WHERE data_locacao = '2021-02-24';

UPDATE DVD
SET data_fabricacao = '2019-07-14'
WHERE num = 10005;

UPDATE Estrela
SET nome_real = 'Miles Alexander Teller'
WHERE nome LIKE '%Miles Teller%';

DELETE FROM Filme WHERE titulo = 'Sing';

-- Consultas
SELECT
    c.num_cadastro,
    c.nome,
    CONVERT(char(10), l.data_locacao, 103) AS data_locacao,
    DATEDIFF(DAY, l.data_locacao, l.data_devolucao) AS Qtd_dias_alugado,
    f.titulo,
    f.ano
FROM Cliente AS c
INNER JOIN Locacao AS l
    ON l.Clientenum_cadastro = c.num_cadastro
INNER JOIN DVD AS d
    ON d.num = l.DVDnum
INNER JOIN Filme AS f
    ON f.id = d.Filmeid
WHERE c.nome LIKE 'Matilde%';

SELECT 
    e.nome,
    e.nome_real,
    f.titulo,
    f.ano
FROM Estrela AS e
INNER JOIN Filme_Estrela AS fe
    on fe.Estrelaid = e.id
INNER JOIN Filme as f
    on fe.Filmeid = f.id
WHERE f.ano = 2015;

SELECT
    f.titulo,
    CONVERT(char(10), d.data_fabricacao, 103) AS data_fabricacao,
    CASE
        WHEN DATEDIFF(
                 YEAR,
                 DATEFROMPARTS(f.ano, 1, 1),
                 GETDATE()
             ) > 6
        THEN CONCAT(
                 DATEDIFF(
                     YEAR,
                     DATEFROMPARTS(f.ano, 1, 1),
                     GETDATE()
                 ),
                 ' anos'
             )
        ELSE CONVERT(
                 varchar(10),
                 DATEDIFF(
                     YEAR,
                     DATEFROMPARTS(f.ano, 1, 1),
                     GETDATE()
                 )
             )
    END AS idade_filme
FROM Filme AS f
INNER JOIN DVD AS d
    ON d.Filmeid = f.id;

