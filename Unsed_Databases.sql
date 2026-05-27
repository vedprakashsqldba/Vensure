
WITH DBUsage AS
(
    SELECT  
        d.name AS DatabaseName,
        max(d.create_date) as Created_Date,
        MAX(
            COALESCE(
                us.last_user_seek,
                us.last_user_scan,
                us.last_user_lookup,
                us.last_user_update
            )
        ) AS LastUsedDate
    FROM sys.databases d
    LEFT JOIN sys.dm_db_index_usage_stats us
        ON d.database_id = us.database_id
    GROUP BY d.name
)
SELECT *
FROM DBUsage
WHERE LastUsedDate IS NULL
   OR LastUsedDate < DATEADD(MONTH, -6, GETDATE())
ORDER BY LastUsedDate;