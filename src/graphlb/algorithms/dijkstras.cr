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
    # @return : Two hashs(dist and prev), dist is the hash which contains the distance
    # of a vertices from the source vertex, prev is the hash which contains the previous
    # vertices of all the vertices that are reachable from source
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
