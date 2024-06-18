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
	count(*) as contagem_pedidos
FROM olist_orders_dataset ood
GROUP BY order_status;
-- Foram encontradas 8 categorias distintas


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
-- Aqui identificamos 1.783 valores faltantes ou diferentes de texto.

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
-- A última venda realizada e enttregue foi realizada em 29/08/2018.



-- Agora vamos analisar a tabela que possui dados dos pagamentos:
SELECT
	count(*) as contagem_linhas,
	count(DISTINCT order_id) contagem_destinta_ids,
	COUNT(*) - count(DISTINCT order_id) as diferenca_linhas
FROM olist_order_payments_dataset oopd;
-- Aqui já podemos identificar que o order_id não é um identificador único. Algumas compraS apresentam o mesmo ID do pedido.
-- No total identificamos uma diferença de 4.446.

SELECT
	order_id,
	COUNT(*)
FROM olist_order_payments_dataset oopd 
GROUP BY order_id
HAVING COUNT(*) > 1
-- E aqui verificamos quais são estes registros.