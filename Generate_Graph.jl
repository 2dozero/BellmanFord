using LightGraphs
using DataStructures
# using Random
# Random.seed!(1234)

function gen_graph(node_size::Int64, sparse_percent::Float64)
    neg_edge_percent = 0.001
    min_weight = -5
    max_weight = 20
    graph = DiGraph(node_size)
    weights = Dict{Tuple{Int64,Int64},Int64}()
    for i in 1:node_size-1
        for j in (i+1):node_size
            add_edge!(graph, i, j)
            if rand() > neg_edge_percent
                weights[(i, j)] = rand(1:max_weight)
            else
                weights[(i, j)] = rand(min_weight:-1)
            end
        end
    end
    println("Initial graph: ", graph)
    graph = sparse_graph(graph, sparse_percent)
    println("Sparse graph: ", graph)
    return graph, weights
end


function sparse_graph(graph::AbstractGraph, sparse_percent::Float64)
    all_edges = collect(edges(graph))
    num_del_edges = round(Int, ne(graph) * sparse_percent)  # Number of edges to delete

    for _ in 1:num_del_edges
        del_arc_index = rand(1:length(all_edges))  # Choose a random index
        del_arc = all_edges[del_arc_index]  # Get the edge at the chosen index
        rem_edge!(graph, del_arc)  # Remove the chosen edge from the graph
        deleteat!(all_edges, del_arc_index)  # Remove the chosen edge from the list
    end

    return graph
end