# Olist Data Analysis

## Objetivo

O objetivo macro desta análise é encontrar soluções para elevar ao máximo as operações deste e-commerce, respondendo perguntas de negócio e criando planos de ação para cada ponto de melhoria encontrado.

A análise será dividida em:

* Análise Exploratória dos Dados.

* Dashboard de Acompanhamento da Operação.

* Perguntas de Negócio.

* Planos de Ação.

## Base de Dados Utilizada

O DataSet Olist é uma representação de um E-Commerce com dados de 100 mil pedidos entre os anos de 2016-2018 fornecidos pela OLIST e nele existem tabelas com dados dos clientes, pagamentos, avaliações de compras, produtos e suas categorias, vendedores, entre outras informações.

A motivação na escolha do DataSet foi devido a sua familiaridade com bases de dados utilizadas no dia a dia de empresas, com relacionamento entre tabelas, chaves primarias e secundárias, entre outras similaridades.

O DataSet possui os seguintes dados:

* Informações sobre os pedidos realizados como status do pedido, data da compra, data da entrega, etc.

* Informações sobre os pagamentos como forma de pagamento, parcelamentos, valor total do pedido, etc.

* Informações sobre os produtos como categoria, peso, largura, altura, comprimento, etc.

* Informações sobre os clientes como identificador do cliente (CPF/CNPJ ou outro documento, porém criptografado), cidade e estado onde moram, etc.

* Informações sobre as avaliações, como a nota, títulos e comentários sobre as avaliações, etc.

* Informações sobre os itens presentes em cada pedido, como identificador do produto, identificador do vendedor, preço, frete, etc.

DataSet Olist no Kaggle:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Repositório de Arquivos Utilizados (Arquivos Excel, SQL e Power BI):

https://drive.google.com/drive/u/0/folders/1RxUEyY75qlQwejZxF--9Y24GLZ_8tx9N

## Ferramentas

Sobre as ferramentas, foram utilizadas as seguintes:

* DBeaver - Utilizando SQL para realizar as análises iniciais das tabelas, realizar tratamento nos dados, e extrair alguns insights iniciais.

(Foi utilizado um arquivo compilado em formato SQlite da Base Olist.)

Link para download: https://dbeaver.io/download/

* Excel - Para realizar análises de medidas de tendência e dispersão dos dados, identificação de outliers, incluindo gráficos e tabelas dinâmicas.

Link para compra: https://www.microsoft.com/pt-br/microsoft-365/excel

* Power BI - Como ferramenta de dataviz, onde será criada uma visualização, utilizando o Power Query como ferramenta de Limpeza e Tratamento, e criação do dashboard de acompanhamento da operação.

(A etapa de limpeza e tratamento poderia e até deveria ser realizada no DBeaver ou em outro SGBD (Sistema Gerenciador de Banco de Dados) devido ao seu melhor processamento, mas neste caso vamos utilizar o Power Query como forma alternativa)

Link para download: https://www.microsoft.com/pt-br/power-platform/products/power-bi

## Instruções:


### Arquivo SQL

No arquivo SQL(.sql), cada Query conterá acima dela uma linha com o propósito e abaixo uma ou mais linhas com um breve resumo do porquê das escolhas dos comandos e funções.

### Arquivo Excel

No arquivo Excel (.xlsx), haverá todas as tabelas criadas através de queries no SQL. Será possível encontrar também uma planilha chamada Dinâmicas, que será utilizada para criação de tabelas para análise, uma planilha chamada "Análises" com dados extraídos das tabelas dinâmicas, e uma planilha chamada "Gráficos" com os gráficos criados através das análises.

### Arquivo Power BI

No arquivo Power BI (.pbix), cada medida e coluna calculada criada conterá no comentário uma breve explicação sobre o porquê das escolhas na utilização dos comandos e funções.

No Repositório de Arquivos Utilizados, a documentação será armazenada em um arquivo chamado [Documentação Relatório Operacional Olist](https://drive.google.com/file/d/1mkScw9VgRWrXcz62_S4eQ5HwBxxjNwmr/view?usp=drive_link).

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

Dos 160 pedidos com a data de aprovação vazia, 141 foram cancelados, 14 foram entregues e 5 foram apenas criados.

Dos 1.783 pedidos com a data de entrega do pedido na transportadora vazias, 609 estão com status indisponíveis, 550 estão cancelados, 314 estão faturados, 301 estão em processamento, 5 estão criados, 2 foram entregue e 2 foram aprovados.

Dos 2.965 pedidos com a data de entrega ao cliente vazias, 1107 estão com status enviado, 619 cancelados, 609 indisponíveis, 314 faturados, 301 em processamento, 8 entregues, 5 criados e 2 aprovados. 

O mês com o maior número de pedidos entregues foi o mês de agosto de 2018:

![Pedidos Entregues ao longo do tempo](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/delivered%20orders.PNG)

Sobre as datas das primeiras e últimas vendas entregues realizadas:

* A primeira venda efetivamente entregue foi realizada em 15-09-2016 e a última venda foi realizada em 29-08-2018.

Analisando estão os pedidos com o status "enviado" e com data de entrega prevista entre 1 de janeiro de 2016 e 30 de junho de 2018, foram encontrados 962 pedidos não entregues.

### Análise da Tabela olist_order_payments_dataset (Pagamentos dos Pedidos)

A tabela de pagamentos possui 5 colunas:

- order_id = identificador do pedido;

- payment_sequential = métodos de pagamentos;

- payment_type = forma de pagamento;

- payment_installments = parcelamento;

- payment_value = valor dos pagamentos.

A tabela de pagamentos possui 103.886 linhas de registro com 99.440 identificadores dos pedidos únicos, ou seja, existem linhas com o mesmo identificador do pedido. A partir desta análise, foram encontrados os pedidos repetições, onde alguns pedidos possuíam 29 linhas com o mesmo identificador do pedido. Alguns possuíam a mesma forma de pagamento, outros formas diferentes.

A coluna métodos de pagamentos retorna a quantidade de formas de pagamentos utilizadas para o pagamento de um pedido. 95,64% (99.360) pedidos foram realizados utilizando apenas uma forma de pagamento.

Entre as formas de pagamento, foram encontradas 8 categorias, sendo elas:

- credit_card = cartão de crédito;

- boleto = boleto;

- voucher = voucher;

- debit_card = cartão de débito;

- not_defined = não definido.

A forma de pagamento via cartão de crédito é a mais utilizada, representando 76.795 compras (73,92%), seguido por boleto com 19.784 (19,04%), voucher com 5.775 (5,56%) e cartão de débito com 1.529 (1,47%). A forma de pagamento não definida teve apenas 3 registros.

![Vendas por Forma de Pagamento](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/payment_type%20x%20payment_value.PNG)

Analisando os parcelamentos, a quantidade de parcelamento mais utilizada é 1x, com 52.546 (50,58%) pedidos realizados, seguido por 2x com 12.413 (11,95%), 3x com 10.461 (10,07%) e 10x com 5.328 (5,13%).

![Vendas por Quantidade de Parcelamentos](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/payment_installments.PNG)

Isto demonstra 50,58% dos pagamentos são realizados à vista e que 99,97% dos pagamentos são parcelados em até 10 vezes.

Sobre o faturamento dos pedidos, o pedido com o maior valor teve um faturamento de R$13.664,08 e os menores foram pedidos com faturamento R$0. As compras com faturamento R$0 tem as formas de pagamento como vouchers ou não definidas.

Já sobre o faturamento por forma de pagamento, cartão de crédito está na primeira posição com R$12.542.084,19 (78,34%), seguido por boleto com R$2.869.361,27 (17,92%), voucher com R$379.436,87 (2,37%) e cartão de débito com R$217.989,79 (1,36%). A forma de pagamento não definida não teve faturamento.

![Faturamento por Forma de Pagamento](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/payment_type%20x%20payment_value%20(R%24).PNG)

As medidas de dispersão e de tendência central da coluna com os pagamentos (payment_values) apresentaram os seguintes valores:

- Contagem Pagamentos: 103.886

- Valor Máximo: R$13.663,08

- Valor Mínimo: R$ 0

- Amplitude: R$ 13.664,08

- Média: R$154,10

- Mediana: R$ 100,00

- Desvio-Padrão: R$217,49

Com estes dados já podemos ter uma noção de como os pagamentos estão distribuídos. A amplitude nos mostra que existe uma grande quantidade de pagamentos de valores diferentes e distantes. O desvio-padrão mostra que existe uma variabilidade grande dos dados com relação a média (R$154,10). A média é maior que a mediana, pressupondo uma assimetria a direita com pagamentos mais altos e também que a maioria dos pagamentos é menor que a média, mas há alguns pagamentos muito altos que aumentam a média.

O histograma abaixo mostra que os dados são assimétricos a direita, e que a maior concentração de pagamentos estão no intervalo entre R$0 e R$759,12.

![Histograma do Pagamentos](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/histograma%20payment_value.PNG)

*A fórmula de Sturges foi utilizada para mensurar a quantidade de bins (intervalos) de todos os Histogramas presentes nesta análise.*

O Boxplot demonstra que 75% dos pagamentos tem valor entre R$0 e R$171,84.

![Boxplot do Pagamentos](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/boxplot%20payment_value.PNG)

Embora concentrados, existem alguns valores discrepantes (outliers), e pode-se verificar que o limite superior para que um pagamento seja considerado estatisticamente um ponto fora da curva, é de R$344,34.

É possível definir com base nos percentis que 95% dos pagamentos tem valores de até R$ 349,90.

Observando por outras segmentações, chegamos ao seguinte resultado quando separando o BoxPlot pela forma de pagamento:

![Boxplot do Pagamentos por Forma ou Tipo de Pagamento](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/boxplot%20payment_value%20x%20payment_type.PNG)

Por mais que o cartão de crédito seja uma forma de pagamento que permita a aquisição de itens com maiores valores devido à possibilidade de parcelamento, é possível visualizar que na forma de pagamento por boleto e cartão de débito também existem valores fora da curva.

A média e mediana entretanto entre as 3 formas de pagamento seguem muito próximas, representando que a distribuição é muito semelhante.

### Análise da Tabela olist_products_dataset (Produtos)

A tabela de produtos possui 9 colunas:

- product_id = identificador do produto;
- 
- product_category_name = nome da categoria do produto;

- product_name_lenght = comprimento do nome do produto;

- product_description_lenght = comprimento da descrição do produto;

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

O gráfico abaixo demonstra melhor a quantidade de produtos por categoria:

![Top 10 categorias com mais produtos](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/top%2010%20product_category_name.PNG)

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

![Top 10 cidades com mais clientes](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/customer_city%20distribution.PNG)

- Já na análise por estados, 3 estados com a maior presença de clientes são: São Paulo com 41.746 (41,98%), Rio de Janeiro com 12.852 (12,92%) e Minas Gerais com 5.466 (11,70%).

![Estados com mais clientes](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/customer_state%20distribution.PNG)

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

![Distribuição de Notas das Avaliações](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/review_score%20distribution.PNG)

O CSAT é de 77,05%, ou seja, existe uma grande porcentagem dos clientes que avaliaram os pedidos com notas 4 ou 5.

Existem 3 linhas de registro da tabela com a data e hora da criação da avaliação vazias.

Também existem 3 linhas de registro da tabela com a data e hora da resposta à avaliação vazias.

### Análise da Tabela olist_order_items_dataset (Itens dos Pedidos)

A tabela de itens dos pedidos possui 7 colunas:

- order_id = identificador do pedido;

- order_item_id = numero de itens inclusos no mesmo pedido.

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

Já com relação ao vendedor, o vendedor que mais faturou obteve um total de R$ 229.472,63. Entretanto, 1.667 vendedores tiveram um faturamento inferior a R$1.000,00

![Top 10 vendedores com mais faturamento](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/Top%2010%20seller%20sales.PNG)

As medidas de dispersão e de tendência central da coluna com o preço dos itens dos pedidos (price) apresentaram os seguintes valores:

- Contagem: 112.650 transações

- Valor Máximo: R$6.735,00

- Valor Mínimo: R$0,85

- Amplitude: R$6.734,15

- Média: R$120,65

- Mediana: R$74,99

- Desvio-Padrão: R$183,63

Assim como as medidas resumo apresentadas na análise dos pagamentos (payment_value), é possível notar o mesmo padrão: grande variabilidade nos dados, mediana menor que a média e desvio padrão relativamente alto.

O histograma do Preço do produto apresenta a seguinte distribuição dos preços:

![Histograma do Preço](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/histograma%20price.PNG)

O preço dos produtos também possui uma assimetria a direita, ou seja, a grande maioria dos valores está concentrada no lado esquerdo com uma grande quantidade agrupada no primeiro intervalo (entre R$0,85 e R$374,97), a presença de outliers com valores altos pode ser identificada, mas será melhor visualizada no Boxplot.

O Boxplot também apresenta valores fora da curva acima de R$277,30 e abaixo de R$0,85:

![Boxplot do Preço](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/boxplot%20price.PNG)

Analisando o percentil 95, podemos constatar que 95% dos preços dos itens dos pedidos possuem valores entre R$0,85 e R$349,90.

As medidas de dispersão e de tendência central da coluna com o valor do frete (freight_value) apresentaram os seguintes valores:

- Contagem: 112.650 transações

- Valor Máximo: R$409,68

- Valor Mínimo: R$0

- Amplitude: R$409,68

- Média: R$19,99

- Mediana: R$16,26

- Desvio-Padrão: R$15,81

No valor do frete já existe uma suavização, considerando obviamente que o valor do frete tende a ter um valor mais baixo em relação ao produto. O Variabilidade dos dados ainda é alta, mas a amplitude é mais baixa. A mediana segue abaixo da média, sugerindo que existem valores altos aumentando a média. O desvio padrão baixo representa que a maioria dos dados não estão tão distantes da média, embora exista a presença de outliers.

O histograma tem a seguinte distribuição:

![Histograma do Frete](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/histograma%20freight_value.PNG)

A maioria dos dados estão concentrados na primeira faixa entre R$0 e R$22,76, e existe uma assimetria a direita com muitos valores altos em relação a média.

O Boxplot possui a seguinte apresentação:

![Boxplot do Frete](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/boxplot%20freight_value.PNG)

Valores acima de R$33,25 ou abaixo de R$0,85 são considerados outliers.

O percentil 95 nos mostra que 95% dos fretes estão acumulados até R$45,12.

Ambos seguem o mesmo padrão das análises anteriores, com concentração dos valores a esquerda o que representa que os valores estão concertados mais próximos do zero, assimetria a direita e outliers identificados principalmente acima dos limites superiores, significando que alguns valores fora do padrão são encontrados muito acima da maioria dos dados.

## Dashboard de Acompanhamento da Operação

O dashboard de acompanhamento da operação possui 5 páginas com análises principais que podem nortear uma tomada de decisão. As análises estão divididas em: Logística, Faturamento, Categoria dos Produtos, Vendedores e Avaliações.

Este modelo é uma simulação do primeiro dashboard de uma empresa, com conteúdo mais voltado para analisar o estado atual da operação.

Outras análises de comparação entre períodos (meses, anos, dias) poderiam ser realizadas, assim como análises mais aprofundadas sobre cada um dos tópicos abordados, com criação de indicadores, etc.

A modelagem de dados foi realizada no modelo SnowFlake:

![Snowflake Model](https://github.com/felipe-francisco/Olist-Data-Analysis/blob/main/Gr%C3%A1ficos/Snowflake%20Schema.png)

Link do dashboard publicado:

[Relatório Operacional](https://app.powerbi.com/view?r=eyJrIjoiZDkxNjE2ZDQtZTViOS00M2Q0LTgzNzctYWIxNGQyZTMxYmNiIiwidCI6ImVjNDM1NmM3LTFhZTItNDc5Zi05NzgyLWRlZjk1YjI3YzlmOCJ9&pageName=9faedfe3790e81026e30)

## Perguntas de Negócio

### Quais foram os produtos entregues mais vendidos?

* O produto entregue mais vendido foi o produto com código aca2eb7d00ea1a7b8ebd4e68314663af, que apresentou um total de 520 unidades.

### Qual a receita mensal ao longo do tempo?

* O mês com maior faturamento foi agosto de 2018, com R$1.323.721,56 faturados.

### Quais categorias de produtos geram mais receitas?

* A categoria que mais gera receita é cama, mesa e banho com um faturamento de R$ 1.648.634,43.

### Qual o valor médio de um pedido por cliente?

* Como cada cliente cadastrado realizou apenas uma compra, as médias de compras são o valor total da única compra realizada, sendo a média máxima R$13.664,08 e mínima R$0,10.

### Qual a taxa de recompra dos clientes?

* A taxa de recompra é 0, ou seja, cada cliente neste DataSet realizou no máximo uma compra.

### Qual é o tempo médio de entrega dos pedidos?

* A diferença média entre a data da aprovação e a entrega efetiva do produto é de 11,64 dias, ou seja, o tempo médio de entrega é de 1 semana e meia.

* A diferença entre a estimativa de entrega e a entrega efetiva é de -11,87 dias, ou seja, em média os pedidos são entregues com aproximadamente 12 dias de antecedência.

### Quais são as regiões com maior tempo de entrega?

* As regiões norte e nordeste possuem o maior prazo de entrega, com 19 e 16 dias respectivamente.

* Em relação às cidades, o top 3 com maior tempo de entrega é representado por: Roraima (28 dias), Amapá (26 dias) e Amazonas (25 dias).

### Qual é a taxa de atrasos nas entregas?

* A taxa de atraso das entregas é de 6,78%.

### Quais são os métodos de pagamento mais utilizados?

* O método de pagamento mais utilizado é cartão de crédito, com 76.795 compras (73,92%), boleto com 19.784 compras (19,04 %). Juntos eles representam 92,97% de todas as compras realizadas.

### Qual a taxa de cancelamento dos produtos de acordo com a forma de pagamento?

* Por ter uma maior quantidade de transações, cartão de crédito é a primeira colocada no ranking de cancelamentos, com 66,87% (444) do total. A segunda colocação entretanto é da forma de pagamento voucher, com 17,32% (115) dos cancelamentos.

### Qual a média de avaliação dos produtos?

* A avaliação média dos produtos é de 4,08.

### Quantos produtos foram avaliados e a média de avaliação por categoria do produto?

* A média de avaliação dos produtos varia de 2,5 a 5. Porém algumas categorias como seguro e serviços (2), pc gamer (8), portáteis de cozinha / preparadores de alimentos (14), la cousine (14), fashion esporte (29), fashion roupa infanto-juvenil (7) e cd's e dvd's musicais (7) possuem um número baixo de amostras para avaliação (menos do que 30).

* Removendo estes que possuem uma quantidade baixa de amostras, fraldas e higiene (3,14), moveis de escritório (3,49) e casa conforto 2 (3,52) estão no TOP 3 com piores avaliações. Já no TOP 3 melhores avaliações estão livros de interesse geral (4,54), portáteis para casa, forno e café (4,51) e moveis para quarto (4,51).

## Planos de Ação

### Dados

#### Problemas, soluções e oportunidades:

* A data de aprovação da compra deveria ser preenchida apenas caso o cancelamento fosse efetuado antes da aprovação. Desta forma poderíamos avaliar compras canceladas antes e depois da aprovação e eventuais motivos (cartão recusado, desistência do cliente, etc).

* Os pedidos entregues deveriam ter a data de aprovação preenchida, pois faz parte do processo completo da venda.

* Apenas os pedidos criados, aprovados, faturados, em processamento e cancelados antes do envio poderiam ter a data de entrega na transportadora vazia.

* Como a entrega é um dos últimos estágios do processo de venda, apenas pedidos com o estágio anterior a entregue poderiam ter a data de entrega à transportadora vazia.

* As avaliações receberam muitos dados fora do padrão das colunas. Inserir uma validação de dados evitando que o cliente insira informações não padronizadas auxiliaria em uma captura de dados e eventual análise mais assertiva.

### Logística

#### Problemas, soluções e oportunidades:

* Considerando que a última venda entregue realizada foi no final de agosto de 2018, qualquer produto com data de entrega prevista para junho ou data anterior está com um tempo de atraso extremamente alto ou o pedido foi extraviado.
O ideal seria monitorar entregas que passem de determinados dias de atraso, mantendo uma comunicação constante com as transportadoras. 
A avaliação do cliente e eventual recompra depende de uma boa experiência desde a entrega, portanto deve ser um dos pontos críticos de análise.

* Os pedidos que não forem entregues em determinados dias podem ser categorizados de forma a identificar que se passou o prazo limite para entrega. Uma equipe deveria então entrar em contato com a transportadora e com o cliente para verificar o que ocorreu, fornecendo opções para resolver a situação com o cliente de forma ativa.

* Identificar e fechar parcerias mais benéficas com transportadoras que entregam no prazo e reavaliar parcerias com transportadoras que possuem histórico negativo também é um caminho interessante.

* Estados do nordeste possuem um tempo de entrega até 2x mais altos do que na região sudeste.
Como tanto as avaliações negativas como positivas levam em consideração a entrega e a qualidade do produto, a menor demanda nestas regiões pode estar relacionado com o tempo elevado de entrega.
Encontrar formas de diminuir o tempo de entrega nestas regiões, otimizando rotas ou melhorando a logística dos Centros de Distribuição podem ser alternativas interessantes.
Da mesma forma, os clientes da região sudeste representam 68,65% dos clientes e para estas regiões incentivos de fretes gratuitos, investimento maior em C.D.'s e fechamento de parcerias se tornariam mais fáceis pela alta proporção de pedidos para esta região.


### Faturamento

#### Problemas, soluções e oportunidades:

* Cartões de Crédito possuem tanto transações (76.795 ou 73,92%) quanto faturamento (R$12.542.084 ou 78,34%) muito superiores em relação às outras formas de pagamento.
Fechar parcerias com operadoras de cartão que ofereçam taxas menores é uma boa opção.

* 99,97% dos parcelamentos realizados são em até 10x e 79,43% são realizados em até 4x. Significa que os parcelamentos acima de 11x não são comumente utilizados e estas opções poderiam facilmente ser removidas. Como geralmente as taxas aumentam na medida que a quantidade de parcelas aumenta, limitar a 5x diminuiria a cobrança de taxas adicionais. Se este for considerado um corte muito radical, poderia limitar a 10 e diminuir ao longo do tempo para validar os impactos.

* Quanto às opções de pagamento oferecidas, 95,64% (ou 99.360 das 99.440) das compras são realizadas com 1 forma de pagamento e 95% dos pagamentos tem valores de até R$349,90, limitar o pagamento a apenas 1 forma pode ser uma alternativa interessante para diminuir as taxas de transação oriundas de duas ou mais formas de pagamento.

* Fornecer frete grátis para compras acima de um determinado valor pode ser uma alternativa interessante para aumentar o faturamento, considerando que 95% dos fretes são até R$45,12.


### Satisfação do Cliente

#### Problemas, soluções e oportunidades:

* Grande maioria das avaliações negativas (notas 1 a 3) e positivas (notas 4 e 5) avaliam os produtos por requisitos muito semelhantes: entrega dos produtos no prazo (ou com antecedência) e qualidade dos produtos.
Criar uma política que garanta a entrega dentro do prazo (e se possível com antecedência) e com cuidado, comercializar produtos de qualidade e mitigar eventuais problemas de forma proativa levará a uma melhor avaliação, recompra e recomendação.

* Nas avaliações foram identificados itens dos pedidos entregues em datas diferentes, e embora não seja um problema de avaliação, impacta significativamente e negativamente este indicador.
