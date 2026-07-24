# PySpark Architecture & Data Processing Pipeline (Week 6)

This contains the implementation of a PySpark ETL (Extract, Transform, Load) data pipeline using the **Superstore dataset** (`Superstore.csv`). The project covers fundamental Apache Spark concepts, architectural designs, performance optimizations, and answers the Week-6 assignment questions.

---

## 🚀 Getting Started

### Prerequisites
* **Python 3.8+**
* **Java 8 or 11** (Required by Apache Spark JVM)
* **PySpark 4.x** (Bundled with Hadoop 3.5.0)

### Setup & Installation
1. **Activate Virtual Environment** (from project root):
   ```powershell
   .\.venv\Scripts\Activate.ps1
   ```
2. **Windows Hadoop Configuration**:
   This project contains a local `hadoop/bin` directory populated with `winutils.exe` and `hadoop.dll`. The pipeline script dynamically registers these files at runtime via:
   ```python
   os.environ["HADOOP_HOME"] = hadoop_home
   os.environ["PATH"] += os.pathsep + os.path.join(hadoop_home, "bin")
   ```
   This resolves the native Windows Hadoop initialization exceptions (`FileNotFoundException`).

### Running the Pipeline
Run the main script using python:
```bash
python Assignment_6/retail_pipeline.py
```

---

## 📂 Project Structure

```text
Assignment_6/
│
├── Superstore.csv            # Source dataset
├── retail_pipeline.py        # Executable PySpark pipeline script
├── README.md                 # Project documentation
│
└── output/                   # Directory containing ETL outputs
    ├── cleaned_retail_csv/      # Cleaned data in CSV format
    ├── cleaned_retail_parquet/  # Optimized columnar Parquet format (partitioned by year)
    └── q12_output_csv/          # Output of Q12 clean processing
```

---

## 💡 Core Apache Spark Concepts Covered

### 1. Spark Architecture & Modes (Q1, Q13)
* **Driver**: Coordinates tasks, compiles the logical Directed Acyclic Graph (DAG), and manages memory.
* **Cluster Manager**: Allocates resources on the cluster (YARN, Kubernetes, Mesos, or Local).
* **Executors**: Workers that execute tasks in parallel across dataset partitions.
* **Client Mode** vs. **Cluster Mode**: Client mode hosts the driver on the master submitting node (great for local debugging), while Cluster mode spawns the driver inside a worker container.

### 2. Lazy Evaluation & Lineage (Q2, Q7)
Spark defers executing transformations until an action is called. It maintains a **Lineage Graph (DAG)** to dynamically optimize execution paths and provide automatic fault tolerance (recomputing missing partitions if a worker node fails).

### 3. CSV vs. Columnar Parquet (Q4, Q9)
* **Row-based (CSV)**: Reads every row of every column even for simple selections.
* **Columnar (Parquet)**: Employs **Column Pruning** (loading only requested fields) and **Predicate Pushdown** (skipping file blocks that don't match filter criteria based on row-group min/max statistics).
* *Performance Metric*: Columnar storage compressed the dataset from **2.25 MB (CSV)** down to **584.20 KB (Parquet)** on disk.

### 4. Transformations vs. Actions (Q11, Q15)
* **Transformations** (Lazy): `select()`, `filter()`, `withColumn()`, `groupBy()`
* **Actions** (Eager): `show()`, `count()`, `write`, `collect()`
* *Best Practice*: When dealing with massive datasets, use `.show(n)` instead of `.collect()` to prevent Driver Out-of-Memory (OOM) crashes.

---

## 📝 Assignment Solutions & Demonstrations

The main pipeline script `retail_pipeline.py` contains executable demonstrations for all Week-6 coding challenges, including:
* **Q3**: Automatically parsing schemas using `inferSchema=True`.
* **Q5**: Selecting columns with predicate filtering.
* **Q6**: Renaming column names and casting String to Double.
* **Q8**: Logical `AND` multi-column filtering.
* **Q10**: Performing arithmetic operations to add calculated columns (e.g., final tax price).
* **Q12**: Reading Parquet, cleaning nulls, and saving back to CSV.
* **Q14**: Logical `OR` multi-column filtering.
