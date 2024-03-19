include("bellman_Ford.jl")
include("reachable.jl")
include("Generate_Graph.jl")

function main(node_size::Int64, sparse_percent::Float64)
    start_node = 1
    end_node = node_size
    graph, weights = gen_graph(node_size, sparse_percent) # gen_graph에서 반환한 그래프와 가중치를 각각 graph와 weights에 할당
    if is_reachable(graph, start_node, end_node) == false
        println("Not all nodes are reachable from each other")
        return
    end
    println("Graph is connected")

    fifo_count_sum = 0
    deque_count_sum = 0
    num_trials = 100

    for _ in 1:num_trials
        println("FIFO")
        @time begin
            dist, path, count = bellman_ford_FIFO(graph, weights, start_node, end_node, "FIFO")
            println("dist :", dist, " path :", path, " count :", count)
            fifo_count_sum += count
        end
        println("Deque")
        @time begin
            dist, path, count = bellman_ford_Deque(graph, weights, start_node, end_node, "Deque")
            println("dist :", dist, " path :", path, " count :", count)
            deque_count_sum += count
        end
    end

    println("Average count for FIFO over ", num_trials, " trials: ", fifo_count_sum / num_trials)
    println("Average count for Deque over ", num_trials, " trials: ", deque_count_sum / num_trials)
end