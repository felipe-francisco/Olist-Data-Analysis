-- Produtos (entregues) mais vendidos:

SELECT 
	ooid.product_id as produto,
	COUNT(*) as qtd__vendida 
FROM olist_order_items_dataset ooid
LEFT JOIN olist_orders_dataset ood
	ON  ooid.order_id = ood.order_id
WHERE ood.order_status = 'delivered'
GROUP BY produto
ORDER BY qtd__vendida DESC;
/*
-- A query retorna um agrupamento dos product_id's e uma contagem do total de linhas da tabela order_itens, quando na tabela de pedidos, o status dos pedidos for entregue.
-- Ao final ordenamos do com maior quantidade para o com menor.
 */


-- Receita mensal total ao longo do tempo:
SELECT 
	strftime('%Y-%m', ood.order_delivered_customer_date) as ano_mes,
	SUM(oopd.payment_value) as total_faturamento
FROM olist_orders_dataset ood
LEFT JOIN olist_order_payments_dataset oopd
	ON ood.order_id = oopd.order_id
WHERE order_status = 'delivered' AND payment_type <> 'voucher' AND ood.order_delivered_customer_date <> ''
GROUP BY ano_mes
ORDER BY ano_mes ASC;
/*
-- Primeiramente realizamos um left join pelos order_id's presentes na tabela olist_orders_dataset e na olist_order_payments_dataset que retornará apenas os pedidos com order_status 'delivered' e payment_type diferente de voucher.
(A escolha foi devido ao voucher ser algum cupom de desconto, credito recebido de cancelamentos ou outro tipo de pagamento que não é considerado um recebimento).
-- Aqui foi utilizada a função strftime para extrair o ano-mês da coluna que possui a data de entrega no cliente e os valores iguais agrupados, realizando uma espécie de truncamento da data.
-- A segunda coluna trará uma soma dos pagamentos.
-- O ano_mes de venda foi então ordenado do maior para o menor.
 */


-- Categorias que geram mais receita:
SELECT
	opd.product_category_name as categoria_produto,
	SUM(oopd.payment_value) as total_faturamento,
	ROUND(SUM(oopd.payment_value) / 
		(SELECT 
			SUM(payment_value) 
		FROM olist_products_dataset opd
		LEFT JOIN olist_order_items_dataset ooid
			ON opd.product_id = ooid.product_id
			LEFT JOIN olist_orders_dataset ood
				ON ooid.order_id = ood.order_id
					LEFT JOIN olist_order_payments_dataset oopd 
					ON ood.order_id = oopd.order_id
		WHERE ood.order_status = 'delivered' AND oopd.payment_type <> 'voucher'
			) * 100, 2) perc_total,
	ROUND(SUM(SUM(oopd.payment_value)/
		(SELECT 
			SUM(payment_value) 
		FROM olist_products_dataset opd
		LEFT JOIN olist_order_items_dataset ooid
			ON opd.product_id = ooid.product_id
			LEFT JOIN olist_orders_dataset ood
				ON ooid.order_id = ood.order_id
					LEFT JOIN olist_order_payments_dataset oopd 
					ON ood.order_id = oopd.order_id
		WHERE ood.order_status = 'delivered' AND oopd.payment_type <> 'voucher'
			)) OVER(ORDER BY SUM(payment_value) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4)*100 AS freq_acumulada
FROM olist_products_dataset opd
LEFT JOIN olist_order_items_dataset ooid
	ON opd.product_id = ooid.product_id
	LEFT JOIN olist_orders_dataset ood
		ON ooid.order_id = ood.order_id
		LEFT JOIN olist_order_payments_dataset oopd 
			ON ood.order_id = oopd.order_id
WHERE 
	ood.order_status = 'delivered' AND 
	oopd.payment_type <> 'voucher'
GROUP BY categoria_produto
ORDER BY total_faturamento DESC;

/*
-- Aqui foram realizados 3 left joins para conseguir as informações dos produtos e dos pagamentos, devido ao fato de que a tabela de produtos não ser diretamente relacionada com a tabela de pagamentos.
-- Foi realizado também um filtro para retornar apenas os valores com o status entregues e o pagamento diferente de voucher.
-- O cálculo para extrair a percentual do faturamento total foi extraído dividindo a soma proporcional (agrupada pela categoria do produto) da soma total do produto (que é a soma dos pagamentos considerando os filtros
e joins aplicados na query principal).
-- Poderia ter sido realizada uma CTE para utilizar nos 3 casos, mas aqui foi apresentado desta forma com alternativa.
-- Ao final, ordenamos pelo que apresenta um somatório maior.
 */


-- Sazonalidade nas vendas:
WITH dados_vendas AS (
    SELECT 
        strftime('%Y-%m', ood.order_delivered_customer_date) AS ano_mes,
        strftime('%Y', ood.order_delivered_customer_date) AS ano,
        strftime('%m', ood.order_delivered_customer_date) AS mes,
        COUNT(*) AS qtd_vendas,
        SUM(oopd.payment_value) AS total_faturamento,
        ROUND(SUM(oopd.payment_value) / COUNT(*), 2) AS ticket_medio
    FROM olist_orders_dataset ood
    LEFT JOIN olist_order_payments_dataset oopd
        ON ood.order_id = oopd.order_id
    WHERE 
    	order_status = 'delivered' AND 
    	payment_type <> 'voucher' AND 
    	ood.order_delivered_customer_date <> ''
    GROUP BY ano_mes
    ORDER BY ano_mes
)
SELECT
    ano,
    mes,
    qtd_vendas,
    total_faturamento,
    ticket_medio,
    RANK() OVER(PARTITION BY ano ORDER BY total_faturamento DESC) AS ranking_vendas
FROM dados_vendas
ORDER BY ranking_vendas;
/*
-- A CTE irá utilizar dados presentes na tabela olist_orders_dataset e na olist_order_payments_dataset, para isto usamos o left join unindo o resultado pelo order_id presente nas duas tabelas.
-- O filtro no where retornará pagamentos com order_status entregue, payment_type diferente de voucher, e data de entrega preenchida (diferente de vazio).
-- A data foi extraida através da função strftime e agrupada pelo group by.
-- Na segunda coluna foi extraido o ano através da função strftime.
-- Na terceira coluna foi extraido o mês através da função strftime.
-- A quarta coluna retorna uma contagem simples do total de linhas.
-- A quinta coluina retorna uma soma do valor de pagamento.
-- A sexta coluna retorna o total faturado (soma do payment_value) dividido pela qtd_vendas (contagem de linhas totais), arredondados pela função round em 2 casas decimais.
-- Ao final, ordenamos pelo ano/mês do menor para o maior (padrão quando não especificado o argumento).

-- Na query principal, retornamos da CTE as colunas: ano, mes, qtd_vendas, total_faturamento e ticket_medio.
-- Para criar um ranking dos meses com maiores vendas de acordo com cada ano, utilizamos a função rank que realiza um raking baseado em algumas condições. Foi utilizada então a window function over e o partition by para
separar o rankeamento pelo ano, ordenando pelo total de faturamento do maior para o menor.
(A opção pela função rank ao invés da row_number ou dense_rank é devido à probabilidade de haver meses com faturamentos iguais. A função rank categorizaria os valores iguais na mesma colocação e deixaria a próxima
posição em aberto, considerando novamente o ranking a partir da colocação a seguir).
 */

-- Onde moram os clientes?
SELECT
	customer_state,
	count(*) as qtd_clientes
FROM olist_customers_dataset ocd
GROUP BY customer_state
ORDER BY qtd_clientes DESC;
/*
-- A query retornará um agrupamento pelo estado do cliente e uma contagem simples da quantidade de linhas.
-- Após o order by realizará o ordenamento do maior para o menor de acordo com a quantidade de linhas.
 */

SELECT
	customer_city,
	count(*) as qtd_clientes
FROM olist_customers_dataset ocd
GROUP BY customer_city
ORDER BY qtd_clientes DESC;
/*
-- A query retornará um agrupamento pela cidade do cliente e uma contagem simples da quantidade de linhas.
-- Após o order by realizará o ordenamento do maior para o menor de acordo com a quantidade de linhas.
 */


-- Valor médio de um pedido por cliente:
WITH pagamentos_unificados as (
	SELECT
		order_id,
		SUM(payment_value) AS total_pagamentos
	FROM olist_order_payments_dataset oopd 
	WHERE payment_type <> 'voucher'
	GROUP BY order_id
)
SELECT
	ocd.customer_unique_id,
	AVG(pu.total_pagamentos) valor_medio 
FROM olist_customers_dataset ocd
LEFT JOIN olist_orders_dataset ood
	ON ocd.customer_id = ood.customer_id
	LEFT JOIN pagamentos_unificados pu
		ON ood.order_id = pu.order_id
GROUP BY ocd.customer_unique_id
ORDER BY valor_medio DESC;
/*
-- Como cada pagamento realizado por formas diferente gerava uma nova linha com o mesmo order_id, a CTE foi criada para somar os valores pagos e agrupar pelo order_id. Na CTE foi inserido também um filtro para
retornar apenas pagamentos não realizados por voucher.
-- O left join unirá a tabela com dados dos clientes (customers_dataset) com a tabela com dados dos pedidos (orders_dataset), por fim esta será unida com a CTE criada com os pagamentos unificados da tabela de 
pagamentos (order_payments_dataset).
-- A query principal irá retornar o customer_unique_id (da tabela com dados do cliente) e a media de pagamentos do total de pagamentos (coluna calculada extraída da CTE), onde será realizado um ordenamento desta
média da maior para a menor.
 */


-- Qual é a taxa de recompra dos clientes?
WITH primeira_compra AS (
	SELECT
		customer_id,
		min(date(order_purchase_timestamp)) AS primeira_compra
	FROM olist_orders_dataset ood2
	WHERE 
		order_status <> 'canceled' AND
		order_status <> 'unavailable' 
	GROUP BY customer_id
)
SELECT
	ood.customer_id,
	(date(ood.order_purchase_timestamp) <> pc.primeira_compra) AS compra_recorrente,
	COUNT(*) contagem
FROM olist_orders_dataset ood
LEFT JOIN primeira_compra AS pc
	ON ood.customer_id = pc.customer_id
GROUP BY ood.customer_id, compra_recorrente
ORDER BY contagem DESC;
/*
-- A CTE irá realizar um filtro na tabela orders_dataset retornando apenas os valores com status diferente de cancelado e indisponível.
-- Na segunda coluna, a data/hora de compra foi convertida para data com a função date e extraímos então a menor data do pedido, ou seja, a primeira compra.

-- Na query principal o left join une a tabela original com a CTE que retorna o id e a data da primeira compra.
-- Agrupamos então o resultado pelo id do cliente e pela compra recorrente. A coluna compra recorrente retorna 1 se a data da compra da linha em questão for diferente da data da primeira compra, 0 se for igual e NULL se
o status da compra for cancelada ou indisponível.
-- Ao final, ordenamos pela contagem de compras.
*/



-- Qual é o tempo médio de entrega dos pedidos?
WITH datas_tratadas AS (
	SELECT
		order_id,
		customer_id,
		date(order_approved_at) AS order_approved_at,
		date(order_estimated_delivery_date) AS order_estimated_delivery_date,
		date(order_delivered_customer_date) AS order_delivered_customer_date,
		CAST(julianday(order_delivered_customer_date) - julianday(order_approved_at) AS INTEGER) AS dif_dias_aprovacao_entrega,
		julianday(date(order_delivered_customer_date)) - julianday(date(order_estimated_delivery_date)) AS dif_dias_estimativa_entrega
	FROM olist_orders_dataset ood
	WHERE ood.order_status = 'delivered'
)
SELECT
	AVG(dif_dias_aprovacao_entrega) AS media_dif_aprovacao_entrega,
	AVG(dif_dias_estimativa_entrega) AS media_dif_dias_estimativa_entrega
FROM datas_tratadas AS dt;
/*
-- A CTE retorna uma tabela filtrada com o order_status entregue, order_id, customer_id e formatação de dados nas colunas order_approved_at, order_estimated_delivery_date e order_delivered_customer_date.
-- Na sexta coluna, a data de entrega (order_delivered_customer_date) foi diminuída da data de aprovação do pedido (order_approved_at), ambas formatadas para datas julianas (para extrair a contagem de dias), convertidas para
o tipo inteiro pela função cast(pois como as colunas tinham data e hora, a contagem seria prejudicada caso não houvesse tratamento).
-- Na sétima coluna, a função cast não foi utilizada pois não existiam horarios diferentes as colunas, sendo assim apenas foi extraída a data juliana e os valores diminuídos.

-- A querie principal irá retornar 2 colunas, uma com a diferença média de dias entre a data de aprovação e entrega e a segunda coluna retornará a diferença de dias entre a data estimada da entrega e a data efetiva da entrega.
 */



-- Quais são as regiões com maior tempo de entrega?
WITH datas_tratadas AS (
	SELECT
		order_id,
		customer_id,
		date(order_approved_at) AS order_approved_at,
		date(order_estimated_delivery_date) AS order_estimated_delivery_date,
		date(order_delivered_customer_date) AS order_delivered_customer_date,
		CAST(julianday(order_delivered_customer_date) - julianday(order_approved_at) AS INTEGER) AS dif_dias_aprovacao_entrega
	FROM olist_orders_dataset ood
	WHERE ood.order_status = 'delivered'
)
SELECT
	customer_state,
	FLOOR(AVG(dif_dias_aprovacao_entrega)) AS tempo_medio_entrega
FROM olist_customers_dataset ocd
LEFT JOIN datas_tratadas AS dt
	ON ocd.customer_id = dt.customer_id
GROUP BY customer_state
ORDER BY tempo_medio_entrega DESC;
/*
-- A CTE retorna uma tabela filtrada com o order_status entregue, order_id, customer_id e formatação de dados nas colunas order_approved_at, order_estimated_delivery_date e order_delivered_customer_date.
-- Na sexta coluna, a data de entrega (order_delivered_customer_date) foi diminuída da data de aprovação do pedido (order_approved_at), ambas formatadas para datas julianas (para extrair a contagem de dias), convertidas para
o tipo inteiro pela função cast(pois como as colunas tinham data e hora, a contagem seria prejudicada caso não houvesse tratamento).

-- A query principal retorna um agrupamento dos estados e uma média da coluna que calculava a diferença de dias entre a aprovação e a entrega, arredondados para baixo pela função floor (pois o dia não completo não pode ser
considerado).
-- Ao final, ordenamos do maior para o menor tempo medio de entrega.
 */


-- Qual é a taxa de atrasos nas entregas?
WITH entregas_tratadas AS (
	SELECT
		order_id,
		CASE
			WHEN julianday(date(order_delivered_customer_date)) - julianday(date(order_estimated_delivery_date)) < 0 THEN 'Antecedência'
			WHEN julianday(date(order_delivered_customer_date)) - julianday(date(order_estimated_delivery_date)) = 0 THEN 'Data Exata'
			ELSE 'Atraso'
		END AS 'status_entrega'
	FROM olist_orders_dataset ood
	WHERE ood.order_status = 'delivered'
)
SELECT
	ROUND(SUM(CASE WHEN status_entrega = 'Atraso' THEN 1 ELSE 0 END) * 1.0 / count(*),4) * 100 AS percent_atraso
FROM entregas_tratadas;
/*
-- Na CTE utilizamos um filtro para retornar apenas os pedidos com order_status entregue.
-- O case when foi usado para definir quando uma entrega foi realizada com antencedência, na data exata ou com atraso. A função verifica se a quantidade de dias corridos do order_delivered_customer_date subtraidosda 
quantidade de dias corridos do order_estimated_delivery_date é menor que 0 (nagativo), igual a zero ou qualquer outro (que neste caso seria maior ou igual a 1).
 
 -- A query principal vai utilizar a CTE e realizar alguns cálculos:
 	-- Primeiro, o case when vai verificar se o status de entrega é atrasado e definir o resultado como 1, os demais serão 0. A função SUM vai somar todos estes resultados 1.0 para convereter para um número decimal.
 	-- O valor desta soma será dividido pela subquery que retornará o total de linhas totais, com pedidos de qualquer status de entrega.
 	-- O total será arredondado para 4 casas decimais.
 	-- Tudo será multiplicado por 100 para apresentar em %.
*/

-- Quais são os métodos de pagamento mais utilizados?
SELECT
	payment_type,
	count(*) AS contagem_pagamentos,
	ROUND(COUNT(*) * 1.0 / (SELECT count(*) FROM olist_order_payments_dataset),4)* 100 AS perc_total,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4)*100 AS freq_acumulada
FROM olist_order_payments_dataset oopd
GROUP BY payment_type
ORDER BY contagem_pagamentos DESC;
/*
-- A query retornará um agrupamento pelo payment_type e um cálculo da contagem de linhas de acordo com o payment_type, multiplicados por 1.0 (para se tornar decimal), dividido pela quantidade total de linhas (retornadas da subquery),
arredondadas para 4 casas decimais pela função round e multiplicadas por 100 para ser apresentada em %.
 */


-- Qual é a taxa de cancelamento de pedidos por método de pagamento?
WITH pedidos_cancelados_filtrados AS (
	SELECT
		*
	FROM olist_order_payments_dataset oopd
	LEFT JOIN olist_orders_dataset ood
		ON oopd.order_id = ood.order_id
	WHERE order_status = 'canceled'
)
SELECT
	payment_type,
	COUNT(*) AS contagem_pagamentos,
	ROUND(COUNT(*) * 1.0 / (SELECT count(*) FROM pedidos_cancelados_filtrados),4) * 100 AS perc_total,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM pedidos_cancelados_filtrados)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4)*100 AS freq_acumulada
FROM pedidos_cancelados_filtrados
GROUP BY payment_type
ORDER BY contagem_pagamentos DESC;
/*
-- A CTE retorna todas as colunas da tabela payments_dataset unida com a tabela orders_dataset pelo order_id, quando o order_status for cancelado.

 -- A query principal vai utilizar a CTE para retornar e realizar um agrupamento pela coluna payment_type, um cálculo da contagem de linhas de acordo com o payment_type, multiplicados por 1.0(para se tornar decimal), 
 dividido pela quantidade total de linhas (retornadas da subquery), arredondadas para 4 casas decimais pela função round e multiplicadas por 100 para ser apresentada em %.
 */

--Qual é a média de avaliação dos produtos pelos clientes?
SELECT
	avg(review_score) media_avaliacoes
FROM olist_order_reviews_dataset oord
WHERE review_score IN (1,2,3,4,5);
/*
-- A query realiza um filtro nos review_score's retornando as apenas valores que forem de 1 a 5. É extraída então uma média destes review_score's filtrados.
 */