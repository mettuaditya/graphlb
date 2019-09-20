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
    def initialize(graph, source)
      vertex_set = graph.get_vertices
      @dist = {} of Node => Float64
      @prev = {} of String => String | Nil
      i = 0
      size = vertex_set.size
      while i < size
        @dist[vertex_set[i]] = Float64::INFINITY
        @prev[vertex_set[i].name] = nil
        i = i + 1
      end
      @dist[source] = 0.0
      i = 1
      while i < size - 1
        vertex_set.each do |j|
          j.edges.keys.each do |neighbour|
            temp = @dist[j] + j.edges[neighbour]
            if temp < @dist[neighbour]
              @dist[neighbour] = temp
              @prev[neighbour.name] = j.name
            end
          end
        end
        i = i + 1
      end
      vertex_set.each do |j|
        j.edges.keys.each do |neighbour|
          temp = @dist[j] + j.edges[neighbour]
          if temp < @dist[neighbour]
            raise "graph contains negative cycle"
          end
        end
      end
    end

    # constructs a path from source vertex to target vertex
    #
    # @param : Source, the source vertex for the path
    #
    # @param : target, The vertex till which the path should be constructed
    #
    # @return : An array which contains all the vertices(path) to be travelled
    # to reach from source to target vertex
    #
    def shortest_path (source, target)
      set = [] of String
      temp = @prev[target.name]
      while (!temp.nil?)
        set.insert(0, temp)
        temp = @prev[temp]
      end
      if (set.empty? ||set[0] != source.name)
        if (target == source)
          return set << source.name
        end
        return set << "nil"
      else
        set << target.name
        return set
      end
    end

    # constructs a path from source vertex to all other vertices in the graph
    #
    # @param : Source, the source vertex for the path
    #
    # @return : An array which contains all the vertices(path) to be travelled
    # to reach from source vertex to all other vertices in the graph
    def shortest_paths (source)
      vertex_path = Array(Array(String)).new()
      @dist.keys.each do |vertex|
        path = shortest_path(source,vertex)
        vertex_path << path
      end
      return vertex_path
    end
  end
end
