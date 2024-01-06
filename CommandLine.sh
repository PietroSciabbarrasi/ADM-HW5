#!/bin/bash

# Load citation graph from .txt file
graph_file="citation_graph.txt"

# Question 1: Identify the node with the highest degree
echo "Identifying a critical connector node:"
highest_degree_node=$(awk '{print $2}' "$graph_file" | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
highest_degree=$(awk -v node="$highest_degree_node" '$2 == node {print $2}' "$graph_file" | sort | uniq -c | awk '{print $1}')

echo "Node: $highest_degree_node, Degree: $highest_degree"

# Question 2: Explore the range of Citation Degrees
echo -e "\nExploring the range of Citation Degrees:"
awk '{print $2}' "$graph_file" | sort -n | uniq -c | awk 'NR==1{min=$1; max=$1} {if($1<min) min=$1; if($1>max) max=$1} END{print min, max}'
echo ""
# Question 3: Understanding Average Length of Shortest Paths

# Python script to analyze average shortest path lengths using NetworkX
python3 - <<END
import networkx as nx

# Load the graph from file
edges = [tuple(map(str, line.strip().split())) for line in open("$graph_file")]
citation_graph = nx.DiGraph(edges)

# Check if the graph is strongly connected
if nx.is_strongly_connected(citation_graph):
    avg_shortest_path = nx.average_shortest_path_length(citation_graph)
    print(f"The graph is strongly connected. Average Length of Shortest Paths: {avg_shortest_path}")
else:
    print("The graph is not strongly connected. Calculating average shortest path lengths for connected components:")
    
    avg_shortest_paths = []
    
    # Calculate average shortest path lengths for each connected component
    for component in nx.strongly_connected_components(citation_graph):
        subgraph = citation_graph.subgraph(component)
        avg_shortest_paths.append(nx.average_shortest_path_length(subgraph))

    # Print average shortest path length for the entire graph
    avg_shortest_path_total = sum(avg_shortest_paths) / len(avg_shortest_paths)
    print(f"\nAverage Length of Shortest Paths (Total): {avg_shortest_path_total}")

END





