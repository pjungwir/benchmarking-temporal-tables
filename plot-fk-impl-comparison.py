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
    hits.sort(key=os.path.getctime, reverse=True)
    return hits[0]


results = most_recent_result('*.results.csv')
results = results[results.rindex('/') + 1:]
results_range_agg = pd.read_csv(most_recent_result('*.results.CheckForeignKeyRangeAgg.csv'))
results_lag = pd.read_csv(most_recent_result('*.results.CheckForeignKeyLag.csv'))
results_exists = pd.read_csv(most_recent_result('*.results.CheckForeignKeyExists.csv'))

def try1():
    # Throughput is wrong because we did 33/33/34. Do latency instead:
    fig, ax = plt.subplots()
    results_range_agg['Throughput (requests/second)'].plot(ax=ax)
    results_lag['Throughput (requests/second)'].plot(ax=ax)
    results_exists['Throughput (requests/second)'].plot(ax=ax)
    # fig.show()
    plt.show()

def try2():
    # Throughput is wrong because we did 33/33/34. Do latency instead:
    fig = plt.figure()
    plt.title(f'{results} throughput (req/sec)')
    plt.plot(results_range_agg['Throughput (requests/second)'], label='range_agg')
    plt.plot(results_lag['Throughput (requests/second)'], label='lag')
    plt.plot(results_exists['Throughput (requests/second)'], label='exists')
    # fig.show()
    plt.legend()
    plt.show()

def try3():
    fig = plt.figure()
    plt.title(f'{results} median latency (milliseconds)')
    plt.plot(results_range_agg['Median Latency (millisecond)'], label='range_agg')
    plt.plot(results_lag['Median Latency (millisecond)'], label='lag')
    plt.plot(results_exists['Median Latency (millisecond)'], label='exists')
    # fig.show()
    plt.legend()
    plt.show()
    fig.savefig(f'{results}-50th-latency.png')

def try4():
    fig = plt.figure()
    plt.title(f'{results} mean latency (milliseconds)')
    plt.plot(results_range_agg['Average Latency (millisecond)'], label='range_agg')
    plt.plot(results_lag['Average Latency (millisecond)'], label='lag')
    plt.plot(results_exists['Average Latency (millisecond)'], label='exists')
    # fig.show()
    plt.legend()
    plt.show()
    fig.savefig(f'{results}-mean-latency.png')

def try5():
    fig = plt.figure()
    plt.title(f'{results} 95th% latency (milliseconds)')
    plt.plot(results_range_agg['95th Percentile Latency (millisecond)'], label='range_agg')
    plt.plot(results_lag['95th Percentile Latency (millisecond)'], label='lag')
    plt.plot(results_exists['95th Percentile Latency (millisecond)'], label='exists')
    # fig.show()
    plt.legend()
    plt.show()
    fig.savefig(f'{results}-95th-latency.png')


try3()
try4()
try5()
'''


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

'''
