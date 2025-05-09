#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import glob
import sys
import os

def most_recent_result(pattern):
    """Returns a relative path to the main .results.csv file,
    e.g. results/temporal_2025-05-07_22-05-02.results.csv"""
    root = '/home/paul/src/benchbase/results'
    hits = glob.glob(pattern, root_dir=root)
    hits = [os.path.join(root, hit) for hit in hits]
    hits.sort(key=os.path.getctime, reverse=True)
    return hits[0]

def result_file(results_stem, filetype):
    return f'{results_stem}.results.{filetype}'

if len(sys.argv) > 1:
    results = sys.argv[1]
else:
    results = most_recent_result('*.results.csv')

results_stem = results[:results.index('.results.csv')] # e.g. results/temporal_2025-05-07_22-05-02
print(results_stem)
results_name = results_stem[results.rindex('/') + 1:] # e.g. temporal_2025-05-07_22-05-02
print(results_name)
results_range_agg = pd.read_csv(result_file(results_stem, 'CheckForeignKeyRangeAgg.csv'))
results_lag = pd.read_csv(result_file(results_stem, 'CheckForeignKeyLag.csv'))
results_exists = pd.read_csv(result_file(results_stem, 'CheckForeignKeyExists.csv'))
colors = ['C0', 'C1', 'C4']

def fig1():
    fig = plt.figure()
    plt.title(f'throughput (requests/second)')
    plt.plot(results_range_agg['Time (seconds)'], results_range_agg['Throughput (requests/second)'], label='range_agg', color=colors[0])
    plt.plot(results_lag['Time (seconds)'], results_lag['Throughput (requests/second)'], label='lag', color=colors[1])
    plt.plot(results_exists['Time (seconds)'], results_exists['Throughput (requests/second)'], label='exists', color=colors[2])
    plt.xlabel('seconds')
    plt.ylabel('requsts/second')
    plt.legend()
    plt.show()
    fig.savefig(f'{results_name}-throughput.png')

def fig3():
    fig = plt.figure()
    plt.title(f'median latency (milliseconds)')
    plt.plot(results_range_agg['Time (seconds)'], results_range_agg['Median Latency (millisecond)'], label='range_agg', color=colors[0])
    plt.plot(results_lag['Time (seconds)'], results_lag['Median Latency (millisecond)'], label='lag', color=colors[1])
    plt.plot(results_exists['Time (seconds)'], results_exists['Median Latency (millisecond)'], label='exists', color=colors[2])
    plt.xlabel('seconds')
    plt.ylabel('milliseconds')
    plt.legend()
    plt.show()
    fig.savefig(f'{results_name}-50th-latency.png')

def fig4():
    fig = plt.figure()
    plt.title(f'mean latency (milliseconds)')
    plt.plot(results_range_agg['Time (seconds)'], results_range_agg['Average Latency (millisecond)'], label='range_agg', color=colors[0])
    plt.plot(results_lag['Time (seconds)'], results_lag['Average Latency (millisecond)'], label='lag', color=colors[1])
    plt.plot(results_exists['Time (seconds)'], results_exists['Average Latency (millisecond)'], label='exists', color=colors[2])
    plt.xlabel('seconds')
    plt.ylabel('milliseconds')
    plt.legend()
    plt.show()
    fig.savefig(f'{results_name}-mean-latency.png')

def fig5():
    fig = plt.figure()
    plt.title(f'95th% latency (milliseconds)')
    plt.plot(results_range_agg['Time (seconds)'], results_range_agg['95th Percentile Latency (millisecond)'], label='range_agg', color=colors[0])
    plt.plot(results_lag['Time (seconds)'], results_lag['95th Percentile Latency (millisecond)'], label='lag', color=colors[1])
    plt.plot(results_exists['Time (seconds)'], results_exists['95th Percentile Latency (millisecond)'], label='exists', color=colors[2])
    plt.xlabel('seconds')
    plt.ylabel('milliseconds')
    plt.legend()
    plt.show()
    fig.savefig(f'{results_name}-95th-latency.png')


fig1()
# fig2()
fig3()
fig4()
fig5()
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
