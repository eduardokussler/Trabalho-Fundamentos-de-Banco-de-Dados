-- busca na loja
DROP FUNCTION IF EXISTS busca_nome;
CREATE OR REPLACE FUNCTION busca_nome(name VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT A.id AS id, A.nome AS nome, A.desconto AS desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS preco_com_desconto
    FROM Produto AS A
    WHERE A.nome ILIKE name||'%';
END;
$$ LANGUAGE plpgsql;

-- Busca jogos com 2 generos
DROP FUNCTION IF EXISTS busca_app_2generos;
CREATE OR REPLACE FUNCTION busca_app_2generos(genero1 VARCHAR(50), genero2 VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT App_infos.id, App_infos.nome, App_infos.desconto, App_infos.preco_com_desconto
    FROM App_infos INNER JOIN Classificacao ON App_infos.id = Classificacao.fk_App_id
    INNER JOIN Genero ON Genero.id = Classificacao.fk_Genero_id
    WHERE Genero.nome = genero1 AND App_infos.id IN (
      SELECT App_infos.id
      FROM App_infos INNER JOIN Classificacao ON App_infos.id = Classificacao.fk_App_id
      INNER JOIN Genero ON Genero.id = Classificacao.fk_Genero_id
      WHERE Genero.nome = genero2
);
END;
$$ LANGUAGE plpgsql;


-- Jogos com 2 categorias, no caso Um jogador e Cooperativo Online
-- Busca jogos com 2 generos
DROP FUNCTION IF EXISTS busca_app_2categorias;
CREATE OR REPLACE FUNCTION busca_app_2categorias(categoria1 VARCHAR(50), categoria2 VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT App_infos.id, App_infos.nome, App_infos.desconto, App_infos.preco_com_desconto
    FROM App_infos INNER JOIN Categorizacao ON App_infos.id = Categorizacao.fk_App_id
    INNER JOIN Categoria ON Categoria.id = Categorizacao.fk_Categoria_id
    WHERE Categoria.nome = categoria1 AND App_infos.id IN (
    SELECT App_infos.id
    FROM App_infos INNER JOIN Categorizacao ON App_infos.id = Categorizacao.fk_App_id
    INNER JOIN Categoria ON Categoria.id = Categorizacao.fk_Categoria_id
    WHERE Categoria.nome = categoria2
    );
END;
$$ LANGUAGE plpgsql;

-- Categorias de um App
DROP FUNCTION IF EXISTS busca_app_categoria;
CREATE OR REPLACE FUNCTION busca_app_categoria(categoriaIN VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
  SELECT App.id AS app_id, Produto.nome AS app_nome, Produto.desconto, ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,10))/100 * Produto.preco, 2) AS preco_com_desconto  
  FROM App
  INNER JOIN Categorizacao AS CAT ON APP.id = CAT.fk_App_id
  INNER JOIN Categoria ON Categoria.id = fk_Categoria_id
  INNER JOIN Produto ON Produto.id = App.id
  WHERE categoria.nome = categoriaIN;
  END;
$$ LANGUAGE plpgsql;

-- Busca apps de tal genero
DROP FUNCTION IF EXISTS busca_app_genero;
CREATE OR REPLACE FUNCTION busca_app_genero(generoIN VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    -- Generos de um App
    SELECT App.id AS app_id, Produto.nome AS app_nome, Produto.desconto, ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,10))/100 * Produto.preco, 2) AS preco_com_desconto  
    FROM App
    INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
    INNER JOIN Genero ON Genero.id = fk_Genero_id
    INNER JOIN Produto ON Produto.id = App.id
    WHERE genero.nome = generoIN;
END;
$$ LANGUAGE plpgsql;

-- busca de Apps por distruibuidora na loja
DROP FUNCTION IF EXISTS busca_app_distribuidora;
CREATE OR REPLACE FUNCTION busca_app_distribuidora(distribuidoraIN VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT App_infos.id, App_infos.nome, App_infos.desconto, App_infos.preco_com_desconto
    FROM App_infos
    WHERE App_infos.distribuidora = distribuidoraIN;
END;
$$ LANGUAGE plpgsql;

-- busca de Apps por desenvolvedora na loja
DROP FUNCTION IF EXISTS busca_app_desenvolvedora;
CREATE OR REPLACE FUNCTION busca_app_desenvolvedora(desenvolvedoraIN VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT App_infos.id, App_infos.nome, App_infos.desconto, App_infos.preco_com_desconto
    FROM App_infos
    WHERE App_infos.desenvolvedora = desenvolvedoraIN;
END;
$$ LANGUAGE plpgsql;

-- Generos de um pacote
DROP FUNCTION IF EXISTS busca_pacote_genero;
CREATE OR REPLACE FUNCTION busca_pacote_genero(generoIN VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
  SELECT DISTINCT Pacote.id, Produto.nome, Produto.desconto, ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,10))/100 * Produto.preco, 2) AS preco_com_desconto 
  FROM Pacote
  INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
  INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
  INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
  INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
  INNER JOIN Genero ON Genero.id = fk_Genero_id
  INNER JOIN Produto ON Produto.id = Pacote.id
  WHERE Genero.nome = GeneroIN;
END;
$$ LANGUAGE plpgsql;


-- Categorias de um pacote
DROP FUNCTION IF EXISTS busca_pacote_categoria;
CREATE OR REPLACE FUNCTION busca_pacote_categoria(CategoriaIN VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
  SELECT DISTINCT Pacote.id, Produto.nome, Produto.desconto, ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,10))/100 * Produto.preco, 2) AS preco_com_desconto 
    FROM Pacote
    INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
    INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
    INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
    INNER JOIN Categorizacao AS CAT ON APP.id = CAT.fk_App_id
    INNER JOIN Categoria ON Categoria.id = fk_Categoria_id
    INNER JOIN Produto ON Produto.id = Pacote.id
    WHERE Categoria.nome = CategoriaIN;
END;
$$ LANGUAGE plpgsql;

-- Desenvolvedores de um pacote
DROP FUNCTION IF EXISTS busca_pacote_desenvolvedora;
CREATE OR REPLACE FUNCTION busca_pacote_desenvolvedora(DevIN VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT DISTINCT Pacote.id, Produto.nome, Produto.desconto, ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,10))/100 * Produto.preco, 2) AS preco_com_desconto 
    FROM Pacote
    INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
    INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
    INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
    INNER JOIN Produto ON Produto.id = Pacote.id
    WHERE APP.desenvolvedora = DevIN;
END;
$$ LANGUAGE plpgsql;

-- distribuidoras de um pacote
DROP FUNCTION IF EXISTS busca_pacote_distribuidora;
CREATE OR REPLACE FUNCTION busca_pacote_distribuidora(DistIN VARCHAR(50)) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT DISTINCT Pacote.id, Produto.nome, Produto.desconto, ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,10))/100 * Produto.preco, 2) AS preco_com_desconto 
    FROM Pacote
    INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
    INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
    INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
    INNER JOIN Produto ON Produto.id = Pacote.id
    WHERE APP.distribuidora = DistIN;
END;
$$ LANGUAGE plpgsql;

-- paginas de pacotes, jogos, dlcs
-- Pagina jogos
DROP FUNCTION IF EXISTS pagina_app_app_info;
CREATE OR REPLACE FUNCTION pagina_app_app_info(INPUT INTEGER) RETURNS TABLE(id INTEGER, nome VARCHAR(50), preco_sem_desconto DECIMAL(6,2), desconto SMALLINT, preco_com_desconto NUMERIC(20,2), data_fim_desconto TIMESTAMP ,data_lancamento TIMESTAMP, desenvolvedora VARCHAR(50), distribuidora VARCHAR(50), quant_avaliacoes BIGINT, perc_avaliacoes DECIMAL(20,10), descricao VARCHAR(1000)) AS $$
BEGIN
RETURN QUERY
    SELECT * FROM App_infos
    WHERE APP_infos.id = INPUT;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS pagina_jogo_expansoes;
CREATE OR REPLACE FUNCTION pagina_jogo_expansoes(INPUT INTEGER) RETURNS TABLE(dlc_id INTEGER, dlc_nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT B.id AS dlc_id, B.nome AS dlc_nome, B.desconto, B.preco_com_desconto  FROM Jogo
    INNER JOIN Dlc ON Jogo.id = Dlc.fk_Jogo_id
    INNER JOIN App_infos AS A ON A.id = Jogo.id
    INNER JOIN App_infos AS B ON B.id = Dlc.id
    WHERE A.id = INPUT;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS pagina_app_mesmos_generos;
CREATE OR REPLACE FUNCTION pagina_app_mesmos_generos(INPUT INTEGER) RETURNS TABLE(id INTEGER, nome VARCHAR(50), desconto SMALLINT, preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT App_infos.id, App_infos.nome, App_infos.desconto, App_infos.preco_com_desconto FROM App_infos
    WHERE App_infos.id <> INPUT AND NOT EXISTS (
      SELECT * FROM App
      INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
      INNER JOIN Genero ON Genero.id = fk_Genero_id
      INNER JOIN Produto ON Produto.id = App.id
      WHERE App.id = INPUT AND Genero.id NOT IN (
        SELECT Genero.id FROM App
        INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
        INNER JOIN Genero ON Genero.id = fk_Genero_id
        INNER JOIN Produto ON Produto.id = App.id
        WHERE App.id = App_infos.id
    )
);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS pagina_app_tags;
CREATE OR REPLACE FUNCTION pagina_app_tags(INPUT INTEGER) RETURNS TABLE(tag VARCHAR(50)) AS $$
BEGIN
RETURN QUERY
    SELECT C.tag FROM App
    INNER JOIN Produto ON App.id = Produto.id 
    INNER JOIN LATERAL (
    SELECT tags.fk_app_id as id, Tags.tag as tag, count(Tags.tag) FROM Tags
    GROUP BY tags.fk_app_id, tags.tag
    HAVING tags.fk_app_id = app.id
    ORDER BY count(Tags.tag)
    LIMIT 4
    ) AS C ON App.id = C.id
    WHERE App.id = INPUT;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS busca_pacote_preco_separado;
CREATE OR REPLACE FUNCTION busca_pacote_preco_separado(INPUT INTEGER) RETURNS TABLE(id INTEGER, diferenca NUMERIC(20,10), preco_separado_Pacote DECIMAL(6,2)) AS $$
BEGIN
RETURN QUERY
  -- Preco dos pacotes se os jogos do pacote forem comprados separadamente
  SELECT Pacote.id, SUM(App_infos.preco_com_desconto) - ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,10))/100 * Produto.preco, 2) AS diferenca, SUM(App_infos.preco_com_desconto) AS preco_separado_Pacote
  FROM App_infos INNER JOIN Composicao ON Composicao.fk_App_id = App_infos.id
  INNER JOIN Pacote ON Composicao.fk_Pacote_id = Pacote.id
  INNER JOIN PRODUTO ON PRODUTO.id = pacote.id
  WHERE Pacote.id = INPUT
  GROUP BY Pacote.id, Produto.id
  ORDER BY preco_separado_Pacote DESC;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS busca_pacote_info;
CREATE OR REPLACE FUNCTION busca_pacote_info(INPUT INTEGER) RETURNS TABLE(pacote_id INTEGER, pacote_nome VARCHAR(50), pacote_preco_sem_desconto NUMERIC(20,2), pacote_desconto SMALLINT, pacote_preco_com_desconto NUMERIC(20,2), pacote_data_fim_desconto TIMESTAMP, pacote_descricao VARCHAR(1000)) AS $$
BEGIN
RETURN QUERY
    -- infos de um Pacote
    SELECT A.id AS pacote_id, A.nome AS pacote_nome, A.preco AS pacote_preco_sem_desconto, A.desconto AS pacote_desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS pacote_preco_com_desconto, A.data_fim_desconto AS pacote_data_fim_desconto, A.descricao AS pacote_descricao FROM Pacote
    INNER JOIN Produto AS A ON A.id = Pacote.id
    WHERE A.id = INPUT;
END;
$$ LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS busca_pacote_apps;
CREATE OR REPLACE FUNCTION busca_pacote_apps(INPUT INTEGER) RETURNS TABLE(app_id INTEGER, app_nome VARCHAR(50), app_desconto SMALLINT, app_preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    -- Apps de um Pacote
    SELECT B.id AS app_id, B.nome  AS app_nome, B.desconto AS app_desconto, B.preco_com_desconto AS app_preco_com_desconto FROM Pacote
    INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
    INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
    INNER JOIN App_infos AS B ON B.id = Comp.fk_App_id
    WHERE A.id = INPUT;    
END;
$$ LANGUAGE plpgsql;


-- adicionar ao carrinho
-- Apps de um Pacote no carrinho
DROP PROCEDURE IF EXISTS adiciona_carrinho_produto;
CREATE OR REPLACE PROCEDURE adiciona_carrinho_produto(Usuario_id INTEGER, Produto_id INTEGER) AS $$
BEGIN
    INSERT INTO Carrinho (fk_Produto_id, fk_Usuario_id) 
    VALUES (Produto_id, Usuario_id);
END;
$$ LANGUAGE plpgsql;


-- Apps de um Pacote no carrinho
DROP FUNCTION IF EXISTS busca_carrinho_pacote_apps;
CREATE OR REPLACE FUNCTION busca_carrinho_pacote_apps(INPUT INTEGER) RETURNS TABLE(pacote_id INTEGER, app_nome VARCHAR(50)) AS $$
BEGIN
RETURN QUERY
    SELECT A.id AS pacote_id, B.nome  AS app_nome FROM Pacote
    INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
    INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
    INNER JOIN App_infos AS B ON B.id = Comp.fk_App_id
    INNER JOIN Carrinho AS C ON A.id = C.fk_Produto_id
    WHERE C.fk_usuario_id = INPUT;    
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS busca_carrinho_produtos;
CREATE OR REPLACE FUNCTION busca_carrinho_produtos(INPUT INTEGER) RETURNS TABLE(produto_id INTEGER, produto_nome VARCHAR(50), produto_preco_com_desconto NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT A.id AS produto_id, A.nome AS produto_nome, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS produto_preco_com_desconto
    FROM Produto AS A
    INNER JOIN Carrinho ON A.id = Carrinho.fk_Produto_id
    INNER JOIN Usuario ON Usuario.id = Carrinho.fk_Usuario_id
    WHERE Carrinho.fk_Usuario_id = INPUT;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS busca_carrinho_produtos_preco;
CREATE OR REPLACE FUNCTION busca_carrinho_produtos_preco(INPUT INTEGER) RETURNS TABLE(produto_preco_total NUMERIC(20,2)) AS $$
BEGIN
RETURN QUERY
    SELECT SUM(ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,2))/100 * Produto.preco, 2)) AS produto_preco_total
    FROM Produto
    INNER JOIN Carrinho ON Produto.id = Carrinho.fk_Produto_id
    GROUP BY Carrinho.fk_Usuario_id
    HAVING Carrinho.fk_Usuario_id = INPUT;
END;
$$ LANGUAGE plpgsql;
-- verificar compras, apps, na conta

-- compras de um usuario
DROP FUNCTION IF EXISTS busca_usuario_compras;
CREATE OR REPLACE FUNCTION busca_usuario_compras(INPUT INTEGER) RETURNS TABLE(compra_id INTEGER, compra_status BOOLEAN, compra_data TIMESTAMP, compra_total DECIMAL(10,2)) AS $$
BEGIN
RETURN QUERY
    SELECT Compra.id as compra_id, compra.aprovado AS compra_status, compra.data AS compra_data, compra.total AS compra_total FROM usuario
    INNER JOIN Compra ON usuario.id = compra.fk_usuario_id
    WHERE usuario.id = INPUT;
END;
$$ LANGUAGE plpgsql;

-- items comprados de um usuario
DROP FUNCTION IF EXISTS busca_usuario_itens_comprados;
CREATE OR REPLACE FUNCTION busca_usuario_itens_comprados(INPUT INTEGER) RETURNS TABLE(compra_id INTEGER, 
produto_id INTEGER,
produto_nome VARCHAR(50) ,
desconto SMALLINT, preco_com_desconto NUMERIC(10,2)) AS $$
BEGIN
RETURN QUERY
    SELECT Compra.id as compra_id, Produto.id AS produto_id, Produto.nome AS produto_nome,  item_comprado.desconto AS desconto, ROUND(CAST((100-item_comprado.desconto) AS NUMERIC(20,10))/100 * item_comprado.valor_original, 2) AS preco_com_desconto FROM usuario
    INNER JOIN Compra ON usuario.id = compra.fk_usuario_id
    INNER JOIN item_comprado ON Compra.id = item_comprado.fk_Compra_id
    INNER JOIN Produto ON Produto.id = fk_Produto_id
    WHERE Usuario.id = INPUT;
END;
$$ LANGUAGE plpgsql;

-- Apps na conta de um usuario (mostrando apps que foram comprados em pacotes)
DROP FUNCTION IF EXISTS busca_usuario_apps;
CREATE OR REPLACE FUNCTION busca_usuario_apps(INPUT INTEGER) RETURNS TABLE(id_app INTEGER, nome_app VARCHAR(50), desenvolvedora VARCHAR(50), distribuidora VARCHAR(50)) AS $$
BEGIN
RETURN QUERY
    SELECT App_infos.id AS id_app, App_infos.nome as nome_app, App_infos.desenvolvedora as desenvolvedora, App_infos.distribuidora as distribuidora FROM Usuario
    INNER JOIN Compra ON Usuario.id = Compra.fk_Usuario_id
    INNER JOIN Item_comprado ON Item_comprado.fk_Compra_id = Compra.id
    LEFT JOIN Pacote ON Item_comprado.fk_Produto_id = Pacote.id
    LEFT JOIN Composicao ON Composicao.fk_Pacote_id = Pacote.id
    INNER JOIN App_infos ON Item_comprado.fk_Produto_id = App_infos.id or Composicao.fk_App_id = App_infos.id
    WHERE Usuario.id = INPUT and Compra.aprovado = true
	ORDER BY App_infos.nome;
END;
$$ LANGUAGE plpgsql;

-- comprar
--DROP PROCEDURE IF EXISTS comprar;
--CREATE OR REPLACE PROCEDURE comprar(Usuario_id INTEGER, data_agora TIMESTAMP, total DECIMAL(10,2)) AS $$
--BEGIN
--    INSERT INTO Compra (data, total, fk_Usuario_id, fk_Cartao_Credito_id, aprovado) 
--    VALUES (data_agora, Usuario_id);
--END;
--$$ LANGUAGE plpgsql;
