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

    # Name of the node, which is expexted to be unique for each vertex.
    getter name

    # A Hash to store the adjacency list of the vertex
    getter edges

    # creats a graph whith no vertices and edges(empty-graph)
    def initialize(@name : String)
      @edges = {} of Node => Float64
    end

    # Adds a new edge from the self to the to_node
    #
    # if to_node is not present in the greaph an exception is raised else an edge is created.
    #
    # @param : to_node, the node where the edge ends,
    #
    # @param : weight, the edge-weight,
    #
    # @return : list of edges of the self node
    def add_edge(to_node, weight)
      @edges[to_node] = weight
    end

    # Removes an already existing edge from the graph
    #
    # if to_node is not present in the greaph an exception is raised else an edge is created.
    #
    # @param : to_node, the node where the edge ends,
    #
    # @return : list of edges of the self node
    def remove_edge(to_node)
      @edges.delete(to_node)
    end

    # Checks the wheather the two node are equal
    #
    # @return : *true* if the two nodes are equal, else false.
    def ==(other : Node)
      name == other.name
    end

    # Checks the wheather the two node are not equal
    #
    # @return : *true* if the two nodes are not equal, else false.
    def !=(other : Node)
      name != other.name
    end
  end
end
