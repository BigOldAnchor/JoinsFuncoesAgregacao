CREATE DATABASE users_projects_2;
GO
USE users_projects_2;
GO 
CREATE TABLE users (
	id INT NOT NULL IDENTITY(1,1),
	nome VARCHAR(45),
	username VARCHAR(45) UNIQUE,
	senha VARCHAR(45) DEFAULT('123mudar'),
	email VARCHAR(45)
	PRIMARY KEY (id),
);
GO 
CREATE TABLE projects (
	id INT IDENTITY(10001, 1),
	nome VARCHAR(45),
	descricao VARCHAR(45),
	dataCriacao DATE CHECK(dataCriacao > '2014-09-01')
	PRIMARY KEY (id)
);
GO
CREATE TABLE users_has_projects (
	users_id INT,
	projects_id INT 
	PRIMARY KEY (users_id, projects_id),
	FOREIGN KEY (users_id) REFERENCES users(id),
	FOREIGN KEY (projects_id) REFERENCES projects(id)
);

-- Modificação de database
ALTER TABLE users
ALTER COLUMN username VARCHAR(10);

ALTER TABLE users
ALTER COLUMN senha VARCHAR(8);

--Inserção de dados
INSERT INTO Users (nome, username, senha, email)
VALUES
	('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
	('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
	('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
	('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
	('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com');

INSERT INTO Projects (nome, descricao, dataCriacao)
VALUES
	('Re-folha', 'Refatoração das Folhas', '2014-09-05'),
	('Manutenção PC’s', 'Manutenção PC’s', '2014-09-06'),
	('Auditoria', NULL, '2014-09-07');

INSERT INTO users_has_projects (users_id, projects_id)
VALUES
	(1, 10001),
	(5, 10001),
	(3, 10003),
	(4, 10002),
	(2, 10002);

UPDATE projects 
SET dataCriacao = '2014-09-06' WHERE nome = '%Manutenção%';

UPDATE users
SET username = 'Rh_cido'
WHERE nome = 'Aparecido';

UPDATE users
SET senha = '888@*'
WHERE userName = 'Rh_maria' AND senha = '123mudar';

INSERT INTO Users (nome, username, senha, email)
VALUES
	('João', 'Ti_joao', '123mudar', 'joao@empresa.com');

INSERT INTO projects(nome, descricao, dataCriacao)
VALUES
	('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '2014-09-12');

-- Consultas
SELECT users.id, users.nome, users.email, pj.id AS ID_Projeto, pj.nome AS nome_projeto,
		pj.descricao AS Descrição_Projeto,pj.dataCriacao
FROM users, projects pj, users_has_projects
WHERE pj.nome LIKE '%Re-folha%';

SELECT p.nome AS nome_projeto
FROM projects p
LEFT OUTER JOIN users_has_projects up ON p.id = up.projects_id
WHERE up.users_id IS NULL;

SELECT u.nome as nome_usuario
FROM users u
LEFT OUTER JOIN users_has_projects up 
ON u.id = up.users_id
WHERE up.projects_id IS NULL;