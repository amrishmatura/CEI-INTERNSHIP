import io
import os
from contextlib import redirect_stdout
from pathlib import Path

python_executable = r"C:\Python314\python.exe"
os.environ["PYSPARK_DRIVER_PYTHON"] = python_executable
os.environ["PYSPARK_PYTHON"] = python_executable

try:
    from pyspark.sql import SparkSession
    from pyspark.sql.functions import avg, col, count, expr, min, max, sum as spark_sum, when, to_timestamp
except ImportError:
    raise SystemExit(
        "PySpark is not installed. Install it with: python -m pip install pyspark --user"
    )


def main():
    output_path = Path(__file__).resolve().parent / "Output.md"
    buffer = io.StringIO()

    with redirect_stdout(buffer):
        spark = (
            SparkSession.builder
            .master("local[1]")
            .appName("Week5SparkAssignment")
            .config("spark.pyspark.driver.python", python_executable)
            .config("spark.pyspark.python", python_executable)
            .getOrCreate()
        )

        data_path = Path(__file__).resolve().parents[1] / "Assignment_3" / "superstore.csv"
        if not data_path.exists():
            raise FileNotFoundError(f"Superstore dataset not found at {data_path}")

        superstore_df = (
            spark.read
                .option("header", "true")
                .option("inferSchema", "true")
                .csv(str(data_path))
        )

        print("\n=== Loaded Superstore dataset ===")
        superstore_df.printSchema()
        superstore_df.show(5, truncate=False)

        superstore_clean = (
            superstore_df.dropDuplicates(["Order ID", "Order Date"])
                          .na.fill({"Ship Mode": "Unknown"})
        )

        superstore_numeric = (
            superstore_clean
            .withColumn("Sales_num", expr("try_cast(Sales AS DOUBLE)"))
            .withColumn("Discount_num", expr("try_cast(Discount AS DOUBLE)"))
        )

        transactions_df = superstore_numeric.select(
            col("Customer ID").alias("user_id"),
            col("Order Date").alias("transaction_date"),
            col("Order ID").alias("transaction_id")
        )

        sales_df = superstore_numeric.select(
            col("Region").alias("region"),
            col("Category").alias("product_category"),
            col("Sales_num").alias("sale_amount")
        )

        status_df = superstore_numeric.withColumn(
            "status",
            when(col("Profit") < 0, None).otherwise("Profitable")
        )

        city_df = superstore_numeric.select(col("City").alias("city"))

        filtered_df = superstore_numeric.filter(
            (col("Region") == "West") &
            (col("Discount_num") >= 0.1) &
            (col("Discount_num") <= 0.2)
        )

        timestamp_df = superstore_clean.withColumn(
            "event_time",
            to_timestamp(col("Order Date"), "M/d/yyyy")
        ).drop("Order Date")

        print("Q3: Remove duplicate rows by user_id and transaction_date ")
        unique_transactions_df = transactions_df.dropDuplicates(["user_id", "transaction_date"])
        unique_transactions_df.show(5, truncate=False)

        print("Q4: Filter West and group by product_category average sale_amount ")
        west_avg_df = (
            sales_df
            .filter(col("region") == "West")
            .groupBy("product_category")
            .agg(avg("sale_amount").alias("avg_sale_amount"))
        )
        west_avg_df.show(5, truncate=False)

        print("Q5: Fill null values in status with 'Unknown' ")
        status_filled_df = status_df.na.fill({"status": "Unknown"})
        status_filled_df.show(5, truncate=False)

        print("Q6: Total count of records per city where count > 100 ")
        city_counts_df = (
            city_df.groupBy("city")
                   .agg(count("*").alias("city_count"))
                   .filter(col("city_count") > 100)
        )
        city_counts_df.show(5, truncate=False)

        print("Q8: Filter West transactions with 10% to 20% discount ")
        filtered_df.show(5, truncate=False)

        print("Q10: Cast Order Date to TimestampType and rename to event_time ")
        timestamp_df.printSchema()
        timestamp_df.show(5, truncate=False)

        print("Q12: Remove rows where Customer ID is null OR Ship Mode is empty ")
        clean_store_df = superstore_clean.filter(
            col("Customer ID").isNotNull() &
            (col("Ship Mode") != "")
        )
        clean_store_df.show(5, truncate=False)

        print("Q13: Calculate min, max, and mean of Sales ")
        price_summary_df = superstore_numeric.agg(
            min("Sales_num").alias("min_sales"),
            max("Sales_num").alias("max_sales"),
            avg("Sales_num").alias("mean_sales")
        )
        price_summary_df.show(truncate=False)

        print("Q15: Final processing pipeline ")
        final_revenue_df = (
            superstore_numeric.dropDuplicates(["Order ID"])
                           .na.fill({"Sales_num": 0})
                           .groupBy("Region")
                           .agg(spark_sum(col("Sales_num")).alias("total_revenue"))
        )
        final_revenue_df.show(10, truncate=False)

        spark.stop()

    output_content = buffer.getvalue()
    output_path.write_text(output_content, encoding="utf-8")
if __name__ == "__main__":
    main()
