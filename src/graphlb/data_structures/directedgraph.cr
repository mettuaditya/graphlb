require "./*"

# In the module the we have defined the data-structures starting from the simple Node data-structure to a complex tree data-structure
# which will be used in many general graph algorithms to obtain efficient solutions.
#
# These are Just some of the basic data-structures and more data-structures will be added as we move between different algorithms.
module Graphlb::DataStructures

  # A directed graph (or digraph) is a graph that is made up of a set of vertices connected by edges,
  # where the edges have a direction and weight associated with them.
  #
  # The class provides various methods which can be used to define/modify a simple directed graph with edge-weight
  # Associated to each edge. Here we are using the adjacency list approach to define a directed graph which
  # can be modified later as per convience
  #
  class DirectedGraph < Graph

    # creats a graph whith no vertices and edges(empty-graph)
    def initialize
      @index = Float64::INFINITY
      @lowlink = Float64::INFINITY
      @onStack = false
    end

    # Creates an edge between the nodes provided as the parametes.
    #
    # If the form_node and to_node_ are same then also the node is created witha cycle in the graph.
    #
    # If any of the from_node or to_node is not found in the graph a exception is raised.
    #
    # @param : from_node, the vertex from which the directed edge starts.
    #
    # @param : to_node, the vertex to which the directed edge ends.
    #
    # @param : weight, the weight of the edge created
    #
    # @return : the list of all edges of the from_node
    def add_edge(from_node : Node, to_node : Node, weight)
      from = @vertices.find { |i| i == from_node }
      to = @vertices.find { |i| i == to_node }
      if (from.nil? || to.nil?)
        raise "Node not found"
      else
        from.add_edge(to_node, weight)
      end
    end

    # Removes the edge form the from_node to the to_node present in the graph
    #
    # If the form_node and to_node_ are same and the edge is present between them the edge is removed
    # else excetion is raised
    #
    # If any of the from_node or to_node is not found in the graph a exception is raised.
    #
    # If edge between the from_node and the to_node is not found in the graph a exception is raised
    #
    # @param : from_node, the node from which the edge starts,
    #
    # @param : to_node, the node where the edge ends,
    #
    # @return : list of all edges from the from node
    def remove_edge(from_node : Node, to_node : Node)
      node = @vertices.find { |i| i == from_node }
      if node.nil?
        raise "Node not found"
      else
        if node.edges.has_key?(to_node)
          node.remove_edge(to_node)
        else
          raise "edge not found"
        end
      end
    end

    # returns informaton about all the vertices inside the graph
    #
    # @return : list of all vertices/nodes in the graph
    def get_vertices
      return @vertices
    end
  end
end
