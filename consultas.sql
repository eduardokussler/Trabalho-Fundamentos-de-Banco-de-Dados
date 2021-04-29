
-- Visão com informações de um App
CREATE VIEW App_infos AS
SELECT Produto.id, Produto.nome, Produto.preco AS preco_sem_desconto, Produto.desconto, ROUND(CAST((100-Produto.desconto) AS NUMERIC(20,10))/100 * Produto.preco, 2) as preco_com_desconto, Produto.data_fim_desconto,App.data_lancamento, emp1.nome AS desenvolvedora, emp2.nome AS distribuidora,COUNT(avaliacoes.recomenda) AS quant_avaliacoes, ROUND(CAST(SUM(CASE WHEN Avaliacoes.recomenda = true THEN 1 END) AS DECIMAL(20,10))/COUNT(*),2) AS perc_avaliacoes FROM App
INNER JOIN Produto ON APP.id = Produto.id
INNER JOIN Empresa AS emp1 ON App.fk_Empresa_id_desenvolvedora = emp1.id
INNER JOIN Empresa AS emp2 ON App.fk_Empresa_id_distribuidora = emp2.id
LEFT JOIN Avaliacoes ON App.id = Avaliacoes.fk_App_id
GROUP BY Produto.id, app.id, emp1.id, emp2.id
ORDER BY id;

-- Categorias de um App
SELECT * FROM App
INNER JOIN Categorizacao AS CAT ON APP.id = CAT.fk_App_id
INNER JOIN Categoria ON Categoria.id = fk_Categoria_id;

-- Generos de um App
SELECT * FROM App
INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
INNER JOIN Genero ON Genero.id = fk_Genero_id;

-- Apps de um Pacote
SELECT * FROM Pacote
INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
INNER JOIN Produto AS A ON A.id = Comp.fk_App_id
INNER JOIN Produto AS B ON B.id = Comp.fk_Pacote_id;

-- Expansões dos Jogos
SELECT * FROM Jogo
INNER JOIN Dlc ON Jogo.id = Dlc.fk_Jogo_id
INNER JOIN App_infos AS A ON A.id = Dlc.id
INNER JOIN App_infos AS B ON B.id = Jogo.id;

-- Preco dos pacotes se os jogos do pacote forem comprados separadamente
SELECT Pacote.id, SUM(App_infos.preco_sem_desconto) AS preco_Pacote
FROM App_infos INNER JOIN Composicao ON Composicao.fk_App_id = App_infos.id
INNER JOIN Pacote ON Composicao.fk_Pacote_id = Pacote.id
GROUP BY Pacote.id
ORDER BY preco_Pacote DESC;

-- Numero de jogos de um determinado genero, no caso abaixo RPG
SELECT COUNT(App_infos.id) AS Num_apps
FROM Classificacao INNER JOIN App_infos ON App_infos.id = Classificacao.fk_App_id
INNER JOIN Genero on Genero.id = Classificacao.fk_Genero_id
GROUP BY Genero.nome
HAVING Genero.nome = 'RPG';


-- Jogos com 2 generos, no caso abaixo de RPG e Ação
SELECT App_infos.nome
FROM App_infos INNER JOIN Classificacao ON App_infos.id = Classificacao.fk_App_id
INNER JOIN Genero on Genero.id = Classificacao.fk_Genero_id
WHERE Genero.nome = 'RPG' AND App_infos.id IN (
  SELECT App_infos.id
  FROM App_infos INNER JOIN Classificacao ON App_infos.id = Classificacao.fk_App_id
  INNER JOIN Genero on Genero.id = Classificacao.fk_Genero_id
  WHERE Genero.nome = 'Ação'
);

-- Jogos com 2 categorias, no caso Um jogador e Cooperativo Online

SELECT App_infos.nome
FROM App_infos INNER JOIN Categorizacao ON App_infos.id = Categorizacao.fk_App_id
INNER JOIN Categoria on Categoria.id = Categorizacao.fk_Categoria_id
WHERE Categoria.nome = 'Um Jogador' AND App_infos.id IN (
  SELECT App_infos.id
  FROM App_infos INNER JOIN Categorizacao ON App_infos.id = Categorizacao.fk_App_id
  INNER JOIN Categoria on Categoria.id = Categorizacao.fk_Categoria_id
  WHERE Categoria.nome = 'Cooperativo Online'
);
