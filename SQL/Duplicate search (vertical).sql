set @from_table = '.....';

SET @cols = (
    SELECT GROUP_CONCAT(CONCAT('`', COLUMN_NAME, '`') ORDER BY ORDINAL_POSITION SEPARATOR ', ')
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @from_table
);

SET @fetch = CONCAT('
    WITH cte AS (
        SELECT *, 
               ROW_NUMBER() OVER(PARTITION BY ', @cols, ') AS row_num
        FROM ', @from_table, '
    )
    SELECT * FROM cte WHERE row_num > 1;
');

PREPARE stmt FROM @fetch;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
