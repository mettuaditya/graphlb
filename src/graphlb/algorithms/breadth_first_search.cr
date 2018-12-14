require "../data_structures/*"

module Graphlb::Algorithms

  # Breadth first Search is an algorithm for finding
  # all the vertices that are reachable from  a source,
  # vertex in a graph.
  #
  # Given a graph and source vertex Breadth First Search finds
  # the vertices that are reachable from the source vertex
  # in a graph
  #
  class BFS

    # returns a list of all vertices that are reachable from the
    # source vertices.
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
      prev[source.name] = source.name
      visitedQueue = Queue(String).new
      queue = Queue(Node).new
      queue.push(source)
      while !queue.empty?
        vertex = queue.pop
        if vertex.nil?
          raise "No vertex available in Queue"
        else
          vertex.edges.keys.each do |neighbour|
            if prev[neighbour.name].nil?
              dist[neighbour] = dist[vertex] + 1
              prev[neighbour.name] = vertex.name
              queue.push(neighbour)
            end
          end
        end
        visitedQueue.push(vertex.name)
      end
      return visitedQueue.values
    end
  end
end
