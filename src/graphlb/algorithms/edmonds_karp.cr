require "../data_structures/directedgraph.cr"
require "../algorithms/depth_first_search.cr"

module Graphlb::Algorithms

  # The Edmonds-Karp Algorithm is a specific implementation of the Ford-Fulkerson
  # algorithm. Like Ford-Fulkerson, Edmonds-Karp is also an algorithm that deals
  # with the max-flow min-cut problem
  #
  # Edmonds-Karp differs from Ford-Fulkerson in that it chooses the next augmenting
  # path using breadth-first search (bfs). So, if there are multiple augmenting
  # paths to choose from, Edmonds-Karp will be sure to choose the shortest
  # augmenting path from the source to the sink.
  class EdmondsKarp

    # Finds the maximum flow in the flow network graph
    #
    # Given a source, sink and flow network the ford fulkerson algorithm runs on the graph.
    # The algorithm starts form the source vetex and finds the maximum flow. This algorithm uses
    # DFS to go to traverse the graph.
    #
    # @param : graph, a directed graph with edge capacities,
    #
    # @param : source, a source node where the algorithm starts,
    #
    # @param : sink, a sink where the flow ends
    #
    # @return : max_flow[Float64], the maximum flow in the flow network
    def run(graph,source,sink)

        max_flow = 0
        rgraph = graph
        r_vertices = rgraph.get_vertices
        r_vertices.each do |vertex|
          vertex.edges.keys.each do |neighbour|
            if (vertex.edges[neighbour] < 0.0)
              raise "graph contains negative capacities"
            end
            if (neighbour.edges.keys.find { |i| i == vertex}).nil?
              neighbour.add_edge(vertex,0.0)
            end
          end
        end

        if (source == sink)
          raise "same source and sink"
        end

        dfs = BFS.new()
        visit_set,prev = dfs.reachable(rgraph,source)
        temp = visit_set.find{ |i| i == sink.name}
        if temp.nil?
          raise "source and sink are not reachable"
        end
        while(true)
          visit_set,prev = dfs.reachable(rgraph,source)

          temp = visit_set.find{ |i| i == sink.name}
          if temp.nil?
            break
          else
            path_len = Float64::INFINITY
            v = sink
            while (v != source)
              u = prev[v]
              if u.nil?
                raise "invalid input"
              end
              path_len = Math.min(path_len,u.edges[v])
              v = u
            end
            v = sink
            while (v != source)
              u = prev[v]
              if (u.nil? || v.nil?)
                raise "invaid input"
              end
              u.edges[v] = u.edges[v] - path_len
              v.edges[u] = v.edges[u] + path_len
              v = u
            end
          end
          max_flow = max_flow + path_len
        end
          return max_flow
      end
  end
end
