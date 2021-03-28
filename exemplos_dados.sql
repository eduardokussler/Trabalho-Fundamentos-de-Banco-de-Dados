/* Testado no pgAdmin 4 com PostgreSQL 13*/

INSERT INTO Produto (nome, preco, desconto, data_fim_desconto, descricao)
VALUES
    -- 1
    ('Dota 2', 0, 0, NULL, NULL),
    -- 2
    ('INSIDE', 36.99, 75, '2021-03-29 18:00:00', 'Perseguido e sozinho, um rapaz é atraído para o centro de um projeto sombrio.'),
    -- 3
    ('Cyberpunk 2077', 199.99, 20, '2021-04-05 18:00:00', 'Cyberpunk 2077 é uma história de ação/aventura no mundo aberto de Night City, uma megalópole obcecada com poder, glamour e alterações de corpos. Aqui serás V, um mercenário exilado que persegue um implante essencial para obter a imortalidade.'),
    -- 4
    ('Cities: Skylines',55.99, 0, NULL, NULL),
    -- 5
    ('Cities: Skylines - Industries', 29.99, 0, NULL, 'Este artigo requer o jogo base Cities: Skylines no Steam para poder ser jogado.'),
    -- 6
    ('Cities: Skylines - Sunset Harbor', 28.99, 0, NULL, 'Este artigo requer o jogo base Cities: Skylines no Steam para poder ser jogado.'),
    -- 7
    ('Comprar Cities: Skylines - City Startup Bundle ', 125.96, 0, NULL, NULL),
    -- 8
    ('Cities: Skylines - Green Cities', 25.99,0,NULL, 'Este artigo requer o jogo base Cities: Skylines no Steam para poder ser jogado.'),
    -- 9
    ('Hades', 47.49, 20, '2021-03-29 18:00:00', NULL),
    -- 10
    ('Hades Original Soundtrack', 16.55, 20, '2021-03-29 18:00:00', 'Isto é conteúdo adicional para Hades, mas não inclui o jogo base.'),
    -- 11
    ('HADES + ORIGINAL SOUNDTRACK BUNDLE', 49.08, 0, NULL, 'Jogo principal e trilha sonora'),
    -- 12
    ('Spelunky 2', 37.99, 0, NULL, NULL),
    -- 13
    ('Spelunky 2 Soundtrack', 14.49, 0, NULL, 'Conteúdo adicional para Spelunky 2, mas não inclui o jogo base.'),
    -- 14
    ('SPELUNKY 2 + SOUNDTRACK BUNDLE', 47.23, 0, NULL, 'Jogo e trilha sonora');


INSERT INTO Usuario (nome, email)
VALUES
    -- 1
    ('Corinthians', 'corinthians@gmail.com'),
    -- 2
    ('Starman','maildoinf@inf.ufrgs.br'),
    -- 3
    ('O Verdadeiro','verdadeiro@outlook.com');

INSERT INTO Cartao_Credito (nro_cartao, nro_sec_cartao, validade_cartao, nome)
VALUES
    -- 1
    ('1234 1234 1234 1234','123','2022-8-5', 'fulano'),
    -- 2
    ('4321 4321 4321 4321','321','2023-3-21', 'ciclano'),
    -- 3
    ('2314 2314 2314 2314','213','2024-12-13', 'deltrano');


INSERT INTO Categoria (nome)
VALUES
    -- 1
    ('Um Jogador'),
    -- 2
    ('Cooperativo Online'),
    -- 3
    ('Conquistas Steam'),
    -- 4
    ('Conteudo Adicional'),
    -- 5
    ('Audio Adicional');

INSERT INTO Genero (nome)
VALUES
    -- 1
    ('RPG'),
    -- 2
    ('Simulação'),
    -- 3
    ('Ação'),
    -- 4
    ('Aventura'),
    -- 5
    ('Estratégia');

INSERT INTO Empresa (nome)
VALUES
    -- 1
    ('PlayDead'),
    -- 2
    ('Valve'),
    -- 3
    ('CD Project Red'),
    -- 4
    ('Supergiant Games'),
    -- 5
    ('Mossmouth'),
    -- 6
    ('Colossal Order Ltd.'),
    -- 7
    ('Paradox Interactive');

INSERT INTO App (id, data_lancamento, fk_Empresa_id_desenvolvedora, fk_Empresa_id_distribuidora)
VALUES
    (1, '2019-07-09 15:00:00', 2, 2),
    (2, '2019-07-07 18:00:00' , 1, 1),
    (3, '2020-12-09 12:00:00', 3, 3),
    (4, '2015-03-10 10:00:00', 6, 7),
    (5, '2017-05-18 09:00:00', 6, 7),
    (6, '2018-10-23 09:00:00', 6, 7),
    (8, '2020-03-26 09:00:00', 6, 7),
    (9, '2020-09-17 09:00:00', 4, 7),
    (10, '2020-09-17 14:00:00', 4, 4),
    (12, '2020-09-29 03:00:00', 5, 5),
    (13, '2020-09-29 03:00:00', 5, 5);

INSERT INTO Categorizacao (fk_App_id, fk_Categoria_id)
VALUES
    (1, 2),
    (1, 3),
    (2, 1),
    (3, 1),
    (3, 3),
    (4, 1),
    (4, 2),
    (4, 3),
    (5, 1),
    (5, 2),
    (5, 3),
    (5, 4),
    (6, 1),
    (6, 2),
    (6, 3),
    (6, 4),
    (8, 1),
    (8, 2),
    (8, 3),
    (8, 4),    
    (9, 1),
    (9, 3),
    (10, 4),
    (10, 5),
    (12, 1),
    (12, 2),
    (12, 3),
    (13, 4),
    (13, 5);

INSERT INTO Classificacao (fk_App_id, fk_Genero_id)
VALUES
    (1, 1),
    (1, 3),
    (2, 3),
    (2, 4),
    (3, 1),
    (3, 3),
    (4, 2),
    (4, 5),
    (5, 2),
    (5, 5),
    (6, 2),
    (6, 5),
    (8, 2),
    (8, 5),
    (9, 3),
    (10, 3),
    (12, 4),
    (13, 4);


INSERT INTO Tags (fk_App_id, fk_Usuario_id, tag)
VALUES
    (12, 1, 'Plataforma'),
    (12, 2, 'Mario'),
    (9, 1, 'Hack and Slash'),
    (9, 2, 'Hack  & Slash');

INSERT INTO Avaliacoes (fk_App_id, fk_Usuario_id, recomenda, comentario)
VALUES
    (1, 1, true, 'Muito bom!!!!!!!'),
    (2, 2, false, 'NÃO RECOMENDO!!!!!!!'),
    (3, 3, true, NULL),
    (4, 1, true, 'Fazia tempo que não jogava um jogo tão bom'),
    (5, 2, false, 'Dlc não adiciona muito ao jogo'),
    (6, 3, true, NULL),
    (8, 1, false, 'Dlc meio fraca, recomendo Industries e Sunset Harbor em vez dessa'),
    (9, 2, true, 'Gostei muito'),
    (10, 3, true, NULL),
    (12, 1, true, 'Melhor jogo desde Spelunky 1'),
    (1, 2, false, 'Muito ruim!!!!!!!'),
    (4, 2, true, 'Melhor jogo da Paradox'),
    (5, 3, true, 'Melhor Dlc do jogo, adiciona muito complexidade as industrias'),
    (8, 2, true, NULL),
    (10, 1, true, NULL),
    (12, 2, true, NULL);


INSERT INTO Pacote (id)
VALUES
    (7),
    (11),
    (14);


INSERT INTO Composicao (fk_App_id, fk_Pacote_id)
VALUES
    (8,7),
    (6,7),
    (5,7),
    (4,7),
    (13,14),
    (12,14),
    (10,11),
    (9,11);

INSERT INTO Jogo (id)
VALUES
    (1),
    (2),
    (3),
    (4),
    (9),
    (12);

INSERT INTO Dlc (id, fk_Jogo_id)
VALUES
    (5,4),
    (6,4),
    (8,4),
    (10,9),
    (13,12);


INSERT INTO Forma_Pagamento (fk_Cartao_Credito_id, fk_Usuario_id)
VALUES
    (1,1),
    (2,1),
    (1,3);

INSERT INTO Carrinho (fk_Produto_id, fk_Usuario_id)
VALUES
    (1,1),
    (2,1),
    (3,1);

INSERT INTO Compra (data, total, fk_Usuario_id, fk_Cartao_Credito_id, aprovado)
VALUES
    ('2021-03-28 13:00:00', 55, 1, 1, true),
    ('2021-03-28 13:00:00', 40, 1, 2, true),
    ('2021-03-28 13:00:00', 30, 1, 1, false);

INSERT INTO Item_comprado (fk_Produto_id, fk_Compra_id, desconto, valor_original)
VALUES
    (4, 1, 0, 55),
    (9, 2, 50, 80),
    (12, 3, 50, 60);
