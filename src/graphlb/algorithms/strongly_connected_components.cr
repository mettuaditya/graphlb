require "../data_structures/directedgraph.cr"

module Graphlb::Algorithms

    class StronglyConnectedComponents

      def initialize( graph)
        @index = 0
        @S = Stack(Node).new
        @Vertex_set = graph.get_vertices
        vertex_set.each do |vertex|
          if (vertex.index == Float64::INFINITY) 
            strongconnect(vertex)
          end
        end
      end

      def strongconnect( node)

        node.index = @index
        node.lowlink = @index
        @index = @index + 1
        S.push(node)
        node.onStack = true

        node.edges.keys.each do |adjacent_vertex|

          if (adjacent_vertex.index == Float64::INFINITY)
            strongConnect(adjacent_vertex)
            node.lowlink = Math.min(node.lowlink,adjacent_vertex.lowlink)
          elseif (adjacent_vertex.onStack)
            node.lowlink = Math.min(node.lowlink,adjacent_vertex.lowlink)
          end
        end

        if (node.lowlink == node.index)
          scc = Array(Node).new
          while (S.empty?)
            w = S.pop
            w.onStack = false
            scc << w
          end
          puts (scc)
        end
      end
    end
end
