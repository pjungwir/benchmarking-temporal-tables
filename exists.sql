\set id 24374000
\set valid_from 2025-05-11
\set valid_til 2026-05-26

EXPLAIN (ANALYZE, COSTS OFF, BUFFERS OFF) SELECT 1 WHERE EXISTS (   SELECT  1   FROM ONLY public.employees x   WHERE id OPERATOR(pg_catalog.=) :id   AND valid_at::pg_catalog.anyrange OPERATOR(pg_catalog.&&) daterange(:'valid_from', :'valid_til')   AND COALESCE(LOWER(valid_at), '-Infinity') <= COALESCE(LOWER(daterange(:'valid_from', :'valid_til')), '-Infinity')   AND COALESCE(LOWER(daterange(:'valid_from', :'valid_til')), '-Infinity') < COALESCE(UPPER(valid_at), ' Infinity')   FOR KEY SHARE OF x) AND EXISTS (   SELECT  1   FROM ONLY public.employees x   WHERE id OPERATOR(pg_catalog.=) :id   AND valid_at::pg_catalog.anyrange OPERATOR(pg_catalog.&&) daterange(:'valid_from', :'valid_til')   AND COALESCE(LOWER(valid_at), '-Infinity') < COALESCE(UPPER(daterange(:'valid_from', :'valid_til')), ' Infinity')   AND COALESCE(UPPER(daterange(:'valid_from', :'valid_til')), 'Infinity') <= COALESCE(UPPER(valid_at), ' Infinity')   FOR KEY SHARE OF x) AND NOT EXISTS (   SELECT  1   FROM ONLY public.employees AS pk1   WHERE id OPERATOR(pg_catalog.=) :id   AND valid_at::pg_catalog.anyrange OPERATOR(pg_catalog.&&) daterange(:'valid_from', :'valid_til')   AND COALESCE(LOWER(daterange(:'valid_from', :'valid_til')), '-Infinity') < COALESCE(UPPER(valid_at), ' Infinity')   AND COALESCE(UPPER(valid_at), 'Infinity') < COALESCE(UPPER(daterange(:'valid_from', :'valid_til')), ' Infinity')   AND NOT EXISTS (     SELECT  1     FROM ONLY public.employees AS pk2     WHERE pk1.id OPERATOR(pg_catalog.=) pk2.id     AND COALESCE(LOWER(pk2.valid_at), '-Infinity') <= COALESCE(UPPER(pk1.valid_at), ' Infinity')     AND COALESCE(UPPER(pk1.valid_at), 'Infinity') < COALESCE(UPPER(pk2.valid_at), ' Infinity')     FOR KEY SHARE OF pk2  )   FOR KEY SHARE OF pk1);

/*
[v18beta1:5460][822135] benchbase_template=# \i exists.sql
                                                                                                                  QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Result  (cost=33.28..33.29 rows=1 width=4)
   One-Time Filter: ((InitPlan 1).col1 AND (InitPlan 2).col1 AND (NOT (InitPlan 4).col1))
   InitPlan 1
     ->  LockRows  (cost=0.28..8.32 rows=1 width=10)
           ->  Index Scan using employees_pkey on employees x  (cost=0.28..8.31 rows=1 width=10)
                 Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))
                 Filter: ((COALESCE(lower(valid_at), '-infinity'::date) <= '2025-05-11'::date) AND ('2025-05-11'::date < COALESCE(upper(valid_at), 'infinity'::date)))
   InitPlan 2
     ->  LockRows  (cost=0.28..8.32 rows=1 width=10)
           ->  Index Scan using employees_pkey on employees x_1  (cost=0.28..8.31 rows=1 width=10)
                 Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))
                 Filter: ((COALESCE(lower(valid_at), '-infinity'::date) < '2026-05-26'::date) AND ('2026-05-26'::date <= COALESCE(upper(valid_at), 'infinity'::date)))
   InitPlan 4
     ->  LockRows  (cost=0.28..16.64 rows=1 width=10)
           ->  Index Scan using employees_pkey on employees pk1  (cost=0.28..16.63 rows=1 width=10)
                 Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))
                 Filter: (('2025-05-11'::date < COALESCE(upper(valid_at), 'infinity'::date)) AND (COALESCE(upper(valid_at), 'infinity'::date) < '2026-05-26'::date) AND (NOT EXISTS(SubPlan 3)))
                 SubPlan 3
                   ->  LockRows  (cost=0.28..8.32 rows=1 width=10)
                         ->  Index Scan using employees_pkey on employees pk2  (cost=0.28..8.31 rows=1 width=10)
                               Index Cond: (id = pk1.id)
                               Filter: ((COALESCE(lower(valid_at), '-infinity'::date) <= COALESCE(upper(pk1.valid_at), 'infinity'::date)) AND (COALESCE(upper(pk1.valid_at), 'infinity'::date) < COALESCE(upper(valid_at), 'infinity'::date)))
(22 rows)



[v18beta1:5460][799904] benchbase=# \i exists.sql
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Result  (cost=33.28..33.29 rows=1 width=4) (actual time=0.141..0.142 rows=1.00 loops=1)
   One-Time Filter: ((InitPlan 1).col1 AND (InitPlan 2).col1 AND (NOT (InitPlan 4).col1))
   Buffers: shared hit=16
   InitPlan 1
     ->  LockRows  (cost=0.28..8.32 rows=1 width=10) (actual time=0.060..0.060 rows=1.00 loops=1)
           Buffers: shared hit=6
           ->  Index Scan using employees_pkey on employees x  (cost=0.28..8.31 rows=1 width=10) (actual time=0.046..0.046 rows=1.00 loops=1)
                 Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))
                 Filter: ((COALESCE(lower(valid_at), '-infinity'::date) <= '2025-05-11'::date) AND ('2025-05-11'::date < COALESCE(upper(valid_at), 'infinity'::date)))
                 Index Searches: 1
                 Buffers: shared hit=4
   InitPlan 2
     ->  LockRows  (cost=0.28..8.32 rows=1 width=10) (actual time=0.042..0.042 rows=1.00 loops=1)
           Buffers: shared hit=6
           ->  Index Scan using employees_pkey on employees x_1  (cost=0.28..8.31 rows=1 width=10) (actual time=0.041..0.041 rows=1.00 loops=1)
                 Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))
                 Filter: ((COALESCE(lower(valid_at), '-infinity'::date) < '2026-05-26'::date) AND ('2026-05-26'::date <= COALESCE(upper(valid_at), 'infinity'::date)))
                 Index Searches: 1
                 Buffers: shared hit=4
   InitPlan 4
     ->  LockRows  (cost=0.28..16.64 rows=1 width=10) (actual time=0.037..0.038 rows=0.00 loops=1)
           Buffers: shared hit=4
           ->  Index Scan using employees_pkey on employees pk1  (cost=0.28..16.63 rows=1 width=10) (actual time=0.037..0.037 rows=0.00 loops=1)
                 Index Cond: ((id = 24374) AND (valid_at && '[2025-05-11,2026-05-26)'::daterange))
                 Filter: (('2025-05-11'::date < COALESCE(upper(valid_at), 'infinity'::date)) AND (COALESCE(upper(valid_at), 'infinity'::date) < '2026-05-26'::date) AND (NOT EXISTS(SubPlan 3)))
                 Rows Removed by Filter: 1
                 Index Searches: 1
                 Buffers: shared hit=4
                 SubPlan 3
                   ->  LockRows  (cost=0.28..8.32 rows=1 width=10) (never executed)
                         ->  Index Scan using employees_pkey on employees pk2  (cost=0.28..8.31 rows=1 width=10) (never executed)
                               Index Cond: (id = pk1.id)
                               Filter: ((COALESCE(lower(valid_at), '-infinity'::date) <= COALESCE(upper(pk1.valid_at), 'infinity'::date)) AND (COALESCE(upper(pk1.valid_at), 'infinity'::date) < COALESCE(upper(valid_at), 'infinity'::date)))
                               Index Searches: 0
 Planning Time: 0.297 ms
 Execution Time: 0.194 ms
(36 rows)
*/
