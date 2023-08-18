/* 
To observe the Marketing Channel Optimism leading to the Website Conversion Performance alongside the Impact of new Product Launches:
Q1. Determine the company's growth volume by the Overall Session and Order Volume; trended in Quarterly review 
*/
SELECT
	 YEAR(website_sessions.created_at) AS Year,
     QUARTER(website_sessions.created_at) AS Quarter,
     COUNT(DISTINCT website_sessions.website_session_id) AS Sessions,
     COUNT(DISTINCT orders.order_id) AS Orders
FROM website_sessions
  LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-01-01'
GROUP BY YEAR(website_sessions.created_at),
         QUARTER(website_sessions.created_at);
/*
RESULT:         
Year    Quarter        Sessions     Orders 
2012	1	       1879	    60
2012	2	       11433	    347
2012	3	       16892	    684
2012	4	       32266	    1495
2013	1	       19833	    1273
2013	2	       24745	    1718
2013	3	       27663	    1840
2013	4	       40540	    2616
2014	1	       46779	    3069
2014	2	       53129	    3848
2014	3	       57141	    4035
2014	4	       76373	    5908
*/
         
		
         
/*
Q2. Demonstrate all the efficiency improvements since the website launch period by Showcasing the:
i. Session to Order Conversion Rate
ii. Revenue per Order
iii. Revenue per Session; in Quarterly review.
*/
SELECT
     YEAR(website_sessions.created_at) AS year,
     QUARTER(website_sessions.created_at) AS Quarter,
     COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS Sess_to_Order_Convr_rate,
     SUM(orders.price_usd)/COUNT(DISTINCT orders.order_id) AS Revenue_per_Order,
     SUM(orders.price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS Revenue_per_Session
FROM website_sessions
  LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-01-01'
GROUP BY YEAR(website_sessions.created_at),
         QUARTER(website_sessions.created_at);
/*
RESULT:         
Year    Quarter    Sess_to_Order_Convr_rate    Revenue_per_Order    Revenue_per_Session
2012	1	       0.0319	                   49.990000	        1.596275
2012	2	       0.0304	                   49.990000	        1.517233
2012	3	       0.0405	                   49.990000	        2.024222
2012	4	       0.0463	                   49.990000	        2.316217
2013	1	       0.0642	                   52.142396	        3.346809
2013	2	       0.0694	                   51.538312	        3.578211
2013	3	       0.0665	                   51.734533	        3.441114
2013	4	       0.0645	                   54.715688	        3.530741
2014	1	       0.0656	                   62.160684	        4.078136
2014	2	       0.0724	                   64.374207	        4.662462
2014	3	       0.0706	                   64.494949	        4.554298
2014	4	       0.0774	                   63.793497	        4.934885
*/         
         
         
         
/*	
Q3. Showcase the Paid Channels' Traffic effeciency to Order by Pulling the Quarterly trend for:
i. Gsearch nonbrand 
ii. Bsearch nonbrand 
iii. G/Bsearch brand 
iv. Organic search 
v. Direct-type-in
*/
SELECT
     -- YEAR(website_sessions.created_at) AS Year,
     -- QUARTER(website_sessions.created_at) AS Quarter,
     MIN(DATE(website_sessions.created_at)) Date_in_quarters,
     COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN order_id END) AS Gsearch_nonbrand,
     COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN order_id END) AS Bsearch_nonbrand,
     COUNT(DISTINCT CASE WHEN utm_source IN ('gsearch', 'bsearch') AND utm_campaign = 'brand' THEN order_id END) AS Brand_search,
	 COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN order_id END) AS Organic_search,
     COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN order_id END) AS Direct_type_in
FROM website_sessions
  LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-01-01'
GROUP BY YEAR(website_sessions.created_at),
		 QUARTER(website_sessions.created_at);
/*
RESULT:         
Year    Quarter     Gsearch_nonbrand     Bsearch_nonbrand     Brand_search     Organic_search     Direct_type_in
2012	1	        60	             0	                  0	           0	              0
2012	2	        291  	             0	                  20	           15	              21
2012	3	        482	             82	                  48	           40	              32
2012	4	        913	             311	          88	           94	              89
2013	1	        766	             183	          108	           125	              91
2013	2	        1114	             237	          114	           134	              119
2013	3	        1132	             245	          153	           167	              143
2013	4	        1657	             291	          248	           223	              197
2014	1	        1667	             344	          354	           338	              311
2014	2	        2208	             427	          410	           445	              402
2014	3	        2259	             434	          432	           445	              402
2014	4	        3248	             683	          615	           605	              532
*/         
         
         
/*
Q4. Present the Overall Session to Order Conversion Rate trend for the same Channels above
*/
SELECT
     YEAR(website_sessions.created_at) AS Year,
     QUARTER(website_sessions.created_at) AS Quarter,
     COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN order_id ELSE NULL END)
        /COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS Gsearch_nonbrand_Convr_rate,
     COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN order_id END)
        /COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN website_sessions.website_session_id END) AS Bsearch_nonbrand_Convr_rate,
     COUNT(DISTINCT CASE WHEN utm_source IN ('gsearch', 'bsearch') AND utm_campaign = 'brand' THEN order_id END)
        /COUNT(DISTINCT CASE WHEN utm_source IN ('gsearch', 'bsearch') AND utm_campaign = 'brand' THEN website_sessions.website_session_id END) AS Brand_search_Convr_rate,
	 COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN order_id END)
        /COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN website_sessions.website_session_id END) AS Organic_search_Convr_rate,
     COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN order_id END)
        /COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id END) AS Direct_type_in_Convr_rate
FROM website_sessions
  LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-01-01'
GROUP BY YEAR(website_sessions.created_at),
		 QUARTER(website_sessions.created_at);
/*
RESULT:
Year    Quarter    Gsearch_nonbrand_Convr_rate    Bsearch_nonbrand_Convr_rate     Brand_Search_Convr_rate     Organic_search_Convr_rate     Direct_type_in_Convr_rate
2012	1	       0.0324		              NULL                            0.0000	                  0.0000	                    0.0000
2012	2	       0.0284		              NULL                            0.0526	                  0.0359	                    0.0536
2012	3	       0.0384	                      0.0408	                      0.0602	                  0.0498	                    0.0443
2012	4	       0.0436	                      0.0497	                      0.0531	                  0.0539	                    0.0537
2013	1	       0.0612	                      0.0693	                      0.0703	                  0.0753	                    0.0614
2013	2	       0.0685	                      0.0690	                      0.0679	                  0.0760	                    0.0735
2013	3	       0.0639	                      0.0697	                      0.0703	                  0.0734	                    0.0719
2013	4	       0.0629	                      0.0601	                      0.0801	                  0.0694	                    0.0647
2014	1	       0.0693	                      0.0704	                      0.0839	                  0.0756	                    0.0765
2014	2	       0.0702	                      0.0695	                      0.0804	                  0.0797	                    0.0738
2014	3	       0.0703	                      0.0698	                      0.0756	                  0.0733	                    0.0702
2014	4	       0.0782	                      0.0841	                      0.0812	                  0.0784	                    0.0748
*/
         


/* 
Q5. Estimate the revenue earned from the gsearch lander(/home to /lander-1) test;
-looking at the increase in the Conversion Rate(Lift Rate), of which channel converts more, from the test BETWEEN '2012-06-19' AND '2012-07-28';
-taking the nonbrand sesions (and the) revenue to calculate the Incremental Value 
*/
-- i.
CREATE TEMPORARY TABLE landertest_firstpageview
SELECT
     website_pageviews.website_session_id,
     MIN(website_pageviews.website_pageview_id) AS Min_pageview
FROM website_pageviews
  INNER JOIN website_sessions
    ON website_sessions.website_session_id = website_pageviews.website_session_id
    AND website_sessions.created_at BETWEEN '2012-06-19' AND '2012-07-28'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY 1;

-- ii. Link the layout pageviews to the url page limiting to just the '/home' and '/lander-1' pages
CREATE TEMPORARY TABLE landertest_landingpage
SELECT 
     landertest_firstpageview.website_session_id,
     website_pageviews.pageview_url As Landing_page
FROM landertest_firstpageview
  LEFT JOIN website_pageviews
    ON landertest_firstpageview.min_pageview = website_pageviews.website_pageview_id
WHERE pageview_url IN ('/home', '/lander-1');

-- iii. Highlight the landertest_landingpage with the orders table
CREATE TEMPORARY TABLE landertest_page_wt_orders
SELECT 
     landertest_landingpage.website_session_id,
     landertest_landingpage.Landing_page,
     orders.order_id
FROM landertest_landingpage
  LEFT JOIN orders
    ON orders.website_session_id = landertest_landingpage.website_session_id;
    
-- iv. Aggregate to determine the Conversion rate grouping by the landing_page
SELECT
     landing_page, 
     COUNT(DISTINCT website_session_id) AS Total_session,
     COUNT(DISTINCT order_id) AS Total_revenue,
     COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS Convr_rt
FROM landertest_page_wt_orders
GROUP BY 1;
/*
RESULT:
Landing_page   Total_session   Total_revenue   Convr_rt
/home	       2261	       72	       0.0318
/lander-1      2316	       94	       0.0406


home     = .0319
lander-1 = .0406
Incremental Value = .0406-0.0319 
	          = .0087 (Lift_Rate)
*/

/*NEXT: Determine the Incremental Order(New_page_sessions X Incremental_value) by:
-determining the total sessions that landed on the (new) '/lander-1' page by:
-determining the last session_id that hitted the '/home' page in order to, next, identify the first session_id on the '/lander-1' to track the number of orders within.
*/
SELECT 
     MAX(website_sessions.website_session_id)
FROM website_sessions
  LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE pageview_url = '/home'
  AND utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand'
  AND website_sessions.created_at < '2012-11-27';
/*
RESULT:
MAX(website_sessions.website_session_id)
'17145'
*/
-- Note: session_id 17145

/*
Next, use the number to determine the total sessions that landed on the (new) '/lander-1' page
i.e "the lift in session to order"
*/
SELECT 
     COUNT(DISTINCT website_session_id) AS New_page_sessions
FROM website_sessions
WHERE created_at < '2012-11-27'
     AND website_session_id > 17145
     AND utm_source = 'gsearch'
     AND utm_campaign = 'nonbrand';
/*
RESULT:
New_page_sessions
22972
--> '/lander-1' total_sessions = 22,972

Incremental Order = new_page_sessions X incremental_value
                   = 22,972 X .0087
		   = 200 
*/


         
/*
Q6. From the previous '/home' to '/lander-1' test;
-aggregate to show a FULL CONVERSION FUNNEL from the two pages to orders
-limiting to the same time-frame BETWEEN '2012-06-19' AND '2012-07-28'
*/
-- i. flag each visited pageview by representing with "1" limting to 'gsearch-nonbrand'
CREATE TEMPORARY TABLE pageview_level
SELECT
     website_sessions.website_session_id,
     website_pageviews.pageview_url,
     CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS home_page,
     CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS lander_page,
     CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
     CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mr_fuzzy_page,
     CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
     CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
     CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
     CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thank_you_page
FROM website_sessions
  LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
  AND website_sessions.utm_campaign = 'nonbrand'
  AND website_sessions.created_at BETWEEN '2012-06-19' AND '2012-07-28'
ORDER BY website_sessions.website_session_id,
         website_pageviews.created_at;
         
-- ii. Typically turn the wide, to a long data_table; sumarizing the cases by session_id
CREATE TEMPORARY TABLE session_level_made_it
SELECT 
     website_session_id,
     MAX(home_page) AS seen_home,
     MAX(lander_page) AS seen_lander,
     MAX(products_page) AS seen_products,
     MAX(mr_fuzzy_page) AS seen_mr_fuzzy,
     MAX(cart_page) AS seen_cart,
     MAX(shipping_page) AS seen_shipping,
     MAX(billing_page) AS seen_billing,
     MAX(thank_you_page) AS seen_thank_you
FROM pageview_level
GROUP BY website_session_id;

-- iii. Run a Split test for both Landers to examine their progress each; through the other pageviews
CREATE TEMPORARY TABLE from_lander_to
SELECT
  CASE 
     WHEN seen_home = 1 THEN 'seen_home'
     WHEN seen_lander = 1 THEN 'seen_lander'
     ELSE 'NULL' 
     END AS segment,
     COUNT(DISTINCT website_session_id) AS sessions,
     COUNT(DISTINCT CASE WHEN seen_products = 1 THEN website_session_id ELSE NULL END) AS to_products,
     COUNT(DISTINCT CASE WHEN seen_mr_fuzzy = 1 THEN website_session_id ELSE NULL END) AS to_mr_fuzzy,
     COUNT(DISTINCT CASE WHEN seen_cart = 1 THEN website_session_id ELSE NULL END) AS to_cart,
     COUNT(DISTINCT CASE WHEN seen_shipping = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
     COUNT(DISTINCT CASE WHEN seen_billing = 1 THEN website_session_id ELSE NULL END) AS to_billing,
     COUNT(DISTINCT CASE WHEN seen_thank_you = 1 THEN website_session_id ELSE NULL END) AS to_thank_you
FROM session_level_made_it 
GROUP BY 1;

-- iv. Aggregate the data to determine the Conversion rate for each lander
SELECT
  CASE   
     WHEN seen_home = 1 THEN 'seen_home'
     WHEN seen_lander = 1 THEN 'seen_lander'
     ELSE 'NULL' 
     END AS Segment,
     COUNT(DISTINCT website_session_id) AS Sessions,
     COUNT(DISTINCT CASE WHEN seen_products = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS Products_click_rate,
     COUNT(DISTINCT CASE WHEN seen_mr_fuzzy = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN seen_products = 1 THEN website_session_id ELSE NULL END) AS Mr_fuzzy_click_rate,
     COUNT(DISTINCT CASE WHEN seen_cart = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN seen_mr_fuzzy = 1 THEN website_session_id ELSE NULL END) AS Cart_click_rate,
     COUNT(DISTINCT CASE WHEN seen_shipping = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN seen_cart = 1 THEN website_session_id ELSE NULL END) AS Shipping_click,
     COUNT(DISTINCT CASE WHEN seen_billing = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN seen_shipping = 1 THEN website_session_id ELSE NULL END) AS Billing_click_rate,
     COUNT(DISTINCT CASE WHEN seen_thank_you = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN seen_billing = 1 THEN website_session_id ELSE NULL END) AS To_thank_you
FROM session_level_made_it 
GROUP BY 1;
/*
RESULT:
Segment         Sessions   Products_click_rate    Mr_fuzzy_click_rate    Cart_click_rate    Shipping_click    Billing_click_rate    To_thank_you
seen_home	2261	   0.4166	          0.7261	         0.4327	            0.6757	      0.8400	            0.4286
seen_lander	2316	   0.4676	          0.7128	         0.4508	            0.6638	      0.8528	            0.4772
/*
-- NOTE: it is evident that, in the case of "products_click_rate" down to the "to_thank_you"(placed orders) rate, the newly introduced '/lander-1' page converts better than the initial '/home' landing page.




/*
Q7. Coming a long way since the days of selling a SINGLE Product; 
Compare the impact of introducing A Product every year on the Sales and Revenue, alongside the Margin; trending by Year.
*/
-- Showcasing for sessions limited to the First Primary Product
SELECT
     YEAR(created_at) AS Year,
     COUNT(DISTINCT order_id) AS Total_sales,
     SUM(price_usd) AS Total_revenue,
     SUM(price_usd - cogs_usd) AS Margin
FROM orders
WHERE primary_product_id = 1
  AND created_at < '2015-01-01'
GROUP BY 1;
/*
RESULT:
Year    Total_sales   Total_revenue   Margin
2012	2586	      129274.14	      78873.00
2013	6133	      314709.23	      192234.50
2014	11879	      762859.83	      475865.50
*/

-- Showcasing for the Overall Products sessions
SELECT
     YEAR(created_at) AS Year,
     COUNT(DISTINCT order_id) AS Total_sales,
     SUM(price_usd) AS Total_revenue,
     SUM(price_usd - cogs_usd) AS Margin
FROM orders
WHERE created_at < '2015-01-01'
GROUP BY 1;
/*
RESULT:
Year    Total_sales   Total_revenue   Margin
2012	2586	      129274.14	      78873.00
2013	7447	      393247.87	      241596.50
2014	16860	      1075612.19      679722.50
*/



/*
Q8. Diving deeper into the impact of introducing new products;
 Pull, Monthly, the:
i. Sessions to the '/products' page
ii. Show how the percentage of those sessions clicking to the next page has changed over time
iii. Present a view of how conversion from '/products' to placing orders has improved.
*/
-- i. Determine the basic '/products' pageview sessions
CREATE TEMPORARY TABLE pageview_session_basics 
SELECT
     YEAR(created_at) AS Year,
     MONTH(created_at) AS Month,
     website_session_id AS Products_page_sessions,
     website_pageviews.website_pageview_id AS Products_pageview_id
FROM website_pageviews
WHERE pageview_url = '/products';

-- Link in the page after the '/products' page
CREATE TEMPORARY TABLE Product_vs_Next_page
SELECT
     Year,
     Month,
     Products_page_sessions,
     Products_pageview_id,
     MIN(website_pageviews.website_pageview_id) AS Page_after_products		
FROM pageview_session_basics
  LEFT JOIN website_pageviews
    ON pageview_session_basics.Products_page_sessions = website_pageviews.website_session_id
    AND website_pageviews.website_pageview_id > Products_pageview_id
GROUP BY 1, 2, 3, 4;

-- Aggregate and Summary
SELECT
     Year,
     Month,
     COUNT(DISTINCT Products_page_sessions) AS Sessions_to_Products,
     COUNT(DISTINCT Page_after_products) AS clicked_tru_products,
     COUNT(DISTINCT Page_after_products)/COUNT(DISTINCT Products_page_sessions) AS clicked_tru_products_rate,
     COUNT(DISTINCT orders.order_id) AS Orders_from_products,
     COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT Products_page_sessions) AS Orders_from_products_rate
FROM Product_vs_Next_page
  LEFT JOIN orders
   ON Product_vs_Next_page.Products_page_sessions = orders.website_session_id
GROUP BY 1, 2;
/*
RESULT:
Year    Month        Sessions_to_Products        Clicked_tru_products   Clicked_tru_products_rate   Orders_from_products   Orders_from_products_rate
2012	3	     743	                 530	                0.7133	                    60	                   0.0808
2012	4	     1447	                 1029	                0.7111	                    99	                   0.0684
2012	5	     1584	                 1135	                0.7165	                    108	                   0.0682
2012	6	     1752	                 1247	                0.7118	                    140	                   0.0799
2012	7	     2018	                 1438	                0.7126	                    169	                   0.0837
2012	8	     3012	                 2198	                0.7297	                    228	                   0.0757
2012	9	     3126	                 2258	                0.7223	                    287	                   0.0918
2012	10	     4030	                 2948	                0.7315	                    371	                   0.0921
2012	11	     6743	                 4849	                0.7191	                    618	                   0.0917
2012	12	     5013	                 3620	                0.7221	                    506	                   0.1009
2013	1	     3380	                 2595	                0.7678	                    391	                   0.1157
2013	2	     3685	                 2803	                0.7607	                    497	                   0.1349
2013	3	     3371	                 2576	                0.7642	                    385	                   0.1142
2013	4	     4362	                 3356	                0.7694	                    553	                   0.1268
2013	5	     4684	                 3609	                0.7705	                    571	                   0.1219
2013	6	     4600	                 3536	                0.7687	                    594	                   0.1291
2013	7	     5020	                 3890	                0.7749	                    603	                   0.1201
2013	8	     5226	                 3951	                0.7560	                    608	                   0.1163
2013	9	     5399	                 4072	                0.7542	                    629	                   0.1165
2013	10	     6038	                 4564	                0.7559	                    708	                   0.1173
2013	11	     7886	                 5900	                0.7482	                    861	                   0.1092
2013	12	     8840	                 7026	                0.7948	                    1047	               0.1184
2014	1	     7790	                 6387	                0.8199	                    983	                   0.1262
2014	2	     7960	                 6485	                0.8147	                    1021	               0.1283
2014	3	     8110	                 6669	                0.8223	                    1065	               0.1313
2014	4	     9744	                 7958	                0.8167	                    1241	               0.1274
2014	5	     10261	                 8465	                0.8250	                    1368	               0.1333
2014	6	     10011	                 8260	                0.8251	                    1239	               0.1238
2014	7	     10837	                 8958	                0.8266	                    1287	               0.1188
2014	8	     10768	                 8980	                0.8340	                    1324	               0.1230
2014	9	     11128	                 9156	                0.8228	                    1424	               0.1280
2014	10	     12335	                 10235	                0.8298	                    1609	               0.1304
2014	11	     14476	                 12020	                0.8303	                    1985	               0.1371
2014	12	     17240	                 14609	                0.8474	                    2314	               0.1342
2015	1	     15217	                 12992	                0.8538	                    2099	               0.1379
2015	2	     14373	                 12187	                0.8479	                    2067	               0.1438
2015	3	     9022	                 7723	                0.8560	                    1254	               0.1390
*/
  
     
     

/*
Q9. Introducing the 4th product as a primary product on December 05, 2014(and not just a cross-sell product anymore)
Pull the sales data, since the introduction date, showing how well each product cross-sell with one another.
*/
SELECT
     orders.primary_product_id,
	 COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id END) AS X_Sell_Product1,
     COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id END) AS X_Sell_Product2,
     COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id END) AS X_Sell_Product3,
     COUNT(DISTINCT CASE WHEN order_items.product_id = 4 THEN orders.order_id END) AS X_Sell_Product4,
     
     COUNT(DISTINCT CASE WHEN order_items.product_id = 1 THEN orders.order_id END)/COUNT(DISTINCT orders.order_id) AS X_Sell_Product1_rate,
     COUNT(DISTINCT CASE WHEN order_items.product_id = 2 THEN orders.order_id END)/COUNT(DISTINCT orders.order_id) AS X_Sell_Product2_rate,
     COUNT(DISTINCT CASE WHEN order_items.product_id = 3 THEN orders.order_id END)/COUNT(DISTINCT orders.order_id) AS X_Sell_Product3_rate,
     COUNT(DISTINCT CASE WHEN order_items.product_id = 4 THEN orders.order_id END)/COUNT(DISTINCT orders.order_id) AS X_Sell_Product4_rate
FROM orders
  LEFT JOIN order_items
    ON orders.order_id = order_items.order_id
    AND order_items.is_primary_item = 0
WHERE orders.created_at BETWEEN '2014-12-05' AND '2015-03-20'
GROUP BY 1
ORDER BY 1;
/*
RESULT:
primary_product_id       X_Sell_Product1       X_Sell_Product2     X_Sell_Product3     X_Sell_Product4       X_Sell_Product1_rate     X_Sell_Product2_rate     X_Sell_Product3_rate   X_Sell_Product4_rate
1	                 0	               238	           553	               933	             0.0000	              0.0533	               0.1238	              0.2089
2	                 25	               0	           40	               260	             0.0196	              0.0000	               0.0313	              0.2036
3	                 84	               40	           0	               208	             0.0904	              0.0431	               0.0000	              0.2239
4	                 16	               9	           22	               0	             0.0275	              0.0155	               0.0379	              0.0000
*/


-- CONCLUSION
/* 
SHARE:
1. There has been an overall Session to Order increment and a recurrent increase in sales and revenue as recorded at every 12th month of the year(mostly generated from the end-year sales) over the time as presensted in the quarterly review.
2. Evidently, the Company has gained more significant traffic growth resulting to a Yearly turn-up of averagely 60% in the Brand and Organic searches and as well the Direct-type-in.
 Thus saving the Company from relying on paid channels whilst build Her brand awareness.
3. From the, '/home' to '/lander-1', lander test by revenue; it is evident that the newly desingned and implemented (/lander-1) landing page converts more revenue than the initial (/home) landing page by 23.4% with an incremental order value of 200 within the specified period.
 The Conversion funnel further shows the difference through the increment in the '/products' click through rate to Orders.
4. Also, there seems to be more traffic leading to increase in Sales and Revenue on yearly basis due to the introduction of other products, whilst aiding Cross-selling, to generate more revenue within a single order.
*/



