# Week 5 
## Contents

- `spark.py` - runnable PySpark pipeline that loads `Assignment_3/superstore.csv`, cleans the data, and prints query results.
- `Spark_Answers.md` - Spark concept answers and explanations for the current assignment questions.
- `Output.md` - actual output produced by `spark.py`.
- `superstore.csv` - the Superstore dataset used in the assignment.

## Description

The assignment covers:
- Spark advantages over traditional MapReduce
- In-memory computing and iterative algorithm performance
- DataFrame deduplication, null handling, filtering, and aggregation
- Wide transformations and shuffle behavior
- Schema casting, column renaming, and dataset cleaning best practices
- Safe numeric conversion for messy CSV fields using `try_cast`

## How to use

Run `python spark.py` from the `Assignment_5` folder to generate the latest output in `Output.md`.
Use `Spark_Answers.md` for question explanations and `spark.py` for runnable PySpark logic.
