# The node Class basically represnts the vertices in a graph
#it contains two properties
# 1. name of the vertex
# 2. edge shared with other vertex
#
#edges property in Node reprensents the adjacency graph which
#is implemented using a hash with vertex name as it key
#and edge weight as its value

class Node
  getter name,edges

  # creates a new edge with a given name

  def initialize(@name : String)
    @edges = {} of Node => Float64
  end

  # Adds a new edge to the vertex node with information about
  # edge weight and adjacent vertex

  def add_edge(node, weight)
    @edges[node] = weight
  end

  def ==(other : Node)
    name == other.name
  end

  def !=(other : Node)
    name != other.name
  end
end

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
