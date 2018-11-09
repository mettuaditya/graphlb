class Node
  getter name,edges

  def initialize(@name : String)
    @edges = {} of Node => Float64
  end

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

class Graph
  getter vertices

  def initialize ()
    @vertices = [] of Node
  end

  def add_vertex(name)
    temp = Node.new(name)
    @vertices << temp
    return temp
  end

  def edge(from_node : Node,to_node : Node,weight)
    #puts (from_node)
    #puts (to_node)
    node = @vertices.find { |i| i == from_node}
    #puts (node)
    if node.nil?
      puts ("exception")
    else
      node.add_edge(to_node,weight)
    end
  end

  def get_vertices ()
    return @vertices
  end
end
