INSERT INTO Produto (nome, preco, desconto, data_fim_desconto, descricao)
VALUES
  --1
    ('Dota 2', 0, 0, NULL, 'Every day, millions of players worldwide enter battle as one of over a hundred Dota heroes. And no matter if its their 10th hour of play or 1,000th, theres always something new to discover. With regular updates that ensure a constant evolution of gameplay, features, and heroes, Dota 2 has taken on a life of its own.'),
    --2
    ('INSIDE', 36.99, 75, '2021-03-29 18:00:00', 'Perseguido e sozinho, um rapaz é atraído para o centro de um projeto sombrio.'),
    --3
    ('Cyberpunk 2077', 199.99, 20, '2021-04-05 18:00:00', 'Cyberpunk 2077 é uma história de ação/aventura no mundo aberto de Night City, uma megalópole obcecada com poder, glamour e alterações de corpos. Aqui serás V, um mercenário exilado que persegue um implante essencial para obter a imortalidade.'),
    --4
    ('Cities: Skylines',55.99, 0, NULL, 'Cities: Skylines is a modern take on the classic city simulation. The game introduces new game play elements to realize the thrill and hardships of creating and maintaining a real city whilst expanding on some well-established tropes of the city building experience.'),
    --5
    ('Cities: Skylines - Industries', 29.99, 0, NULL, 'Este artigo requer o jogo base Cities: Skylines no Steam para poder ser jogado.'),
    --6
    ('Cities: Skylines - Sunset Harbor', 28.99, 0, NULL, 'Este artigo requer o jogo base Cities: Skylines no Steam para poder ser jogado.'),
    --7
    ('Comprar Cities: Skylines - City Startup Bundle ', 125.96, 0, NULL, 'Assume o cargo de novo presidente da câmara com o City Startup Bundle, que inclui não só o jogo base como também três expansões:
-Cities: Skylines - Mass Transit
-Cities: Skylines - Industries
-Cities: Skylines - Sunset Harbor'),
    --8
    ('Cities: Skylines - Green Cities', 25.99,0,NULL, 'Este artigo requer o jogo base Cities: Skylines no Steam para poder ser jogado.'),
    --9
    ('Hades', 47.49, 20, '2021-03-29 18:00:00', 'Defy the god of the dead as you hack and slash out of the Underworld in this rogue-like dungeon crawler from the creators of Bastion, Transistor, and Pyre.'),
    --10
    ('Hades Original Soundtrack', 16.55, 20, '2021-03-29 18:00:00', 'Isto é conteúdo adicional para Hades, mas não inclui o jogo base.'),
    --11
    ('HADES + ORIGINAL SOUNDTRACK BUNDLE', 49.08, 0, NULL, 'Jogo principal e trilha sonora'),
    --12
    ('Spelunky 2', 37.99, 0, NULL, 'Spelunky 2 builds upon the unique, randomized challenges that made the original a roguelike classic, offering a huge adventure designed to satisfy players old and new. Meet the next generation of explorers as they find themselves on the Moon, searching for treasure and missing family.'),
    --13
    ('Spelunky 2 Soundtrack', 14.49, 0, NULL, 'Isto é conteúdo adicional para Spelunky 2, mas não inclui o jogo base.'),
    --14
    ('SPELUNKY 2 + SOUNDTRACK BUNDLE', 47.23, 0, NULL, 'Play Spelunky 2, the expansive sequel to the original roguelike platformer Spelunky, and then listen to the magical soundtrack by Eirik Suhrke, which captures the broad variety of the game, from lush, underground jungles and deadly, trap-filled ruins to warm community spaces and cozy shops (and much more!).

By buying this bundle, youll become the proud owner of both Spelunky 2 and its original soundtrack. Enjoy!');


INSERT INTO Usuario (nome, email)
VALUES
    ('Corinthians', 'corinthians@gmail.com'),
    ('Carro da Paçoca','paçoqueiro@inf.ufrgs.br'),
    ('O Verdadeiro','verdadeiro@outlook.com');

INSERT INTO Cartao_Credito (nro_cartao, nro_sec_cartao, validade_cartao, nome)
VALUES
    ('1234 1234 1234 1234','123','2019-10-21', 'fulano'),
    ('1234 1234 1234 1235','123','2019-11-21', 'ciclano'),
    ('1234 1234 1234 1236','123','2019-12-21', 'deltrano');


INSERT INTO Categoria (nome)
VALUES
    ('Um Jogador'),
    ('Cooperativo Online'),
    ('Conquistas Steam');

INSERT INTO Genero (nome)
VALUES
    ('RPG'),
    ('Simulação'),
    ('Estratégia');

INSERT INTO Empresa (nome)
VALUES
    ('EA'),
    ('Valve'),
    ('Paradox Interactive');

INSERT INTO App (id, data_lancamento, fk_Empresa_id_desenvolvedora, fk_Empresa_id_distribuidora)
VALUES
    (1, '2019-03-29 18:00:00', 2, 2),
    (2, '2019-04-05 18:00:00' , 3, 3),
    (3, '2019-04-05 18:00:00', 3, 1),
    (4, '2019-04-05 18:00:00', 3, 2),
    (5, '2019-04-05 18:00:00', 3, 2),
    (6, '2019-04-05 18:00:00', 1, 3),
    (8, '2019-04-05 18:00:00', 1, 3),
    (9, '2019-04-05 18:00:00', 2, 3),
    (10, '2019-04-05 18:00:00', 3, 2),
    (12, '2019-04-05 18:00:00', 3, 1),
    (13, '2019-04-05 18:00:00', 3, 3);

INSERT INTO Categorizacao (fk_App_id, fk_Categoria_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 3),
    (5, 2),
    (6, 1),
    (8, 1),
    (9, 2),
    (10, 3),
    (12, 2),
    (13, 1);

INSERT INTO Classificacao (fk_App_id, fk_Genero_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 3),
    (5, 2),
    (6, 1),
    (8, 1),
    (9, 2),
    (10, 3),
    (12, 2),
    (13, 1);


INSERT INTO Tags (fk_App_id, fk_Usuario_id, tag)
VALUES
    (1, 1, 'MUITO LOCO'),
    (2, 2,  'Brasil'),
    (3, 3, 'RPG');

INSERT INTO Avaliacoes (fk_App_id, fk_Usuario_id, recomenda, comentario)
VALUES
    (1, 1, true, 'Muito bom!!!!!!!'),
    (2, 2, false, 'NÃO RECOMENDO!!!!!!!'),
    (3, 3, true, 'MAKES YOU FEEL LIKE BATMAN!!!!!!!');

INSERT INTO Pacote (id)
VALUES
    (7),
    (11),
    (14);


INSERT INTO Composicao (fk_App_id, fk_Pacote_id)
VALUES
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
    (2,1),
    (3,2),
    (1,3);

INSERT INTO Compra (data, total, fk_Usuario_id, fk_Cartao_Credito_id, aprovado)
VALUES
    ('2021-04-29 18:00:00', 55, 1, 1, true),
    ('2021-03-29 18:00:00', 40, 2, 2, true),
    ('2021-02-26 18:00:00', 30, 3, 3, true);

INSERT INTO Item_comprado (fk_Produto_id, fk_Compra_id, desconto, valor_original)
VALUES
    (1, 1, 0, 55),
    (2, 2, 50, 80),
    (3, 3, 50, 60);
