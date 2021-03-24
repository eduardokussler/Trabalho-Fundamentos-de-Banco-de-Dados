/* modelo_logico: */

CREATE TABLE Produto (
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(50) NOT NULL,
    preco DECIMAL(6,2) NOT NULL,
    desconto SMALLINT NOT NULL,
    data_fim_desconto TIMESTAMP,
    descricao VARCHAR(1000) NOT NULL
);

CREATE TABLE App (
    data_lancamento TIMESTAMP NOT NULL,
    fk_analises_especialistas_analises_especialistas_PK INT NOT NULL,
    fk_links_links_PK INT NOT NULL,
    fk_Produto_id SERIAL PRIMARY KEY NOT NULL,
    fk_Serie_id SERIAL NOT NULL
);

CREATE TABLE Jogo (
    fk_App_fk_Produto_id SERIAL PRIMARY KEY NOT NULL
);

CREATE TABLE Conjunto (
    fk_Produto_id SERIAL PRIMARY KEY NOT NULL,
    Conjunto_TIPO INT NOT NULL
);

CREATE TABLE Dlc (
    fk_App_fk_Produto_id SERIAL PRIMARY KEY NOT NULL,
    fk_Jogo_fk_App_fk_Produto_id SERIAL NOT NULL
);

CREATE TABLE Jogo_acesso_antecipado (
    porque VARCHAR(500) NOT NULL,
    tempo VARCHAR(500) NOT NULL,
    diferenca_completa VARCHAR(500) NOT NULL,
    estado_atual VARCHAR(500) NOT NULL,
    alteracao_preco VARCHAR(500) NOT NULL,
    comunidade VARCHAR(500) NOT NULL,
    fk_Jogo_fk_App_fk_Produto_id SERIAL PRIMARY KEY NOT NULL
);

CREATE TABLE Usuario (
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Empresa (
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE Genero (
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Categoria (
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Idioma (
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Plataforma (
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Compras (
    id SERIAL PRIMARY KEY NOT NULL,
    data TIMESTAMP NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    fk_Usuario_id SERIAL NOT NULL,
    fk_Cartao_Credito_nro_cartao CHAR(19) NOT NULL,
    Aprovado BOOLEAN NOT NULL
);

CREATE TABLE Serie (
    nome VARCHAR(50) NOT NULL,
    id SERIAL PRIMARY KEY NOT NULL
);

CREATE TABLE Cartao_Credito (
    nro_cartao CHAR(19) PRIMARY KEY NOT NULL,
    nro_sec_cartao CHAR(3) NOT NULL,
    validade_cartao DATE NOT NULL,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE analises_especialistas (
    analises_especialistas_PK INT NOT NULL PRIMARY KEY NOT NULL,
    quem VARCHAR(50) NOT NULL,
    nota DECIMAL(4,2) NOT NULL,
    resumo VARCHAR(100) NOT NULL
);

CREATE TABLE links (
    links_PK INT NOT NULL PRIMARY KEY NOT NULL,
    links VARCHAR(200) NOT NULL
);

CREATE TABLE Composicao (
    fk_App_fk_Produto_id SERIAL NOT NULL,
    fk_Conjunto_fk_Produto_id SERIAL NOT NULL
);

CREATE TABLE Avaliacoes (
    fk_App_fk_Produto_id SERIAL NOT NULL,
    fk_Usuario_id SERIAL NOT NULL,
    recomenda BOOLEAN NOT NULL,
    comentario VARCHAR(1000)
);

CREATE TABLE Carrinho (
    fk_Produto_id SERIAL NOT NULL,
    fk_Usuario_id SERIAL NOT NULL
);

CREATE TABLE Tags (
    fk_App_fk_Produto_id SERIAL NOT NULL,
    fk_Usuario_id SERIAL NOT NULL,
    id SERIAL PRIMARY KEY NOT NULL
);

CREATE TABLE Desenvolvedora (
    fk_Empresa_id SERIAL NOT NULL,
    fk_App_fk_Produto_id SERIAL NOT NULL
);

CREATE TABLE Distribuidora (
    fk_Empresa_id SERIAL NOT NULL,
    fk_App_fk_Produto_id SERIAL NOT NULL
);

CREATE TABLE Classificacao (
    fk_Genero_id SERIAL NOT NULL,
    fk_App_fk_Produto_id SERIAL NOT NULL
);

CREATE TABLE Categorizacao (
    fk_Categoria_id SERIAL NOT NULL,
    fk_App_fk_Produto_id SERIAL NOT NULL
);

CREATE TABLE Linguagem (
    fk_Idioma_id SERIAL NOT NULL,
    fk_App_fk_Produto_id SERIAL NOT NULL,
    interface BOOLEAN NOT NULL,
    dublagem BOOLEAN NOT NULL,
    legenda BOOLEAN NOT NULL
);

CREATE TABLE Requisitos (
    fk_Plataforma_id SERIAL NOT NULL,
    fk_App_fk_Produto_id SERIAL NOT NULL,
    minimo VARCHAR(400),
    recomendado VARCHAR(400)
);

CREATE TABLE Item_comprado (
    fk_App_fk_Produto_id SERIAL NOT NULL,
    fk_Compras_id SERIAL NOT NULL,
    desconto SMALLINT NOT NULL,
    valor_original DECIMAL(6,2) NOT NULL
);

CREATE TABLE Forma_Pagamento (
    fk_Cartao_Credito_nro_cartao CHAR(19) NOT NULL,
    fk_Usuario_id SERIAL NOT NULL
);
 
ALTER TABLE App ADD CONSTRAINT FK_App_2
    FOREIGN KEY (fk_analises_especialistas_analises_especialistas_PK)
    REFERENCES analises_especialistas (analises_especialistas_PK)
    ON DELETE NO ACTION;
 
ALTER TABLE App ADD CONSTRAINT FK_App_3
    FOREIGN KEY (fk_links_links_PK)
    REFERENCES links (links_PK)
    ON DELETE NO ACTION;
 
ALTER TABLE App ADD CONSTRAINT FK_App_4
    FOREIGN KEY (fk_Produto_id)
    REFERENCES Produto (id)
    ON DELETE CASCADE;
 
ALTER TABLE App ADD CONSTRAINT FK_App_5
    FOREIGN KEY (fk_Serie_id)
    REFERENCES Serie (id)
    ON DELETE CASCADE;
 
ALTER TABLE Jogo ADD CONSTRAINT FK_Jogo_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE CASCADE;
 
ALTER TABLE Conjunto ADD CONSTRAINT FK_Conjunto_2
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
 
ALTER TABLE Jogo_acesso_antecipado ADD CONSTRAINT FK_Jogo_acesso_antecipado_2
    FOREIGN KEY (fk_Jogo_fk_App_fk_Produto_id)
    REFERENCES Jogo (fk_App_fk_Produto_id)
    ON DELETE CASCADE;
 
ALTER TABLE Compras ADD CONSTRAINT FK_Compras_2
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE CASCADE;
 
ALTER TABLE Compras ADD CONSTRAINT FK_Compras_3
    FOREIGN KEY (fk_Cartao_Credito_nro_cartao)
    REFERENCES Cartao_Credito (nro_cartao)
    ON DELETE CASCADE;
 
ALTER TABLE Composicao ADD CONSTRAINT FK_Composicao_1
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE RESTRICT;
 
ALTER TABLE Composicao ADD CONSTRAINT FK_Composicao_2
    FOREIGN KEY (fk_Conjunto_fk_Produto_id)
    REFERENCES Conjunto (fk_Produto_id)
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
 
ALTER TABLE Desenvolvedora ADD CONSTRAINT FK_Desenvolvedora_1
    FOREIGN KEY (fk_Empresa_id)
    REFERENCES Empresa (id)
    ON DELETE RESTRICT;
 
ALTER TABLE Desenvolvedora ADD CONSTRAINT FK_Desenvolvedora_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE SET NULL;
 
ALTER TABLE Distribuidora ADD CONSTRAINT FK_Distribuidora_1
    FOREIGN KEY (fk_Empresa_id)
    REFERENCES Empresa (id)
    ON DELETE RESTRICT;
 
ALTER TABLE Distribuidora ADD CONSTRAINT FK_Distribuidora_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
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
 
ALTER TABLE Linguagem ADD CONSTRAINT FK_Linguagem_1
    FOREIGN KEY (fk_Idioma_id)
    REFERENCES Idioma (id)
    ON DELETE RESTRICT;
 
ALTER TABLE Linguagem ADD CONSTRAINT FK_Linguagem_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE SET NULL;
 
ALTER TABLE Requisitos ADD CONSTRAINT FK_Requisitos_1
    FOREIGN KEY (fk_Plataforma_id)
    REFERENCES Plataforma (id)
    ON DELETE RESTRICT;
 
ALTER TABLE Requisitos ADD CONSTRAINT FK_Requisitos_2
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE SET NULL;
 
ALTER TABLE Item_comprado ADD CONSTRAINT FK_Item_comprado_1
    FOREIGN KEY (fk_App_fk_Produto_id)
    REFERENCES App (fk_Produto_id)
    ON DELETE RESTRICT;
 
ALTER TABLE Item_comprado ADD CONSTRAINT FK_Item_comprado_2
    FOREIGN KEY (fk_Compras_id)
    REFERENCES Compras (id)
    ON DELETE SET NULL;
 
ALTER TABLE Forma_Pagamento ADD CONSTRAINT FK_Forma_Pagamento_1
    FOREIGN KEY (fk_Cartao_Credito_nro_cartao)
    REFERENCES Cartao_Credito (nro_cartao)
    ON DELETE SET NULL;
 
ALTER TABLE Forma_Pagamento ADD CONSTRAINT FK_Forma_Pagamento_2
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE SET NULL;