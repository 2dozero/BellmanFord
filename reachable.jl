function is_reachable(graph::AbstractGraph, start_node::Int64, end_node::Int64)
    visited = Set{Int64}()
    stack = [start_node]

    while !isempty(stack)
        node = pop!(stack)
        if node == end_node
            return true
        end
        if !(node in visited)
            push!(visited, node)
            for neighbor in outneighbors(graph, node)
                push!(stack, neighbor)
            end
        end
    end
    return false
end