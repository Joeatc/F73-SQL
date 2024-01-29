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
