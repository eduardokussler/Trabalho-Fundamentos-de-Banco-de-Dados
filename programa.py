import psycopg2 as pg2
import tabulate as tab


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
            "busca_app_genero": self.busca_app_genero,
            "busca_app_categoria": self.busca_app_categoria,
            "busca_app_distribuidora": self.busca_app_distribuidora,
            "busca_app_desenvolvedora": self.busca_app_desenvolvedora,
            "busca_pacote_distribuidora": self.busca_pacote_distribuidora,
            "busca_pacote_desenvolvedora": self.busca_pacote_desenvolvedora,
            "busca_pacote_genero": self.busca_pacote_genero,
            "busca_pacote_categoria": self.busca_pacote_categoria,
            "abrir_pagina": self.abrir_pagina,
            "carrinho": self.carrinho,
            "meus_apps": self.meus_apps,
            "minhas_compras": self.minhas_compras,
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
    
    def get_columns(self, command):
        with self.connection.cursor() as cur:
            cur.execute(command)
            infos = cur.fetchall()
            colnames = [desc[0] for desc in cur.description]
        return infos, colnames

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
        args = " ".join(args)
        args = args.split("""'""")
        args = [i.replace("'","") for i in args]
        args = [i for i in args if i != ' ' and i != '']

        # verifica se o comando foi encontrado
        if not command:
            raise InvalidCommand("Comando invalido")
        command(args)

    def exit(self, args):
        '''
        Sai do programa
        '''
        # testa se o numero de argumentos está correto
        if len(args) != 0:
            raise IncorrectNumberOfArgs("exit não precisa de argumentos")
        # sai do programa
        exit()

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

    def carrinho(self, args):
        if len(args) != 0:
            raise IncorrectNumberOfArgs("carrinho não precisa de argumentos")
        if self.is_system():
            raise CommandError("Sistema não possui carrinho")
        inputQuery = self.user
        busca_carrinho_pacote_apps = f'''SELECT * FROM busca_carrinho_pacote_apps({inputQuery}) '''
        busca_carrinho_produtos =  f'''SELECT * FROM busca_carrinho_produtos({inputQuery}) '''
        busca_carrinho_produtos_preco = f'''SELECT * FROM busca_carrinho_produtos_preco({inputQuery}) '''

        infosPA, headersPA = self.get_columns(busca_carrinho_pacote_apps) 
        infosP,  headersP = self.get_columns(busca_carrinho_produtos)
        infosPP, headersPP = self.get_columns(busca_carrinho_produtos_preco)

        idsProds = [i[0] for i in infosP]
        nomes_apps_com_id_prods = [(i[0],i[1]) for i in infosPA]

        print("Produtos no carrinho")
        for i in range(len(infosP)):
            print(tab.tabulate([infosP[i]],headers=headersP))
            prods_nesse_pacote = [j[1] for j in nomes_apps_com_id_prods if j[0] == infosP[i][0]]
            if (len(prods_nesse_pacote) != 0):
                print("Produtos nesse pacote: ", end = '')        
                print(", ".join(prods_nesse_pacote))
        preco = infosPP[0][0]
        print(f"\nPreço total: {preco}")

    def minhas_compras(self, args):
        if len(args) != 0:
            raise IncorrectNumberOfArgs("minhas_compras não precisa de argumentos")
        if self.is_system():
            raise CommandError("Sistema não possui compras")
        inputQuery = self.user
        busca_usuario_itens_comprados = f'''SELECT * FROM busca_usuario_itens_comprados({inputQuery}) '''
        busca_usuario_compras =  f'''SELECT * FROM busca_usuario_compras({inputQuery}) '''

        infosIC, headersIC = self.get_columns(busca_usuario_itens_comprados) 
        infosC,  headersC = self.get_columns(busca_usuario_compras)


        id_compras = [i[0] for i in infosC]
    
        infos_itens_comprados = [[i[0],(i[1],i[2],i[3],i[4])] for i in infosIC]
        print("Minhas Compras: ")
        for i in range(len(infosC)):

            print(f"{headersC[0].upper()}:{infosC[i][0]} ")
            print(f"{headersC[1]}:{infosC[i][1]} ")
            print(f"{headersC[2]}:{infosC[i][2]} ")
            print(f"{headersC[3]}:{infosC[i][3]} ")
            print(f"{headersC[4]}:{infosC[i][4]} ")
            print()
            prods_nessa_compra = [j[1] for j in infos_itens_comprados if j[0] == infosC[i][0]]
            print("Produtos nessa Compra: ")        
            print(tab.tabulate(prods_nessa_compra,headers=headersIC[1:]))

            print()


    def meus_apps(self, args):
        if len(args) != 0:
            raise IncorrectNumberOfArgs("meus_apps não precisa de argumentos")
        if self.is_system():
            raise CommandError("Sistema não possui apps")
        inputQuery = self.user
        busca_usuario_apps = f'''SELECT * FROM busca_usuario_apps({inputQuery}) '''

        infosA, headersA = self.get_columns(busca_usuario_apps) 
        print(tab.tabulate(infosA,headers=headersA))

    def busca_nome(self, args):
        '''
        busca na loja pelo nome
        '''
        if len(args) != 1:
            raise IncorrectNumberOfArgs("busca_nome só precisa de 1 argumento")
        
        name = args[0]
        command = f'''SELECT * FROM busca_nome('{name}') '''
        infos, colnames = self.get_columns(command)
        print(tab.tabulate(infos,headers=colnames))

    def busca_app_genero(self, args):
        if len(args) != 1 and len(args) != 2:
            raise IncorrectNumberOfArgs("busca_app_genero só precisa de 2 ou 1 argumentos")

        if len(args) == 1:
            genero = args[0]
            print(genero)
            command = f'''SELECT * FROM busca_app_genero('{genero}') '''
            print(command)
            infos, colnames = self.get_columns(command)
            print(infos)
            print(tab.tabulate(infos,headers=colnames))

        if len(args) == 2:
            command = f'''SELECT * FROM busca_app_2generos('{args[0]}', '{args[1]}') '''
            print(command)
            infos, colnames = self.get_columns(command)
            print(infos)
            print(tab.tabulate(infos,headers=colnames))

    def busca_app_categoria(self, args):
        if len(args) != 1 and len(args) != 2:
            raise IncorrectNumberOfArgs("busca_app_categoria só precisa de 2 ou 1 argumentos")

        if len(args) == 1:
            categoria = args[0]
            print(categoria)
            command = f'''SELECT * FROM busca_app_categoria('{categoria}') '''
            print(command)
            infos, colnames = self.get_columns(command)
            print(infos)
            print(tab.tabulate(infos,headers=colnames))

        if len(args) == 2:
            command = f'''SELECT * FROM busca_app_2categorias('{args[0]}', '{args[1]}') '''
            print(command)
            infos, colnames = self.get_columns(command)
            print(infos)
            print(tab.tabulate(infos,headers=colnames))

    def busca_app_desenvolvedora(self, args):
        if len(args) != 1:
            raise IncorrectNumberOfArgs("busca_app_desenvolvedora só precisa de 1 argumento")

        inputQuery = args[0]
        command = f'''SELECT * FROM busca_app_desenvolvedora('{inputQuery}') '''
        print(command)
        infos, colnames = self.get_columns(command)
        print(infos)
        print(tab.tabulate(infos,headers=colnames))

    def busca_app_distribuidora(self, args):
        if len(args) != 1:
            raise IncorrectNumberOfArgs("busca_app_distribuidora só precisa de 1 argumento")

        inputQuery = args[0]
        command = f'''SELECT * FROM busca_app_distribuidora('{inputQuery}') '''
        print(command)
        infos, colnames = self.get_columns(command)
        print(infos)
        print(tab.tabulate(infos,headers=colnames))
        
    def busca_pacote_desenvolvedora(self, args):
        if len(args) != 1:
            raise IncorrectNumberOfArgs("busca_pacote_desenvolvedora só precisa de 1 argumento")

        inputQuery = args[0]
        command = f'''SELECT * FROM busca_pacote_desenvolvedora('{inputQuery}') '''
        print(command)
        infos, colnames = self.get_columns(command)
        print(infos)
        print(tab.tabulate(infos,headers=colnames))

    def busca_pacote_distribuidora(self, args):
        if len(args) != 1:
            raise IncorrectNumberOfArgs("busca_pacote_distribuidora só precisa de 1 argumento")

        inputQuery = args[0]
        command = f'''SELECT * FROM busca_pacote_distribuidora('{inputQuery}') '''
        print(command)
        infos, colnames = self.get_columns(command)
        print(infos)
        print(tab.tabulate(infos,headers=colnames))

    def busca_pacote_genero(self, args):
        if len(args) != 1:
            raise IncorrectNumberOfArgs("busca_pacote_genero só precisa de 1 argumento")

        inputQuery = args[0]
        command = f'''SELECT * FROM busca_pacote_genero('{inputQuery}') '''
        print(command)
        infos, colnames = self.get_columns(command)
        print(infos)
        print(tab.tabulate(infos,headers=colnames))

    def busca_pacote_categoria(self, args):
        if len(args) != 1:
            raise IncorrectNumberOfArgs("busca_pacote_categoria só precisa de 1 argumento")

        inputQuery = args[0]
        command = f'''SELECT * FROM busca_pacote_categoria('{inputQuery}') '''
        print(command)
        infos, colnames = self.get_columns(command)
        print(infos)
        print(tab.tabulate(infos,headers=colnames))

    def abrir_pagina(self, args):
        if len(args) != 1:
            raise IncorrectNumberOfArgs("busca_pacote_categoria só precisa de 1 argumento")

        inputQuery = args[0]
        tab_jogos, lixo = self.get_columns(f'SELECT * FROM Jogo WHERE id = {inputQuery}')
        tab_dlc, lixo = self.get_columns(f'SELECT * FROM dlc WHERE id = {inputQuery}')
        if(len(tab_jogos) != 0):
            self.abrir_jogo(inputQuery)
        elif(len(tab_dlc) != 0):
            self.abrir_dlc(inputQuery)
        else:
            self.abrir_pacote(inputQuery)


    def abrir_dlc(self,inputQuery):
        pagina_app_app_infos = f'''SELECT * FROM pagina_app_app_info({inputQuery}) '''
        pagina_app_mesmos_generos =  f'''SELECT * FROM pagina_app_mesmos_generos({inputQuery}) '''
        pagina_app_tags = f'''SELECT * FROM pagina_app_tags({inputQuery}) '''

        infosA, informacoes = self.get_columns(pagina_app_app_infos) 
        infosAS,  apps_similares = self.get_columns(pagina_app_mesmos_generos)
        infosT,  tags = self.get_columns(pagina_app_tags)
        infosT = ", ".join([i[0] for i in infosT])
        descricao = infosA[0][-1]
        infosA = [infosA[0][:-1]]
        informacoes = informacoes[:-1]

        print("Informações da DLC")
        print(tab.tabulate(infosA,headers=informacoes))
        print(f"Descricao: {descricao}")
        print(f"Tags: {infosT}")
        print("\nInformações dos Apps Similares")
        print(tab.tabulate(infosAS,headers=apps_similares))

    def abrir_jogo(self,inputQuery):
        pagina_app_app_infos = f'''SELECT * FROM pagina_app_app_info({inputQuery}) '''
        pagina_jogo_expansoes =  f'''SELECT * FROM pagina_jogo_expansoes({inputQuery}) '''
        pagina_app_mesmos_generos =  f'''SELECT * FROM pagina_app_mesmos_generos({inputQuery}) '''
        pagina_app_tags = f'''SELECT * FROM pagina_app_tags({inputQuery}) '''

        infosA, informacoes = self.get_columns(pagina_app_app_infos) 
        infosE,  expansoes = self.get_columns(pagina_jogo_expansoes)
        infosAS,  apps_similares = self.get_columns(pagina_app_mesmos_generos)
        infosT,  tags = self.get_columns(pagina_app_tags)
        infosT = ", ".join([i[0] for i in infosT])
        descricao = infosA[0][-1]
        infosA = [infosA[0][:-1]]
        informacoes = informacoes[:-1]

        print("Informações do Jogo")
        print(tab.tabulate(infosA,headers=informacoes))
        print(f"Descricao: {descricao}")
        print(f"Tags: {infosT}")
        print("\nInformações das Expansões")
        print(tab.tabulate(infosE,headers=expansoes))
        print("\nInformações dos Apps Similares")
        print(tab.tabulate(infosAS,headers=apps_similares))

           
    def abrir_pacote(self, inputQuery):
        busca_pacote_info = f'''SELECT * FROM busca_pacote_info({inputQuery}) '''
        busca_pacote_apps =  f'''SELECT * FROM busca_pacote_apps({inputQuery}) '''
        busca_pacote_preco_separado =  f'''SELECT * FROM busca_pacote_preco_separado({inputQuery}) '''''

        infosI, informacoes = self.get_columns(busca_pacote_info) 
        infosA,  apps= self.get_columns(busca_pacote_apps)
        infosPS,  preco_separado = self.get_columns(busca_pacote_preco_separado)


        descricao = infosI[0][-1]
        infosI = [infosI[0][:-1]]
        informacoes = informacoes[:-1]

        print("Informações do Pacote")
        print(tab.tabulate(infosI,headers=informacoes))
        print(f"Descricao: {descricao}")
        print()
        print("\nInformações dos Apps do Pacote")
        print(tab.tabulate(infosA,headers=apps))
        #print(infosPS)
        print()
        print(f"O quanto economiza comprando o Pacote: {infosPS[0][1]}")
        print(f"Preço se os Apps fossem comprados separadamente: {infosPS[0][2]}")
        
    

if __name__ == "__main__":
    store = Store()
    store.shell()