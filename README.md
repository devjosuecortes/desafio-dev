# Desafio Dev - ByCoders\_

Este projeto foi desenvolvido como parte do desafio de código proposto pela ByCoders\_. Ele permite a importação de transações financeiras a partir de arquivos enviados pelo usuário.

## 📌 Repositório Original

O projeto foi forkeado do repositório original:
[ByCodersTec/desafio-dev](https://github.com/ByCodersTec/desafio-dev)

## 🚀 Tecnologias Utilizadas

- **Ruby** 3.4.2
- **Rails** 8.0.2
- **PostgreSQL** como banco de dados
- **Docker e Docker Compose** (opcional)
- **Swagger** para documentação da API

## 📦 Configuração do Projeto

O projeto pode ser executado de duas formas:

### 🔹 Método 1: Configuração Manual

1. Clone o repositório:
   ```sh
   git clone git@github.com:devjosuecortes/desafio-dev.git
   cd desafio-dev
   ```
2. Instale as dependências do Rails:
   ```sh
   bundle install
   ```
3. Configure o banco de dados:
   ```sh
   rails db:create
   rails db:migrate
   ```
4. Inicie o servidor:
   ```sh
   rails server
   ```
5. Acesse o projeto no navegador: [http://localhost:3000](http://localhost:3000)
6. Crie uma conta (email e senha)
7. Após o login, você será redirecionado para o **Dashboard**
8. Clique na aba **Transactions**
9. Selecione um arquivo e importe-o.

---

### 🔹 Método 2: Utilizando Docker

1. Certifique-se de ter **Docker** e **Docker Compose** instalados.
2. Clone o repositório e entre na pasta do projeto:
   ```sh
   git clone git@github.com:devjosuecortes/desafio-dev.git
   cd desafio-dev
   ```
3. Construa a aplicação sem cache:
   ```sh
   docker compose build --no-cache
   ```
4. Suba os containers:
   ```sh
   docker compose up -d
   ```
5. Configure o banco de dados:
   ```sh
   docker compose exec app bin/rails db:setup
   ```
6. Acesse a aplicação normalmente em [http://localhost:3000](http://localhost:3000)
7. Para parar os containers:
   ```sh
   docker compose down
   ```

---

## 🔧 Melhorias Futuras

- Exibir apenas os arquivos importados recentemente, sem duplicação.
- Criar uma API para cadastro de usuários, login e envio de arquivos.
- Melhorar a documentação da API com Swagger (já instalado).

---

## 📜 Licença

Este projeto segue a licença do repositório original da ByCoders\_.

---

## ✉️ Contato

Caso tenha dúvidas ou sugestões, sinta-se à vontade para abrir uma issue ou contribuir com o projeto.

---

> Desenvolvido para o desafio ByCoders\_ 🚀
