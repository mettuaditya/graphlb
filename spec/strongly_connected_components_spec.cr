require "./spec_helper"

include Graphlb::DataStructures
include Graphlb::Algorithms

describe Graphlb do
  it "directed Graph" do
    graph = DirectedGraph.new()
    vertex1 = graph.add_vertex("vertex1")
    vertex2 = graph.add_vertex("vertex2")
    vertex3 = graph.add_vertex("vertex3")
    vertex4 = graph.add_vertex("vertex4")

    graph.add_edge(vertex1,vertex2,10.0)
    graph.add_edge(vertex2,vertex3,1.0)
    graph.add_edge(vertex1,vertex3,1.0)
    graph.add_edge(vertex2,vertex4,1.0)
    graph.add_edge(vertex3,vertex4,-3.0)
    graph.add_edge(vertex4,vertex2,1.0)
  end
    # bell = StronglyConnectedComponents.new(graph)
    # puts (bell)
end
