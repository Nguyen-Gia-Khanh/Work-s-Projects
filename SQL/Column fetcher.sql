SELECT 
    GROUP_CONCAT(column_name
        ORDER BY ordinal_position
        SEPARATOR ', ')
FROM
    information_schema.columns
WHERE
    table_name = @from_table
        AND table_schema = DATABASE();