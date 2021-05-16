-- VISÃO
-- Visão com informações de um App
-- INFORMAÇÔES:
-- id do app, nome do app, preco sem desconto, desconto, preco com o desconto, 
-- data de termino do desconto, data_lancamento, desenvolvedora, distribuidora
-- quantidade de avaliações, porcentagem de avaliações positivas e descrição
CREATE VIEW App_infos AS
SELECT Produto.id, Produto.nome, Produto.preco AS preco_sem_desconto, Produto.desconto, ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,10))/100 * Produto.preco, 2) as preco_com_desconto, Produto.data_fim_desconto,App.data_lancamento, emp1.nome AS desenvolvedora, emp2.nome AS distribuidora,COUNT(avaliacoes.recomenda) AS quant_avaliacoes, ROUND(CAST(SUM(CASE WHEN Avaliacoes.recomenda = true THEN 1 ELSE 0 END) AS DECIMAL(20,10))/COUNT(*),2) AS perc_avaliacoes_positivas, Produto.descricao FROM App
INNER JOIN Produto ON APP.id = Produto.id
INNER JOIN Empresa AS emp1 ON App.fk_Empresa_id_desenvolvedora = emp1.id
INNER JOIN Empresa AS emp2 ON App.fk_Empresa_id_distribuidora = emp2.id
LEFT JOIN Avaliacoes ON App.id = Avaliacoes.fk_App_id
GROUP BY Produto.id, app.id, emp1.id, emp2.id
ORDER BY id;

-- Consulta com Subquery, Visão
-- Apps com os 2 generos especificados, no caso abaixo de RPG e Ação, No programa foi generalizada para quaisquer dois generos
-- retorna id, nome, desconto e preco com desconto dos apps
SELECT App_infos.id, App_infos.nome, App_infos.desconto, App_infos.preco_com_desconto
FROM App_infos 
INNER JOIN Classificacao ON App_infos.id = Classificacao.fk_App_id
INNER JOIN Genero ON Genero.id = Classificacao.fk_Genero_id
WHERE Genero.nome = 'RPG' AND App_infos.id IN (
  SELECT App_infos.id
  FROM App_infos 
  INNER JOIN Classificacao ON App_infos.id = Classificacao.fk_App_id
  INNER JOIN Genero ON Genero.id = Classificacao.fk_Genero_id
  WHERE Genero.nome = 'Ação'
);

-- Consulta com Subquery, Visão
-- Apps com as 2 categorias especificadas, no caso Um jogador e Cooperativo Online, No programa foi generalizada para quaisquer duas categorias
-- retorna id, nome, desconto e preco com desconto dos apps
SELECT App_infos.id, App_infos.nome, App_infos.desconto, App_infos.preco_com_desconto
FROM App_infos 
INNER JOIN Categorizacao ON App_infos.id = Categorizacao.fk_App_id
INNER JOIN Categoria ON Categoria.id = Categorizacao.fk_Categoria_id
WHERE Categoria.nome = 'Um Jogador' AND App_infos.id IN (
  SELECT App_infos.id
  FROM App_infos 
  INNER JOIN Categorizacao ON App_infos.id = Categorizacao.fk_App_id
  INNER JOIN Categoria ON Categoria.id = Categorizacao.fk_Categoria_id
  WHERE Categoria.nome = 'Cooperativo Online'
);

-- Consulta com Group By, Visão
-- Preço dos pacotes e preço se os jogos dos pacotes fossem comprados separadamente
-- retorna id, nome, preço se apps forem comprados separadamente, preco e diferença entre os precos(separadamente - normal) dos pacotes
SELECT Pacote.id, produto.nome, 
SUM(App_infos.preco_com_desconto) AS preco_pacote_separadamente,
ROUND(CAST((100-produto.desconto) AS NUMERIC(20,10))/100 * produto.preco, 2) as preco_pacote, 
SUM(App_infos.preco_com_desconto) - ROUND(CAST((100-produto.desconto) AS NUMERIC(20,10))/100 * produto.preco, 2)as diferenca
FROM App_infos 
INNER JOIN Composicao ON Composicao.fk_App_id = App_infos.id
INNER JOIN Pacote ON Composicao.fk_Pacote_id = Pacote.id
INNER JOIN PRODUTO ON PRODUTO.id = PAcote.id
GROUP BY Pacote.id, produto.id
ORDER BY preco_Pacote DESC;

-- Consulta com Group By, Having, Subquery
-- 4 Tags mais populares de um App
-- retorna id, nome e tags dos apps
SELECT App.id, Produto.nome, C.tag FROM App
INNER JOIN Produto ON App.id = Produto.id 
INNER JOIN LATERAL (
  SELECT tags.fk_app_id as id, Tags.tag as tag, count(tag) FROM Tags
  GROUP BY tags.fk_app_id, tags.tag
  HAVING tags.fk_app_id = app.id
  ORDER BY count(tag) DESC
  LIMIT 4
) AS C ON App.id = C.id;

-- Consulta com Subquery, Not Exists
-- Apps que tem todos generos de outro App
-- nesse caso o App com id = 1
-- retorna id, nome, desconto e preco com desconto dos apps
SELECT App_infos.id, App_infos.nome, App_infos.desconto, App_infos.preco_com_desconto FROM App_infos
WHERE App_infos.id <> 1 AND NOT EXISTS (
  SELECT * FROM Classificacao AS CLA
  INNER JOIN Genero ON Genero.id = CLA.fk_Genero_id
  WHERE CLA.fk_App_id = 1 AND Genero.id NOT IN (
    SELECT Genero.id FROM Classificacao AS CLA 
    INNER JOIN Genero ON Genero.id = CLA.fk_Genero_id
    WHERE CLA.fk_App_id = App_infos.id
  )
);

-- Consulta com Group By
-- Soma dos produtos no carrinho de um usuario, no caso o usuario com id 1, mas extendida para mais usuarios no programa
-- retorna id, email , preco total no carrinho dos usuarios
SELECT Usuario.id, Usuario.email, SUM(ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,2))/100 * Produto.preco, 2)) AS produto_preco_total
FROM Produto
INNER JOIN Carrinho ON Produto.id = Carrinho.fk_Produto_id
INNER JOIN Usuario ON Usuario.id = Carrinho.fk_Usuario_id
WHERE Usuario.id = 1
GROUP BY USUARIO.id;

-- Apps nas contas dos usuario (mostrando apps que foram comprados em pacotes) e apenas mostrando apps que tiveram a compra aprovada
-- retorna id, email dos usuarios e id, nome, desenvolvedora, distribuidora dos apps
SELECT Usuario.id AS id_usuario, Usuario.email, App_infos.id AS id_app, App_infos.nome as nome_app, desenvolvedora, distribuidora FROM Usuario
INNER JOIN Compra ON Usuario.id = Compra.fk_Usuario_id
INNER JOIN Item_comprado ON Item_comprado.fk_Compra_id = Compra.id
LEFT JOIN Pacote ON Item_comprado.fk_Produto_id = Pacote.id
LEFT JOIN Composicao ON Composicao.fk_Pacote_id = Pacote.id
INNER JOIN App_infos ON Item_comprado.fk_Produto_id = App_infos.id or Composicao.fk_App_id = App_infos.id
WHERE Compra.aprovado = true
ORDER BY App_infos.nome;

-- Produtos comprados por usuarios(produtos de compras não aprovadas aparecem)
-- retorna id e email do usuario
--         id da compra
--         id, nome, desconto e preco com desconto do produto quando foi comprado 
SELECT Usuario.id as usuario_id, Usuario.email,  Compra.id as compra_id, Produto.id AS produto_id, Produto.nome AS produto_nome,  item_comprado.desconto AS desconto, ROUND(CAST((100-item_comprado.desconto) AS NUMERIC(20,10))/100 * item_comprado.valor_original, 2) AS preco_com_desconto 
FROM USUARIO
INNER JOIN Compra ON Usuario.id = Compra.fk_Usuario_id
INNER JOIN item_comprado ON Compra.id = item_comprado.fk_Compra_id
INNER JOIN Produto ON Produto.id = fk_Produto_id;

-- Compras de usuarios
-- retorna id, email do usuario
--         id, cartao, status, data, valor da compra
SELECT Usuario.id, Usuario.email, Compra.id as compra_id, Cartao_Credito.nro_cartao as num_cartao, compra.aprovado AS compra_status, compra.data AS compra_data, compra.total AS compra_total 
FROM usuario
INNER JOIN Compra ON usuario.id = compra.fk_usuario_id
INNER JOIN Cartao_Credito ON Cartao_Credito.id = Compra.fk_Cartao_Credito_id;

-- Apps de um Pacote
-- retorna id e nome do pacote
--         id, nome, preco_sem_desconto, preco com desconto, desconto dos apps
SELECT A.id AS pacote_id, A.nome AS pacote_nome, B.id AS app_id, B.nome  AS app_nome, B.preco_sem_desconto AS app_preco_sem_desconto, B.preco_com_desconto AS app_preco_com_desconto, B.desconto AS app_desconto 
FROM Composicao AS Comp
INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
INNER JOIN App_infos AS B ON B.id = Comp.fk_App_id;

-- Expansões dos Jogos
-- retorna id e nome do jogo
--         id, nome, preco_sem_desconto, preco com desconto e desconto das Dlcs
SELECT A.id AS jogo_id, A.nome AS jogo_nome, B.id AS dlc_id, B.nome AS dlc_nome, B.preco_sem_desconto, B.preco_com_desconto, B.desconto  
FROM Dlc
INNER JOIN App_infos AS A ON A.id = Dlc.fk_Jogo_id
INNER JOIN App_infos AS B ON B.id = Dlc.id;

-- Produtos no carrinho
-- retorna id e email do usuario
--         id, nome, preco_semdesconto, desconto, preco com desconto, data de fim do desconto e descrição dos produtos
SELECT Usuario.id, Usuario.email, A.id AS produto_id, A.nome AS produto_nome, A.preco AS produto_preco_sem_desconto, A.desconto AS produto_desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS produto_preco_com_desconto, A.data_fim_desconto AS produto_data_fim_desconto, A.descricao AS produto_descricao 
FROM Produto AS A
INNER JOIN Carrinho ON A.id = Carrinho.fk_Produto_id
INNER JOIN Usuario ON Usuario.id = Carrinho.fk_Usuario_id;

-- Categorias de um App
-- retorna id, nome e categorias dos apps
SELECT CAT.fk_App_id AS app_id, Produto.nome AS app_nome, Categoria.nome AS categoria 
FROM Categorizacao AS CAT
INNER JOIN Categoria ON Categoria.id = fk_Categoria_id
INNER JOIN Produto ON Produto.id = CAT.fk_App_id;

-- Generos de um App
-- retorna id, nome e generos dos apps
SELECT CLA.fk_App_id AS app_id, Produto.nome AS app_nome, Genero.nome AS genero 
FROM Classificacao AS CLA 
INNER JOIN Genero ON Genero.id = fk_Genero_id
INNER JOIN Produto ON Produto.id = CLA.fk_App_id;

-- Generos de um pacote
-- retorna id e nome do pacote, nome do app e seus generos
SELECT DISTINCT Comp.fk_Pacote_id, PRODUTO.nome as nome_pacote, APP.nome as nome_app, Genero.nome as genero
FROM Composicao AS Comp
INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
INNER JOIN Genero ON Genero.id = fk_Genero_id
INNER JOIN Produto ON Produto.id = Comp.fk_Pacote_id;

-- Categorias de um pacote
-- retorna id e nome do pacote, nome do app e suas categorias
SELECT DISTINCT Comp.fk_Pacote_id, PRODUTO.nome as nome_pacote, APP.nome as nome_app, Categoria.nome as categoria
FROM Composicao AS Comp
INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
INNER JOIN Categorizacao AS CAT ON APP.id = CAT.fk_App_id
INNER JOIN Categoria ON Categoria.id = fk_Categoria_id
INNER JOIN Produto ON Produto.id = Comp.fk_Pacote_id;

-- Desenvolvedores de um pacote
-- retorna id e nome do pacote, nome do app e sua desenvolvedora
SELECT DISTINCT Comp.fk_Pacote_id, A.nome as nome_pacote, APP.nome as nome_app, APP.desenvolvedora 
FROM Composicao AS Comp
INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id;

-- Distribuidoras de um pacote
-- retorna id e nome do pacote, nome do app e sua distribuidora
SELECT DISTINCT Comp.fk_Pacote_id, A.nome as nome_pacote, APP.nome as nome_app, APP.distribuidora 
FROM Composicao AS Comp
INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id;

-- Apps de pacotes no carrinho
-- retorna id e email do usuario
--         id do pacote e nome do app no pacote
SELECT Usuario.id, Usuario.email, A.id AS pacote_id, B.nome  AS app_nome FROM Pacote
INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
INNER JOIN App_infos AS B ON B.id = Comp.fk_App_id
INNER JOIN Carrinho AS C ON A.id = C.fk_Produto_id
INNER JOIN USUARIO ON USUARIO.id = Carrinho.fk_Usuario_id;   



-- CONSULTA QUE NÂO USA 3 TABELAS MAS FOI USADA NO PROGRAMA
-- Informações de produtos
-- INFORMAÇÔES:
-- id, nome, preco sem desconto, desconto, preco com desconto,
-- data do fim do desconto e descrição
SELECT A.id AS produto_id, A.nome AS produto_nome, A.preco AS produto_preco_sem_desconto, A.desconto AS produto_desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS produto_preco_com_desconto, A.data_fim_desconto AS produto_data_fim_desconto, A.descricao AS produto_descricao 
FROM Produto AS A;

-- CONSULTA QUE NÂO USA 3 TABELAS MAS FOI USADA NO PROGRAMA
-- Informações de pacotes
-- INFORMAÇÔES:
-- id, nome, preco sem desconto, desconto, preco com desconto,
-- data do fim do desconto e descrição
SELECT A.id AS pacote_id, A.nome AS pacote_nome, A.preco AS pacote_preco_sem_desconto, A.desconto AS pacote_desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS pacote_preco_com_desconto, A.data_fim_desconto AS pacote_data_fim_desconto, A.descricao AS pacote_descricao 
FROM Pacote
INNER JOIN Produto AS A ON A.id = Pacote.id;