require "../data_structures/nodes.cr"
require "../data_structures/stack.cr"

module Graphlb::Algorithms
  # Depth first Search is an algorithm for finding
  # all the vertices that are reachable from  a source,
  # vertex in a graph.
  #
  # Given a graph and source vertex Depth First Search finds
  # the vertices that are reachable from the source vertex
  # in a graph
  #
  class DFS
    # Given a graph and a Source vertex the DFS algorithm starts running from the sources
    # vertex to find all the vertices that are visited from the source vertex.
    #
    # The DFS algorithm uses stack data-structure to find the next node to visit
    #
    # @param : graph, A graph on which the vertices are connected
    #
    # @param : Source, A source vertex where the algorithm starts
    #
    # @return : [string], An array of type string which contains all the node that are reachable form the source vertex
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
      prev[source.name] = source.name
      visitedQueue = Stack(String).new
      queue = Stack(Node).new
      queue.push(source)
      while !queue.empty?
        vertex = queue.pop
        if vertex.nil?
          raise "No vertex available in stack"
        else
          vertex.edges.keys.each do |neighbour|
            if prev[neighbour.name].nil?
              dist[neighbour] = dist[vertex] + 1
              prev[neighbour.name] = vertex.name
              queue.push(neighbour)
            end
          end
        end
        puts (vertex.name)
        visitedQueue.push(vertex.name)
      end
      return visitedQueue.values
    end

    # Given a graph and a Source vertex the DFS algorithm starts running from the sources
    # vertex to find all the vertices that are reachable from the source vertex and the
    #information about the previous node of all nodes
    #
    #
    # @param : graph, A graph on which the vertices are connected
    #
    # @param : Source, A source vertex where the algorithm starts
    #
    # @return : a tuple ([String]visited_nodes,[Hash]prev), visited nodes store the names
    # of all the nodes that are reachable form the source vertex and prev stores the information
    # about the previous nodes  
    def reachable(graph, source)
      vertex_set = [] of Node
      vertices = graph.get_vertices
      prev = {} of Node => Node | Nil
      i = 0
      size = vertices.size
      while i < size
        prev[vertices[i]] = nil
        vertex_set << vertices[i]
        i = i + 1
      end
      prev[source] = source
      visitedQueue = Stack(String).new
      queue = Stack(Node).new
      queue.push(source)
      while !queue.empty?
        vertex = queue.pop
        if vertex.nil?
          raise "No vertex available in stack"
        else
          vertex.edges.keys.each do |neighbour|
            if (prev[neighbour].nil? && vertex.edges[neighbour] > 0.0)
              prev[neighbour] = vertex
              queue.push(neighbour)
            end
          end
        end
        visitedQueue.push(vertex.name)
      end
      return visitedQueue.values,prev
    end
  end
end
