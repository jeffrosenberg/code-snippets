
SELECT index_name = i.name
     , i.type_desc
     , [schema_name] = s.name
     , table_name = t.name
     , [column] = c.name
     , i.is_unique
     , i.is_primary_key
     , ic.key_ordinal
     , ic.is_included_column
     , i.has_filter
     , i.filter_definition
FROM sys.indexes AS i
INNER JOIN sys.tables AS t
  ON t.object_id = i.object_id
INNER JOIN sys.schemas AS s
  ON s.schema_id = t.schema_id
INNER JOIN sys.index_columns AS ic
  ON ic.index_id = i.index_id
    AND ic.object_id = i.object_id
INNER JOIN sys.columns AS c
  ON c.object_id = ic.object_id
    AND c.column_id = ic.column_id
--WHERE t.name LIKE ''
WHERE s.name IN ('dbo','archive','audit','util')
ORDER BY t.name, i.name, ic.key_ordinal
