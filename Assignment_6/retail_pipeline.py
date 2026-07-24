"""
Spark Architecture & Data Processing Pipeline
Dataset: Superstore.csv

Covers:
  1. Spark architecture (Driver / Cluster Manager / Executors) [Q1, Q13]
  2. Lazy evaluation + DAG / lineage [Q2, Q7]
  3. Schema handling on read (CSV + Parquet) [Q3]
  4. Filtering, column selection [Q5, Q8, Q14]
  5. Renaming, casting, derived columns [Q6, Q10]
  6. Transformations vs actions [Q11, Q15]
  7. Wide transformation / shuffle + predicate pushdown [Q9]
  8. CSV vs Parquet performance (cross-platform directory sizing) [Q4]
  9. Null handling [Q12]
  10. Full read -> transform -> filter -> write pipeline
  11. Best practices (no collect() on big data, use show()/limit())
"""

import time
import os
import sys

# Configure HADOOP_HOME for Windows execution
script_dir = os.path.dirname(os.path.abspath(__file__))
workspace_dir = os.path.dirname(script_dir)
hadoop_home = os.path.join(workspace_dir, "hadoop")
if os.path.exists(hadoop_home):
    os.environ["HADOOP_HOME"] = hadoop_home
    os.environ["PATH"] += os.pathsep + os.path.join(hadoop_home, "bin")

from pyspark.sql import SparkSession
from pyspark.sql.types import (
    StructType, StructField, StringType, IntegerType, DoubleType, LongType
)
from pyspark.sql.functions import (
    col, when, round as spark_round, to_date, year as sp_year,
    month as sp_month, trim, upper, count, sum as spark_sum, avg
)

# ---------------------------------------------------------------------------
# 1. SPARK ARCHITECTURE [Q1, Q13]
# ---------------------------------------------------------------------------
# Driver: This Python process running the main code.
# Cluster Manager: Local master (local[*]) managing CPU threads on this machine.
# Executors: Worker threads running inside the JVM executing partition tasks.
#
# Client Mode (our local setup) vs Cluster Mode:
# - Client Mode: Driver runs locally on the machine submitting the job (e.g. here).
# - Cluster Mode: Driver runs inside a container on one of the cluster's worker nodes.
spark = (
    SparkSession.builder
    .appName("SuperstoreDataPipeline")
    .master("local[*]")
    .config("spark.sql.shuffle.partitions", "8")  # small cluster -> fewer shuffle partitions
    .getOrCreate()
)
spark.sparkContext.setLogLevel("ERROR")

print("=" * 80)
print("SPARK ARCHITECTURE INFO")
print("=" * 80)
print(f"Spark version      : {spark.version}")
print(f"Master             : {spark.sparkContext.master}")
print(f"Default parallelism: {spark.sparkContext.defaultParallelism}  (this many executor cores/threads)")
print(f"App name / ID       : {spark.sparkContext.appName} / {spark.sparkContext.applicationId}")

# ---------------------------------------------------------------------------
# 2. SCHEMA HANDLING (explicit schema instead of inferSchema=True)
# ---------------------------------------------------------------------------
# Explicit schema avoids a full extra pass over the file and guarantees correct types.
superstore_schema = StructType([
    StructField("Row ID",            IntegerType(), True),
    StructField("Order ID",          StringType(), True),
    StructField("Order Date",        StringType(), True),
    StructField("Ship Date",         StringType(), True),
    StructField("Ship Mode",         StringType(), True),
    StructField("Customer ID",       StringType(), True),
    StructField("Customer Name",     StringType(), True),
    StructField("Segment",           StringType(), True),
    StructField("Country",           StringType(), True),
    StructField("City",              StringType(), True),
    StructField("State",             StringType(), True),
    StructField("Postal Code",       StringType(), True),
    StructField("Region",            StringType(), True),
    StructField("Product ID",        StringType(), True),
    StructField("Category",          StringType(), True),
    StructField("Sub-Category",      StringType(), True),
    StructField("Product Name",      StringType(), True),
    StructField("Sales",             DoubleType(), True),
    StructField("Quantity",          IntegerType(), True),
    StructField("Discount",          DoubleType(), True),
    StructField("Profit",            DoubleType(), True),
])

CSV_PATH = os.path.join(script_dir, "Superstore.csv")
OUTPUT_CSV_PATH = os.path.join(script_dir, "output", "cleaned_retail_csv")
OUTPUT_PARQUET_PATH = os.path.join(script_dir, "output", "cleaned_retail_parquet")

print("\n" + "=" * 80)
print("READING CSV WITH EXPLICIT SCHEMA")
print("=" * 80)

t0 = time.time()
df_csv = (
    spark.read
    .option("header", "true")
    .schema(superstore_schema)   # explicit schema -> no inference scan
    .csv(CSV_PATH)
)
# NOTE: this line above is still "lazy" - no data has been read yet.
csv_row_count = df_csv.count()
csv_read_time = time.time() - t0
print(f"CSV row count       : {csv_row_count}")
print(f"CSV read+count time : {csv_read_time:.2f}s")

df_csv.printSchema()

# ---------------------------------------------------------------------------
# 3. LAZY EVALUATION + DAG / LINEAGE [Q2, Q7]
# ---------------------------------------------------------------------------
# Lazy evaluation registers transformations in a Lineage Graph (DAG) and defers
# execution until an Action is called. If a worker node fails, the Driver uses
# the DAG to recompute the lost partitions from the original dataset (Fault Tolerance).
print("\n" + "=" * 80)
print("LAZY EVALUATION DEMO - building a transformation chain (no execution yet)")
print("=" * 80)

lazy_chain = (
    df_csv
    .select("Row ID", "Customer ID", "Country", "Category",
             "Sales", "Order Date", "Ship Mode", "Profit")
    .filter(col("Sales").isNotNull())
    .filter(col("Country") == "United States")
)
print("Chain built (nothing has run yet). Logical + physical plan:")
lazy_chain.explain(mode="formatted")

# ---------------------------------------------------------------------------
# 4. SELECT + FILTER + 5. RENAME / CAST / DERIVE + 9. NULL HANDLING
# ---------------------------------------------------------------------------
print("\n" + "=" * 80)
print("TRANSFORM: select, filter, rename, cast, derive columns, handle nulls")
print("=" * 80)

df_clean = (
    df_csv
    .select(
        col("Row ID").cast(LongType()).alias("row_id"),
        trim(col("Order ID")).alias("order_id"),
        to_date(col("Order Date"), "M/d/yyyy").alias("order_date"),
        to_date(col("Ship Date"), "M/d/yyyy").alias("ship_date"),
        trim(col("Ship Mode")).alias("ship_mode"),
        trim(col("Customer ID")).alias("customer_id"),
        trim(col("Customer Name")).alias("customer_name"),
        trim(col("Segment")).alias("segment"),
        trim(col("Country")).alias("country"),
        trim(col("City")).alias("city"),
        trim(col("State")).alias("state"),
        trim(col("Postal Code")).alias("postal_code"),
        trim(col("Region")).alias("region"),
        trim(col("Product ID")).alias("product_id"),
        upper(trim(col("Category"))).alias("category"),
        trim(col("Sub-Category")).alias("sub_category"),
        trim(col("Product Name")).alias("product_name"),
        spark_round(col("Sales"), 2).alias("sales"),
        col("Quantity").cast(IntegerType()).alias("quantity"),
        spark_round(col("Discount"), 4).alias("discount"),
        spark_round(col("Profit"), 2).alias("profit"),
    )
    .dropna(subset=["row_id", "order_id", "sales"])
    .fillna({"postal_code": "Unknown", "customer_name": "Unknown"})
    .withColumn(
        "sales_value_tier",
        when(col("sales") >= 500, "High")
        .when(col("sales") >= 150, "Medium")
        .otherwise("Low")
    )
    .withColumn("order_year", sp_year(col("order_date")))
    .withColumn("order_month", sp_month(col("order_date")))
)

df_clean.printSchema()
print("Sample of cleaned data (Using show() which is safe, unlike collect()): [Q15]")
df_clean.show(5, truncate=False)

null_before = df_csv.filter(col("Sales").isNull()).count()
null_after = df_clean.filter(col("sales").isNull()).count()
print(f"Rows with null Sales before cleaning: {null_before}")
print(f"Rows with null sales after cleaning : {null_after}")
print(f"Rows after cleaning pipeline         : {df_clean.count()}")

# ---------------------------------------------------------------------------
# 6/7. TRANSFORMATIONS vs ACTIONS [Q11]
# ---------------------------------------------------------------------------
# - Transformations (Lazy): select(), filter(), groupBy(), withColumn()
# - Actions (Eager): count(), show(), write, collect()
print("\n" + "=" * 80)
print("WIDE TRANSFORMATION DEMO: groupBy + agg (triggers a shuffle)")
print("=" * 80)

category_summary = (
    df_clean.groupBy("category")
    .agg(
        count("*").alias("num_orders"),
        spark_sum("sales").alias("total_revenue"),
        avg("sales").alias("avg_order_value"),
    )
    .orderBy(col("total_revenue").desc())
)
print("Physical plan showing the Exchange (shuffle) step:")
category_summary.explain(mode="simple")
category_summary.show(20, truncate=False)

# ---------------------------------------------------------------------------
# 8. CSV vs PARQUET - WRITE [Q4]
# ---------------------------------------------------------------------------
# CSV is Row-based; Parquet is Columnar. Columnar storage facilitates extreme
# compression rates, column pruning, and predicate pushdowns.
print("\n" + "=" * 80)
print("WRITE COMPARISON: CSV vs Parquet")
print("=" * 80)

t0 = time.time()
(df_clean.write.mode("overwrite").option("header", "true")
 .csv(OUTPUT_CSV_PATH))
csv_write_time = time.time() - t0

t0 = time.time()
(df_clean.write.mode("overwrite")
 .partitionBy("order_year")
 .parquet(OUTPUT_PARQUET_PATH))
parquet_write_time = time.time() - t0

print(f"CSV write time     : {csv_write_time:.2f}s")
print(f"Parquet write time : {parquet_write_time:.2f}s")

# Cross-platform helper to calculate directory size
def get_dir_size(path):
    total_size = 0
    if os.path.exists(path):
        for dirpath, dirnames, filenames in os.walk(path):
            for f in filenames:
                fp = os.path.join(dirpath, f)
                if not os.path.islink(fp):
                    total_size += os.path.getsize(fp)
    for unit in ['B', 'KB', 'MB', 'GB']:
        if total_size < 1024:
            return f"{total_size:.2f} {unit}"
        total_size /= 1024
    return f"{total_size:.2f} TB"

csv_size = get_dir_size(OUTPUT_CSV_PATH)
parquet_size = get_dir_size(OUTPUT_PARQUET_PATH)
print(f"CSV output size on disk     : {csv_size}")
print(f"Parquet output size on disk : {parquet_size}")

# ---------------------------------------------------------------------------
# 8b. CSV vs PARQUET - READ + PREDICATE PUSHDOWN [Q9]
# ---------------------------------------------------------------------------
print("\n" + "=" * 80)
print("READ COMPARISON + PREDICATE PUSHDOWN")
print("=" * 80)

t0 = time.time()
csv_readback = spark.read.option("header", "true").schema(df_clean.schema).csv(OUTPUT_CSV_PATH)
csv_filtered_count = csv_readback.filter(col("category") == "FURNITURE").count()
csv_reread_time = time.time() - t0

t0 = time.time()
parquet_readback = spark.read.parquet(OUTPUT_PARQUET_PATH)
parquet_filtered_count = parquet_readback.filter(col("category") == "FURNITURE").count()
parquet_reread_time = time.time() - t0

print(f"CSV     : filter(category == 'FURNITURE') -> {csv_filtered_count} rows in {csv_reread_time:.2f}s")
print(f"Parquet : filter(category == 'FURNITURE') -> {parquet_filtered_count} rows in {parquet_reread_time:.2f}s")

print("\nParquet physical plan (look for 'PushedFilters' - this is predicate pushdown):")
parquet_readback.filter(col("category") == "FURNITURE").explain(mode="simple")

print("\nAlso note column pruning: Parquet is columnar, so selecting only 2-3 columns")
print("reads only those column chunks from disk. CSV is row-based and must read every")
print("column of every row regardless of what you select.")
t0 = time.time()
parquet_readback.select("category", "sales").filter(col("sales") > 500).count()
pruned_time = time.time() - t0
print(f"Parquet column-pruned scan (2 cols only) time: {pruned_time:.2f}s")

# ---------------------------------------------------------------------------
# ASSIGNMENT QUESTIONS DIRECT CODE DEMONSTRATIONS (Week-6 Q1-Q15)
# ---------------------------------------------------------------------------
print("\n" + "=" * 80)
print("WEEK-6 ASSIGNMENT QUESTIONS - EXPLICIT DEMONSTRATIONS")
print("=" * 80)

# Q3 Demo: Read CSV with header=True and inferSchema=True
print("\n--- Q3: Reading with inferSchema=True ---")
q3_df = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv(CSV_PATH)
)
print("Schema inferred automatically by Spark:")
q3_df.select("Order ID", "Sales", "Quantity").printSchema()

# Q5 Demo: Select product_id and price where category is 'Electronics'
# (Using 'Product ID' and 'Sales' where 'Category' is 'Technology' as Superstore equivalents)
print("\n--- Q5: Select columns with filters ---")
q5_df = (
    df_clean
    .select(col("product_id"), col("sales").alias("price"))
    .filter(col("category") == "TECHNOLOGY")
)
q5_df.show(3, truncate=False)

# Q6 Demo: Rename old_name to new_name, and cast price from String to Double
print("\n--- Q6: Renaming and Casting ---")
# Creating a dummy dataframe to simulate starting state
dummy_data = [("Prod_01", "299.99"), ("Prod_02", "120.50")]
dummy_schema = ["old_name", "price"]
q6_df_start = spark.createDataFrame(dummy_data, dummy_schema)
print("Before Q6 transformation:")
q6_df_start.printSchema()

q6_df_revised = (
    q6_df_start
    .withColumnRenamed("old_name", "new_name")
    .withColumn("price", col("price").cast(DoubleType()))
)
print("After Q6 transformation (renamed to 'new_name' and cast to Double):")
q6_df_revised.printSchema()

# Q8 Demo: Filter orders where status is 'Completed' AND amount > 1000
# (Using 'Ship Mode' == 'Standard Class' AND 'Sales' > 1000 as Superstore equivalents)
print("\n--- Q8: Logical AND Filter ---")
q8_df = (
    df_clean
    .filter((col("ship_mode") == "Standard Class") & (col("sales") > 1000))
)
print(f"Number of orders matching criteria: {q8_df.count()}")
q8_df.select("order_id", "ship_mode", "sales").show(3)

# Q10 Demo: Add new column final_price which is base_price * 1.18
print("\n--- Q10: Derived column (base_price * 1.18) ---")
q10_df = (
    df_clean
    .select(col("sales").alias("base_price"))
    .withColumn("final_price", spark_round(col("base_price") * 1.18, 2))
)
q10_df.show(3)

# Q12 Demo: Load Parquet, filter out null user_id (or customer_id), and save as CSV
print("\n--- Q12: Load Parquet -> Clean Nulls -> Save as CSV ---")
parquet_input = spark.read.parquet(OUTPUT_PARQUET_PATH)
q12_cleaned = parquet_input.dropna(subset=["customer_id"])
q12_output_path = os.path.join(script_dir, "output", "q12_output_csv")
q12_cleaned.write.mode("overwrite").option("header", "true").csv(q12_output_path)
print(f"Successfully processed Q12. Output saved to: {q12_output_path}")

# Q14 Demo: Filter rows where region is 'North' OR priority is 'High'
# (Using region is 'West' OR segment is 'Corporate' as Superstore equivalents)
print("\n--- Q14: Logical OR Filter ---")
q14_df = (
    df_clean
    .filter((col("region") == "West") | (col("segment") == "Corporate"))
)
print(f"Number of rows matching region='West' OR segment='Corporate': {q14_df.count()}")
q14_df.select("order_id", "region", "segment").show(3)

# ---------------------------------------------------------------------------
# 11. BEST PRACTICES REMINDER
# ---------------------------------------------------------------------------
print("\n" + "=" * 80)
print("BEST PRACTICES APPLIED IN THIS SCRIPT")
print("=" * 80)
print("""
- Explicit schema on read instead of inferSchema (avoids an extra full scan)
- show()/count() used for inspection instead of collect() (never pulled full
  data to the driver - with 300K+ rows collect() risks driver OOM and is
  unnecessary since we only need to see samples or aggregates)
- Parquet used for the final storage layer -> columnar, compressed, supports
  predicate pushdown and column pruning, and is splittable for parallel reads
- partitionBy("order_year") on Parquet write -> future queries filtering by
  year can skip whole partitions entirely (partition pruning)
- Reduced spark.sql.shuffle.partitions to 8 to match this small local
  environment (default 200 would create excessive tiny tasks here)
""")

spark.stop()
print("Spark session stopped.")
