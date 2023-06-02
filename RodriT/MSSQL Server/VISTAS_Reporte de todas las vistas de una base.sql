select schema_name(schema_id) as schema_name,
       name as view_name
from sys.views
order by schema_name,
         view_name;