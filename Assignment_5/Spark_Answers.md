
## Q1: What are the key limitations of traditional MapReduce that make Spark a preferred choice for modern big data processing?
- Heavy disk I/O between each MapReduce stage.
- Inefficient for iterative workloads like machine learning and graph algorithms.
- Only two main phases (map and reduce), which makes complex workflows harder to express.
- High latency and poor support for interactive queries.
- No built-in caching mechanism for intermediate results.

## Q2: Explain how Spark uses In-Memory Computing to speed up iterative machine learning algorithms compared to disk-based systems.
Spark caches data in memory using `cache()` or `persist()`. Iterative algorithms reuse the same dataset multiple times without writing to disk each time, which reduces I/O, eliminates repeated serialization, and delivers much faster performance than disk-based systems.

## Q5: What is the difference between .na.drop() and .na.fill()?
- `.na.drop()` removes rows that contain null values.
- `.na.fill()` replaces null values with specified constants.

Example:
```python
df_filled = df.na.fill({"status": "Unknown"})
```

## Q7: How does the immutability of Spark DataFrames affect how you perform "data cleaning" steps like dropping columns or renaming them?
Spark DataFrames are immutable. Each transformation returns a new DataFrame, so you must assign the result of drop, rename, or other cleaning operations to a new variable.

Example:
```python
df2 = df.drop("old_column").withColumnRenamed("raw_name", "clean_name")
```

## Q9: When cleaning a dataset, why is it often better to handle null values before performing mathematical aggregations like sum() or avg()?
Null values can cause aggregates to ignore missing values or produce misleading results. Cleaning nulls first ensures aggregates reflect the intended dataset and avoids unexpected averages or sums.

## Q11: Explain the "Shuffle" process that occurs during a grouping operation. Why is it considered a wide transformation?
During `groupBy`, Spark redistributes rows across partitions so all rows with the same grouping key land together. This network data movement is called a shuffle. It is a wide transformation because it exchanges data between executors and forms a stage boundary in the execution plan.

## Q14: In the context of cleaning a dataset, what is the risk of using inferSchema=true when your source data contains messy or inconsistent date formats?
`inferSchema=true` can misinterpret inconsistent date formats, turning some values into null or wrong types. This can hide data quality problems and lead to inaccurate results.

## Q15: Final processing pipeline explanation
The pipeline:
1. Removes duplicate rows using `Order ID` and `Order Date`.
2. Fills null `Ship Mode` values with `Unknown`.
3. Uses `try_cast` to convert `Sales` and `Discount` to numeric values safely.
4. Groups by `Region` and calculates total revenue using cleaned `Sales_num` values.
This ensures cleaned data before aggregation and produces reliable regional revenue totals from the Superstore dataset.
