SELECT partition_number, [rows] = SUM(row_count)
FROM sys.dm_db_partition_stats
WHERE object_id=OBJECT_ID('dbo.t_pick_container_label')   
  AND (index_id=0 or index_id=1)
GROUP BY partition_number
;
