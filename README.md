# Olist Data Analysis

  

  

## Objetivo

  

O objetivo macro desta análise é encontrar soluções para elevar ao máximo as operações deste e-commerce, respondendo perguntas de negócio e criando planos de ação para cada ponto de melhoria encontrado.

  
  

A análise será dividida em:

  

* Análise Exploratória dos Dados.

  

* Criação do Dashboard de Acompanhamento da Operação.

  

* Perguntas de Negócio.

  

* Planos de Ação.

  

  

## Base de Dados Utilizada

  

  

O DataSet Olist é uma representação de um E-Commerce com dados de 100 mil pedidos entre os anos de 2016-2018 fornecidos pela OLIST e nele existem tabelas com dados dos clientes, pagamentos, avaliações de compras, produtos e suas categorias, vendedores, entre outras informações.

  

  

A motivação na escolha do DataSet foi devido a sua familiaridade com bases de dados utilizadas no dia a dia de empresas, com relacionamento entre tabelas, chaves primarias e secundárias, entre outras similaridades.

  

  

DataSet Olist no Kaggle:

  

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

  

  

Repoositório de Arquivos Utilizados (Arquivos Excel, SQL e Power BI):

  

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

  

  

No arquivo Excel (.xlsx), haverá todas as tabelas do dataset, haverá uma planilha chamada "Análises" com analises realizadas nas tabelas dinâmicas, e uma planilha chamada "Gráficos" com os gráficos criados através do DataSet ou das tabelas dinâmicas.

  

  

### Arquivo Power BI

  

  

No arquivo Power BI (.pbix), cada medida e coluna calculada criada conterá no comentário uma breve explicação sobre o porquê das escolhas na utilização dos comandos e funções.

  

No Repositório de Arquivos Utilizados, haverá um README com as limpezas realizadas no Power Query do Power BI.

  

  

## Análise Exploratória dos Dados

  

  

### Análise da Tabela olist_orders_dataset (Pedidos)

  
A tabela de pedidos possui 8 colunas:

- order_id = identificador do pedido;

- customer_id = identificador do cliente;

- order_status = status da compra;

- order_purchase_timestamp = data e hora da compra;

- order_approved_at = data e hora da aprovação da compra;

- order_delivered_carrier_date = data e hora da entrega do pedido na transportadora;

- order_delivered_customer_date = data e hora da entrega do pedido ao cliente;

- order_estimated_delivered_date = data estimada da entrega di pedido ao cliente.

  

* Segundo as analises de integridade realizadas, cada linha da tabela representa um id de identificação único da compra do cliente. Portanto existem 99.441 registros de pedidos e 99.441 clientes.

  

Quanto ao status de cada compra, foram encontradas 8 categorias distintas, sendo elas:

- "delivered" = entregue;

- "shipped" = enviado;

- "canceled" = cancelado;

- "unavailable" = indisponível;

- "invoiced" = faturado;

- "processing" = em processamento;

- "created" = criado;

- "approved" = aprovado;

  

Os pedidos entregues representam a maioria com 97,02%, seguido pelos enviados com 1,11%, cancelados com 0,6%, indisponíveis com 0,6%, em processamento com 0,3%, criados com 0,01% e aprovados com 0,001%.

![Gráfico da Frequência Relativa](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/order_status.PNG)

Com relação ao preenchimento dos dados, as colunas de data de aprovação, data de entrega do pedido na transportadora e data de entrega ao cliente possuem 160, 1.783 e 2.965 valores vazios respectivamente.

  

Dos 160 pedidos com a data de aprovação vazia, 141 foram cancelados, 14 foram entregues e 5 foram apenas criados. Os pedidos cancelados não deveriam ter a data de aprovação apenas caso o cancelamento fosse cancelado antes da aprovação e os pedidos entregues deveriam ter a data de aprovação, pois faz parte do processo completo da venda.

  

Dos 1.783 pedidos com a data de entrega do pedido na transportadora vazias, 609 estão com status indisponíveis, 550 estão cancelados, 314 estão faturados, 301 estão em processamento, 5 estão criados, 2 foram entregue e 2 foram aprovados. Apenas os pedidos criados, aprovados, faturados, em processamento e cancelados antes do envio poderiam ter a data de entrega na transportadora vazia.

  

Dos 2.965 pedidos com a data de entrega ao cliente vazias, 1107 estão com status enviado, 619 cancelados, 609 indisponíveis, 314 faturados, 301 em processamento, 8 entregues, 5 criados e 2 aprovados. Como a data de entrega é um dos últimos estágios do processo de venda, apenas pedidos com o estágio anterior a entregue poderiam ter essa data vazia.
  

Sobre as datas das primeiras e últimas vendas entregues realizadas:

  
* A primeira venda efetivamente entregue foi realizada em 15-09-2016 e a última venda foi realizada em 29-08-2018.


Contando que a última venda entregue realizada foi no final de agosto de 2018, qualquer produto com data de entrega prevista para junho ou data anterior está com um tempo de atraso extremamente alto.
Analisando estão os pedidos com o status "enviado" e com data de entrega prevista entre 1 de janeiro de 2016 e 30 de junho de 2018, foram encontrados 962 pedidos não entregues.


  

### Análise da Tabela olist_order_payments_dataset (Pagamentos dos Pedidos)

  

A tabela de pagamentos possui 5 colunas:

- order_id = identificador do pedido;

- payment_sequential = métodos de pagamentos;

- payment_type = forma de pagamento;

- payment_installments = parcelamento;

- payment_value = valor dos pagamentos.

A tabela de pagamentos possui 103.886 linhas de registro com 99.440 identificadores dos pedidos únicos, ou seja, existem linhas com o mesmo identificador do pedido. A partir desta análise, foram encontrados os pedidos repetições, onde alguns pedidos possuiam 29 linhas com o mesmo identificador do pedido. Alguns possuíam a mesma forma de pagamento, outros formas diferentes.

A coluna métodos de pagamentos retorna a quantidade de formas de pagamentos utilizadas para o pagamento de um pedido. 95,64% (99.360) pedidos foram realizados utilizando apenas uma forma de pagamento.

Entre as formas de pagamento, foram encontradas 8 categorias, sendo elas:

- credit_card = cartão de crédito;

- boleto = boleto;

- voucher = voucher;

- debit_card = cartão de débito;

- not_defined = não definido.

  

A forma de pagamento via cartão de crédito é a mais utilizada, representando 76.795 compras (73,92%), seguido por boleto com 19.784 (19,04%), voucher com 5.775 (5,56%) e cartão de débito com 1.529 (1,47%). A forma de pagamento não definida teve apenas 3 registros.

  

Analisando os parcelamentos, a quantidade de parcelamento mais utilizada é 1x, com 52.546 (50,58%) pedidos realizados, seguido por 2x com 12.413 (11,95%), 3x com 10.461 (10,07%) e 10x com 5.328 (5,13%).

  

Sobre o faturamento dos pedidos, o pedido com o maior valor teve um faturamento de R$13.664,08 e os menores foram 3 pedidos com faturamento R$0. As compras com faturamento R$0 tem as formas de pagamento como vouchers ou não definidas.

  

Já sobre o faturamento por forma de pagamento, cartão de crédito está na primeira posição com R$12.542.084,19 (78,34%), seguido por boleto com R$2.869.361,27 (17,92%), voucher com R$379.436,87 (2,37%) e cartão de débito com R$217.989,79 (1,36%). A forma de pagamento não definida não teve faturamento.

As medidas de dispersão e de tendência central da coluna com os pagamentos (payment_values) apresentaram os seguintes valores:
- Contagem Pagamentos: 103.886
- Valor Máximo: R$13.663,08
- Valor Mínimo: R$ 0
- Amplitude: R$ 13.664,08
- Média: R$154,10
- Mediana: R$ 100,00
- Desvio-Padrão: R$217,49



### Análise da Tabela olist_products_dataset (Produtos)

A tabela de produtos possui 9 colunas:
- product_id = identificador do produto;
- product_category_name = nome da categoria do produto;
- product_name_lenght = comprimento do nome do produto;
- product_description_lenght =  comprimento da descrição do produto;
- product_weight_g = peso do produto em gramas;
- product_lenght_cm = comprimento do produto em centímetros;
- product_height_cm = altura do produto em centímetros;
- product_width_cm = largura do produto em centímetros.

A tabela possui 32.951 linhas, sendo 32951 identificadores dos pedidos, ou seja, cada linha representa um único produto. Já sobre as categorias, existem 74 categorias distintas.

Cama, mesa e banho é a categoria com a maior quantidade de produtos, sendo o top 10 formados por:
- cama mesa e banho = 3.029;
- esportes e lazer = 2.867;
- moveis e decoração = 2.657;
- saúde e beleza = 2.444
- utilidades domésticas = 2.335;
- automotivo = 1.900;
- informática e acessórios = 1.639;
- brinquedos = 1.411;
- relógios e presentes = 1.329;
- telefonia = 1.134.

Existem 610 produtos com categoria em branco, sendo 1 dele sem nenhuma informação cadastrada (exceto pelo product_id).
Há um cadastro da categoria bebes, que não possui peso, comprimento, altura ou largura.

O produto mais pesado é da categoria cama, mesa e banho com 40.425g (40 kg).
Existem 149 produtos com o maior comprimento, sendo 105 cm.
Existem 24 produtos com o maior altura, sendo 105 cm.
O produto com maior largura é da categoria cama, mesa e banho com 118cm.
 
### Análise da Tabela olist_customers_dataset (Clientes)

 A tabela clientes possui 5 tabelas:
 - customer_id = identificador do cliente;
 - customer_unique_id = identificador único do cliente (CPF ou CNPJ);
 - customer_zip_code_prefix = prefixo do CEP (endereço postal) do cliente;
 - customer_city = cidade do cliente;
 - customer_state = estado do cliente.

A tabela de clientes possui 99.441 linhas, sendo que os registros do identificador do cliente possuem a mesma quantidade distinta. 

Já o identificador único do cliente possui 96.096 registros únicos, ou seja, existem identificadores únicos do cliente repetidos.
Analisando os registros repetidos, alguns identificadores únicos possuem até 17 repetições, algumas com cadastro em outra cidade e/ou estado. Será considerado que as repetições ser filiais de empresas ou pessoas que compraram em diferentes estados.

Analisando os clientes de acordo com o local onde moram:

- As 5 cidades com mais clientes são: São Paulo com 15.540 (15,63%), Rio de Janeiro com 6.882 (6,82%), Belo Horizonte com 2.773 (2,79%), Brasília com 2.131 (2,14%) e Curitiba com 1.521 (1,53%).

- Foi identificado que os 3 estados com a maior quantidade de clientes são: São Paulo com 41.746 (41,98%), Rio de Janeiro com 12.852 (12,92%) e Rio Grande do Sul com 5.466 (5,5%).

- A análise por regiões, trás a região Sudeste em primeiro lugar com 68.266 (68,65%), o Sul com 14,148 (14,23%), o Nordeste com 9.394 (9,45%), o Norte com 3.991 (4,01%) e o Centro-Oeste com 3.642 (3,66%).


### Análise da Tabela olist_order_reviews_dataset (Avaliações dos Pedidos)


  A tabela de avaliações tem 7 colunas:
  - review_id = identificador da avaliação;
  - order_id = identificador do pedido;
  - review_score = avaliação;
  - review_comment_title = título do comentário;
  - review_comment_message = comentário;
  - review_creation_date = data e hora da criação da avaliação;
  - review_answer_timestamp = data e hora da resposta à avaliação.

A tabela possui 79.121 linhas, sendo que a coluna de identificadores da avaliação possui 78.479 registros distintos e a coluna de identificadores do pedido possui 78.325 registros distintos.

A coluna de identificadores da avaliação possui 138 valores vazios e outros caracteres diferentes do padrão.

A coluna de identificadores do pedido também possui valores fora do padrão, sendo 12 vazios e 437 nulos.

A coluna de avaliação possui valores diferentes das notas de 1 a 5 padrões, totalizando 607 registros nestas condições.

As avaliações com maior frequência da maior para a menor são: Nota 5 com 44.954 (57,69%) votos, Nota 4 com 15.080 (19,35%) votos, Nota 1 com 9.001 (11,55%) votos, Nota 3 com 6.413 (8,23%) e Nota 2 com 2.469 (3,17%) votos.

O CSAT é de 77,05%, ou seja, existe uma grande porcentagem dos clientes que avaliaram os produtos e a entrega com notas 4 ou 5.

Existem 3 linhas de registro da tabela com a data e hora da criação da avaliação vazias.

Também existem 3 linhas de registro da tabela com a data e hora da resposta à avaliação vazias.

As medidas de dispersão e de tendência central da coluna com o preço dos itens dos pedidos (price) apresentaram os seguintes valores:
- Contagem: 112.650 transações
- Valor Máximo: R$6.735,00
- Valor Mínimo: R$0,85
- Amplitude: R$6.734,15
- Média: R$120,65
- Mediana: R$74,99
- Desvio-Padrão: R$183,63

As medidas de dispersão e de tendência central da coluna com o valor do frete (freight_value) apresentaram os seguintes valores:
- Contagem: 112.650 transações
- Valor Máximo: R$409,68
- Valor Mínimo: R$0
- Amplitude: R$409,68
- Média: R$19,99
- Mediana: R$16,26
- Desvio-Padrão: R$15,81

Utilizando a fórmula de Sturges, chegamos aos 18 bins. Com esta informação, nosso histograma tem a seguinte distribuição:

O BoxPlot abaixo mostra que valores acima de R$344,34 são considerados outliers.


### Análise da Tabela olist_order_items_dataset (Itens dos Pedidos)

A tabela de itens dos pedidos possui 7 colunas:
- order_id = identificador do pedido;
- order_item_id = numero de itens incluidos no mesmo pedido.
- product_id = identificador do produto;
- seller_id = identificador do vendedor;
- shipping_limit_date = data limite de envio;
- price = preço
- freight_value = preço do frete;  

  A tabela possui 112.650 linhas, sendo que a coluna de identificadores do pedido possui 98.666 valores distintos, ou seja, existem valores duplicados na coluna dos identificadores do pedido. A tabela de vendedores possui 3.095 valores distintos, representando então a quantidade de vendedores que já realizaram alguma venda.

Analisando os identificadores dos pedidos duplicados, foram encontrados 9.803 registros com mais do que 1 registro.

A analise da tabela de produtos retornou que foram vendidos 32.951 produtos diferentes ao longo do tempo.
O produto mais vendido teve um total de 527 unidades.
O produto com mais faturamento obteve um total de R$63.885,00.

Já com relação ao vendedor, o vendedor que mais faturou obteve um total de R$ 229.472,63.  Entretanto, 1.667 vendedores tiveram um faturamento inferior a R$1.000,00

Na coluna de produtos, o maior preço foi de R$6.735,00 e o menor foi de R$0,85.

Na coluna de fretes, o maior frete foi de R$408,68 e o menor frete foi R$0,00.

  

## Criação do Dashboard de Acompanhamento da Operação

  

  

## Perguntas de Negócio

  

  

## Planos de Ação
