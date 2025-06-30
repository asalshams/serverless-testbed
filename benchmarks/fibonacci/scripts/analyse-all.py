import pandas as pd
import matplotlib.pyplot as plt

# Load CSV
df = pd.read_csv("benchmark-results.csv")

# Ensure proper data types
df['cpu'] = df['cpu'].astype(float)
df = df.sort_values(by=['runtime', 'cpu'])

# === 1. Avg Latency vs CPU ===
plt.figure()
for runtime in df['runtime'].unique():
    subset = df[df['runtime'] == runtime]
    plt.plot(subset['cpu'], subset['avg_latency'], marker='o', label=runtime)
plt.title("Average Latency vs CPU")
plt.xlabel("CPU")
plt.ylabel("Avg Latency (s)")
plt.legend()
plt.grid(True)
plt.savefig("avg_latency_vs_cpu.png")

# === 2. p95 and p99 Latency ===
for p in ['p95', 'p99']:
    plt.figure()
    for runtime in df['runtime'].unique():
        subset = df[df['runtime'] == runtime]
        plt.plot(subset['cpu'], subset[p], marker='o', label=runtime)
    plt.title(f"{p.upper()} Latency vs CPU")
    plt.xlabel("CPU")
    plt.ylabel("Latency (s)")
    plt.legend()
    plt.grid(True)
    plt.savefig(f"{p}_latency_vs_cpu.png")

# === 3. Requests/sec per CPU (Efficiency) ===
df['rps_per_cpu'] = df['requests_per_sec'] / df['cpu']
plt.figure()
for runtime in df['runtime'].unique():
    subset = df[df['runtime'] == runtime]
    plt.plot(subset['cpu'], subset['rps_per_cpu'], marker='o', label=runtime)
plt.title("Efficiency: Requests/sec per CPU")
plt.xlabel("CPU")
plt.ylabel("Requests/sec per CPU")
plt.legend()
plt.grid(True)
plt.savefig("rps_per_cpu_vs_cpu.png")

# === 4. Optional: Save processed data with efficiency ===
df.to_csv("results_with_efficiency.csv", index=False)
