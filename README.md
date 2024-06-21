# Olist Data Analysis

  

## Objetivo

O objetivo macro desta análise é encontrar soluções para elevar ao máximo as operações deste e-commerce, criando planos de ação para cada ponto de melhoria encontrado.

  

A análise será dividida em:

* Análise Exploratória dos Dados.

* Análise Estatística.

* Criação do Dashboard de Acompanhamento da Operação.

* Perguntas de Negócio.

* Planos de Ação.

  

## Base de Dados Utilizada

  

O DataSet Olist é uma representação de uma série de E-Commerces brasileiros com dados de 100 mil pedidos entre os anos de 2016-2018 e nele existem tabelas com dados dos clientes, pagamentos, avaliações de compras, produtos e suas categorias, vendedores, entre outras informações.

  

A motivação na escolha do DataSet Olist foi devido a sua familiaridade com bases de dados utilizadas no dia a dia da maioria das empresas, com relacionamento entre tabelas, chaves primarias e secundárias, entre outras similaridades.

  

DataSet Olist no Kaggle:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

  

Repoositório de Arquivos Utilizados (Arquivos Excel, CSV, SQL(cópias) e Power BI):

https://drive.google.com/drive/u/0/folders/1RxUEyY75qlQwejZxF--9Y24GLZ_8tx9N

  

## Ferramentas

  

Sobre as ferramentas, foram utilizadas as seguintes:

  

* DBeaver - Utilizando SQL para realizar as análises iniciais das tabelas, realizar tratamento nos dados, e extrair alguns insights iniciais.

(Foi utilizado um arquivo compilado em formato SQlite da Base Olist.)

  

Link para download: https://dbeaver.io/download/

  

* Excel - Para realizar análises de medidas de tendência e dispersão dos dados, identificação de outliers, incluindo gráficos e tabelas dinâmicas.

  

Link para compra: https://www.microsoft.com/pt-br/microsoft-365/excel

  

* Power BI - Como ferramenta de dataviz, onde será criada uma visualização, utilizando o Power Query como ferramenta de Limpeza e Tratamento, e criação do dashboard de acompanhamento da operação.

(A etapa de limpeza e tratamento poderia e até deveria ser realizada no DBeaver ou em outro SGBD(Sistema Gerenciador de Banco de Dados) devido ao seu melhor processamento, mas neste caso vamos utilizar o Power Query como forma alternativa)

  

Link para download: https://www.microsoft.com/pt-br/power-platform/products/power-bi

  

## Instruções:

  

### Arquivo SQL

  

No arquivo SQL(.sql), cada Query conterá acima dela uma linha com o propósito e abaixo uma ou mais linhas com um breve resumo do porquê das escolhas dos comandos e funções.

  

### Arquivo Excel

  

No arquivo Excel (.xlsx), haverá uma planilha chamada "Análises" com as cópias das tabelas dinâmicas, gráficos, motivações e respostas obtidas.

  

### Arquivo Power BI

  

No arquivo Power BI (.pbix), cada medida e coluna calculada criada conterá no comentário uma breve explicação sobre o porquê das escolhas na utilização dos comandos e funções.

No Repositório de Arquivos Utilizados, haverá um README com as limpezas realizadas no Power Query do Power BI.

  

## Análise Exploratória dos Dados

  

### Análise da Tabela olist_orders_dataset (Pedidos)

  

* Segundo as analises de integridade realizadas, cada linha da tabela representa um id de identificação único da compra do cliente. Portanto existem 99.441 registros de pedidos e 99.441 clientes.

  

 * Quanto ao status de cada compra, foram encontradas 8 categorias distintas, sendo elas:
	  - "delivered" = entregue;
      -  "shipped" = enviado;
      -  "canceled" = cancelado;
      -  "unavailable" = indisponível;
      -  "invoiced" = faturado;
      -  "processing" = em processamento;
      -  "created" = criado;
      -  "approved" = aprovado;

	Os pedidos entregues representam a 		maioria com 97,02%, seguido pelos  		enviados com 1,11%, cancelados com 0,6%, indisponíveis com 0,6%, em processamento com 0,3%, criados com 0,01% e aprovados com 0,001%.

* Com relação ao preenchimento dos dados, a tabela de data de aprovação possui 160 valores vazios e a tabela de data de entrega do pedido na transportadora possui 1.783 valores vazios.

	Estes valores podem representar problemas

### Análise da Tabela olist_order_payments_dataset (Pagamentos dos Pedidos)

  
  
  

### Análise da Tabela olist_products_dataset (Produtos)

  
  
  

### Análise da Tabela olist_customers_dataset (Clientes)

  
  
  

### Análise da Tabela olist_order_reviews_dataset (Avaliações dos Pedidos)

  
  
  

### Análise da Tabela olist_order_items_dataset (Itens dos Pedidos)

  
  

## Análise Estatística

  
  

## Criação do Dashboard de Acompanhamento da Operação

  
  

## Perguntas de Negócio

  
  

## Planos de Ação