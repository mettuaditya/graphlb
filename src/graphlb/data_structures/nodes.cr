module Graphlb::DataStructures
  # The node Class basically represnts the vertices in a graph
  # it contains two properties
  #   1. name of the vertex
  #   2. edge shared with other vertex
  #
  # edges property in Node reprensents the adjacency graph which
  # is implemented using a hash with vertex name as it key
  # and edge weight as its value
  class Node
    getter name, edges

    # creates a new edge with a given name
    def initialize(@name : String)
      @edges = {} of Node => Float64
    end

    # Adds a new edge to the vertex node with information about
    # edge weight and adjacent vertex
    def add_edge(node, weight)
      @edges[node] = weight
    end

    # Removes an already existing edge from the graph
    def remove_edge(node)
      @edges.delete(node)
    end

    def ==(other : Node)
      name == other.name
    end

    def !=(other : Node)
      name != other.name
    end
  end
end
