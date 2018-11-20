module graphlb::DirectedGraph

include graphlb::Node

  # The Graph class represents a graph with all the vertices and edges

  class Graph
    getter vertices

    # creats a graph

    def initialize ()
      @vertices = [] of Node
    end

    # Add nodes to the graph with the given name
    def add_vertex(name)
      temp = Node.new(name)
      @vertices << temp
      return temp
    end

    # Add edges to the graph from the from_node to to_node with a given edge_weight

    def edge(from_node : Node,to_node : Node,weight)
      node = @vertices.find { |i| i == from_node}
      if node.nil?
        puts ("exception")
      else
        node.add_edge(to_node,weight)
      end
    end
    # returns informaton about all the vertices inside the graph
    def get_vertices ()
      return @vertices
    end
  end
end
