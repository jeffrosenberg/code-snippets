--
-- Export data via BCP
-- Full BCP syntax: https://msdn.microsoft.com/en-us/library/ms162802.aspx
--

DECLARE @sql nvarchar(4000), @filename nvarchar(4000), @cmd nvarchar(4000);
DECLARE @formatFileParameters varchar(50), @fieldDelimiter varchar(5), @rowDelimiter varchar(5);
SET @sql = ''; -- Use 3-part name (include database name)
SET @filename = ''
SET @formatFileParameters = '-c' -- -c = char | -w = nchar | -n = native | -N = native (unicode)
SET @fieldDelimiter = '\t' --Default: \t
SET @rowDelimiter = '\n' --Default: \n
--EXEC (@sql) --uncomment to test @sql before running

SET @cmd = 'bcp "' + @sql 
           + '" queryout ' + @filename + ' ' + @FormatFileParameters -- File name and format
           + ' -S ' + @@SERVERNAME -- Target server
           + ' -T' -- Trusted connection
           + ' -t "' + @fieldDelimiter + '"' -- Field delimiter
           + ' -r "' + @rowDelimiter + '"' -- Row delimiter
PRINT @cmd
EXEC xp_cmdshell @cmd