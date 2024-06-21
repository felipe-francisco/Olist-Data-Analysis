--Verificar se os id's dos pedidos são únicos:
SELECT
	count(*) as contagem_linhas,
	count(DISTINCT order_id) contagem_destinta_ids
FROM olist_orders_dataset ood;
-- A query retornou que existem 99.441 linhas e 99.441 registros distintos de ID's


--Verififcar se cada linha representa uma ou mais compras dos clientes:
SELECT
	count(*) as contagem_linhas,
	count(DISTINCT customer_id) contagem_destinta_clientes
FROM olist_orders_dataset ood;
-- A query retornou as mesmas 99.441 linhas para a contagem distinta dos id's dos clientes, ou seja, cada linha representa uma única compra de cada cliente.


-- Verificar quantas categorias existem na coluna order_status e quantos pedidos estão presentes em cada categoria:
SELECT 
	distinct order_status,
	count(*) as contagem_pedidos,
	CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_orders_dataset ood) AS DECIMAL) AS perc_total
FROM olist_orders_dataset ood
GROUP BY order_status;
-- Foram encontradas 8 categorias distintas
-- E aproximadamente 97% dos pedidos foram entregues


-- Verificar se todos os dados da coluna de data são do tipo data, ou se existe algum valor nulo ou vazio
SELECT
    COUNT(*) AS total_linhas,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS nulos,
    SUM(CASE WHEN typeof(order_purchase_timestamp) <> 'text' OR TRIM(order_purchase_timestamp) = '' THEN 1 ELSE 0 END) AS valores_invalidos
FROM olist_orders_dataset ood;
-- Aqui filtramos os valores Nulos que possam existir na coluna utilizando um 'Case When' que retorna 1 se o valor for nulo e 0 se o valor for não nulo, se não existir nenhum a query retornará 0.
-- Utilizamos o mesmo padrão no segundo 'Case When', utilizando a função 'TRIM' para remover espaços vazios no inicio ou final da linha da coluna, e depois verificamos se ela é diferente de texto ou se possui espaços vazios.
-- Geralmente as datas no SQLite são armazenadas como strings com o formato 'YYYY-MM-DD HH:MM:SS'.
-- Nesta primeira query não identificamos nenhuma linha da coluna com valores faltantes ou diferentes de texto.

SELECT
    COUNT(*) AS total_linhas,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS nulos,
    SUM(CASE WHEN typeof(order_approved_at) <> 'text' OR TRIM(order_approved_at) = '' THEN 1 ELSE 0 END) AS valores_invalidos
FROM olist_orders_dataset ood;
-- Aqui identificamos 160 valores faltantes ou diferentes de texto.

-- Uma outra possibilidade é agrupar pelo mês/ano e caso não haja uma data ou a query não consiga converter utilizando o 'strftime', aprecerá Nulo.
SELECT 
	STRFTIME('%Y-%m', order_approved_at) as ano_mes,
	COUNT(order_approved_at)
FROM olist_orders_dataset ood
GROUP BY ano_mes
ORDER BY ano_mes ASC;

SELECT
    COUNT(*) AS total_linhas,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS nulos,
    SUM(CASE WHEN TYPEOF(order_delivered_carrier_date) <> 'text' OR TRIM(order_delivered_carrier_date) = '' THEN 1 ELSE 0 END) AS valores_invalidos
FROM olist_orders_dataset ood;

SELECT
	COUNT(*)
FROM olist_orders_dataset ood
WHERE order_delivered_carrier_date = ''
-- Aqui identificamos 1.783 valores faltantes ou diferentes de texto.

-- E identificamos quais são essas linhas
SELECT
	DISTINCT order_status,
	COUNT(*) AS contagem_pedidos
FROM olist_orders_dataset ood
WHERE order_delivered_carrier_date = ''
GROUP BY order_status
ORDER BY contagem_pedidos DESC
-- Encontramos 2 pedidos entregues, sem data de entrega à transportadora

SELECT 
	*
FROM olist_orders_dataset ood
WHERE 
	order_delivered_carrier_date = '' AND
	order_status IN('delivered')
-- Aqui encontramos 2 pedidos com status entregues, porém sem data de entrega à transportadora. Pode ser caso de retirada na loja (se existir), uma falha no preenchimento da data, ter sido entregue de forma alternativa ou não ter sido entregue

SELECT
    COUNT(*) AS total_linhas,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS nulos,
    SUM(CASE WHEN typeof(order_delivered_customer_date) <> 'text' OR TRIM(order_delivered_customer_date) = '' THEN 1 ELSE 0 END) AS valores_invalidos
FROM olist_orders_dataset ood;
-- Aqui identificamos 2.965 valores faltantes ou diferentes de texto.

SELECT
    COUNT(*) AS total_linhas,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS nulos,
    SUM(CASE WHEN typeof(order_estimated_delivery_date) <> 'text' OR TRIM(order_estimated_delivery_date) = '' THEN 1 ELSE 0 END) AS valores_invalidos
FROM olist_orders_dataset ood;
-- Aqui não identificamos valores faltantes ou diferentes de texto.

-- Vamos verificar então qual aa primeira e a última compra realizada e que foram entregues:

SELECT
	*
FROM olist_orders_dataset ood
WHERE order_purchase_timestamp = (SELECT MIN(order_purchase_timestamp) FROM olist_orders_dataset ood WHERE order_status = 'delivered');
-- Aqui utilizamos uma subquery no WHERE com um filtro para pegar apenas a primeira venda realizada que foi entregue.
-- Se a base for atualizada e uma data anterior de venda entregue for inserida, a query retornará o valor correto pois está automatizada.
-- A primeira venda realizada e entregue foi realizada em 15/09/2016.

SELECT
	*
FROM olist_orders_dataset ood
WHERE order_purchase_timestamp = (SELECT MAX(order_purchase_timestamp) FROM olist_orders_dataset ood WHERE order_status = 'delivered');
-- A última venda realizada e entregue foi realizada em 29/08/2018.



-- Agora vamos analisar a tabela que possui dados dos pagamentos:
SELECT
	count(*) as contagem_linhas,
	count(DISTINCT order_id) contagem_destinta_ids,
	COUNT(*) - count(DISTINCT order_id) as diferenca_linhas
FROM olist_order_payments_dataset oopd;
-- Conforme a explicação do DataSet, pagamentos que são realizados com mais de uma forma de pagamento criam sequencias, desta forma o order_id se repetirá sempre que houver esta sequência.

SELECT
	order_id,
	COUNT(*) as registros_duplicados
FROM olist_order_payments_dataset oopd 
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY registros_duplicados DESC
-- E aqui verificamos quais são estes registros, ordenando dos que possuem mais repetições para os que possuem menos repetições.



-- O  ideal seria saber se o voucher é um cupom de desconto aplicado, um presente recebido de outra pessoa (como um gift card), um saldo em carteira derivado de algum cancelamento ou alguma outra modalidade de crédito.
SELECT
	order_id,
	COUNT(*) as registros_duplicados,
	payment_type
FROM olist_order_payments_dataset oopd
WHERE payment_type <> 'voucher'
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY registros_duplicados DESC

SELECT
	order_id,
	COUNT(*) as registros_duplicados,
	payment_type
FROM olist_order_payments_dataset oopd
WHERE payment_type = 'voucher'
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY registros_duplicados DESC

-- Valor pago de acordo com o pedido
SELECT
	order_id,
	SUM(payment_value) valor_total
FROM olist_order_payments_dataset oopd
GROUP BY order_id
ORDER BY valor_total desc
-- Se agruparmos pelo 'order_id' utilizando a função de agregação 'SUM' para somar todos os valores na coluna de pagamentos, teremos o valor total pago de todos os pedidos.
-- Sendo o maior valor de compra R$13.664,08, utilizando todas as formas de pagamento.

SELECT
	order_id,
	SUM(payment_value) valor_total
FROM olist_order_payments_dataset oopd
GROUP BY order_id
ORDER BY valor_total ASC
-- Encontramos também alguns registros zerados, vamos identificá-los abaixo


SELECT
	*
FROM olist_order_payments_dataset oopd
LEFT JOIN olist_orders_dataset ood
	ON oopd.order_id = ood.order_id
WHERE payment_value = 0
-- Em todos os pagamentos zerados, foi identificado o pagamento por voucher ou por uma categoria não definida.

-- Vamos analisar os parcelamentos, através da coluna payment_installmentes: 
SELECT
	DISTINCT payment_installments AS parcelamentos,
	COUNT(*) AS contagem,
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset) AS DECIMAL),4) AS perc_total,
	ROUND(SUM(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset) AS DECIMAL)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_order_payments_dataset oopd
GROUP BY parcelamentos
ORDER BY contagem DESC
--Podemos identificar que a forma de pagamento mais utilizada é "à vista" (ou em parcela única), representando aproximadamente 50% dos pagamentos


-- Agora vamos analisar a coluna de pagamentos (payment_value):
SELECT
	payment_type,
	count(*) qtd_por_tipo,
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset) AS DECIMAL),2) AS perc_total,
	SUM(payment_value) AS total_pagamentos,
	ROUND(CAST(SUM(payment_value) * 1.0 / (SELECT SUM(payment_value) FROM olist_order_payments_dataset) AS DECIMAL),4) AS perc_total_pagamentos
FROM olist_order_payments_dataset oopd
GROUP BY payment_type
ORDER BY qtd_por_tipo DESC
-- A maioria das compras foi realizada no crédito, representando aproximadamente 73,92% da quantidade total vendida.
-- Em valores, cartão de crédito também está na primeira colocação, porém com aproximadamente 78,33% dos valores recebidos nesta modalidade de pagamento.


-- Calculando o valor máximo, mínimo, amplitude, media, mediana e moda dos pagamentos:
SELECT
	MAX(payment_value) AS valor_maximo_pedido,
	MIN(payment_value) AS valor_minimo_pedido,
	MAX(payment_value) - MIN(payment_value) AS amplitude_pedido,
	ROUND(AVG(payment_value),2) AS media_pagamentos,
	MEDIAN(payment_value) AS mediana_pagamentos,
	round(STDEV(payment_value),2) AS desvio_padrao_pagamentos
FROM olist_order_payments_dataset oopd
-- A Amplitude dos dados é a mesma do valor máximo devido ao valor do menor pedido ser 0.
-- A média e a mediana estão relavitamente próximas, e ambas muito próximas ao valor mínimo. Sem criar o gráfico, a hipótese inicial é que seja uma distribuição assimétrica com concentração à esquerda.
-- Plotando um gráfico BoxPlot, provavelmente encontraremos outliers acima dos limites superiores.


-- Agora dos pagamentos separados por forma de pagamento:
SELECT
	payment_type,
	MAX(payment_value) AS valor_maximo_pedido,
	MIN(payment_value) AS valor_minimo_pedido,
	MAX(payment_value) - MIN(payment_value) AS amplitude_pedido,
	ROUND(AVG(payment_value),2) AS media_pagamentos,
	MEDIAN(payment_value) AS mediana_pagamentos,
	ROUND(STDEV(payment_value),2) AS desvio_padrao_pagamentos
FROM olist_order_payments_dataset oopd
GROUP BY payment_type
-- Em todos os tipos de pagamento é possível notar a média e mediana relativamente próximas e uma concentração dos dados muito próximas aos valores mínimos.


-- Para calcular a moda:
SELECT 
	payment_type,
	payment_value,
	count(*) AS frequencia
FROM olist_order_payments_dataset oopd
GROUP BY payment_type, payment_value
ORDER BY frequencia DESC
-- Aqui identificamos que a variável payment_value é unimodal com uma frequência de 273 para o valor de 50 no voucher.
-- Os pagamentos que mais aparecem são vouchers no valor de 50, seguidos por vouchers de 20 e 100.
-- Removendo os Vouchers, o pagamento mais comum é de 77,57 no cartão de crédito.

-- Continuando a análise da coluna de pagamentos, vamos extrair algumas medidas de tendência central e dispersão:
SELECT
	DISTINCT payment_installments AS numero_parcelas,
	count(*) qtd_pagamentos,
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset) AS DECIMAL),4) AS perc_total,
	ROUND(SUM(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset) AS DECIMAL)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada,
	MIN(payment_value) AS pagamento_minimo,
	MAX(payment_value) AS pagamento_maximo,
	ROUND(AVG(payment_value), 2) AS media_de_pagamentos,
	ROUND(MEDIAN(payment_value),2) AS mediana,
	ROUND(STDEV(payment_value),2) AS desvio_padrao_pagamentos
FROM olist_order_payments_dataset oopd
GROUP BY numero_parcelas
-- O que podemos extrair desta análise é que aproximadamente 99,67% das transações são em até 10x.
-- As maiores transações estão também nesta faixa, com exceção dos parcelamentos em 15x e em em 20x que tem transações máximas acima de 2.000.


-- Agora vamos explocar a base de categorias dos produtos,
SELECT
	COUNT(*),
	COUNT(DISTINCT product_id),
	COUNT(DISTINCT product_category_name)
FROM olist_products_dataset opd

SELECT
	DISTINCT product_category_name AS categorias,
	COUNT(product_id) AS contagem,
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_products_dataset) AS DECIMAL),4) AS perc_total,
	ROUND(SUM(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_products_dataset) AS DECIMAL)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_products_dataset opd
GROUP BY categorias
ORDER BY contagem DESC
-- Podemos ver que das 74 categorias, uma não possui nome (que representa 18% do total).
-- Cama, mesa e banho é a categoria com a maior quantidade de produtos.
-- Aqui não vamos ver qual o produto mais vendido ou com maior valor, pois o objetivo inicial é explorar a base.


-- O objetivo aqui é analisar a tabela de clientes:
SELECT
	COUNT(*) AS qtd_linhas,
	COUNT(DISTINCT customer_id) AS qtd_ids_clientes,
	COUNT(DISTINCT customer_unique_id) AS qtd_ids_cadastros_unicos,
	COUNT(*) - COUNT(DISTINCT customer_unique_id) AS dif_total_linhas_x_ids_clientes_unicos
FROM olist_customers_dataset ocd
-- Se o registro único for, por exemplo, um CPF, RG ou documento de identificação única, poderíamos ter uma fraude, erro de validação possibilitando cadastros duplicados, etc.
-- Das 99.441 linhas, existem 3.345 linhas que possuem ID's Unicos repetidos.

SELECT
	customer_unique_id,
	COUNT(*) as qtd_registros
FROM olist_customers_dataset
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY qtd_registros DESC
-- Podemos então verificar quais são os registros duplicados e a quantidade de duplicatas que cada um tem.
-- As duplicatas variam de 2 a 17 registros com o mesmo customer unique id.


WITH cadastros_duplicados AS (
	SELECT
		customer_unique_id,
		COUNT(*) as registros_duplicados
	FROM olist_customers_dataset
	GROUP BY customer_unique_id
	HAVING COUNT(*) > 1
)
SELECT 
	COUNT(*) AS contagem_duplicados,
	SUM(registros_duplicados) total_registros
FROM cadastros_duplicados
-- Ou seja, temos 2.997 customer unique id distintos com 2 registros ou mais duplicados, totalizando 6.342 linhas.

WITH cadastros_unicos AS (
	SELECT
		DISTINCT customer_unique_id AS id_unico,
		customer_city,
		customer_state
	FROM olist_customers_dataset
)
SELECT
	id_unico,
	COUNT(*)
FROM cadastros_unicos
GROUP BY id_unico
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC
-- Aqui também podemos identificar quais dos repetidos estão com registros em cidades e até estados diferentes.
-- Pode ser caso de clientes que se cadastram em diferentes cidades e estados, ou que fazem alguma espécie de cadastro básico para uma compra única, etc.
-- Em todos os casos, essa tabela precisará de maiores cuidados ao ser manipulada para uma extração de dados qualificada.


--Estado com maior quantidade de clientes e as frequências relativas e acumuladas:
SELECT
	customer_state,
	count(*) AS contagem,
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset) AS DECIMAL),4) AS perc_total,
	ROUND(SUM(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset) AS DECIMAL)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_customers_dataset ocd
GROUP BY customer_state
ORDER BY contagem DESC
-- Podemos notar que aproximadamente 42% dos clientes estão presentas no estado de São Paulo e que 68,64% estão presentes na Região Sudeste (SP, RJ, MG e ES).
-- A região sul (PR, SC e RS) vem logo em seguida, com 14,23%.

-- Para uma melhor visualização das regiões:
SELECT
	CASE
		WHEN customer_state IN ('SP', 'RJ', 'MG', 'ES') THEN 'Sudeste'
		WHEN customer_state IN ('PR', 'SC', 'RS') THEN 'Sul'
		WHEN customer_state IN ('MT', 'MS', 'GO') THEN 'Centro-Oeste'
		WHEN customer_state IN ('MA', 'PI', 'CE', 'BA', 'SE', 'AL', 'PE', 'PB', 'RN') THEN 'Nordeste'
		ELSE 'Norte'
	END AS regioes,
	count(*) AS contagem,
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset) AS DECIMAL),4) AS perc_total,
	ROUND(SUM(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset) AS DECIMAL)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_customers_dataset ocd
GROUP BY regioes
ORDER BY contagem DESC

-- Cidade com maior quantidade de clientes e as frequências relativas e acumuladas:
SELECT
	customer_city,
	customer_state,
	COUNT(*) AS contagem,
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset) AS DECIMAL),4) AS perc_total,
	ROUND(SUM(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset) AS DECIMAL)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_customers_dataset ocd
GROUP BY customer_city
ORDER BY contagem DESC
-- Podemos identificar que aproximadamente 15,6% dos nossos clientes moram na cidade de São Paulo.
-- É possível identificar também uma concentração dos pedidos nas capitais dos estados.

-- Organizando melhor a visualização por capitais:
SELECT
	customer_state,
	customer_city,
	CASE
		WHEN customer_city IN ('belo horizonte', 'salvador', 'fortaleza', 'joao pessoa', 'sao luis', 'maceio', 'aracaju', 'natal', 'recife', 'teresina', 'goiania', 'cuiaba', 'palmas', 'porto alegre', 
		'curitiba', 'florianopolis', 'sao paulo', 'rio de janeiro', 'vitoria', 'porto velho', 'rio branco', 'manaus', 'boa vista', 'macapa', 'belem', 'sao luis', 'brasilia') THEN 'Capital'
		ELSE 'Demais Cidades'
	END AS capitais,
	COUNT(*) AS contagem,
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset) AS DECIMAL),4) AS perc_total,
	ROUND(SUM(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset) AS DECIMAL)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_customers_dataset ocd
GROUP BY customer_city
ORDER BY capitais
-- De acordo com a frequência acumulada,  77,53% dos clientes se encontram nas capitais.


-- Agora vamos analisar a tabela de Reviews:
SELECT * FROM olist_order_reviews_dataset oord

SELECT
	COUNT(*),
	COUNT(DISTINCT review_id),
	COUNT(DISTINCT order_id) 
FROM olist_order_reviews_dataset oord
-- É possível identificar que existe uma diferença entre a quantidade de linhas e a quantidade de reviews distintos e dos order id's distintos

SELECT
	review_id,
	COUNT(*) as qtd_registros
FROM olist_order_reviews_dataset oord
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY qtd_registros DESC
-- Identificamos registros em branco, com falha na coleta e com registros incompletos, além de muitos registos duplicados.

-- Vamos então tentar identificar uma forma de filtrar os registros diferentes do padrão de ID:
SELECT
DISTINCT review_id,
LENGTH(review_id)
FROM olist_order_reviews_dataset oord
-- Identificamos que existe um padrão de 32 na quantidade de caracteres do review_id. Vamos então utilizá-lo para tentar identificar os reviews fora de padrão.

SELECT
	review_id 
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_id) <> 32
-- Aparentemente o padrão retornou apenas valores diferentes do id padrão 

WITH cadastros_duplicados AS (
	SELECT
		review_id,
		COUNT(*) as registros_duplicados
	FROM olist_order_reviews_dataset oord
	GROUP BY review_id
	HAVING COUNT(*) > 1
)
SELECT 
	COUNT(*) AS contagem_duplicados,
	SUM(registros_duplicados) AS total_registros 
FROM cadastros_duplicados
-- Ao total são 489 registros nestas duplicados, totalizando 1.131 linhas.

WITH cadastros_unicos AS (
	SELECT
		review_id,
		COUNT(review_id)
	FROM olist_order_reviews_dataset oord
	WHERE LENGTH(review_id) = 32
	GROUP BY review_id
	HAVING count(review_id) = 1
)
SELECT
	COUNT(*) AS registros_unicos
FROM cadastros_unicos
-- Das 79.121 linhas, 76.937 possuem registros únicos, não estão vazios ou possuem mais de 32 caracteres sem sua composição.


-- Agora vamos analisar a coluna com as notas:
SELECT 
	DISTINCT review_score
FROM olist_order_reviews_dataset oord
-- É possível identificar diversos registros que não são numéricos.

SELECT 
	count(DISTINCT review_score)
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1
-- Identificamos 5 registros com 1 caractere.

SELECT
	DISTINCT(review_score)
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1
-- E como as notas são de 1 a 5, elas tem 1 caractere. Qualquer registro fora deste padrão é algum tipo de erro na coleta.


SELECT
	COUNT(review_score)
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) <> 1
-- Encontramos então 602 registros fora do padrão

SELECT 
AVG(review_score)
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1
-- Embora ao final a média altere pouco, podemos ter um dado muito mais exato e correto.

SELECT
	DISTINCT review_score,
	COUNT(*) AS qtd_notas,
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_reviews_dataset WHERE LENGTH(review_score) = 1) AS DECIMAL),4) AS perc_total,
	ROUND(SUM(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_reviews_dataset WHERE LENGTH(review_score) = 1) AS DECIMAL)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1
GROUP BY review_score
-- Podemos verificar que 75,88% das notas estão entre 4 e 5.
-- Porém 11,38% das notas são de 1(pior nota). O que é um número bem elevado.

SELECT
	CASE
		WHEN review_score IN (4, 5) THEN 'Positiva'
		ELSE 'Negativa'
	END AS categoria_avaliacoes,
	count(*),
	ROUND(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_reviews_dataset WHERE LENGTH(review_score) = 1) AS DECIMAL),4) AS perc_total
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1
GROUP BY categoria_avaliacoes
-- A proporção de notas positivas/negativas é relativamente positiva. Através das Análises posteriores será possível encontrar muitas oportunidades de melhoria através dos feedbacks, tanto positivos quanto negativos.

-- Por último vamos analisar a tabela com os itens dos pedidos:
SELECT 
	COUNT(*) AS contagem_linhas,
	COUNT(DISTINCT order_id) AS contagem_id_pedidos,
	COUNT(DISTINCT seller_id) AS contagem_id_vendedores
FROM olist_order_items_dataset ooid
-- Como esperado da tabela com os itens dos produtos, haverá id dos pedidos duplicados.
-- Podemos verificar também que existem 3095 vendedores.

SELECT
	order_id,
	count(*) AS contagem_order_id
FROM olist_order_items_dataset ooid
GROUP BY order_id
ORDER BY contagem_order_id DESC
-- Podemos identificar que existem pedidos com até 21 itens.

SELECT
	product_id,
	count(*) AS contagem_product_id
FROM olist_order_items_dataset ooid
GROUP BY product_id
ORDER BY contagem_product_id DESC
-- O produto que mais apareceu nos pedidos teve 527 solicitações.

SELECT * FROM olist_order_items_dataset ooid

SELECT
	product_id,
	SUM(price) AS total_vendas
FROM olist_order_items_dataset ooid
GROUP BY product_id
ORDER BY total_vendas DESC
-- O produto mais vendido vendeu R$ 63.885,00 sem considerar o frete (que geralmente é repassado para a transportadora).

SELECT
	seller_id,
	SUM(price) AS total_vendas
FROM olist_order_items_dataset ooid
GROUP BY seller_id
ORDER BY total_vendas DESC
--O vendedor que mais vendeu arrecadou 229.472,63 (sem considerar o frete).

-- Já o vendedor que menos vendeu
WITH vendedores_baixa_performance AS (
	SELECT
		seller_id,
		SUM(price) AS total_vendas
	FROM olist_order_items_dataset ooid
	GROUP BY seller_id
	HAVING SUM(price) < 1000
)
SELECT
	COUNT(*) AS contagem_vendedores
FROM vendedores_baixa_performance
-- Dos 3095 vendedores, 1.667 venderam um total em valores abaixo de 1.000.

-- Vamos analisar agora o preço e frete dos produtos separadamente:

SELECT
	DISTINCT typeof(price)  AS tipo_variavel
FROM olist_order_items_dataset ooid
-- Aqui verificamos o tipo de variável de forma distinta, para verificar se não existe um erro na captação dos dados.

SELECT
	DISTINCT typeof(freight_value) AS tipo_variavel
FROM olist_order_items_dataset ooid
-- Realizamos o mesmo processo para as duas variáveis numéricas.

SELECT
	COUNT(price) AS qtd_vendida, 
	MAX(price) AS preco_maximo,
	MIN(price) AS preco_minimo,
	(MAX(price) - MIN(price)) AS amplitude,
	ROUND(AVG(price),2) AS media,
	MEDIAN(PRICE) AS mediana,
	ROUND(STDEV(PRICE),2) AS desvio_padrao
FROM olist_order_items_dataset ooid
-- Analisamos então a quantidade vendida, valores máximos e mínimos, amplitude, media, mediana e desvio padrão dos preços.
-- Podemos identificar de forma prévia, que existe uma distribuição assimétrica com concentração à esquerda.

-- Para finalizar, calculamos a moda:
SELECT 
	price,
	count(*) AS frequencia
FROM olist_order_items_dataset ooid 
GROUP BY price
ORDER BY frequencia DESC
LIMIT 1
-- Através da moda, identificamos que a variável price é unimodal e seu valor é 59,90.

-- Agora analisando o frete:
SELECT
	COUNT(*),
	MAX(freight_value) AS maximo_frete,
	MIN(freight_value) AS minimo_frete,
	(MAX(freight_value) - MIN(freight_value)) AS amplitude, 
	AVG(freight_value) AS media,
	MEDIAN(freight_value) AS mediana,
	STDEV(freight_value) AS desvio_padrao
FROM olist_order_items_dataset ooid

SELECT
	freight_value,
	COUNT(*) AS frequencia
FROM olist_order_items_dataset ooid
GROUP BY freight_value
ORDER BY frequencia DESC
LIMIT 1
-- Identificamos que a variável freight é unimodal, e seu valor é 15,10.

