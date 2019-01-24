require "../data_structures/*"
require "../algorithms/depth_first_search.cr"

module Graphlb::Algorithms

  class EdmondsKarp

    def run(graph,source,sink)

        puts ("fot")
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
          # rgraph.get_vertices.each do |vertex|
          #   vertex.edges.keys.each do |i|
          #     puts ("#{vertex.name}-#{i.name}-->#{vertex.edges[i]}")
          #   end
          # end
          dfs = DFS.new()
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
