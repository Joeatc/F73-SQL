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
