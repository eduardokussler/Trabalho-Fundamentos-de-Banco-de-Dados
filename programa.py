import psycopg2 as pg2
import tabulate as tab


# busca na loja
# paginas de produtos, apps
# adicionar ao carrinho

# comprar
# verificar compras, apps, na conta


def visao():
    return '''SELECT * FROM App_infos'''


def tags_mais_pop():
    return f'''
    SELECT App.id, Produto.nome, C.tag FROM App
    INNER JOIN Produto ON App.id = Produto.id 
    INNER JOIN LATERAL (
      SELECT tags.fk_app_id as id, Tags.tag as tag, count(tag) FROM Tags
      GROUP BY tags.fk_app_id, tags.tag
      HAVING tags.fk_app_id = app.id
      ORDER BY count(tag)
      LIMIT 4
    ) AS C ON App.id = C.id'''

-- Consulta com Group By, Visão
-- Preco dos pacotes se os jogos do pacote forem comprados separadamente
SELECT Pacote.id, SUM(App_infos.preco_sem_desconto) AS preco_Pacote
FROM App_infos INNER JOIN Composicao ON Composicao.fk_App_id = App_infos.id
INNER JOIN Pacote ON Composicao.fk_Pacote_id = Pacote.id
GROUP BY Pacote.id
ORDER BY preco_Pacote DESC;

-- Consulta com Subquery, Visão
-- Jogos com 2 generos, no caso abaixo de RPG e Ação
SELECT App_infos.nome
FROM App_infos INNER JOIN Classificacao ON App_infos.id = Classificacao.fk_App_id
INNER JOIN Genero ON Genero.id = Classificacao.fk_Genero_id
WHERE Genero.nome = 'RPG' AND App_infos.id IN (
  SELECT App_infos.id
  FROM App_infos INNER JOIN Classificacao ON App_infos.id = Classificacao.fk_App_id
  INNER JOIN Genero ON Genero.id = Classificacao.fk_Genero_id
  WHERE Genero.nome = 'Ação'
);

-- Consulta com Subquery, Visão
-- Jogos com 2 categorias, no caso Um jogador e Cooperativo Online
SELECT App_infos.nome
FROM App_infos INNER JOIN Categorizacao ON App_infos.id = Categorizacao.fk_App_id
INNER JOIN Categoria ON Categoria.id = Categorizacao.fk_Categoria_id
WHERE Categoria.nome = 'Um Jogador' AND App_infos.id IN (
  SELECT App_infos.id
  FROM App_infos INNER JOIN Categorizacao ON App_infos.id = Categorizacao.fk_App_id
  INNER JOIN Categoria ON Categoria.id = Categorizacao.fk_Categoria_id
  WHERE Categoria.nome = 'Cooperativo Online'
);

-- Consulta com Subquery, Not Exists
-- Apps que tem o mesmo genero que outro App
-- nesse caso o App com id = 1
SELECT App_infos.id, App_infos.nome FROM App_infos
WHERE App_infos.id <> 1 AND NOT EXISTS (
  SELECT * FROM App
  INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
  INNER JOIN Genero ON Genero.id = fk_Genero_id
  INNER JOIN Produto ON Produto.id = App.id
  WHERE App.id = 1 AND Genero.id NOT IN (
    SELECT Genero.id FROM App
    INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
    INNER JOIN Genero ON Genero.id = fk_Genero_id
    INNER JOIN Produto ON Produto.id = App.id
    WHERE App.id = App_infos.id
  )
);


-- CONSULTAS VARIADAS
-- Apps de um Pacote
SELECT A.id AS pacote_id, A.nome AS pacote_nome, B.id AS app_id, B.nome  AS app_nome, B.preco_sem_desconto AS app_preco_sem_desconto, B.preco_com_desconto AS app_preco_com_desconto, B.desconto AS app_desconto FROM Pacote
INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
INNER JOIN App_infos AS B ON B.id = Comp.fk_App_id;

-- Expansões dos Jogos
SELECT A.id AS jogo_id, A.nome AS jogo_nome, B.id AS dlc_id, B.nome AS dlc_nome, B.preco_sem_desconto, B.preco_com_desconto, B.desconto  FROM Jogo
INNER JOIN Dlc ON Jogo.id = Dlc.fk_Jogo_id
INNER JOIN App_infos AS A ON A.id = Jogo.id
INNER JOIN App_infos AS B ON B.id = Dlc.id;

-- Apps na conta de um usuario (mostrando apps que foram comprados em pacotes)
SELECT Usuario.id AS id_usuario, App_infos.id AS id_app, App_infos.nome, desenvolvedora, distribuidora FROM Usuario
INNER JOIN Compra ON Usuario.id = Compra.fk_Usuario_id
INNER JOIN Item_comprado ON Item_comprado.fk_Compra_id = Compra.id
LEFT JOIN Pacote ON Item_comprado.fk_Produto_id = Pacote.id
LEFT JOIN Composicao ON Composicao.fk_Pacote_id = Pacote.id
INNER JOIN App_infos ON Item_comprado.fk_Produto_id = App_infos.id or Composicao.fk_App_id = App_infos.id
ORDER BY App_infos.nome;


def infos_pacotes(id_pacote):
    #Informações de pacotes
    return f'''SELECT A.id AS pacote_id, A.nome AS pacote_nome, A.preco AS pacote_preco_sem_desconto, A.desconto AS pacote_desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS pacote_preco_com_desconto, A.data_fim_desconto AS pacote_data_fim_desconto, A.descricao AS pacote_descricao FROM Pacote
    INNER JOIN Produto AS A ON A.id = Pacote.id
    WHERE pacote_id = {id_pacote}'''

def infos_produtos(id_produto):
    #Informações de produtos
    return f'''SELECT A.id AS produto_id, A.nome AS produto_nome, A.preco AS produto_preco_sem_desconto, A.desconto AS produto_desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS produto_preco_com_desconto, A.data_fim_desconto AS produto_data_fim_desconto, A.descricao AS produto_descricao FROM Produto AS A
    WHERE produto_id = {id_produto}'''

def categorias_pacotes():
    #Categorias de um App
    return f'''SELECT App.id AS app_id, Produto.nome AS app_nome, Categoria.nome AS categoria FROM App
    INNER JOIN Categorizacao AS CAT ON APP.id = CAT.fk_App_id
    INNER JOIN Categoria ON Categoria.id = fk_Categoria_id
    INNER JOIN Produto ON Produto.id = App.id'''

def generos_app():
    #Generos de um App
    return f'''SELECT App.id AS app_id, Produto.nome AS app_nome, Genero.nome AS genero FROM App
    INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
    INNER JOIN Genero ON Genero.id = fk_Genero_id
    INNER JOIN Produto ON Produto.id = App.id'''

def generos_pacote():
    #Generos de um pacote
    return f'''SELECT DISTINCT Pacote.id, Produto.nome, Genero.nome FROM Pacote
    INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
    INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
    INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
    INNER JOIN Classificacao AS CLA ON APP.id = CLA.fk_App_id
    INNER JOIN Genero ON Genero.id = fk_Genero_id
    INNER JOIN Produto ON Produto.id = Pacote.id'''

def categorais_pacote():
    #Categorias de um pacote
    return f'''SELECT DISTINCT Pacote.id, Produto.nome, Categoria.nome FROM Pacote
    INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
    INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
    INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
    INNER JOIN Categorizacao AS CAT ON APP.id = CAT.fk_App_id
    INNER JOIN Categoria ON Categoria.id = fk_Categoria_id
    INNER JOIN Produto ON Produto.id = Pacote.id'''

def desenvolvedores_pacote():
        #Desenvolvedores de um pacote
    return f'''SELECT DISTINCT Pacote.id, Produto.nome, APP.desenvolvedora FROM Pacote
    INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
    INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
    INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
    INNER JOIN Produto ON Produto.id = Pacote.id'''

def distribuidoras_pacote():
    #Distribuidoras de um pacote
    return f'''SELECT DISTINCT Pacote.id, Produto.nome, APP.distribuidora FROM Pacote
    INNER JOIN Composicao AS Comp ON Pacote.id = Comp.fk_Pacote_id
    INNER JOIN Produto AS A ON A.id = Comp.fk_Pacote_id
    INNER JOIN App_infos AS APP ON APP.id = Comp.fk_App_id
    INNER JOIN Produto ON Produto.id = Pacote.id'''

def produtos_carrinho():
    #Produtos no carrinho
    return f'''SELECT Usuario.id, A.id AS produto_id, A.nome AS produto_nome, A.preco AS produto_preco_sem_desconto, A.desconto AS produto_desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS produto_preco_com_desconto, A.data_fim_desconto AS produto_data_fim_desconto, A.descricao AS produto_descricao FROM Produto AS A
    INNER JOIN Carrinho ON A.id = Carrinho.fk_Produto_id
    INNER JOIN Usuario ON Usuario.id = Carrinho.fk_Usuario_id'''

def compras_usuario():
    #Compras de um usuario
    return f'''SELECT usuario.id AS id, compra.aprovado AS status, compra.data AS data, compra.total AS total, item_comprado.valor_original AS preco_sem_desconto, item_comprado.desconto AS desconto, ROUND(CAST((100-item_comprado.desconto) AS NUMERIC(20,10))/100 * item_comprado.valor_original, 2) AS preco_com_desconto FROM usuario
    INNER JOIN Compra ON usuario.id = compra.fk_usuario_id
    INNER JOIN item_comprado ON Compra.id = item_comprado.fk_Compra_id
    INNER JOIN Produto ON Produto.id = fk_Produto_id'''

def num_apps_genero(nome_genero):
    # Numero de Apps de um determinado genero, no caso abaixo RPG
    return f'''SELECT COUNT(App_infos.id) AS Num_apps
    FROM Classificacao INNER JOIN App_infos ON App_infos.id = Classificacao.fk_App_id
    INNER JOIN Genero ON Genero.id = Classificacao.fk_Genero_id
    GROUP BY Genero.nome
    HAVING Genero.nome = '{nome_genero}' '''


class InvalidCommand(Exception):
    pass

class IncorrectNumberOfArgs(Exception):
    pass

class CommandError(Exception):
    pass

class Store:

    SYSTEM = 0

    def __init__(self):
        '''
        Construtor para a loja
        '''
        # system
        self.user = Store.SYSTEM

        # comandos do programa
        self.commands = {
            "change_user": self.change_user,
            "exit": self.exit,
            "get_user": self.get_user,
            "busca_nome": self.busca_nome,
        }

        with open('token.txt','r') as f:
            secret = f.readlines()[0]

        # postgres
        self.connection = pg2.connect(database='fbd',user='postgres', password=secret)



    def is_system(self):
        '''
        Verifica se o usuario atual é o sistema
        '''
        return self.user == Store.SYSTEM

    def shell(self):
        '''
        Shell interativo para a loja.
        '''
        while(True):
            string_input = input("$ ").strip()
            try:
                self.run_command(string_input)
            except InvalidCommand as e:
                print(e)
            except IncorrectNumberOfArgs as e:
                print(e)
            except CommandError as e:
                print(e)


    def run_command(self, string_input):
        '''
        Executa um comando no shell
        '''
        # verifica se a string não está vazia
        if not string_input:
            raise InvalidCommand("Comando invalido")

        # argumentos e comando
        list_input = string_input.split()
        command = self.commands.get(list_input[0].lower())
        args = list_input[1:]

        # verifica se o comando foi encontrado
        if not command:
            raise InvalidCommand("Comando invalido")
        command(args)

    def get_user(self, args):
        '''
        Mostra o usuario atual
        '''
        # testa se o numero de argumentos está correto
        if len(args) != 0:
            raise IncorrectNumberOfArgs("get_user não precisa de argumentos")
        # imprime o id
        if self.is_system():
            print("Usuario atual é SYSTEM")
        else:
            print(f"Usuario atual é {self.user}")


    def change_user(self, args):
        '''
        Troca de usuario
        '''
        # testa se o numero de argumentos está correto
        if len(args) != 1:
            raise IncorrectNumberOfArgs("change_user só precisa de 1 argumento")

        # usuario
        try:
            user = int(args[0])
        except ValueError:
            raise CommandError("id usado como argumento não era inteiro")
        

        # caso o usuario seja o sistema não é necessario buscar
        if user == Store.SYSTEM:
            self.user = user
        else:
            # busca os usuarios
            with self.connection.cursor() as cur:
                cur.execute('SELECT id FROM usuario')
                users = cur.fetchall()
            users = [i[0] for i in users]
            
            # verifica se o usuario está na base de dados
            if user in users:
                self.user = user
            else:
                raise CommandError("Usuario não está na base de dados")

    def exit(self, args):
        '''
        Sai do programa
        '''
        # testa se o numero de argumentos está correto
        if len(args) != 0:
            raise IncorrectNumberOfArgs("exit não precisa de argumentos")
        # sai do programa
        exit()

    def busca_nome(self, args):
        '''
        busca na loja pelo nome
        '''
        if len(args) != 1:
            raise IncorrectNumberOfArgs("busca_nome só precisa de 1 argumento")
        
        name = args[0][1:-1]
        command = f'''
            SELECT A.id AS id, A.nome AS nome, A.desconto AS desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS preco_com_desconto
            FROM Produto AS A
            WHERE A.nome ILIKE '{name}%'
        '''
        infos, colnames = self.get_columns(command)
        print(infos)
        print(tab.tabulate(infos,headers=colnames))

    def entra_pagina(self, args):
        if len(args) != 1:
            raise IncorrectNumberOfArgs("entra_pagina só precisa de 1 argumento")
        
        id = args[0]
        commandApp = f'''
                    SELECT * FROM App_views
                    WHERE id = {id}
                    '''
        commandPac = '''
                    SELECT A.id AS pacote_id, A.nome AS pacote_nome, A.preco AS pacote_preco_sem_desconto, A.desconto AS pacote_desconto, ROUND(CAST((100-A.desconto) AS NUMERIC(20,10))/100 * A.preco, 2) AS pacote_preco_com_desconto, A.data_fim_desconto AS pacote_data_fim_desconto, A.descricao AS pacote_descricao FROM Pacote
                    INNER JOIN Produto AS A ON A.id = Pacote.id
                    WHERE id = {id}
                    '''
        infosApp, colnamesApp = self.get_columns(commandApp)
        infosPac, colnamesPac = self.get_columns(commandPac)

        if infosApp:
            commandTags = f'''
            SELECT C.tag FROM App
            INNER JOIN Produto ON App.id = Produto.id 
            INNER JOIN LATERAL (
              SELECT tags.fk_app_id as id, Tags.tag as tag, count(tag) FROM Tags
              GROUP BY tags.fk_app_id, tags.tag
              HAVING tags.fk_app_id = app.id
              ORDER BY count(tag)
              LIMIT 4
            ) AS C ON App.id = C.id
            WHERE APP.id = {id}
            '''
            infosTags, colnamesTags = self.get_columns(commandTags)
        else:
            commandPrecoSeparadamente = '''
                SELECT Pacote.id, SUM(App_infos.preco_sem_desconto) AS preco_Pacote
                FROM App_infos INNER JOIN Composicao ON Composicao.fk_App_id = App_infos.id
                INNER JOIN Pacote ON Composicao.fk_Pacote_id = Pacote.id
                GROUP BY Pacote.id
                ORDER BY preco_Pacote DESC
                WHERE pacote.id = {id}
            '''   
            infosPrecoSeparadamente, colnamesPrecoSeparadamente = self.get_columns(commandPrecoSeparadamente)


        
        
    def get_columns(self, command):
        with self.connection.cursor() as cur:
            cur.execute(command)
            infos = cur.fetchall()
            colnames = [desc[0] for desc in cur.description]
        return infos, colnames
        
    

if __name__ == "__main__":
    store = Store()
    store.shell()