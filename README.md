# Olist Data Analysis

  

## Objetivo

O objetivo macro desta análise é encontrar soluções para elevar ao máximo as operações deste e-commerce, respondendo perguntas de negócio e criando planos de ação para cada ponto de melhoria encontrado.


A análise será dividida em:

* Análise Exploratória dos Dados.

* Análise Estatística Descritiva.

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

* A tabela de pedidos possui 8 colunas:
      - order_id = identificador do pedido;
      - customer_id = identificador do cliente;
      - order_status = status da compra;
      - order_purchase_timestamp = data e hora da compra;
      - order_approved_at = data e hora da aprovação da compra;
      - order_delivered_carrier_date = data e hora da entrega do pedido na transportadora;
      - order_delivered_customer_date = data e hora da entrega do pedido ao cliente;
      - order_estimated_delivered_date = data estimada da entrega di pedido ao cliente.

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

	Os pedidos entregues representam a maioria com 97,02%, seguido pelos enviados com 1,11%, cancelados com 0,6%, indisponíveis com 0,6%, em processamento com 0,3%, criados com 0,01% e aprovados com 0,001%.

* Com relação ao preenchimento dos dados, as colunas de data de aprovação, data de entrega do pedido na transportadora e data de entrega ao cliente possuem 160, 1.783 e 2.965 valores vazios respectivamente.

	Dos 160 pedidos com a data de aprovação vazia, 141 foram cancelados, 14 foram entregues e 5 foram apenas criados. Os pedidos cancelados não deveriam ter a data de aprovação apenas caso o cancelamento fosse cancelado antes da aprovação e os pedidos entregues deveriam ter a data de aprovação, pois faz parte do processo completo da venda.

      Dos 1.783 pedidos com a data de entrega do pedido na transportadora vazias, 609 estão com status indisponíveis, 550 estão cancelados, 314 estão faturados, 301 estão em processamento, 5 estão criados, 2 foram entregue e 2 foram aprovados. Apenas os pedidos criados, aprovados, faturados, em processamento e cancelados antes do envio poderiam ter a data de entrega na transportadora vazia. 

      Dos 2.965 pedidos com a data de entrega ao cliente vazias, 1107 estão com status enviado, 619 cancelados, 609 indisponíveis, 314 faturados, 301 em processamento, 8 entregues, 5 criados e 2 aprovados. Como a data de entrega é um dos últimos estágios do processo de venda, apenas pedidos com o estágio anterior a entregue poderiam ter essa data vazia.

* Sobre as datas das priemiras e últimas vendas entregues realizadas:

      A primeira venda efetivamente entregue foi realizada em 15-09-2016 e a última venda foi realizada em 29-08-2018.
	

### Análise da Tabela olist_order_payments_dataset (Pagamentos dos Pedidos)

* A tabela de pagamentos possui 5 colunas:
      - order_id = identificador do pedido;
      - payment_sequential = sequência de pagamentos;
      - payment_type = forma de pagamento;
      - payment_installmentes = parcelamento;
      - payment_value = valor dos pagamentos.
  
* A tabela de pagamentos possui 103.886 linhas de registro com 99.440 identificadores dos pedidos únicos, ou seja, existem linhas com o mesmo identificador do pedido. A partir desta análise, foram encontrados os pedidos repetições, onde alguns pedidos possuiam 29 linhas com o mesmo identificador do pedido. Alguns possuíam a mesma forma de pagamento, outros formas diferentes.

* Entre as formas de pagamento, foram encontradas 8 categorias, sendo elas:
      - credit_card = cartão de crédito;
      - boleto = boleto;
      - voucher = voucher;
      - debit_card = cartão de débito;
      - not_defined = não definido.

      A forma de pagamento via cartão de crédito é a mais utilizada, representando 76.795 (73,92%) compras, seguido por boleto com 19.784 (19,04%), voucher com 5.775 (5,56%) e cartão de débito com 1.529 (1,47%). A forma de pagamento não definida teve apenas 3 registros.

* Analisando os parcelamentos, a quantidade de parcelamento mais utilizada é 1x, com 52.546 (50,58%) pedidos realizados, seguido por 2x com 12.413 (11,95%), 3x com 10.461 (10,07%) e 10x com 5.328 (5,13%).

* Sobre o faturamento dos pedidos, o pedido com o maior valor teve um faturamento de R$13.664,08 e os menores foram 3 pedidos com faturamento R$0. As compras com faturamento R$0 tem as formas de pagamento como vouchers ou não definidas. A média de pagamentos geral é de R$154,10, com mediana de R$100 e desvio padrão de R$217,49.

* Já sobre o faturamento por forma de pagamento, cartão de crédito está na primeira posição com R$12.542.084,19 (78,34%), seguido por boleto com R$2.869.361,27 (17,92%), voucher com R$379.436,87 (2,37%) e cartão de débito com R$217.989,79 (1,36%). A forma de pagamento não definida não teve faturamento. 

* Dados estatísticos de acordo com a forma de pagamento:
      - Boleto:
            Valor máximo: R$7.274,88
            Valor mínimo: R$11,62
            Amplitude: R$7.263,26
            Média: R$145,03
            Mediana: R$93,89
            Desvio Padrão: R$213,58
      
      - Cartão de Crédito:
            Valor máximo: R$13.664,08
            Valor mínimo: R$0,01
            Amplitude: R$13.664,07
            Média: R$163,32
            Mediana: R$106,87
            Desvio Padrão: R$222,12

      - Cartão de Débito:
            Valor máximo: R$4.445,50
            Valor mínimo: R$13,38
            Amplitude: R$4.432,12
            Média: R$142,57
            Mediana: R$89,30
            Desvio Padrão: R$245,79

      - Voucher:
            Valor máximo: R$3.184,34
            Valor mínimo: R$0
            Amplitude: R$3.184,34
            Média: R$65,70
            Mediana: R$39,28
            Desvio Padrão: R$115,52

### Análise da Tabela olist_products_dataset (Produtos)

  

  

### Análise da Tabela olist_customers_dataset (Clientes)

  
  
  

### Análise da Tabela olist_order_reviews_dataset (Avaliações dos Pedidos)

  
  
  

### Análise da Tabela olist_order_items_dataset (Itens dos Pedidos)

  
  

## Análise Estatística Descritiva

  
  

## Criação do Dashboard de Acompanhamento da Operação

  
  

## Perguntas de Negócio

  
  

## Planos de Ação