require "../data_structures/*"

module Graphlb::Algorithms
  # Bellman Ford's algorithm is an algorithm for finding
  # the shortest paths between nodes in a graph,
  #
  # Given a graph and source vertex Bellman Fords algorithm finds
  # the shortest distance from the source vertex to all other
  # vertices in the graph.
  # It also finds wheather a negative cycle is prsent in a graph or not
  class BellmanFord
    #
    # returns two hashes, one contains the distance is vetex from the source
    # node whereas, other hash conntains the information about the previous
    # nodes for vertices in the graph
    #
    def run(graph, source)
      vertex_set = graph.get_vertices
      dist = {} of Node => Float64
      prev = {} of String => String | Nil
      i = 0
      size = vertex_set.size
      while i < size
        dist[vertex_set[i]] = Float64::INFINITY
        prev[vertex_set[i].name] = nil
        i = i + 1
      end
      dist[source] = 0.0
      i = 1
      while i < size - 1
        vertex_set.each do |j|
          j.edges.keys.each do |neighbour|
            temp = dist[j] + j.edges[neighbour]
            if temp < dist[neighbour]
              dist[neighbour] = temp
              prev[neighbour.name] = j.name
            end
          end
        end
        i = i + 1
      end
      vertex_set.each do |j|
        j.edges.keys.each do |neighbour|
          temp = dist[j] + j.edges[neighbour]
          if temp < dist[neighbour]
            raise "graph contains negative cycle"
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
