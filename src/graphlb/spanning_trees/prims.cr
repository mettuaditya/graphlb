require "../data_structures/*"

include Graphlb::DataStructures

module Graphlb::Algorithms
  # Prim's algorithm is an algorithm for finding
  # the Minimum spanning tree in a graph, i.e the tree
  # with the lowest weight
  #
  # Given a graph and source vertex dijkstra function finds
  # the shortest distance from the source vertex to all other
  # vertices in the graph
  #
  class Prims
    #
    # returns a hashes, which contains the information about the
    # previous vertex of all the vertives present inside the graph
    #
    def run(graph, source)
      vertex_set = graph.get_vertices
      dist = {} of Node => Float64
      prev = {} of String => String | Nil
      visit_set = {} of Node => Bool
      i = 0
      size = vertex_set.size
      while i < size
        dist[vertex_set[i]] = Float64::INFINITY
        prev[vertex_set[i].name] = nil
        visit_set[vertex_set[i]] = false
        i = i + 1
      end
      dist[source] = 0.0

      while !vertex_set.empty?
        u = vertex_set.min_by { |n| dist.fetch(n, Float64::INFINITY) }
        vertex_set.delete(u)
        visit_set[u] = true
        u.edges.keys.each do |neighbour|
          # temp = dist[u] + u.edges[neighbour]
          if u.edges[neighbour] < dist[neighbour] && visit_set[neighbour] == false
            dist[neighbour] = u.edges[neighbour]
            prev[neighbour.name] = u.name
          end
        end
      end

      return prev
    end

    # constructs a path from source vertex to target vertex
    # Returns the shortest path, if it exists, as an Array of vertices.
    def path_constructor(prev, source, target)
      set = [] of String
      temp = target.name
      while (!temp.nil? && temp != source.name)
        set.insert(0, temp)
        temp = prev[temp]
      end
      set.insert(0, source.name)
      return set
    end
  end
end
