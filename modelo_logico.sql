/* SQL */

CREATE TABLE Produto (
    id SERIAL NOT NULL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    preco DECIMAL(6,2) NOT NULL,
    desconto SMALLINT NOT NULL CHECK(desconto BETWEEN 0 AND 100),
    data_fim_desconto TIMESTAMP,
    descricao VARCHAR(1000) NOT NULL
);

CREATE TABLE Usuario (
    id SERIAL NOT NULL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Cartao_Credito (
    id SERIAL NOT NULL PRIMARY KEY,
    nro_cartao CHAR(19) NOT NULL UNIQUE,
    nro_sec_cartao CHAR(3) NOT NULL,
    validade_cartao DATE NOT NULL,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE Categoria (
    nome VARCHAR(50) NOT NULL UNIQUE,
    id SERIAL NOT NULL PRIMARY KEY
);

CREATE TABLE Genero (
    id SERIAL NOT NULL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Empresa (
    id SERIAL NOT NULL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);


CREATE TABLE App (
    id INTEGER PRIMARY KEY NOT NULL,
    data_lancamento TIMESTAMP NOT NULL,
    fk_Empresa_id_desenvolvedora INTEGER NOT NULL,
    fk_Empresa_id_distribuidora INTEGER NOT NULL,
    FOREIGN KEY (id) REFERENCES Produto(id) ON DELETE CASCADE,
    FOREIGN KEY (fk_Empresa_id_desenvolvedora) REFERENCES Empresa(id) ON DELETE RESTRICT,
    FOREIGN KEY (fk_Empresa_id_distribuidora) REFERENCES Empresa(id) ON DELETE RESTRICT
);

CREATE TABLE Categorizacao (
    fk_Categoria_id INTEGER NOT NULL,
    fk_App_id INTEGER NOT NULL,
    PRIMARY KEY(fk_Categoria_id, fk_App_id),
    FOREIGN KEY (fk_Categoria_id) REFERENCES Categoria (id) ON DELETE RESTRICT,
    FOREIGN KEY (fk_App_id) REFERENCES App (id) ON DELETE CASCADE
);


CREATE TABLE Classificacao (
    fk_Genero_id INTEGER NOT NULL,
    fk_App_id INTEGER NOT NULL,
    PRIMARY KEY (fk_Genero_id, fk_App_id),
    FOREIGN KEY (fk_Genero_id) REFERENCES Genero (id) ON DELETE RESTRICT,
    FOREIGN KEY (fk_App_id) REFERENCES App (id) ON DELETE CASCADE
);

CREATE TABLE Tags (
    fk_App_id INTEGER NOT NULL,
    fk_Usuario_id INTEGER NOT NULL,
    tag VARCHAR(50) NOT NULL,
    PRIMARY KEY (fk_App_id, fk_Usuario_id, tag),
    FOREIGN KEY (fk_App_id) REFERENCES App (id) ON DELETE CASCADE,
    FOREIGN KEY (fk_Usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE
);

CREATE TABLE Avaliacoes (
    fk_App_id INTEGER NOT NULL,
    fk_Usuario_id INTEGER NOT NULL,
    recomenda BOOLEAN NOT NULL,
    comentario VARCHAR(1000),
    PRIMARY KEY(fk_App_id, fk_Usuario_id),
    FOREIGN KEY (fk_App_id) REFERENCES App (id) ON DELETE CASCADE,
    FOREIGN KEY (fk_Usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE

);

CREATE TABLE Pacote (
    id INTEGER PRIMARY KEY NOT NULL,
    FOREIGN KEY (id) REFERENCES Produto(id) ON DELETE CASCADE
);

CREATE TABLE Composicao (
    fk_App_id INTEGER NOT NULL,
    fk_Pacote_id INTEGER NOT NULL,
    PRIMARY KEY (fk_App_id, fk_Pacote_id),
    FOREIGN KEY (fk_App_id) REFERENCES App (id) ON DELETE CASCADE,
    FOREIGN KEY (fk_Pacote_id) REFERENCES Pacote (id) ON DELETE CASCADE
);

CREATE TABLE Jogo (
    id INTEGER PRIMARY KEY NOT NULL,
    FOREIGN KEY (id) REFERENCES App(id) ON DELETE CASCADE
);

CREATE TABLE Dlc (
    id INTEGER NOT NULL PRIMARY KEY,
    fk_Jogo_id INTEGER NOT NULL,
    FOREIGN KEY (id) REFERENCES App(id) ON DELETE CASCADE,
    FOREIGN KEY (fk_Jogo_id) REFERENCES Jogo(id) ON DELETE CASCADE
);

CREATE TABLE Forma_Pagamento (
    fk_Cartao_Credito_id INTEGER NOT NULL,
    fk_Usuario_id INTEGER NOT NULL,
    PRIMARY KEY(fk_Cartao_Credito_id, fk_Usuario_id),
    FOREIGN KEY (fk_Cartao_Credito_id) REFERENCES Cartao_Credito (id) ON DELETE CASCADE,
    FOREIGN KEY (fk_Usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE
);

CREATE TABLE Carrinho (
    fk_Produto_id INTEGER NOT NULL,
    fk_Usuario_id INTEGER NOT NULL,
    PRIMARY KEY(fk_Produto_id, fk_Usuario_id),
    FOREIGN KEY (fk_Produto_id) REFERENCES Produto (id) ON DELETE CASCADE,
    FOREIGN KEY (fk_Usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE
);

CREATE TABLE Compra (
    id SERIAL PRIMARY KEY NOT NULL,
    data TIMESTAMP NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    fk_Usuario_id INTEGER NOT NULL,
    fk_Cartao_Credito_id INTEGER NOT NULL,
    Aprovado BOOLEAN NOT NULL,
    FOREIGN KEY (fk_Usuario_id) REFERENCES Usuario (id) ON DELETE CASCADE,
    FOREIGN KEY (fk_Cartao_Credito_id) REFERENCES Cartao_Credito (id) ON DELETE RESTRICT
);

CREATE TABLE Item_comprado (
    fk_Produto_id INTEGER NOT NULL,
    fk_Compra_id INTEGER NOT NULL,
    desconto SMALLINT NOT NULL CHECK(desconto BETWEEN 0 AND 100),
    valor_original DECIMAL(6,2) NOT NULL,
    PRIMARY KEY(fk_Produto_id, fk_Compra_id),
    FOREIGN KEY (fk_Produto_id) REFERENCES Produto (id) ON DELETE RESTRICT,
    FOREIGN KEY (fk_Compra_id) REFERENCES Compra (id) ON DELETE RESTRICT
);
 