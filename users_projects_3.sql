CREATE DATABASE users_projects_3;
GO
USE users_projects_3; 
GO
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(45),
    username VARCHAR(45) UNIQUE,
    senha VARCHAR(45) DEFAULT '123mudar',
    email VARCHAR(45)
);
GO

CREATE TABLE projects (
    id INT IDENTITY(10001,1) PRIMARY KEY,
    nome VARCHAR(45),
    descricao VARCHAR(45),
    data_criacao DATE CHECK (data_criacao > '20140901')
);
GO

CREATE TABLE users_has_projects (
    users_id INT,
    projects_id INT,

    PRIMARY KEY (users_id, projects_id),

    CONSTRAINT FK_users_has_projects_users
    FOREIGN KEY (users_id) REFERENCES users(id),

    CONSTRAINT FK_users_has_projects_projects
    FOREIGN KEY (projects_id) REFERENCES projects(id)
);
GO


-- ============================================
-- 2. ALTERAR AS COLUNAS (DDL)
-- ============================================

ALTER TABLE users
ALTER COLUMN username VARCHAR(10);
GO

ALTER TABLE users
ALTER COLUMN senha VARCHAR(8);
GO

--INSERÇÃO de dados

INSERT INTO users (nome, username, senha, email)
VALUES
('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com');

SET IDENTITY_INSERT users OFF;
GO

INSERT INTO projects (nome, descricao, data_criacao)
VALUES
('Re-folha', 'Refatoração das Folhas', '20140905'),
('Manutenção PCs', 'Manutenção PCs', '20140906'),
('Auditoria', NULL, '20140907');
GO

INSERT INTO users_has_projects (users_id, projects_id)
VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002);
GO

UPDATE projects
SET data_criacao = '20140912'
WHERE nome = 'Manutenção PCs';
GO


-- Alterar o username de Aparecido

UPDATE users
SET username = 'Rh_cido'
WHERE nome = 'Aparecido';
GO


-- Alterar a senha de Maria somente se
-- a senha atual ainda for 123mudar

UPDATE users
SET senha = '888@*'
WHERE username = 'Rh_maria'
AND senha = '123mudar';
GO

DELETE FROM users_has_projects
WHERE users_id = 2
AND projects_id = 10002;
GO

INSERT INTO users (nome, username, senha, email)
VALUES
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com');
GO

INSERT INTO projects (nome, descricao, data_criacao)
VALUES
('Atualização de Sistemas',
 'Modificação de Sistemas Operacionais nos PC''s',
 '20140912');
GO

SELECT * FROM users_has_projects;
SELECT * FROM projects;

-- Consultas
SELECT
    COUNT(pj.id) AS qty_projects_no_users
FROM projects pj
LEFT OUTER JOIN users_has_projects up
    on pj.id = up.projects_id
WHERE up.projects_id IS NULL;

-- Consultas
SELECT
    pj.id as ID_PROJETO,
    pj.nome,
    COUNT(up.users_id) as qty_users_project
FROM projects pj
INNER JOIN users_has_projects up
    on pj.id = up.projects_id
GROUP BY pj.id, pj.nome
ORDER BY pj.nome ASC;