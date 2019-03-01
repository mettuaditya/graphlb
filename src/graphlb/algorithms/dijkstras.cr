require "../data_structures/nodes.cr"


module Graphlb::Algorithms
  # Dijkstra's algorithm is an algorithm for finding
  # the shortest paths between nodes in a graph,
  #
  # Given a graph and source vertex dijkstra function finds
  # the shortest distance from the source vertex to all other
  # vertices in the graph
  #
  class Dijkstras
    # Runs the Dijkstras Algorithm on the given graph and the source node
    #
    # @param : graph, A directed graph,
    #
    # @param : Source, Source vertex form which the algorithm starts running,
    #
    # @raise : it raises an exception when there is a negative edge in the graph
    def initialize(graph, source)
      vertex_set = [] of Node
      vertices = graph.get_vertices
      @dist = {} of Node => Float64
      @prev = {} of String => String | Nil
      i = 0
      size = vertices.size
      while i < size
        @dist[vertices[i]] = Float64::INFINITY
        @prev[vertices[i].name] = nil
        vertex_set << vertices[i]
        i = i + 1
      end
      @dist[source] = 0.0

      while !vertex_set.empty?
        u = vertex_set.min_by { |n| @dist.fetch(n, Float64::INFINITY) }
        vertex_set.delete(u)
        u.edges.keys.each do |neighbour|
          if u.edges[neighbour] < 0
            raise Exception.new("graph contains negative edge")
          else
            temp = @dist[u] + u.edges[neighbour]
            if temp < @dist[neighbour]
              @dist[neighbour] = temp
              @prev[neighbour.name] = u.name
            end
          end
        end
      end
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
