Select table_name, column_name, column_type
from information_schema.columns
where table_schema = database()
order by table_name, ordinal_position;