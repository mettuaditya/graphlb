require "../data_structures/nodes.cr"

# Algorithms contain all the general algorithms that can be used on a graph data-structure
#
# like Flow Networks, Graph Traversal, Shortest path between Nodes, Spanning Trees etc.
#
module Graphlb::Algorithms
  # Bellman Ford's algorithm is an algorithm for finding
  # the shortest paths between nodes in a graph,
  #
  # Given a graph and source vertex Bellman Fords algorithm finds
  # the shortest distance from the source vertex to all other
  # vertices in the graph.
  #
  # It also finds wheather a negative cycle is present in a graph or not
  class BellmanFord
    #

    # Runs the Bellman_Ford Algorithm on the given graph and the source node
    #
    # If the graph contains a negative cycle it returns an exception
    #
    # @param : graph, A directed graph
    #
    # @param : Source, Source vertex form which the algorithm starts running
    #
    # @return : Two hashs(dist and prev), dist is the hash which contains the distance
    # of a vertices from the source vertex, prev is the hash which contains the previous
    # vertices of all the vertices that are reachable from source
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
    #
    # @param : prev , prev hash contains the previous node of all the vertices
    #
    # @param : Source, the source vertex for the path
    #
    # @param : target, The vertex till which the path should be constructed
    #
    # @return : An array which contains all the vertices(path) to be travelled
    # to reach from source to target vertex
    #
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
