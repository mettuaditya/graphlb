require "./*"

module Graphlb::DataStructures
  # The DirectedGraph class represents a graph with all the vertices and directed edges
  class DirectedGraph
    getter vertices

    # creats a graph
    def initialize
      @vertices = [] of Node
    end

    # Add nodes to the graph with the given name
    def add_vertex(name)
      temp = Node.new(name)
      @vertices << temp
      return temp
    end

    # Add edges to the graph from the from_node to to_node with a given edge_weight
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
    def get_vertices
      return @vertices
    end
  end
end
