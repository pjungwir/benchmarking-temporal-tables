\set id 24374
\set valid_from 2025-05-11
\set valid_til 2026-05-26

EXPLAIN ANALYZE SELECT 1 FROM (   SELECT  uk.uk_start_value, uk.uk_end_value,           NULLIF(LAG(uk.uk_end_value) OVER (ORDER BY uk.uk_start_value),           uk.uk_start_value) AS x   FROM   (     SELECT  COALESCE(LOWER(x.valid_at), '-Infinity') AS uk_start_value,             COALESCE(UPPER(x.valid_at), 'Infinity') AS uk_end_value     FROM    ONLY public.employees AS x     WHERE id OPERATOR(pg_catalog.=) :id     AND valid_at::pg_catalog.anyrange OPERATOR(pg_catalog.&&) daterange(:'valid_from', :'valid_til')     FOR KEY SHARE OF x   ) AS uk ) AS uk WHERE uk.uk_start_value < COALESCE(UPPER(daterange(:'valid_from', :'valid_til')), 'Infinity') AND   uk.uk_end_value >= COALESCE(LOWER(daterange(:'valid_from', :'valid_til')), '-Infinity') HAVING MIN(uk.uk_start_value) <= COALESCE(LOWER(daterange(:'valid_from', :'valid_til')), '-Infinity') AND    MAX(uk.uk_end_value) >= COALESCE(UPPER(daterange(:'valid_from', :'valid_til')), 'Infinity') AND    array_agg(uk.x) FILTER (WHERE uk.x IS NOT NULL) IS NULL;

/*
                                                                                 QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=8.38..8.40 rows=1 width=4)
   Filter: ((array_agg(uk.x) FILTER (WHERE (uk.x IS NOT NULL)) IS NULL) AND (min(uk.uk_start_value) <= '2025-05-11'::date) AND (max(uk.uk_end_value) >= '2026-05-26'::date))
   ->  Subquery Scan on uk  (cost=8.33..8.37 rows=1 width=12)
         Filter: ((uk.uk_start_value < '2026-05-26'::date) AND (uk.uk_end_value >= '2025-05-11'::date))
         ->  WindowAgg  (cost=8.33..8.36 rows=1 width=12)
               Window: w1 AS (ORDER BY uk_1.uk_start_value)
               ->  Sort  (cost=8.33..8.34 rows=1 width=8)
                     Sort Key: uk_1.uk_start_value
                     ->  Subquery Scan on uk_1  (cost=0.28..8.32 rows=1 width=8)
                           ->  LockRows  (cost=0.28..8.31 rows=1 width=14)
                                 ->  Index Scan using employees_pkey on employees x  (cost=0.28..8.30 rows=1 width=14)
                                       Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))
(12 rows)



[v18beta1:5460][799904] benchbase=# \i lag.sql                                                                                                                                                                                                                                                                                                                 QUERY PLAN                                                                                                                                                                                   -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------                                                                                                  Aggregate  (cost=8.38..8.40 rows=1 width=4) (actual time=0.086..0.087 rows=1.00 loops=1)
   Filter: ((array_agg(uk.x) FILTER (WHERE (uk.x IS NOT NULL)) IS NULL) AND (min(uk.uk_start_value) <= '2025-05-11'::date) AND (max(uk.uk_end_value) >= '2026-05-26'::date))
   Buffers: shared hit=6
   ->  Subquery Scan on uk  (cost=8.33..8.37 rows=1 width=12) (actual time=0.080..0.082 rows=1.00 loops=1)
         Filter: ((uk.uk_start_value < '2026-05-26'::date) AND (uk.uk_end_value >= '2025-05-11'::date))
         Buffers: shared hit=6
         ->  WindowAgg  (cost=8.33..8.36 rows=1 width=12) (actual time=0.078..0.080 rows=1.00 loops=1)
               Window: w1 AS (ORDER BY uk_1.uk_start_value)
               Storage: Memory  Maximum Storage: 17kB
               Buffers: shared hit=6
               ->  Sort  (cost=8.33..8.34 rows=1 width=8) (actual time=0.071..0.071 rows=1.00 loops=1)
                     Sort Key: uk_1.uk_start_value
                     Sort Method: quicksort  Memory: 25kB
                     Buffers: shared hit=6
                     ->  Subquery Scan on uk_1  (cost=0.28..8.32 rows=1 width=8) (actual time=0.063..0.064 rows=1.00 loops=1)
                           Buffers: shared hit=6
                           ->  LockRows  (cost=0.28..8.31 rows=1 width=14) (actual time=0.062..0.064 rows=1.00 loops=1)
                                 Buffers: shared hit=6
                                 ->  Index Scan using employees_pkey on employees x  (cost=0.28..8.30 rows=1 width=14) (actual time=0.048..0.048 rows=1.00 loops=1)
                                       Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))
                                       Index Searches: 1
                                       Buffers: shared hit=4
 Planning Time: 0.195 ms
 Execution Time: 0.141 ms
(24 rows)
*/
