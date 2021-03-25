/* modelo_logico_com_tipos: */

CREATE TABLE Produto (
    id INTEGER PRIMARY KEY,
    nome VARCHAR,
    preco DECIMAL,
    desconto SMALLINT,
    data_fim_desconto TIMESTAMP,
    descricao VARCHAR
);

CREATE TABLE App (
    data_lancamento TIMESTAMP,
    fk_Produto_id INTEGER PRIMARY KEY,
    fk_Empresa_id_desenvolvedora INTEGER,
    fk_Empresa_id_distribuidora INTEGER
);

CREATE TABLE Categoria (
    nome VARCHAR UNIQUE,
    id INTEGER PRIMARY KEY
);

CREATE TABLE Categorizacao (
    fk_Categoria_id INTEGER,
    fk_App_fk_Produto_id INTEGER
);

CREATE TABLE Genero (
    id INTEGER PRIMARY KEY,
    nome VARCHAR UNIQUE
);

CREATE TABLE Classificacao (
    fk_Genero_id INTEGER,
    fk_App_fk_Produto_id INTEGER
);

CREATE TABLE Empresa (
    id INTEGER PRIMARY KEY,
    nome VARCHAR
);

CREATE TABLE Tags (
    fk_App_fk_Produto_id INTEGER,
    fk_Usuario_id INTEGER,
    tag VARCHAR PRIMARY KEY
);

CREATE TABLE Avaliacoes (
    fk_App_fk_Produto_id INTEGER,
    fk_Usuario_id INTEGER,
    recomenda BOOLEAN,
    comentario VARCHAR
);

CREATE TABLE Pacote (
    fk_Produto_id INTEGER PRIMARY KEY
);

CREATE TABLE Composicao (
    fk_App_fk_Produto_id INTEGER,
    fk_Pacote_fk_Produto_id INTEGER
);

CREATE TABLE Jogo (
    fk_App_fk_Produto_id INTEGER PRIMARY KEY
);

CREATE TABLE Dlc (
    fk_App_fk_Produto_id INTEGER PRIMARY KEY,
    fk_Jogo_fk_App_fk_Produto_id INTEGER
);

CREATE TABLE Usuario (
    id INTEGER PRIMARY KEY,
    nome VARCHAR,
    email VARCHAR UNIQUE
);

CREATE TABLE Cartao_Credito (
    nro_cartao INTEGER PRIMARY KEY,
    nro_sec_cartao CHAR,
    validade_cartao DATE,
    nome VARCHAR
);

CREATE TABLE Forma_Pagamento (
    fk_Cartao_Credito_nro_cartao INTEGER,
    fk_Usuario_id INTEGER
);

CREATE TABLE Carrinho (
    fk_Produto_id INTEGER,
    fk_Usuario_id INTEGER
);

CREATE TABLE Compra (
    id INTEGER PRIMARY KEY,
    data TIMESTAMP,
    total DECIMAL,
    fk_Usuario_id INTEGER,
    fk_Cartao_Credito_nro_cartao INTEGER,
    Aprovado BOOLEAN
);

CREATE TABLE Item_comprado (
    fk_Produto_id INTEGER,
    fk_Compra_id INTEGER,
    desconto SMALLINT,
    valor_original DECIMAL
);
 
ALTER TABLE App ADD CONSTRAINT FK_App_2
    FOREIGN KEY (fk_Produto_id)
    REFERENCES Produto (id)
    ON DELETE CASCADE;
 
ALTER TABLE App ADD CONSTRAINT FK_App_3
    FOREIGN KEY (fk_Empresa_id_desenvolvedora, fk_Empresa_id_distribuidora)
    REFERENCES Empresa (id, id)
    ON DELETE CASCADE;
 
ALTER TABLE Jogo ADD CONSTRAINT FK_Jogo_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE CASCADE;
 
ALTER TABLE Pacote ADD CONSTRAINT FK_Pacote_2
    FOREIGN KEY (fk_Produto_id)
    REFERENCES Produto (id)
    ON DELETE CASCADE;
 
ALTER TABLE Dlc ADD CONSTRAINT FK_Dlc_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE CASCADE;
 
ALTER TABLE Dlc ADD CONSTRAINT FK_Dlc_3
    FOREIGN KEY (fk_Jogo_fk_App_fk_Produto_id)
    REFERENCES Jogo (fk_App_fk_Produto_id)
    ON DELETE CASCADE;
 
ALTER TABLE Compra ADD CONSTRAINT FK_Compra_2
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE CASCADE;
 
ALTER TABLE Compra ADD CONSTRAINT FK_Compra_3
    FOREIGN KEY (fk_Cartao_Credito_nro_cartao)
    REFERENCES Cartao_Credito (nro_cartao)
    ON DELETE CASCADE;
 
ALTER TABLE Composicao ADD CONSTRAINT FK_Composicao_1
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE RESTRICT;
 
ALTER TABLE Composicao ADD CONSTRAINT FK_Composicao_2
    FOREIGN KEY (fk_Pacote_fk_Produto_id)
    REFERENCES Pacote (fk_Produto_id)
    ON DELETE SET NULL;
 
ALTER TABLE Avaliacoes ADD CONSTRAINT FK_Avaliacoes_1
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE SET NULL;
 
ALTER TABLE Avaliacoes ADD CONSTRAINT FK_Avaliacoes_2
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE SET NULL;
 
ALTER TABLE Carrinho ADD CONSTRAINT FK_Carrinho_1
    FOREIGN KEY (fk_Produto_id)
    REFERENCES Produto (id)
    ON DELETE SET NULL;
 
ALTER TABLE Carrinho ADD CONSTRAINT FK_Carrinho_2
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE SET NULL;
 
ALTER TABLE Tags ADD CONSTRAINT FK_Tags_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE SET NULL;
 
ALTER TABLE Tags ADD CONSTRAINT FK_Tags_3
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE SET NULL;
 
ALTER TABLE Classificacao ADD CONSTRAINT FK_Classificacao_1
    FOREIGN KEY (fk_Genero_id)
    REFERENCES Genero (id)
    ON DELETE RESTRICT;
 
ALTER TABLE Classificacao ADD CONSTRAINT FK_Classificacao_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE SET NULL;
 
ALTER TABLE Categorizacao ADD CONSTRAINT FK_Categorizacao_1
    FOREIGN KEY (fk_Categoria_id)
    REFERENCES Categoria (id)
    ON DELETE RESTRICT;
 
ALTER TABLE Categorizacao ADD CONSTRAINT FK_Categorizacao_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE SET NULL;
 
ALTER TABLE Item_comprado ADD CONSTRAINT FK_Item_comprado_1
    FOREIGN KEY (fk_Produto_id)
    REFERENCES Produto (id)
    ON DELETE RESTRICT;
 
ALTER TABLE Item_comprado ADD CONSTRAINT FK_Item_comprado_2
    FOREIGN KEY (fk_Compra_id)
    REFERENCES Compra (id)
    ON DELETE SET NULL;
 
ALTER TABLE Forma_Pagamento ADD CONSTRAINT FK_Forma_Pagamento_1
    FOREIGN KEY (fk_Cartao_Credito_nro_cartao)
    REFERENCES Cartao_Credito (nro_cartao)
    ON DELETE SET NULL;
 
ALTER TABLE Forma_Pagamento ADD CONSTRAINT FK_Forma_Pagamento_2
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE SET NULL;