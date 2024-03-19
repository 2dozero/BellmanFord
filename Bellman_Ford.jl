using LightGraphs
using DataStructures

# one-to-one
# LIST를 FIFO와 dequeue 2가지 타입으로
# negative cycle 체크하기
function bellman_ford_FIFO(graph::AbstractGraph, weights::Dict{Tuple{Int64, Int64}, Int64}, start_node::Int64, end_node::Int64, type::String="FIFO")
    distances = Dict(n => Inf for n in vertices(graph))
    distances[start_node] = 0
    pred = Dict(n => 0 for n in vertices(graph))  # Initialize pred for all nodes
    label_count = 0

    LIST = OrderedSet([start_node])
    while !isempty(LIST)
        node = popfirst!(LIST)
        for neighbor in outneighbors(graph, node)
            weight = get(weights, (node, neighbor), Inf)
            if distances[neighbor] > distances[node] + weight
                distances[neighbor] = distances[node] + weight
                label_count += 1
                pred[neighbor] = node
                if !(neighbor in LIST)
                    push!(LIST, neighbor)
                end
            end
        end
    end

    for edge in edges(graph)
        u, v = src(edge), dst(edge)
        weight = get(weights, (u, v), Inf)
        if distances[u] + weight < distances[v]
            error("Graph contains a negative-weight cycle")
        end
    end

    path = []
    node = end_node
    while node != start_node
        pushfirst!(path, node)
        node = pred[node]
    end
    pushfirst!(path, start_node)

    return distances[end_node], path, label_count
end

function bellman_ford_Deque(graph::AbstractGraph, weights::Dict{Tuple{Int64, Int64}, Int64}, start_node::Int64, end_node::Int64, type::String="Deque")
    distances = Dict(n => Inf for n in vertices(graph))
    distances[start_node] = 0
    pred = Dict(n => 0 for n in vertices(graph))  # Initialize pred for all nodes
    label_count = 0

    LIST = Deque{Int64}()
    push!(LIST, start_node)
    while !isempty(LIST)
        node = popfirst!(LIST)
        for neighbor in outneighbors(graph, node)
            weight = get(weights, (node, neighbor), Inf)
            if distances[neighbor] > distances[node] + weight
                distances[neighbor] = distances[node] + weight
                label_count += 1
                if !(neighbor in LIST) && pred[neighbor] != 0
                    pushfirst!(LIST, neighbor)
                else
                    push!(LIST, neighbor)
                end
                pred[neighbor] = node
            end
        end
    end

    for edge in edges(graph)
        u, v = src(edge), dst(edge)
        weight = get(weights, (u, v), Inf)
        if distances[u] + weight < distances[v]
            error("Graph contains a negative-weight cycle")
        end
    end

    path = []
    node = end_node
    while node != start_node
        pushfirst!(path, node)
        node = pred[node]
    end
    pushfirst!(path, start_node)

    return distances[end_node], path, label_count
end
