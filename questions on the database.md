# Fragen an die Datenbank

With a dataset of 1 million rows in both the `Personen` and `Adresse` tables, it's important to formulate questions that
are both relevant and efficient to execute. Here's a refined list of questions that take into consideration the large
dataset:

1. **List the Total Number of Persons for Each Gender**: This involves a simple count and group by the `geschlechtId`.

2. **Find the Average Number of Addresses per City (`Ort`)**: Use aggregate functions over the `locations.Adresse`
   and `locations.Ort` tables.

3. **Display the Top 10 Most Populated Cities (`Ort`)**: A count of addresses grouped by city, ordered by the count.

4. **Calculate the Average Age of Persons in the Database**: This would require a calculation from the `geburtstag`
   column.

5. **Identify the City (`Ort`) With the Most Addresses**: Aggregate functions with a `JOIN` between `locations.Ort`
   and `locations.Adresse`.

6. **List Persons Born in a Specific Decade (e.g., 1990s)**: Filter `Personen` based on `geburtstag`.

7. **Count the Number of Persons with More Than One Address**: Use aggregate functions and a `HAVING` clause.

8. **Find the Person Who Has Lived in the Most Cities**: Requires counting distinct cities per person.

9. **Show the Distribution of Persons Across Different Address Types**: Group by `typeId` and count.

10. **Calculate the Longest Duration Someone Lived at a Single Address**: Use date-time calculations on `von` and `bis`.

11. **Rank Cities Based on the Number of Persons Living There**: Use window functions to rank cities.

12. **Display Total Number of Persons Who Have Moved in the Last Year**: A count based on `von` and `bis`.

13. **List All Persons Who Have an Address but No Recorded Gender**: Involves a `LEFT JOIN` and a `WHERE` clause
    checking for nulls.

14. **Show the City With the Highest Number of Different Address Types**: Aggregate and count distinct `typeId` per
    city.

15. **Find the Top 5 Most Common First Names (`vorname`) Among Persons**: A count grouped by `vorname`.

16. **Calculate the Median Age of Persons in Each City**: Requires window functions and percentile calculations.

17. **Display the Number of Persons Who Have Lived at an Address for More Than 5 Years**: Based on date-time
    calculations.

18. **List Persons Who Have Never Changed Their Address**: Filter based on the count of addresses.

19. **Identify the Address Type Most Commonly Associated with Each City**: Aggregate functions with a `JOIN` between
    address type and city.

20. **Show the Average Number of Times Persons Have Moved**: A count of address changes per person.

21. **Find the Person Who Has Moved the Furthest Distance (Assuming Distance Between Cities Is Known)**: Involves
    calculations based on hypothetical distance data.

22. **Count the Number of Addresses That Have Been Home to More Than 10 Different Persons**: Aggregation and a `HAVING`
    clause.

23. **List the Persons Who Have Lived in the Same Address as Someone Else at a Different Time**: Requires self-join and
    date comparisons.

24. **Show the Total Number of Persons for Each `bundesland`**: Group by `bundesland` in `locations.Ort` and count.

25. **Generate a List of Persons With Their Longest Stay at an Address**: Requires date-time calculations and window
    functions.

# Lösungen

1. **List the Total Number of Persons for Each Gender**
   ```sql
   SELECT geschlechtId, COUNT(*) AS Total
   FROM people.Personen
   GROUP BY geschlechtId;
   ```

2. **Find the Average Number of Addresses per City (`Ort`)**
   ```sql
   SELECT o.ort, AVG(CountPerOrt) AS AverageAddresses
   FROM (
       SELECT ortId, COUNT(*) AS CountPerOrt
       FROM locations.Adresse
       GROUP BY ortId
   ) AS SubQuery
   JOIN locations.Ort o ON SubQuery.ortId = o.id
   GROUP BY o.ort;
   ```

3. **Display the Top 10 Most Populated Cities (`Ort`)**
   ```sql
   SELECT TOP 10 o.ort, COUNT(*) AS NumberOfAddresses
   FROM locations.Adresse a
   JOIN locations.Ort o ON a.ortId = o.id
   GROUP BY o.ort
   ORDER BY COUNT(*) DESC;
   ```

4. **Calculate the Average Age of Persons in the Database**
   ```sql
   SELECT AVG(DATEDIFF(YEAR, geburtstag, GETDATE())) AS AverageAge
   FROM people.Personen;
   ```

5. **Identify the City (`Ort`) With the Most Addresses**
   ```sql
   SELECT TOP 1 o.ort
   FROM locations.Adresse a
   JOIN locations.Ort o ON a.ortId = o.id
   GROUP BY o.ort
   ORDER BY COUNT(*) DESC;
   ```

6. **List Persons Born in a Specific Decade (e.g., 1990s)**
   ```sql
   SELECT *
   FROM people.Personen
   WHERE YEAR(geburtstag) BETWEEN 1990 AND 1999;
   ```

7. **Count the Number of Persons with More Than One Address**
   ```sql
   SELECT COUNT(DISTINCT personId)
   FROM people.PersonenAdressen
   GROUP BY personId
   HAVING COUNT(adresseId) > 1;
   ```

8. **Find the Person Who Has Lived in the Most Cities**
   ```sql
   SELECT TOP 1 p.personId
   FROM people.PersonenAdressen pa
   JOIN locations.Adresse a ON pa.adresseId = a.id
   GROUP BY p.personId
   ORDER BY COUNT(DISTINCT a.ortId) DESC;
   ```

9. **Show the Distribution of Persons Across Different Address Types**
   ```sql
   SELECT at.adressenTyp, COUNT(DISTINCT pa.personId) AS Total
   FROM locations.AdressenTyp at
   JOIN people.PersonenAdressen pa ON at.id = pa.typeId
   GROUP BY at.adressenTyp;
   ```

10. **Calculate the Longest Duration Someone Lived at a Single Address**
    ```sql
    SELECT TOP 1 personId, DATEDIFF(DAY, MIN(von), MAX(bis)) AS LongestDuration
    FROM people.PersonenAdressen
    GROUP BY personId
    ORDER BY LongestDuration DESC;
    ```

11. **Rank Cities Based on the Number of Persons Living There**
    ```sql
    SELECT o.ort, RANK() OVER (ORDER BY COUNT(DISTINCT pa.personId) DESC) AS Rank
    FROM people.PersonenAdressen pa
    JOIN locations.Adresse a ON pa.adresseId = a.id
    JOIN locations.Ort o ON a.ortId = o.id
    GROUP BY o.ort;
    ```

12. **Display Total Number of Persons Who Have Moved in the Last Year**
    ```sql
    SELECT COUNT(DISTINCT personId)
    FROM people.PersonenAdressen
    WHERE von >= DATEADD(YEAR, -1, GETDATE());
    ```

13. **List All Persons Who Have an Address but No Recorded Gender**
    ```sql
    SELECT DISTINCT p.id, p.name
    FROM people.Personen p
    LEFT JOIN people.PersonenAdressen pa ON p.id = pa.personId
    WHERE p.geschlechtId IS NULL AND pa.adresseId IS NOT NULL;
    ```

14. **Show the City With the Highest Number of Different Address Types**
    ```sql
    SELECT TOP 1 o.ort
    FROM locations.Ort o
    JOIN locations.Adresse a ON o.id = a.ortId
    JOIN people.PersonenAdressen pa ON a.id = pa.adresseId
    GROUP BY o.ort
    ORDER BY COUNT(DISTINCT pa.typeId) DESC;
    ```

15. **Find the Top 5 Most Common First Names (`vorname`) Among Persons**
    ```sql
    SELECT TOP 5 vorname, COUNT(*) AS Total
    FROM people.Personen
    GROUP BY vorname
    ORDER BY Total DESC;
    ```

16. **Calculate the Median Age of Persons in Each City**
    ```sql
    SELECT o.ort, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY DATEDIFF(YEAR, p.geburtstag, GETDATE())) OVER (PARTITION BY o.ort) AS MedianAge
    FROM people.Personen p
    JOIN people.PersonenAdressen pa ON p.id = pa.personId
    JOIN locations.Adresse a ON pa.adresseId = a.id
    JOIN locations.Ort o ON a.ortId = o.id;
    ```

17. **Display the Number of Persons Who Have Lived at an Address for More Than 5 Years**
    ```sql
    SELECT COUNT(DISTINCT personId)
    FROM people.PersonenAdressen
    WHERE DATEDIFF(YEAR, von, bis) > 5;
    ```

18. **List Persons Who Have Never Changed Their Address**
    ```sql
    SELECT personId
    FROM people.PersonenAdressen
    GROUP BY personId
    HAVING COUNT(DISTINCT adresseId) = 1;
    ```

19. **Identify the Address Type Most Commonly Associated with Each City**
    ```sql
    SELECT o.ort, TOP 1 at.adressenTyp
    FROM locations.Ort o
    JOIN locations.Adresse a ON o.id = a.ortId
    JOIN people.PersonenAdressen pa ON a.id = pa.adresseId
    JOIN locations.AdressenTyp at ON pa.typeId = at.id
    GROUP BY o.ort, at.adressenTyp
    ORDER BY COUNT(*) DESC;
    ```

20. **Show the Average Number of Times Persons Have Moved**
    ```sql
    SELECT AVG(Moves) AS AverageMoves
    FROM (
        SELECT personId, COUNT(*) AS Moves
        FROM people.PersonenAdressen
        GROUP BY personId
    ) AS SubQuery;
    ```

21. **Count the Number of Addresses That Have Been Home to More Than 10 Different Persons**
    ```sql
    SELECT COUNT(*)
    FROM (
        SELECT adresseId
        FROM people.PersonenAdressen
    GROUP BY adresseId
    HAVING COUNT(DISTINCT personId) > 10
    ) AS SubQuery;
    ```

22. **List the Persons Who Have Lived in the Same Address as Someone Else at a Different Time**
    ```sql
    SELECT DISTINCT p1.personId
    FROM people.PersonenAdressen p1
    JOIN people.PersonenAdressen p2 ON p1.adresseId = p2.adresseId AND p1.personId != p2.personId
    WHERE p1.von > p2.bis OR p1.bis < p2.von;
    ```

23. **Show the Total Number of Persons for Each `bundesland`**
    ```sql
    SELECT o.bundesland, COUNT(DISTINCT pa.personId) AS Total
    FROM locations.Ort o
    JOIN locations.Adresse a ON o.id = a.ortId
    JOIN people.PersonenAdressen pa ON a.id = pa.adresseId
    GROUP BY o.bundesland;
    ```

24. **Generate a List of Persons With Their Longest Stay at an Address**
    ```sql
    SELECT personId, MAX(DATEDIFF(DAY, von, bis)) AS LongestStay
    FROM people.PersonenAdressen
    GROUP BY personId;
    ```

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
