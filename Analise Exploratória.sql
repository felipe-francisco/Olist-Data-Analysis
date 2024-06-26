/*
*********************************
Análise da Tabela orders_dataset:
*********************************
*/

--Verificar se os id's dos pedidos e clientes são únicos:
SELECT
	COUNT(*) as contagem_linhas,
	COUNT(DISTINCT order_id) contagem_destinta_ids,
	COUNT(DISTINCT customer_id) contagem_destinta_clientes
FROM olist_orders_dataset ood;
/*
-- Realizada a contagem de linhas, contagem distinta de id's e de clientes utilizando a função DISTINCT.
*/


-- Verificar quantas categorias existem na coluna order_status, quantos pedidos estão presentes em cada categoria e o percentual do total:
SELECT 
	order_status AS categorias,
	COUNT(*) as contagem_pedidos,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_orders_dataset ood),4) AS perc_total
FROM olist_orders_dataset ood
GROUP BY categorias
ORDER BY contagem_pedidos DESC;
/*
-- Foi realizado um agrupamento pelo order_status (nomeado categorias), onde cada linha mostrará a quantidade de itens de acordo com a categoria e a porcentagem que representa do total de itens.
-- Para calular a porcentagem, foi utilizada a contagem de linhas por categoria (multiplicada por 1.0 para retornar em decimal), dividida por uma subquerie que retorna o total de linhas. 
-- Foi utilizada a função ROUND para arredondar os número para 4 casas decimais depois da vírgula.
-- Ao final, ordenamos pela quantidade de pedidos.
*/

-- Verificar se todos os dados da coluna de data são do tipo data, ou se existe algum valor nulo ou vazio:
SELECT
    COUNT(*) AS total_linhas,
    SUM(CASE 
	    	WHEN order_purchase_timestamp IS NULL THEN 1 
    		ELSE 0 
    	END) AS nulos_purchase,
    SUM(CASE
	    	WHEN typeof(order_purchase_timestamp) <> 'text' OR TRIM(order_purchase_timestamp) = '' THEN 1
	   		ELSE 0 
	    END) AS valores_invalidos_purchase,
    SUM(CASE
	    	WHEN order_approved_at IS NULL THEN 1
	    	ELSE 0 
	    END) AS nulos_approved,
    SUM(CASE
	    	WHEN typeof(order_approved_at) <> 'text' OR TRIM(order_approved_at) = '' THEN 1
	    	ELSE 0
	    END) AS valores_invalidos_approved,
    SUM(CASE 
		    WHEN order_delivered_carrier_date IS NULL THEN 1 
		    ELSE 0 
	    END) AS nulos_delivered_carrier,
    SUM(CASE
		    WHEN TYPEOF(order_delivered_carrier_date) <> 'text' OR TRIM(order_delivered_carrier_date) = '' THEN 1 
		    ELSE 0
	    END) AS valores_invalidos_delivered_carrier,
	        SUM(CASE 
	    	WHEN order_delivered_customer_date IS NULL THEN 1 
	    	ELSE 0 
	    END) AS nulos_order_delivered_customer_date,
    SUM(CASE 
	    	WHEN typeof(order_delivered_customer_date) <> 'text' OR TRIM(order_delivered_customer_date) = '' THEN 1
	    	ELSE 0
	    END) AS valores_invalidos_order_delivered_customer_date,
    SUM(CASE
	    	WHEN order_estimated_delivery_date IS NULL THEN 1
	    	ELSE 0 
	    END) AS nulos_order_estimated_delivery_date,
    SUM(CASE
	    	WHEN typeof(order_estimated_delivery_date) <> 'text' OR TRIM(order_estimated_delivery_date) = '' THEN 1
	    	ELSE 0 
	    END) AS valores_invalidos_eorder_estimated_delivery_date
FROM olist_orders_dataset ood;
/*
-- Foram filtrados os valores Nulos que possam existir na coluna utilizando um 'Case When' que retorna 1 se o valor for nulo e 0 se o valor for não nulo, se não existir nenhum valor nulo a query retornará 0. Somamos a quantidade de 1.
-- Utilizamos o mesmo padrão no segundo e quarto 'Case When', utilizando a função 'TRIM' para remover espaços vazios no inicio ou final da linha da coluna, e depois verificamos se ela é diferente de texto ou se possui espaços vazios.
-- Geralmente as datas no SQLite são armazenadas como strings com o formato 'YYYY-MM-DD HH:MM:SS', por este motivo a utilização da função diferente de texto.
*/

/*
-- Uma outra possibilidade é agrupar pelo mês/ano e caso não haja uma data ou a query não consiga converter utilizando o 'strftime', aprecerá Nulo.
	SELECT 
		STRFTIME('%Y-%m', order_approved_at) as ano_mes,
		COUNT(order_approved_at) AS contagem_approved
	FROM olist_orders_dataset ood
	GROUP BY ano_mes
	ORDER BY ano_mes ASC;

--E uma outra possibilidade é procurar por valores vazios utilizando o where:
	SELECT
		COUNT(*) AS contagem_pedidos
	FROM olist_orders_dataset ood
	WHERE order_approved_at = ''
*/

-- Identificando qual o status dos valores da tabela quando o approved_at está vazio:
SELECT
	order_status,
	COUNT(*) AS contagem_pedidos
FROM olist_orders_dataset ood
WHERE order_approved_at = ''
GROUP BY order_status
ORDER BY contagem_pedidos DESC;
/*
-- Foram filtardos os valores vazios, e a contagem agrupada pelo order_status
*/


-- Com relação à coluna com a data da entrega do pedido à transportadora:
SELECT
	COUNT(*)
FROM olist_orders_dataset ood
WHERE order_delivered_carrier_date = ''
/*
-- Realizada uma contagem de linhas da coluna order_delivered_carrier_date para descobrir a quantidade de valores vazios.
 */

-- Aqui identificamos quais são essas linhas vazias:
SELECT
	order_status AS categorias,
	COUNT(*) AS contagem_pedidos
FROM olist_orders_dataset ood
WHERE order_delivered_carrier_date = ''
GROUP BY categorias
ORDER BY contagem_pedidos DESC;
/*
-- Agrupando a contagem de pedidos quando a data de entrega na transportadora for vazia pelo order-status para encontrar a categoria de cada valor vazio.
*/

-- Identificar quais são os 2 valores com data de entrega na transportadora vazia e com status do pedido entregue:
SELECT 
	*
FROM olist_orders_dataset ood
WHERE 
	order_delivered_carrier_date = '' AND
	order_status IN('delivered');
/*
-- Realizada uma query que retorna todas as linhas quando a data da entrega na transportadora for vazia e o status do pedido for entregue
*/

-- Data da primeira e última venda realizada:
SELECT
	*
FROM olist_orders_dataset ood
WHERE order_purchase_timestamp = (
	SELECT 
		MIN(order_purchase_timestamp) 
	FROM olist_orders_dataset ood
	WHERE order_status = 'delivered'
	);
/*
-- Foi criada uma subquery no WHERE com um filtro para pegar apenas a primeira venda realizada que foi entregue.
-- Se a base for atualizada e uma data anterior de venda entregue for inserida, a query retornará o valor correto pois está automatizada.
*/

SELECT
	*
FROM olist_orders_dataset ood
WHERE order_purchase_timestamp = (
	SELECT 
		MAX(order_purchase_timestamp)
	FROM olist_orders_dataset ood 
	WHERE order_status = 'delivered'
	);
/*
-- Foi criada uma subquery no WHERE com um filtro para pegar apenas a última venda realizada que foi entregue.
-- Se a base for atualizada e uma data posterior de venda entregue for inserida, a query retornará o valor correto pois está automatizada.
*/


/*
***********************************************
Análise da Tabela olist_order_payments_dataset:
***********************************************
*/

-- Verificar se cada order_id é único:
SELECT
	count(*) as contagem_linhas,
	count(DISTINCT order_id) contagem_destinta_ids,
	COUNT(*) - count(DISTINCT order_id) as diferenca_linhas
FROM olist_order_payments_dataset oopd;
/*
-- Conforme a explicação do DataSet, pagamentos que são realizados diferentes formas de pagamento criam sequencias, assim o order_id se repetirá sempre que houver esta sequência.
-- A query retorna uma contagem de linhas simples, uma contagem distinta de order_id e uma subtração entre a contagem de linhas e contagem de order_id distintos.
*/

-- Verificar quais são os pedidos que foram realizados com diferentes formas de pagamento:
SELECT
	order_id,
	COUNT(*) as registros_duplicados
FROM olist_order_payments_dataset oopd 
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY registros_duplicados DESC;
/*
-- A query retorna o order_id e uma contagem de linhas agrupadas pelo order_id, assim todos os pedidos com order_id repetidos seram agrupados e contados. Utilizamos o comando HAVING para filtrar no agrupamento os order_id's maiores que 1.
-- O order_by ordena a quantidade de registros duplicados do maior para o menor.
*/ 

-- Analisar um dos order_id's duplicados: 
SELECT
	*
FROM olist_order_payments_dataset oopd 
WHERE order_id = '465c2e1bee4561cb39e0db8c5993aafc';
/*
-- A Query retorna todas as linhas quando o order_id for igual a determinado id inserido no filtro.
*/


-- Verificar a quantidade de tipos de pagamentos distintos foram realizadas:
SELECT 
	payment_type,
	COUNT(*) AS contagem
FROM olist_order_payments_dataset oopd
GROUP BY payment_type;
/*
-- A query retorna os payment_type's, e uma contagem de todas as linhas agrupados pelos payment_types, permitindo saber quantos tipos de pagamentos existem e sua quantidade.
*/ 


-- Valor pago de acordo com o pedido (maior para o menor valor):
SELECT
	order_id,
	SUM(payment_value) valor_total
FROM olist_order_payments_dataset oopd
GROUP BY order_id
ORDER BY valor_total DESC;
/*
-- A query retorna or order_id's agrupados e uma soma do payment_value.
-- O order_by ordena os pedidos com o valor total do payment_value do maior para o menor.
*/

-- Valor pago de acordo com o pedido (menor para o maior valor):
SELECT
	order_id,
	SUM(payment_value) valor_total
FROM olist_order_payments_dataset oopd
GROUP BY order_id
ORDER BY valor_total;
/*
-- A query retorna or order_id's agrupados e uma soma do payment_value.
-- O order_by sem o comando posterior, por padrão orderna do menor para o maior. Os pedidos foram ordenados então do menor para o maior.
*/


--Identificando os payment_values com valores zerados:
SELECT
	*
FROM olist_order_payments_dataset oopd
LEFT JOIN olist_orders_dataset ood
	ON oopd.order_id = ood.order_id
WHERE payment_value = 0;
/*
-- A query retorna todas as colunas da tabela olist_order_payments_dataset e da olist_orders_dataset onde na tabela olist_orders_dataset os dados não forem nuloes. Foi utilizada a coluna order_id em comum entre as duas tabelas.
-- O comando Where filtra os resultados da query retornando apenas os valores iguais a 0.
*/

-- Analisar os pagamentos pela quantidade de parcelamentos: 
SELECT
	payment_installments AS parcelamentos,
	COUNT(*) AS contagem,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset),4) AS perc_total,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_order_payments_dataset oopd
GROUP BY parcelamentos
ORDER BY contagem DESC;
/*
-- Nesta query, realizamos um agrupamento pelo payment_installments (parcelamentos), juntamente com uma contagem do total de linhas.
-- Em seguida, utilizamos a subquery em 2 contextos:
	-- No primeiro contexto foi realizada uma contagem de linhas, multiplicando este valor por 1.0 para se tornar decimal. Dividimos então este valor da quantidade de linhas gerais trazida pela subquery, resultando na porcentagem
	que a categoria representa. A função CAST vai fomatar todo o valor para decimal, e a função ROUND arredondar para 4 casas decimais, tornando o valor mais visível.
	-- No segundo contexto foi realizada o mesmo processo, porém com o comando SUM e a window function OVER. O comando SUM vai somar todas as porcentagens criando um total acumulado, e o comando OVER define a ordem das linhas para
	aplicar o cálculo, ordernado pela contagem das linhas de forma decrescente, entre a primeira linha e a linha atual da tabela. A função ROUND vai arredondar para 4 casas decimais, 
	tornando o valor mais visível.
-- O order by irá ordernar a contagem dos parcelamentos do maior para o menor em relação a quantidade.
*/


-- Analisar a quantidade de pagamentos por payment_type:
SELECT
	payment_type,
	count(*) qtd_por_tipo,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset),2) AS perc_total,
	SUM(payment_value) AS total_pagamentos,
	ROUND(SUM(payment_value) * 1.0 / (SELECT SUM(payment_value) FROM olist_order_payments_dataset),4) AS perc_total_pagamentos
FROM olist_order_payments_dataset oopd
GROUP BY payment_type
ORDER BY qtd_por_tipo DESC;
/*
-- A query retorna um agrupamento pelo payment_type e uma contagem dos valores.
-- Em seguida a terceira coluna retorna o percentual que cada payment_type (utilizando o mesmo preceito da query anterior).
-- É realizada uma soma do total de payment_value's e por último o percentual que cada soma do payment_value por payment_type representa do total.
-- Ao final ordenamos pelo payment_type do que possui maior frequência para o com menor frequência.
 */


-- Calculando o valor máximo, mínimo, amplitude, media e mediana do payment_value:
SELECT
	MAX(payment_value) AS valor_maximo_pedido,
	MIN(payment_value) AS valor_minimo_pedido,
	MAX(payment_value) - MIN(payment_value) AS amplitude_pedido,
	ROUND(AVG(payment_value),2) AS media_pagamentos,
	MEDIAN(payment_value) AS mediana_pagamentos,
	round(STDEV(payment_value),2) AS desvio_padrao_pagamentos
FROM olist_order_payments_dataset oopd;
/*
-- A query retorna algumas medidas de tendência central e dispersão.
-- Na primeira coluna, retornará o valor máximo.
-- Na segunda coluna, retornará o valor mínimo.
-- Na terceira coluna a Amplitude, representada pelo valor máximo diminuindo o valor mínimo.
-- Na quarta couluna, extraimos a média com a função AVG, arredondando o resultado con a função ROUND para 2 casas decimais depois da virgula.
-- Na quinta coluna, a mediana com a função MEDIAN.
-- Na última coluna,o desvio padrão representado pela função STDVE, arredondado pela função ROUND para 2 casas decimais depois da virgula.
 */


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
GROUP BY payment_type;
/*
-- O mesmo processo da query anterior foi realizado, porém agora agrupando os resultados de acordo com o payment_type.
 */

-- Continuando a análise da coluna de pagamentos, vamos extrair algumas medidas de tendência central e dispersão:
SELECT
	payment_installments AS numero_parcelas,
	count(*) qtd_pagamentos,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset),4) AS perc_total,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada,
	MIN(payment_value) AS pagamento_minimo,
	MAX(payment_value) AS pagamento_maximo,
	ROUND(AVG(payment_value), 2) AS media_de_pagamentos,
	ROUND(MEDIAN(payment_value),2) AS mediana,
	ROUND(STDEV(payment_value),2) AS desvio_padrao_pagamentos
FROM olist_order_payments_dataset oopd
GROUP BY numero_parcelas;
/*
-- Utilizamos conceitos já utilizados anteriormente para extrair o percentual total, a frequência acumulada e medidas de tendência central/dispersão.
-- Entretanto, desta vez agrupamos cada medida e suas porcentagens pelo payment_installments
 */


/*
****************************************
Análise da Tabela product_category_name:
****************************************
*/

-- Verificar se cada linha representa um único product_id e a quantidade de produtos distintos presentes:
SELECT
	COUNT(*),
	COUNT(DISTINCT product_id),
	COUNT(DISTINCT product_category_name)
FROM olist_products_dataset opd;
/*
-- Realizada uma contagem de linhas simples, uma contagem de product_id distinta e de product_category_name distinta.
 */

--
SELECT
	product_category_name AS categorias,
	COUNT(product_id) AS contagem,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_products_dataset),4) AS perc_total,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_products_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_products_dataset opd
GROUP BY categorias
ORDER BY contagem DESC;
/*
-- Extraindo a frequência, frequência relativa e frequência acumulada de cada product_category_name
-- Conceitos já apresentados nas análises das tabelas anteriores.
 */


-- Analisar se existem customer_id e customer_unique_id duplicados:
SELECT
	COUNT(*) AS qtd_linhas,
	COUNT(DISTINCT customer_id) AS qtd_ids_clientes,
	COUNT(DISTINCT customer_unique_id) AS qtd_ids_cadastros_unicos
FROM olist_customers_dataset ocd;
/*
-- Conceitos já apresentados nas análises das tabelas anteriores.
-- Contagem simples de linhas, contagem de customer_id e customer_unique_id distintas
 */

-- Analisar quais sãoo os customer_unique_id's repetidos e a quantidade de repetições:
SELECT
	customer_unique_id,
	COUNT(*) as qtd_registros
FROM olist_customers_dataset
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY qtd_registros DESC;
/*
-- Conceitos já apresentados nas análises das tabelas anteriores.
-- Agrupamento por customer_unique_id, contagem de linhas e filtro pós agrupamento trazendo apenas os customer_unique_id's com valores repetidos e a quantidade de repetições.
-- Ordenação do customer_unique_id com maior quantidade de repetições para o menor.
 */


-- Analisar quantos customer_unique_id's são repetidos:
WITH cadastros_duplicados AS (
	SELECT
		customer_unique_id,
		COUNT(*) as registros_duplicados
	FROM olist_customers_dataset
	GROUP BY customer_unique_id
	HAVING COUNT(*) > 1;
)
SELECT 
	COUNT(*) AS contagem_duplicados,
	SUM(registros_duplicados) total_registros
FROM cadastros_duplicados;
/*
-- Aqui utilizamos uma CTE que irá retornar todos os customer_unique_id's repetidos e a quantidade de repetições (embora essa segunda coluna seja apenas para validação).
-- A query principal, realiza uma contagem do total de linhas da CTE, retornando a quantidade de customer_unique_id's repetidos e uma soma do total de registros, para identificar o total de linhas com repetições.
 */

-- Analisar se os customer_unique_id's estão presentes na mesma cidade e estados ou em cidades/estados distintos.
WITH cadastros_unicos AS (
	SELECT
		DISTINCT customer_unique_id AS id_unico,
		customer_city,
		customer_state
	FROM olist_customers_dataset
)
SELECT
	id_unico,
	COUNT(*) qtd_repeticoes
FROM cadastros_unicos
GROUP BY id_unico
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;
/*
-- A CTE trás apenas os customer_unique_id distintos, sua cidade e estado.
-- Com as informações da CTE, realizamos uma contagem do total de repetições que cada customer_unique_id teve, agrupando pelo id_unico (que é o customer_unique_id distinto) e filtrando os que possuirem uma contagem maior que 1
com o comando Having.
 */

-- Analisar um dos customer_unique_id's repetidos:
SELECT
	*
FROM olist_customers_dataset ocd
WHERE customer_unique_id = 'd44ccec15f5f86d14d6a2cfa67da1975';
/*
-- Filtro where básico realizado, que retorna todas as linhas desde que o customer_unique_id for o especificado.
-- O customer_unique_id utilzado foi encontrado na query anterior.
 */

--Analisar a frequência, frequência relativa e frequência acumulada:
SELECT
	customer_state,
	count(*) AS contagem,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset),4) AS perc_total,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_customers_dataset ocd
GROUP BY customer_state
ORDER BY contagem DESC;
/*
-- Utilizando conceitos abordados anteriormente, criamos uma coluna agrupada pelos estados e 3 colunas com frequências.
-- A segunda coluna é uma contagem simples de linhas, a terceira é um cálculo do percentual do total, dividindo a contagem agrupada pela contagem total retornada pela subquery, a última é a mesma porcentagem anterio, porém somada linha
a linha da primeira até a linha atual pelo window function OVER.
-- Ao final, a query foi ordenada de forma descrescente pela contagem.
 */

-- Análise por regiões:
SELECT
	CASE
		WHEN customer_state IN ('SP', 'RJ', 'MG', 'ES') THEN 'Sudeste'
		WHEN customer_state IN ('PR', 'SC', 'RS') THEN 'Sul'
		WHEN customer_state IN ('MT', 'MS', 'GO') THEN 'Centro-Oeste'
		WHEN customer_state IN ('MA', 'PI', 'CE', 'BA', 'SE', 'AL', 'PE', 'PB', 'RN') THEN 'Nordeste'
		ELSE 'Norte'
	END AS regioes,
	count(*) AS contagem,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset),4) AS perc_total,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_customers_dataset ocd
GROUP BY regioes
ORDER BY contagem DESC;
/*
-- Utilizado o case when para formatar os estados formando as regiões.
-- A segunda coluna contem os mesmos conceitos abordados anteriormente, uma contagem simples (frequência absoluta), o percentual total (frequência acumulada) e frequência acumulada.
-- Ao final, a query foi ordenada de forma descrescente pela contagem.
 */


-- Análise por cidades:
SELECT
	customer_city,
	customer_state,
	COUNT(*) AS contagem,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset),4) AS perc_total,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_customers_dataset ocd
GROUP BY customer_city
ORDER BY contagem DESC;
/*
-- A query irá retornar a cidade, o estado ao qual esta cidade pertence e a frequência absoluta, relativa e acumulada.
 */

-- Análise por capitais dos estados:
SELECT
	customer_state,
	customer_city,
	CASE
		WHEN customer_city IN ('belo horizonte', 'salvador', 'fortaleza', 'joao pessoa', 'sao luis', 'maceio', 'aracaju', 'natal', 'recife', 'teresina', 'goiania', 'cuiaba', 'palmas', 'porto alegre', 
		'curitiba', 'florianopolis', 'sao paulo', 'rio de janeiro', 'vitoria', 'porto velho', 'rio branco', 'manaus', 'boa vista', 'macapa', 'belem', 'sao luis', 'brasilia') THEN 'Capital'
		ELSE 'Demais Cidades'
	END AS capitais,
	COUNT(*) AS contagem,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset),4) AS perc_total,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
FROM olist_customers_dataset ocd
GROUP BY customer_city
ORDER BY capitais;
/*
-- Utilizado o case when para localizar as cidades que são capitais.
-- Depois, foram utilizados conceitos já aplicados para encontrar a frequência absoluta, frequência relativa e frequência acumulada.

-- Outra possibilidade, é utilizando o Having para filtrar os resultados do agrupamento:
  	SELECT
		customer_state,
		customer_city,
		COUNT(*) AS contagem,
		ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset),4) AS perc_total,
		ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
	FROM olist_customers_dataset ocd
	GROUP BY customer_city
	HAVING customer_city IN('belo horizonte', 'salvador', 'fortaleza', 'joao pessoa', 'sao luis', 'maceio', 'aracaju', 'natal', 'recife', 'teresina', 'goiania', 'cuiaba', 'palmas', 'porto alegre', 
			'curitiba', 'florianopolis', 'sao paulo', 'rio de janeiro', 'vitoria', 'porto velho', 'rio branco', 'manaus', 'boa vista', 'macapa', 'belem', 'sao luis', 'brasilia');
			
-- Para analisar as cidades que não são capitais:
	  	SELECT
		customer_state,
		customer_city,
		COUNT(*) AS contagem,
		ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset),4) AS perc_total,
		ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_customers_dataset)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS freq_acumulada
	FROM olist_customers_dataset ocd
	GROUP BY customer_city
	HAVING customer_city NOT IN('belo horizonte', 'salvador', 'fortaleza', 'joao pessoa', 'sao luis', 'maceio', 'aracaju', 'natal', 'recife', 'teresina', 'goiania', 'cuiaba', 'palmas', 'porto alegre', 
			'curitiba', 'florianopolis', 'sao paulo', 'rio de janeiro', 'vitoria', 'porto velho', 'rio branco', 'manaus', 'boa vista', 'macapa', 'belem', 'sao luis', 'brasilia');
*/


/*
**********************************************
Análise da Tabela olist_order_reviews_dataset:
**********************************************
*/

-- Analise da quantidade de linhas distintas de review_id e order_id:
SELECT
	COUNT(*),
	COUNT(DISTINCT review_id) AS contagem_review_id,
	COUNT(DISTINCT order_id) AS contagem_order_id 
FROM olist_order_reviews_dataset oord;
/*
-- A query retorna uma contagem simples, e uma contagem distinta do review_id e order_id
 */

-- Analise dos review_id's duplicados:
SELECT
	review_id,
	COUNT(*) as qtd_registros
FROM olist_order_reviews_dataset oord
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY qtd_registros DESC;
/*
-- A query retorna um agrupamento o review_id e a contagem de quantas vezes este review_id aparece.
-- O order by organiza os resultados do maior para o menor.
 */

-- Analise dos review_i's fora do padrão:
SELECT
	DISTINCT review_id,
	LENGTH(review_id) qtd_caracteres
FROM olist_order_reviews_dataset oord
ORDER BY qtd_caracteres;
/*
-- A query retorna os reviews_id's distintos e a quantidade de caracteres que cada review_id possui.
-- Ao final a query foi ordenada do menor para a maior quantidade de caracteres pelo order by.
-- 
 */

-- Analise dos reviews_id quando o numero de caracteres é diferente de 32:
SELECT
	review_id 
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_id) <> 32;
/*
-- A query retorna todos os review_id's quando a quantidade de caracteres for diferente de 32.
 */

-- Analise dos reviews_id quando o numero de caracteres é igual a 32:
SELECT
	review_id 
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_id) = 32;
/*
-- A query retorna todos os review_id's quando a quantidade de caracteres for igual a 32.
 */

-- Análise dos review_id's duplicados:
WITH cadastros_duplicados AS (
	SELECT
		review_id,
		COUNT(*) as qtd_registros
	FROM olist_order_reviews_dataset oord
	WHERE LENGTH(review_id) = 32
	GROUP BY review_id
	HAVING COUNT(*) > 1
)
SELECT 
	COUNT(*) AS contagem_duplicados,
	SUM(qtd_registros) AS total_registros 
FROM cadastros_duplicados;
/*
-- A CTE chamada cadastros_duplicados retorna todos os review_id's com 32 caracteres, quando a contagem da aparição deles for maior que 1.
-- A query principal faz a contagem de quantos review_id's são duplicados e soma estas quantidades.
 */

-- Analise dos review_id's com registros únicos:
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
FROM cadastros_unicos;
/*
-- A CTE chamada cadastros_unicos retorna todos os review_id's com 32 caracteres, quando a contagem da aparição deles for maior igual a 1, ou seja, review_id's que apareceram apenas 1 vez.
-- A query principal faz a contagem de quantos review_id's são únicos.
 */


-- Análise das notas:
SELECT 
	DISTINCT review_score
FROM olist_order_reviews_dataset oord;
/*
-- Query simples que retorna os review_score's distintos.
 */

-- Validação de que as reviews_score's possuem apenas 1 caractere:
SELECT 
	count(DISTINCT review_score)
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1;
/*
-- A query retornará uma contagem dos review_score's distintos quando a quantidade de caracters for igual a 1.
 */

-- Validação de quais são os reviews_score's com 1 caractere:
SELECT
	DISTINCT(review_score)
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1;
/*
-- A query retorna os distintos review_score's quando a contagem de caracteres for igual a 1.
 */

-- Verificação da quantidade de review_scores diferentes das notas de 1 a 5:
SELECT
	COUNT(review_score)
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) <> 1;
/*
-- A query retorna uma contagem dos review_score's quando a quantidade de caracteres for maior que 1.
 */

-- Média de avaliações com filtragem:
SELECT 
	AVG(review_score) media_avaliacoes
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1;
/*
-- A query retorna a media do review_score quando a quantidade de caracteres dele for igual a 1, ou seja, notas de 1 a 5.
 */

-- Média de avaliações sem filtragem:
SELECT 
	AVG(review_score) media_avaliacoes
FROM olist_order_reviews_dataset oord;

/*
-- A query retorna a media do review_score sem filtros.
 */

-- Análise das frequências das notas:
SELECT
	review_score,
	COUNT(*) AS frequencia,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_reviews_dataset WHERE LENGTH(review_score) = 1),4) AS frequencia_relativa,
	ROUND(SUM(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_reviews_dataset WHERE LENGTH(review_score) = 1)) OVER(ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),4) AS frequencia_acumulada
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1
GROUP BY review_score;
/*
-- A query retorna um agrupamento do review_score, uma contagem da frequencia em que aparecem, sua frequência relativa (utilizando uma subquery para retornar a frequência total) e a frequência acumulada que é a soma das % até o 100%(1),
filtrando apenas os review_score's com o número de caracteres igual a 1.
 */

-- Avaliação da quantidade de frequência relativa das notas positivas e negativas:
SELECT
	CASE
		WHEN review_score IN (4, 5) THEN 'Positiva'
		ELSE 'Negativa'
	END AS categoria_avaliacoes,
	count(*) AS contagem,
	ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM olist_order_reviews_dataset WHERE LENGTH(review_score) = 1),4) AS perc_total
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1
GROUP BY categoria_avaliacoes
ORDER BY contagem DESC;
/*
-- A query retorna a quantidade e frequência relativa das notas.
-- As linhas que serão utilizadas nesta query são as linhas do review_score que apresentam uma contagem de caracteres = 1, para limpar os registros que não são numéricos.
-- Foi utilizado o case when para formatar as notas 4 e 5 para positivas e as demais notas para negativas, agrupando a contagem de linhas nestas condições para as 2 categorias criadas.
-- Ao final, apenas para fim estético, ordenamos do maior para o menor.
*/

-- Extraíndo o CSAT (customer satisfaction) do review_score:
SELECT
	ROUND(((SUM(CASE
		WHEN review_score IN (4, 5) THEN 1
		ELSE 0
	END)) * 1.0 / (SELECT COUNT(*) FROM olist_order_reviews_dataset WHERE LENGTH(review_score) = 1)),4) * 100 AS csat
FROM olist_order_reviews_dataset oord
WHERE LENGTH(review_score) = 1;
/*
-- Utilizamos aqui o Case When novamente, utilizando um booleano para diferenciar as notas positivas e negativas, sendo positivas 1 e negativas 0. Somamos então todos os valores, retornando apenas a quantidade de notas positivas.
(multiplicamos por 1.0 para se tornar decimal)
Dividimos o valor do case when pelo valor resultado de uma subquery que retorna a contagem de linhas quando a quantidade de caracteres do review_score for igual a 1, e através do round arredondamos para 4 casas decimais.
Ao final, todo este valor é multiplicado por 100 para se tornar uma porcentagem, tendo assim o CSAT.
-- 
 */


/*
**********************************************
Análise da Tabela olist_order_reviews_dataset:
**********************************************
*/

-- Análise da quantidade de registro, order_id's e seller_id's distintos:
SELECT 
	COUNT(*) AS contagem_linhas,
	COUNT(DISTINCT order_id) AS contagem_id_pedidos,
	COUNT(DISTINCT seller_id) AS contagem_id_vendedores
FROM olist_order_items_dataset ooid;
/*
-- A query retorna uma contagem do total de linhas e uma contagem dos order_id's e seller_id's distintos
 */

-- Analisar a quantidade de order_id's repetidos:
SELECT
	order_id,
	count(*) AS contagem_order_id
FROM olist_order_items_dataset ooid
GROUP BY order_id
ORDER BY contagem_order_id DESC;
/*
-- A query agrupa os order_id's e realiza uma contagem da quantidade de linhas, retornando os order_id's que aparecem mais vezes, ordenados do com mais aparições para o menor. 
 */

-- Análise do produto mais pedido:
SELECT
	product_id,
	count(*) AS contagem_product_id
FROM olist_order_items_dataset ooid
GROUP BY product_id
ORDER BY contagem_product_id DESC;
/*
-- A query agrupa os product_id's e realiza uma contagem da quantidade de linhas, retornando os product's_ids que aparecem mais vezes, ordenados do com mais aparições para o menor. 
 */

-- Análise do produto com maior faturamento:
SELECT
	product_id,
	SUM(price) AS total_faturamento
FROM olist_order_items_dataset ooid
GROUP BY product_id
ORDER BY total_faturamento DESC;
/*
-- A query retorna um agrupamento dos product_id's e uma soma dos price's de cada um, ordenados dos com maiores faturamentos para os com menores.
 */

-- Análise do vendedor que tem o maior faturamento:
SELECT
	seller_id,
	SUM(price) AS total_faturamento
FROM olist_order_items_dataset ooid
GROUP BY seller_id
ORDER BY total_faturamento DESC;
/*
-- Utilizamos o mesmo conceito da query anterior, porém agrupando pelo seller_id.
 */

-- Análise dos vendedores que faturaram menos de 1000
WITH vendedores_baixa_performance AS (
	SELECT
		seller_id,
		SUM(price) AS total_faturamento
	FROM olist_order_items_dataset ooid
	GROUP BY seller_id
	HAVING total_faturamento < 1000
)
SELECT
	COUNT(*) AS contagem_vendedores
FROM vendedores_baixa_performance;
/*
-- A CTE criada retorna um agrupamento dos vendedores e o total faturado por cada um deles, ao final filtramos o agrupamento com o having retornando apenas os vendedores com vendas menores do que 1 mil.
-- A query principal faz a contagem destes vendedores
 */

-- Analise do tipo de variável da coluna price:
SELECT
	DISTINCT typeof(price)  AS tipo_variavel
FROM olist_order_items_dataset ooid;
/*
-- Utilizamos a função typeof que retorna o tipo de dado presente na coluna, procurando por valores diferentes de numéricos.
 */

-- Analise do tipo de variável da coluna freight_value:
SELECT
	DISTINCT typeof(freight_value) AS tipo_variavel
FROM olist_order_items_dataset ooid;
/*
-- Assim como na query anterior, utilizamos a função typeof que retorna o tipo de dado presente na coluna, procurando por valores diferentes de numéricos.
 */

-- Análise de medidas de tendência central e dispersão da coluna price:
SELECT
	COUNT(price) AS qtd_transacoes, 
	MAX(price) AS preco_maximo,
	MIN(price) AS preco_minimo,
	(MAX(price) - MIN(price)) AS amplitude,
	ROUND(AVG(price),2) AS media,
	MEDIAN(PRICE) AS mediana,
	ROUND(STDEV(PRICE),2) AS desvio_padrao
FROM olist_order_items_dataset ooid;
/*
-- A query retorna algumas medidas de tendência central e dispersão.
-- Na primeira coluna, retornará uma contagem.
-- Na segunda coluna, retornará o valor máximo.
-- Na terceira coluna, retornará o valor mínimo.
-- Na quarta coluna a Amplitude, representada pelo valor máximo diminuindo o valor mínimo.
-- Na quinta couluna, extraimos a média com a função AVG, arredondando o resultado con a função ROUND para 2 casas decimais depois da virgula.
-- Na sexta coluna, a mediana com a função MEDIAN.
-- Na última coluna,o desvio padrão representado pela função STDVE, arredondado pela função ROUND para 2 casas decimais depois da virgula.
 */

-- Análise de medidas de tendência central e dispersão da coluna freight_value:
SELECT
	COUNT(*) AS qtd_fretes,
	MAX(freight_value) AS maximo,
	MIN(freight_value) AS minimo,
	(MAX(freight_value) - MIN(freight_value)) AS amplitude, 
	AVG(freight_value) AS media,
	MEDIAN(freight_value) AS mediana,
	STDEV(freight_value) AS desvio_padrao
FROM olist_order_items_dataset ooid;
/*
-- A query retorna algumas medidas de tendência central e dispersão.
-- Na primeira coluna, retornará uma contagem.
-- Na segunda coluna, retornará o valor máximo.
-- Na terceira coluna, retornará o valor mínimo.
-- Na quarta coluna a Amplitude, representada pelo valor máximo diminuindo o valor mínimo.
-- Na quinta couluna, extraimos a média com a função AVG, arredondando o resultado con a função ROUND para 2 casas decimais depois da virgula.
-- Na sexta coluna, a mediana com a função MEDIAN.
-- Na última coluna,o desvio padrão representado pela função STDVE, arredondado pela função ROUND para 2 casas decimais depois da virgula.
 */