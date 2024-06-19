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
	strftime('%Y-%m', order_approved_at) as ano_mes,
	count(order_approved_at)
FROM olist_orders_dataset ood
GROUP BY ano_mes
ORDER BY ano_mes ASC;

SELECT
    COUNT(*) AS total_linhas,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS nulos,
    SUM(CASE WHEN typeof(order_delivered_carrier_date) <> 'text' OR TRIM(order_delivered_carrier_date) = '' THEN 1 ELSE 0 END) AS valores_invalidos
FROM olist_orders_dataset ood;

SELECT
	COUNT(*)
FROM olist_orders_dataset ood
WHERE order_delivered_carrier_date = ''
-- Aqui identificamos 1.783 valores faltantes ou diferentes de texto.

-- E identificamos quais são essas linhas
SELECT
	DISTINCT order_status,
	count (*) AS contagem_pedidos
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
	CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset) AS DECIMAL) AS perc_total,
	SUM(CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset) AS DECIMAL)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS freq_acumulada
FROM olist_order_payments_dataset oopd
GROUP BY parcelamentos
ORDER BY contagem DESC
--Podemos identificar que a forma de pagamento mais utilizada é "à vista" (ou em parcela única), representando aproximadamente 50% dos pagamentos


-- Agora vamos analisar a coluna de pagamentos (payment_value):
SELECT
	payment_type,
	count(*) qtd_por_tipo,
	CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset) AS DECIMAL) AS perc_total,
	SUM(payment_value) AS total_pagamentos,
	CAST(SUM(payment_value) * 1.0 / (SELECT SUM(payment_value) FROM olist_order_payments_dataset) AS DECIMAL) AS perc_total_pagamentos
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
	AVG(payment_value) AS media_pagamentos,
	MEDIAN(payment_value) AS mediana_pagamentos,
	STDEV(payment_value) AS desvio_padrao_pagamentos
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
	AVG(payment_value) AS media_pagamentos,
	MEDIAN(payment_value) AS mediana_pagamentos,
	STDEV(payment_value) AS desvio_padrao_pagamentos
FROM olist_order_payments_dataset oopd
GROUP BY payment_type
-- Em todos os tipos de pagamento é possível notar a média e mediana muito próximas e uma concentração dos dados muito próximas aos valores mínimos.


-- Para calcular a moda:
SELECT 
	payment_type,
	payment_value,
	count(*) AS frequencia
FROM olist_order_payments_dataset oopd
GROUP BY payment_type, payment_value
ORDER BY frequencia DESC
-- Aqui identificamos que os pagamentos que mais aparecem são vouchers no valor de 50, seguidos por vouchers de 20 e 100.
-- Removendo os Vouchers, o pagamento mais comum é de 77,57 no cartão de crédito.