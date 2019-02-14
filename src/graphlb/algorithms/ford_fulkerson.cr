require "../data_structures/directedgraph.cr"
require "../algorithms/breadth_first_search.cr"

module Graphlb::Algorithms

  # in the graph, to find the maximum possible flow from s to t with following constraints needs to be true:
  #
  # a) Flow on an edge doesn’t exceed the given capacity of the edge.
  #
  # b) Incoming flow is equal to outgoing flow for every vertex except s and t.
  #
  # In ford Fulkerson algorithm An augmenting path is a simple path from source to sink which do not include any
  # cycles and that pass only through positive weighted edges. A residual network graph
  # indicates how much more flow is allowed in each edge in the network graph. If there
  # are no augmenting paths possible from source to sink, then the flow is maximum. The result i.e.
  # the maximum flow will be the total flow out of source node which is also equal to
  # total flow in to the sink node.
  class FordFulkerson

    # Finds the maximum flow in the flow network graph
    #
    # Given a source, sink and flow network the ford fulkerson algorithm runs on the graph.
    # The algorithm starts form the source vetex and finds the maximum flow. This algorithm uses
    # BFS to go to traverse the graph.
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
            if (neighbour.edges.keys.find { |i| i == vertex}).nil?
              neighbour.add_edge(vertex,0.0)
            end
          end
        end

        while(true)
          bfs = BFS.new()
          visit_set,prev = bfs.reachable(rgraph,source)
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
