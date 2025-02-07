# Layoff Data Analysis: Data Cleaning & EDA Project

## Introduction

This project focuses on data cleaning and exploratory data analysis (EDA) of layoff data sourced from Kaggle. The goal is to preprocess the dataset, handle inconsistencies, and extract meaningful insights using SQL functions and analytical techniques.


---

## Data Cleaning Steps

### 1. Removing Duplicates

Since the dataset does not contain a unique identifier column, duplicates were identified using all available columns.

A row_number() window function was used to assign a unique number to each row based on duplicate values.

Rows with row_num > 1 were deleted to remove duplicates.

The extra column created for this operation was dropped at the end of the process.


### 2. Standardizing Data

To ensure data consistency, the following steps were performed:

- Data type conversion: The date column was updated from text format to a proper date format.

- Trimming: Whitespace was removed from relevant columns to prevent discrepancies in data analysis.


### 3. Handling Null and Empty Values

- Missing values in crucial columns were filled using appropriate strategies, such as forward fill or default values.

- Unnecessary null or empty rows were removed.


### 4. Removing Unwanted Rows and Columns

- Irrelevant or redundant columns that did not contribute to the analysis were dropped.

- Rows containing incomplete data that could not be reasonably imputed were removed.



---

## Exploratory Data Analysis (EDA)

Several SQL functions and techniques were used to derive insights:

### 1. Understanding Layoff Trends

Grouping by Year/Company: Aggregated layoffs by year and company to identify trends.

Window Functions:

Used sum() to calculate total layoffs over different time periods.

Applied dense_rank() to rank companies based on layoff counts.

Common Table Expressions (CTE) helped break down and structure complex queries.



### 2. Key Questions Answered

Which year had the highest layoffs?

Which company had the most layoffs?

What industries were most affected?

How do layoffs vary over time?



---

## Technologies Used

- SQL: For data cleaning, transformation, and analysis.





---

## Conclusion

This project successfully cleaned and analyzed layoff data, ensuring accuracy and extracting meaningful insights. The processed dataset and queries used can serve as a foundation for further analysis and visualization.
