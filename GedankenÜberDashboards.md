# Dashboard

Creating a dashboard from SQL Server data typically involves using a reporting or business intelligence tool that can
connect to your database and visualize the data. SQL Server integrates well with several tools like Microsoft Power BI,
SQL Server Reporting Services (SSRS), and even Excel.

Here are a few key visualizations that could make for an
effective dashboard based on your database. These visualizations will give an overview of different aspects of your
data:

### 1. Population Distribution by Gender

- **Data Query**: Aggregate count of persons by gender.
- **Visualization**: Pie chart or bar chart.
- **SQL Query**:
  ```sql
  SELECT g.gender, COUNT(*) AS Total
  FROM people.Personen p
  JOIN people.Geschlecht g ON p.geschlechtId = g.id
  GROUP BY g.gender;
  ```

### 2. Top 5 Cities by Number of Addresses

- **Data Query**: Cities with the most addresses.
- **Visualization**: Bar chart.
- **SQL Query**:
  ```sql
  SELECT TOP 5 o.ort, COUNT(*) AS NumberOfAddresses
  FROM locations.Adresse a
  JOIN locations.Ort o ON a.ortId = o.id
  GROUP BY o.ort
  ORDER BY COUNT(*) DESC;
  ```

### 3. Average Age of Persons

- **Data Query**: Average age of persons in the database.
- **Visualization**: Single number visualization or gauge.
- **SQL Query**:
  ```sql
  SELECT AVG(DATEDIFF(YEAR, geburtstag, GETDATE())) AS AverageAge
  FROM people.Personen;
  ```

### 4. Persons Per Address Type

- **Data Query**: Distribution of persons across different address types.
- **Visualization**: Stacked bar chart or grouped bar chart.
- **SQL Query**:
  ```sql
  SELECT at.addressType, COUNT(DISTINCT pa.personId) AS Total
  FROM locations.AdressenTyp at
  JOIN people.PersonenAdressen pa ON at.id = pa.typeId
  GROUP BY at.addressType;
  ```

### 5. Persons Movement in the Last Year

- **Data Query**: Total number of persons who have moved in the last year.
- **Visualization**: Line chart over time or single number visualization.
- **SQL Query**:
  ```sql
  SELECT COUNT(DISTINCT personId)
  FROM people.PersonenAdressen
  WHERE von >= DATEADD(YEAR, -1, GETDATE());
  ```

### Implementing the Dashboard

- **Power BI**: A powerful tool for creating interactive dashboards. You can connect Power BI directly to your SQL
  Server database, use the SQL queries to retrieve data, and then create the visualizations. Power BI allows you to
  publish dashboards and share them with others.

- **SQL Server Reporting Services (SSRS)**: Good for creating traditional reports and dashboards. It's more static
  compared to Power BI but very effective for creating detailed reports.

- **Excel**: With features like Power Query and PivotTables, Excel can also be used for creating dashboards, especially
  if you're looking for a simpler and more familiar tool.
