require "./*"

module Graphlb::DataStructures
  # An undirected graph is a graph that is made up of a set of vertices connected by edges,
  # where the edges have a not direction and weight are associated with the edges.
  #
  # The class provides various methods which can be used to define/modify a simple undirected graph with edge-weight
  # Associated to each edge. Here we are using the adjacency list approach to define a undirected graph which
  # can be modified later as per convience
  #
  class UnDirectedGraph < Graph

    # Creates an edge between the nodes provided as the parametes.
    #
    # If the form_node and to_node_ are same then also the node is created witha cycle in the graph.
    #
    # If any of the from_node or to_node is not found in the graph a exception is raised.
    #
    # @param : from_node
    #
    # @param : to_node
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
        to.add_edge(from_node, weight)
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
    # @param : from_node.
    #
    # @param : to_node.
    #
    # @return : list of all edges from the from node
    def remove_edge(from_node : Node, to_node : Node)
      from = @vertices.find { |i| i == from_node }
      to = @vertices.find { |i| i == to_node }
      if (node.nil? || to.nil?)
        raise "Node not found"
      else
        if (from.edges.has_key?(to) && to.edges.has_key?(from))
          from.remove_edge(to_node)
          to.remove_edge(from_node)
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
