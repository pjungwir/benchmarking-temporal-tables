# 2024-08-05_17-59-09

Ran this with `TemporalConstancts.CHECK_FK_GAUSSIAN_RANGE = false`.
It gave a lot of failed FKs:

```
Completed Transactions:
com.oltpbenchmark.benchmarks.temporal.procedures.CheckForeignKeyRangeAgg/01      [304110] ********************************************************************************
com.oltpbenchmark.benchmarks.temporal.procedures.CheckForeignKeyLag/02           [304086] *******************************************************************************
com.oltpbenchmark.benchmarks.temporal.procedures.CheckForeignKeyExists/03        [303905] *******************************************************************************
com.oltpbenchmark.benchmarks.temporal.procedures.Noop/04                         [ 19155] *****

Aborted Transactions:
<EMPTY>

Rejected Transactions (Server Retry):
<EMPTY>

Rejected Transactions (Retry Different):
<EMPTY>

Unexpected SQL Errors:
com.oltpbenchmark.benchmarks.temporal.procedures.CheckForeignKeyRangeAgg/01      [335071] ********************************************************************************
com.oltpbenchmark.benchmarks.temporal.procedures.CheckForeignKeyLag/02           [334739] *******************************************************************************
com.oltpbenchmark.benchmarks.temporal.procedures.CheckForeignKeyExists/03        [334526] *******************************************************************************
```

Surprisingly the `EXISTS` impl is way faster than the others.
I think that's because when the FK is not valid, it can abort quickly and not run most of the plan.
