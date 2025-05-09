\set id 24374
\set valid_from 2025-05-11
\set valid_til 2026-05-26

EXPLAIN ANALYZE SELECT 1 FROM (   SELECT valid_at AS r   FROM ONLY public.employees x WHERE id OPERATOR(pg_catalog.=) :id   AND valid_at::pg_catalog.anyrange OPERATOR(pg_catalog.&&) daterange(:'valid_from', :'valid_til')::pg_catalog.daterange   FOR KEY SHARE OF x ) x1 HAVING   daterange(:'valid_from', :'valid_til')::pg_catalog.daterange OPERATOR(pg_catalog.<@) pg_catalog.range_agg(x1.r);

/*
                                              QUERY PLAN 
-------------------------------------------------------------------------------------------------------
 Aggregate  (cost=8.32..8.34 rows=1 width=4)
   Filter: ('[2025-05-11,2026-05-26)'::daterange <@ range_agg(x1.r))
   ->  Subquery Scan on x1  (cost=0.28..8.32 rows=1 width=10)
         ->  LockRows  (cost=0.28..8.31 rows=1 width=16)
               ->  Index Scan using employees_pkey on employees x  (cost=0.28..8.30 rows=1 width=16)
                     Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))
(6 rows)




[v18beta1:5460][799904] benchbase=# \i range_agg.sql
                                                                    QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=8.32..8.34 rows=1 width=4) (actual time=0.078..0.078 rows=1.00 loops=1)                                                                                                                                                                                        Filter: ('[2025-05-11,2026-05-26)'::daterange <@ range_agg(x1.r))
   Buffers: shared hit=6
   ->  Subquery Scan on x1  (cost=0.28..8.32 rows=1 width=10) (actual time=0.068..0.070 rows=1.00 loops=1)
         Buffers: shared hit=6
         ->  LockRows  (cost=0.28..8.31 rows=1 width=16) (actual time=0.068..0.069 rows=1.00 loops=1)
               Buffers: shared hit=6                                                                                                                                                                                                                                                         ->  Index Scan using employees_pkey on employees x  (cost=0.28..8.30 rows=1 width=16) (actual time=0.054..0.054 rows=1.00 loops=1)                                                                                                                                                  Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))                                                                                                                                                                                             Index Searches: 1
                     Buffers: shared hit=4
 Planning Time: 0.133 ms
 Execution Time: 0.113 ms
(13 rows)
*/
