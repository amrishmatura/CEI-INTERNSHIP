
=== Loaded Superstore dataset ===
root
 |-- Row ID: integer (nullable = true)
 |-- Order ID: string (nullable = true)
 |-- Order Date: string (nullable = true)
 |-- Ship Date: string (nullable = true)
 |-- Ship Mode: string (nullable = true)
 |-- Customer ID: string (nullable = true)
 |-- Customer Name: string (nullable = true)
 |-- Segment: string (nullable = true)
 |-- Country: string (nullable = true)
 |-- City: string (nullable = true)
 |-- State: string (nullable = true)
 |-- Postal Code: double (nullable = true)
 |-- Region: string (nullable = true)
 |-- Product ID: string (nullable = true)
 |-- Category: string (nullable = true)
 |-- Sub-Category: string (nullable = true)
 |-- Product Name: string (nullable = true)
 |-- Sales: string (nullable = true)
 |-- Quantity: string (nullable = true)
 |-- Discount: string (nullable = true)
 |-- Profit: double (nullable = true)

+------+--------------+----------+----------+--------------+-----------+---------------+---------+-------------+---------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------------+--------+--------+--------+--------+
|Row ID|Order ID      |Order Date|Ship Date |Ship Mode     |Customer ID|Customer Name  |Segment  |Country      |City           |State     |Postal Code|Region|Product ID     |Category       |Sub-Category|Product Name                                               |Sales   |Quantity|Discount|Profit  |
+------+--------------+----------+----------+--------------+-----------+---------------+---------+-------------+---------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------------+--------+--------+--------+--------+
|1     |CA-2017-152156|11/8/2017 |11/11/2017|Second Class  |CG-12520   |Claire Gute    |Consumer |United States|Henderson      |Kentucky  |42420.0    |South |FUR-BO-10001798|Furniture      |Bookcases   |Bush Somerset Collection Bookcase                          |261.96  |2.0     |0.0     |41.9136 |
|2     |CA-2017-152156|11/8/2017 |11/11/2017|Second Class  |CG-12520   |Claire Gute    |Consumer |United States|Henderson      |Kentucky  |42420.0    |South |FUR-CH-10000454|Furniture      |Chairs      |Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back|731.94  |3.0     |0.0     |219.582 |
|3     |CA-2017-138688|6/12/2017 |6/16/2017 |Second Class  |DV-13045   |Darrin Van Huff|Corporate|United States|Los Angeles    |California|90036.0    |West  |OFF-LA-10000240|Office Supplies|Labels      |Self-Adhesive Address Labels for Typewriters by Universal  |14.62   |2.0     |0.0     |6.8714  |
|4     |US-2016-108966|10/11/2016|10/18/2016|Standard Class|SO-20335   |Sean O'Donnell |Consumer |United States|Fort Lauderdale|Florida   |33311.0    |South |FUR-TA-10000577|Furniture      |Tables      |Bretford CR4500 Series Slim Rectangular Table              |957.5775|5.0     |0.45    |-383.031|
|5     |US-2016-108966|10/11/2016|10/18/2016|Standard Class|SO-20335   |Sean O'Donnell |Consumer |United States|Fort Lauderdale|Florida   |33311.0    |South |OFF-ST-10000760|Office Supplies|Storage     |Eldon Fold 'N Roll Cart System                             |22.368  |2.0     |0.2     |2.5164  |
+------+--------------+----------+----------+--------------+-----------+---------------+---------+-------------+---------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------------+--------+--------+--------+--------+
only showing top 5 rows
Q3: Remove duplicate rows by user_id and transaction_date 
+--------+----------------+--------------+
|user_id |transaction_date|transaction_id|
+--------+----------------+--------------+
|AA-10315|10/4/2016       |CA-2016-121391|
|AA-10315|3/3/2017        |CA-2017-103982|
|AA-10315|3/31/2015       |CA-2015-128055|
|AA-10315|6/29/2018       |CA-2018-147039|
|AA-10315|9/15/2015       |CA-2015-138100|
+--------+----------------+--------------+
only showing top 5 rows
Q4: Filter West and group by product_category average sale_amount 
+----------------+------------------+
|product_category|avg_sale_amount   |
+----------------+------------------+
|Office Supplies |102.09524668141587|
|Furniture       |342.80778871391055|
|Technology      |382.57975746268664|
+----------------+------------------+

Q5: Fill null values in status with 'Unknown' 
+------+--------------+----------+---------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------+------------+--------+--------+--------+---------+------------+----------+
|Row ID|Order ID      |Order Date|Ship Date|Ship Mode     |Customer ID|Customer Name    |Segment    |Country      |City         |State     |Postal Code|Region|Product ID     |Category       |Sub-Category|Product Name                                         |Sales       |Quantity|Discount|Profit  |Sales_num|Discount_num|status    |
+------+--------------+----------+---------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------+------------+--------+--------+--------+---------+------------+----------+
|2718  |CA-2015-100006|9/7/2015  |9/13/2015|Standard Class|DK-13375   |Dennis Kane      |Consumer   |United States|New York City|New York  |10024.0    |East  |TEC-PH-10002075|Technology     |Phones      |AT&T EL51110 DECT                                    |377.97      |3.0     |0.0     |109.6113|377.97   |0.0         |Profitable|
|6288  |CA-2015-100090|7/8/2015  |7/12/2015|Standard Class|EB-13705   |Ed Braxton       |Corporate  |United States|San Francisco|California|94122.0    |West  |FUR-TA-10003715|Furniture      |Tables      |Hon 2111 Invitation Series Corner Table              |502.488     |3.0     |0.2     |-87.9354|502.488  |0.2         |Unknown   |
|9515  |CA-2015-100293|3/14/2015 |3/18/2015|Standard Class|NF-18475   |Neil FranzÃ¶sisch|Home Office|United States|Jacksonville |Florida   |32216.0    |South |OFF-PA-10000176|Office Supplies|Paper       |Xerox 1887                                           |91.056      |6.0     |0.2     |31.8696 |91.056   |0.2         |Profitable|
|3084  |CA-2015-100328|1/28/2015 |2/3/2015 |Standard Class|JC-15340   |Jasper Cacioppo  |Consumer   |United States|New York City|New York  |10024.0    |East  |OFF-BI-10000343|Office Supplies|Binders     |"Pressboard Covers with Storage Hooks, 9 1/2"" x 11""| Light Blue"|3.928   |1.0     |0.2     |NULL     |1.0         |Profitable|
|3836  |CA-2015-100363|4/8/2015  |4/15/2015|Standard Class|JM-15655   |Jim Mitchum      |Corporate  |United States|Glendale     |Arizona   |85301.0    |West  |OFF-FA-10000611|Office Supplies|Fasteners   |Binder Clips by OIC                                  |2.368       |2.0     |0.2     |0.8288  |2.368    |0.2         |Profitable|
+------+--------------+----------+---------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------+------------+--------+--------+--------+---------+------------+----------+
only showing top 5 rows
Q6: Total count of records per city where count > 100 
+-------------+----------+
|city         |city_count|
+-------------+----------+
|Philadelphia |265       |
|Los Angeles  |384       |
|San Francisco|265       |
|Columbus     |111       |
|Chicago      |171       |
+-------------+----------+
only showing top 5 rows
Q8: Filter West transactions with 10% to 20% discount 
+------+--------------+----------+----------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+----------------------------------------+-------+--------+--------+--------+---------+------------+
|Row ID|Order ID      |Order Date|Ship Date |Ship Mode     |Customer ID|Customer Name    |Segment    |Country      |City         |State     |Postal Code|Region|Product ID     |Category       |Sub-Category|Product Name                            |Sales  |Quantity|Discount|Profit  |Sales_num|Discount_num|
+------+--------------+----------+----------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+----------------------------------------+-------+--------+--------+--------+---------+------------+
|6288  |CA-2015-100090|7/8/2015  |7/12/2015 |Standard Class|EB-13705   |Ed Braxton       |Corporate  |United States|San Francisco|California|94122.0    |West  |FUR-TA-10003715|Furniture      |Tables      |Hon 2111 Invitation Series Corner Table |502.488|3.0     |0.2     |-87.9354|502.488  |0.2         |
|3836  |CA-2015-100363|4/8/2015  |4/15/2015 |Standard Class|JM-15655   |Jim Mitchum      |Corporate  |United States|Glendale     |Arizona   |85301.0    |West  |OFF-FA-10000611|Office Supplies|Fasteners   |Binder Clips by OIC                     |2.368  |2.0     |0.2     |0.8288  |2.368    |0.2         |
|9462  |CA-2015-100867|10/19/2015|10/24/2015|Standard Class|EH-14125   |Eugene Hildebrand|Home Office|United States|Lakewood     |California|90712.0    |West  |TEC-PH-10004922|Technology     |Phones      |RCA Visys Integrated PBX 8-Line Router  |321.552|6.0     |0.2     |20.097  |321.552  |0.2         |
|8464  |CA-2015-100881|3/28/2015 |4/1/2015  |Standard Class|DR-12940   |Daniel Raglin    |Home Office|United States|Albuquerque  |New Mexico|87105.0    |West  |TEC-PH-10003273|Technology     |Phones      |AT&T TR1909W                            |302.376|3.0     |0.2     |22.6782 |302.376  |0.2         |
|4565  |CA-2015-101175|12/9/2015 |12/14/2015|Standard Class|DM-12955   |Dario Medina     |Corporate  |United States|Mesa         |Arizona   |85204.0    |West  |OFF-ST-10004950|Office Supplies|Storage     |Acco Perma 3000 Stacking Storage Drawers|100.704|6.0     |0.2     |-1.2588 |100.704  |0.2         |
+------+--------------+----------+----------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+----------------------------------------+-------+--------+--------+--------+---------+------------+
only showing top 5 rows
Q10: Cast Order Date to TimestampType and rename to event_time 
root
 |-- Row ID: integer (nullable = true)
 |-- Order ID: string (nullable = true)
 |-- Ship Date: string (nullable = true)
 |-- Ship Mode: string (nullable = false)
 |-- Customer ID: string (nullable = true)
 |-- Customer Name: string (nullable = true)
 |-- Segment: string (nullable = true)
 |-- Country: string (nullable = true)
 |-- City: string (nullable = true)
 |-- State: string (nullable = true)
 |-- Postal Code: double (nullable = true)
 |-- Region: string (nullable = true)
 |-- Product ID: string (nullable = true)
 |-- Category: string (nullable = true)
 |-- Sub-Category: string (nullable = true)
 |-- Product Name: string (nullable = true)
 |-- Sales: string (nullable = true)
 |-- Quantity: string (nullable = true)
 |-- Discount: string (nullable = true)
 |-- Profit: double (nullable = true)
 |-- event_time: timestamp (nullable = true)

+------+--------------+---------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------+------------+--------+--------+--------+-------------------+
|Row ID|Order ID      |Ship Date|Ship Mode     |Customer ID|Customer Name    |Segment    |Country      |City         |State     |Postal Code|Region|Product ID     |Category       |Sub-Category|Product Name                                         |Sales       |Quantity|Discount|Profit  |event_time         |
+------+--------------+---------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------+------------+--------+--------+--------+-------------------+
|2718  |CA-2015-100006|9/13/2015|Standard Class|DK-13375   |Dennis Kane      |Consumer   |United States|New York City|New York  |10024.0    |East  |TEC-PH-10002075|Technology     |Phones      |AT&T EL51110 DECT                                    |377.97      |3.0     |0.0     |109.6113|2015-09-07 00:00:00|
|6288  |CA-2015-100090|7/12/2015|Standard Class|EB-13705   |Ed Braxton       |Corporate  |United States|San Francisco|California|94122.0    |West  |FUR-TA-10003715|Furniture      |Tables      |Hon 2111 Invitation Series Corner Table              |502.488     |3.0     |0.2     |-87.9354|2015-07-08 00:00:00|
|9515  |CA-2015-100293|3/18/2015|Standard Class|NF-18475   |Neil FranzÃ¶sisch|Home Office|United States|Jacksonville |Florida   |32216.0    |South |OFF-PA-10000176|Office Supplies|Paper       |Xerox 1887                                           |91.056      |6.0     |0.2     |31.8696 |2015-03-14 00:00:00|
|3084  |CA-2015-100328|2/3/2015 |Standard Class|JC-15340   |Jasper Cacioppo  |Consumer   |United States|New York City|New York  |10024.0    |East  |OFF-BI-10000343|Office Supplies|Binders     |"Pressboard Covers with Storage Hooks, 9 1/2"" x 11""| Light Blue"|3.928   |1.0     |0.2     |2015-01-28 00:00:00|
|3836  |CA-2015-100363|4/15/2015|Standard Class|JM-15655   |Jim Mitchum      |Corporate  |United States|Glendale     |Arizona   |85301.0    |West  |OFF-FA-10000611|Office Supplies|Fasteners   |Binder Clips by OIC                                  |2.368       |2.0     |0.2     |0.8288  |2015-04-08 00:00:00|
+------+--------------+---------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------+------------+--------+--------+--------+-------------------+
only showing top 5 rows
Q12: Remove rows where Customer ID is null OR Ship Mode is empty 
+------+--------------+----------+---------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------+------------+--------+--------+--------+
|Row ID|Order ID      |Order Date|Ship Date|Ship Mode     |Customer ID|Customer Name    |Segment    |Country      |City         |State     |Postal Code|Region|Product ID     |Category       |Sub-Category|Product Name                                         |Sales       |Quantity|Discount|Profit  |
+------+--------------+----------+---------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------+------------+--------+--------+--------+
|2718  |CA-2015-100006|9/7/2015  |9/13/2015|Standard Class|DK-13375   |Dennis Kane      |Consumer   |United States|New York City|New York  |10024.0    |East  |TEC-PH-10002075|Technology     |Phones      |AT&T EL51110 DECT                                    |377.97      |3.0     |0.0     |109.6113|
|6288  |CA-2015-100090|7/8/2015  |7/12/2015|Standard Class|EB-13705   |Ed Braxton       |Corporate  |United States|San Francisco|California|94122.0    |West  |FUR-TA-10003715|Furniture      |Tables      |Hon 2111 Invitation Series Corner Table              |502.488     |3.0     |0.2     |-87.9354|
|9515  |CA-2015-100293|3/14/2015 |3/18/2015|Standard Class|NF-18475   |Neil FranzÃ¶sisch|Home Office|United States|Jacksonville |Florida   |32216.0    |South |OFF-PA-10000176|Office Supplies|Paper       |Xerox 1887                                           |91.056      |6.0     |0.2     |31.8696 |
|3084  |CA-2015-100328|1/28/2015 |2/3/2015 |Standard Class|JC-15340   |Jasper Cacioppo  |Consumer   |United States|New York City|New York  |10024.0    |East  |OFF-BI-10000343|Office Supplies|Binders     |"Pressboard Covers with Storage Hooks, 9 1/2"" x 11""| Light Blue"|3.928   |1.0     |0.2     |
|3836  |CA-2015-100363|4/8/2015  |4/15/2015|Standard Class|JM-15655   |Jim Mitchum      |Corporate  |United States|Glendale     |Arizona   |85301.0    |West  |OFF-FA-10000611|Office Supplies|Fasteners   |Binder Clips by OIC                                  |2.368       |2.0     |0.2     |0.8288  |
+------+--------------+----------+---------+--------------+-----------+-----------------+-----------+-------------+-------------+----------+-----------+------+---------------+---------------+------------+-----------------------------------------------------+------------+--------+--------+--------+
only showing top 5 rows
Q13: Calculate min, max, and mean of Sales 
+---------+---------+-----------------+
|min_sales|max_sales|mean_sales       |
+---------+---------+-----------------+
|0.556    |11199.968|223.8288696913575|
+---------+---------+-----------------+

Q15: Final processing pipeline 
+-------+------------------+
|Region |total_revenue     |
+-------+------------------+
|South  |190071.66299999997|
|Central|244558.26519999994|
|East   |327743.13300000015|
|West   |325435.2455000009 |
+-------+------------------+

