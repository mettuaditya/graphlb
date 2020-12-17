module Graphlb::DataStructures
  abstract class Graph
    # All the vertices of the graph are stored in this variables
    getter vertices = [] of Node

    # Creates a new vertex with in the graph.
    #
    # The vertex name is expected to be unique to differentiate between the vertex within the graph
    # and perform operations on them.
    #
    # @param name, to define the name of the vertex hwich is expected to be unique.
    def add_vertex(name : String) : Node
      temp = Node.new(name)
      @vertices << temp
      return temp
    end

    abstract def add_edge(from_node : Node, to_node : Node, weight)
    abstract def remove_edge(from_node : Node, to_node : Node)
  end
end