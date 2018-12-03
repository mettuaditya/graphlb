require "../data_structures/*"

include Graphlb::DataStructures

module Graphlb::Algorithms

  # Dijkstra's algorithm is an algorithm for finding
  # the shortest paths between nodes in a graph,
  #
  # Given a graph and source vertex dijkstra function finds
  # the shortest distance from the source vertex to all other
  # vertices in the graph
  #
  class Dijkstras
    #
    # returns two hashes, one contains the distance is vetex from the source
    # node whereas, other hash conntains the information about the previous
    # nodes for vertices in the graph
    #
    def run(graph, source)
      vertex_set = [] of Node
      vertices = graph.get_vertices
      dist = {} of Node => Float64
      prev = {} of String => String | Nil
      i = 0
      size = vertices.size
      while i < size
        dist[vertices[i]] = Float64::INFINITY
        prev[vertices[i].name] = nil
        vertex_set << vertices[i]
        i = i + 1
      end
      dist[source] = 0.0

      while !vertex_set.empty?
        u = vertex_set.min_by { |n| dist.fetch(n, Float64::INFINITY) }
        vertex_set.delete(u)
        u.edges.keys.each do |neighbour|
          temp = dist[u] + u.edges[neighbour]
          if temp < dist[neighbour]
            dist[neighbour] = temp
            prev[neighbour.name] = u.name
          end
        end
      end

      return dist, prev
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
