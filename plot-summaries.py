#!/usr/bin/env python

import matplotlib.pyplot as plt
import pandas as pd
import json

summaries = {
    'range_agg': 'temporal_2024-07-28_20-10-41.summary.json',
    'lag': 'temporal_2024-07-28_20-15-25.summary.json',
    'exists': 'temporal_2024-07-28_20-14-17.summary.json',
}

def plot_throughput():
    results = {}
    for impl, filename in summaries.items():
        j = json.load(open(f"results/{filename}"))
        results[impl] = j['Throughput (requests/second)']
        
    fig = plt.figure()
    plt.bar(results.keys(), results.values())
    plt.xlabel("implementation")
    plt.ylabel("requests/second")
    plt.title("Throughput")
    plt.show()
    fig.savefig("throughput-comparison-2024-07-28.png")

def plot_latency(*, with_max=False):
    columns = ['Percentile']
    results = [[25], [50], [75], [90], [99]]
    if with_max:
        results.append([100])
    for impl, filename in summaries.items():
        columns.append(impl)
        j = json.load(open(f"results/{filename}"))
        j2 = j['Latency Distribution']
        results[0].append(j2['25th Percentile Latency (microseconds)'] / 1000)
        results[1].append(j2['Median Latency (microseconds)'] / 1000)
        results[2].append(j2['75th Percentile Latency (microseconds)'] / 1000)
        results[3].append(j2['90th Percentile Latency (microseconds)'] / 1000)
        results[4].append(j2['99th Percentile Latency (microseconds)'] / 1000)
        if with_max:
            results[5].append(j2['Maximum Latency (microseconds)'] / 1000)

    df = pd.DataFrame(results, columns=columns)
    fig = plt.figure()
    # plt.plot(df)
    for col in columns[1:]:
        plt.plot(df['Percentile'], df[col], label=col)
    plt.legend()
    plt.title("Latency")
    plt.xlabel("Percentile")
    plt.ylabel("milliseconds")
    plt.show()
    withmax = 'max-' if with_max else ''
    fig.savefig(f"latency-{withmax}comparison-2024-07-28.png")

# plot_throughput()
plot_latency()
plot_latency(with_max=True)
