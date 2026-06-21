# Python Pandas Shopping Analysis

## Overview

This project focuses on data cleaning, preprocessing, and exploratory data analysis (EDA) using the Pandas library in Python. The objective is to analyze a shopping dataset, clean the data, and prepare it for further analysis.

## Objectives

- Load the shopping dataset
- Explore the dataset structure and characteristics
- Handle missing values
- Remove duplicate records
- Clean and preprocess the data
- Export the cleaned dataset
- Perform exploratory data analysis (EDA)

## Project Structure

```
CEI INTERNSHIP/
├── Python_Pandas_Shopping_Analysis.ipynb
├── shopping_data.csv
├── shopping_cleaned.csv
└── README.md
```

## Technologies Used

- Python
- Pandas
- NumPy
- Jupyter Notebook
- Matplotlib / Seaborn (for visualizations)

## Files Description

| File | Description |
|------|-------------|
| `Python_Pandas_Shopping_Analysis.ipynb` | Jupyter Notebook containing the complete implementation and analysis |
| `shopping_data.csv` | Original shopping dataset (raw data) |
| `shopping_cleaned.csv` | Cleaned dataset generated after preprocessing |

## Tasks Performed

- Imported the dataset using Pandas
- Explored the dataset using `head()`, `info()`, and `describe()`
- Checked for missing values and handled appropriately
- Removed duplicate records
- Cleaned and preprocessed the dataset
- Performed exploratory data analysis with visualizations
- Exported the cleaned dataset as `shopping_cleaned.csv`

## Requirements

- Python 3.8 or higher
- pandas
- numpy
- matplotlib or seaborn
- Jupyter / JupyterLab

## How to Run

1. Install required libraries:

```bash
pip install pandas numpy matplotlib seaborn jupyter
```

2. Launch Jupyter Notebook:

```bash
jupyter notebook Python_Pandas_Shopping_Analysis.ipynb
```

3. Run all cells sequentially to reproduce the analysis and generate the cleaned dataset.

## Output

After running the notebook, the cleaned dataset is generated as:

- `shopping_cleaned.csv` — preprocessed data ready for analysis or modeling

## Notes

- Ensure both `shopping_data.csv` is in the same directory as the notebook before running
- For large datasets, consider optimizing memory usage or sampling for quick iteration
- Review the notebook for detailed comments on each preprocessing step

## Author

Amrish Matura  
Assignment: Python Pandas Shopping Analysis  
CEI Internship Program
