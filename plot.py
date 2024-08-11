#!/usr/bin/env python

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import glob
import os

def most_recent_result(pattern):
    root = '/home/paul/src/benchbase/results'
    hits = glob.glob(pattern, root_dir=root)
    hits = [os.path.join(root, hit) for hit in hits]
    hits.sort(key=os.path.getctime)
    return hits[0]


# read the most recent samples file:
# df = pd.read_csv('/home/paul/src/benchbase/results/temporal_2024-08-01_20-42-48.samples.csv')
df = pd.read_csv(most_recent_result("*.samples.csv"))
# print(df.to_string())
print(df.head())
# df['Throughput (requests/second)'].plot()
df[['25th Percentile Latency (microseconds)', 'Median Latency (microseconds)', '95th Percentile Latency (microseconds)']].plot()
plt.show()

# TODO
# - plot the rows read
# - plot the cpu
# - increase the load until it falls over

