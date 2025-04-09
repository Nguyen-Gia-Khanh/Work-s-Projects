
SELECT GROUP_CONCAT(column_name SEPARATOR ', ')
FROM information_schema.columns
WHERE table_schema = database();

SET @from_table = '.....';
-- Horizontal search
SELECT CONCAT(
    'SELECT ',
    GROUP_CONCAT(CONCAT(
        'SUM(CASE WHEN `', COLUMN_NAME, '` IS NULL THEN 1 ELSE 0 END) AS `', COLUMN_NAME, '_null_count`'
    ) SEPARATOR ', '),
    ' FROM ', @from_table, ';'
) INTO @query
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @from_table AND TABLE_SCHEMA = DATABASE();

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- Vertical search
SET @from_table = 'layoffs';
SELECT GROUP_CONCAT(
    CONCAT('SELECT ''', COLUMN_NAME, ''' AS column_name, COUNT(*) 
    FROM ', DATABASE(), '.', @from_table, ' WHERE `', COLUMN_NAME, '` IS NULL')
    SEPARATOR ' UNION ALL '
) INTO @query
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @from_table;

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
