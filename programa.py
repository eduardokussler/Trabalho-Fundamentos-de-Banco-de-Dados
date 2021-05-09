import psycopg2 as pg2

class InvalidCommand(Exception):
    pass

class IncorretNumberOfArgs(Exception):
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
        self.user = 0

        # comandos do programa
        self.commands = {
            "change_user": self.change_user,
            "exit": self.exit,
            "get_user": self.get_user,
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
            except IncorretNumberOfArgs as e:
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
            raise IncorretNumberOfArgs("get_user não precisa de argumentos")
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
            raise IncorretNumberOfArgs("change_user só precisa de 1 argumento")

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
            raise IncorretNumberOfArgs("exit não precisa de argumentos")
        # sai do programa
        exit()
    

if __name__ == "__main__":
    store = Store()
    store.shell()