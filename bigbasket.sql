SELECT * FROM bigbasket;

-- Calculate the rank of products within each category based on their sale price.
SELECT 	
	  product_id,
	  product,
      category,
      sub_category,
      sale_price,
      ROW_NUMBER() OVER (PARTITION BY category order by sale_price) as rank_by_category
FROM 
	  bigbasket;
      
 -- Determine the difference between the sale price of each product and the average sale price of products in its category.
 
WITH avg_cate AS
		 (SELECT 
				*,
				ROUND(AVG(sale_price) OVER (PARTITION BY category),2) as avg_category
		 FROM 
				bigbasket)
SELECT 
		product,
        category,
        sale_price, 
        avg_category,
        sale_price - avg_category as difference
FROM 
		avg_cate;
                
-- Rank products within each sub-category based on their market price.
SELECT 
		product_id, 
        product,
        category,
        sub_category,
        brand,
        market_price,
		DENSE_RANK() OVER (PARTITION BY sub_category ORDER BY market_price) AS rk_sub_category
FROM 	
	    bigbasket;

-- Identify the top-rated product in each category, along with its rating.
SELECT 
		product_id,
        product,
        category,
        rating,
        DENSE_RANK() OVER(PARTITION BY category ORDER BY rating DESC) as rk_rating
FROM 
		bigbasket;
        
-- Calculate the cumulative sum of sale prices for products within each brand, ordered by sale price.

SELECT 
	  product_id,
      sale_price,
      brand,
      product,
      SUM(sale_price) OVER(PARTITION BY brand ORDER BY sale_price) AS running_total
FROM 
	  bigbasket;

-- Determine the percentage contribution of each product's sale price to the total sale price of its category.
WITH cte as
(SELECT 
		product_id,
        product,
        category,
        sale_price,
        SUM(sale_price) over(PARTITION BY category ) as total_sale_price
FROM
		bigbasket)

SELECT 
		*,
        ROUND((sale_price / total_sale_price) * 100 ,2)as persenctage
FROM 
		cte;




