# Week 5 - Spark Assignment Answers

## Q1: Key limitations of traditional MapReduce
- It writes intermediate data to disk after each stage, causing high I/O overhead.
- It is slow for iterative tasks such as machine learning and graph processing.
- It has poor support for interactive and real-time analytics.
- Spark is preferred because it uses in-memory processing and a DAG execution engine.

## Q2: How Spark uses in-memory computing
- Spark stores data in memory across transformations instead of writing it to disk after every step.
- This makes repeated operations much faster for iterative algorithms.
- Disk-based systems repeatedly read and write data, which increases latency.

## Q3: Remove duplicate rows by specific columns
```python
from pyspark.sql.functions import col

df_unique = df.dropDuplicates(["user_id", "transaction_date"])
```

## Q4: Filter West and group by product category
```python
from pyspark.sql.functions import avg, col

result = (
    df_sales
    .filter(col("region") == "West")
    .groupBy("product_category")
    .agg(avg("sale_amount").alias("avg_sale_amount"))
)
```

## Q5: Difference between .na.drop() and .na.fill()
- `.na.drop()` removes rows with null values.
- `.na.fill()` replaces null values with a specified value.

Example:
```python
df_filled = df.na.fill({"status": "Unknown"})
```

## Q6: Count records per city where count > 100
```python
from pyspark.sql.functions import count, col

city_counts = (
    df.groupBy("city")
      .agg(count("*").alias("city_count"))
      .filter(col("city_count") > 100)
)
```

## Q7: Effect of DataFrame immutability
- Spark DataFrames are immutable, so transformations return a new DataFrame.
- You must assign the result to a new variable instead of modifying the original in place.

```python
df2 = df.drop("old_column")
df3 = df2.withColumnRenamed("raw_name", "clean_name")
```

## Q8: Filter rows where age is between 18 and 30 and subscription is Premium
```python
from pyspark.sql.functions import col

filtered_df = (
    df.filter(
        (col("age") >= 18) &
        (col("age") <= 30) &
        (col("subscription") == "Premium")
    )
)
```

## Q9: Why handle nulls before aggregations
- Null values can distort results of `sum()`, `avg()`, and other numeric calculations.
- Cleaning nulls first makes the aggregates more accurate and meaningful.

## Q10: Cast a column to TimestampType and rename it
```python
from pyspark.sql.functions import to_timestamp, col

df2 = df.withColumn("event_time", to_timestamp(col("raw_timestamp")))
```

## Q11: What is shuffle
- During `groupBy`, Spark redistributes rows across partitions so rows with the same key are grouped together.
- This movement of data is called a shuffle.
- It is a wide transformation because it requires data exchange between partitions and executors.

## Q12: Remove rows where email is null or username is empty
```python
from pyspark.sql.functions import col

df_clean = df.filter(
    col("email").isNotNull() &
    col("username").isNotNull() &
    (col("username") != "")
)
```

## Q13: Use `.agg()` for multiple statistics
```python
from pyspark.sql.functions import min, max, avg

summary = df.agg(
    min("price").alias("min_price"),
    max("price").alias("max_price"),
    avg("price").alias("avg_price")
)
```

## Q14: Risk of `inferSchema=True` with messy dates
- It may misinterpret inconsistent date values as null or wrong types.
- This can hide data quality issues and give incorrect results.

## Q15: Final processing pipeline
```python
from pyspark.sql.functions import col, sum

final_df = (
    df.dropDuplicates()
      .na.fill({"price": 0})
      .groupBy("store_id")
      .agg(sum("price").alias("total_revenue"))
)
```
