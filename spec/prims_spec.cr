require "./spec_helper"

include Graphlb::DataStructures
include Graphlb::Algorithms

describe Graphlb do

  it "BFs works" do

    graph = UnDirectedGraph.new()
    vertex1 = graph.add_vertex("vertex1")
    vertex2 = graph.add_vertex("vertex2")
    vertex3 = graph.add_vertex("vertex3")
    vertex4 = graph.add_vertex("vertex4")

    graph.add_edge(vertex1,vertex2,10.0)
    graph.add_edge(vertex2,vertex3,1.0)
    graph.add_edge(vertex1,vertex3,1.0)
    graph.add_edge(vertex2,vertex4,1.0)
    graph.add_edge(vertex3,vertex4,10.0)

    dij = Prims.new()
    result = dij.run(graph,vertex1)
    # puts (result)
    ans = {"vertex1" => nil, "vertex2" => "vertex3", "vertex3" => "vertex1", "vertex4" => "vertex2"}
    true.should eq(result == ans)
  end

  it "If graph has two components" do

    graph = UnDirectedGraph.new()
    vertex1 = graph.add_vertex("vertex1")
    vertex2 = graph.add_vertex("vertex2")
    vertex3 = graph.add_vertex("vertex3")
    vertex4 = graph.add_vertex("vertex4")
    ind = graph.add_vertex("ind")

    graph.add_edge(vertex1,vertex2,10.0)
    graph.add_edge(vertex2,vertex3,1.0)
    graph.add_edge(vertex1,vertex3,1.0)
    graph.add_edge(vertex2,vertex4,1.0)
    graph.add_edge(vertex3,vertex4,10.0)


    dij = Prims.new()
    result= dij.run(graph,vertex1)
    # puts (result)
    ans = {"vertex1" => nil, "vertex2" => "vertex3", "vertex3" => "vertex1", "vertex4" => "vertex2", "ind" => nil}

    true.should eq(result == ans)
  end

  it "graph with negative edges" do
    graph = UnDirectedGraph.new()
    vertex1 = graph.add_vertex("vertex1")
    vertex2 = graph.add_vertex("vertex2")
    vertex3 = graph.add_vertex("vertex3")
    vertex4 = graph.add_vertex("vertex4")

    graph.add_edge(vertex1,vertex2,10.0)
    graph.add_edge(vertex2,vertex3,-2.0)
    graph.add_edge(vertex1,vertex3,-2.0)
    graph.add_edge(vertex2,vertex4,1.0)
    graph.add_edge(vertex3,vertex4,10.0)

    dij = Prims.new()
    result= dij.run(graph,vertex1)
    # puts (result)
    ans = {"vertex1" => nil, "vertex2" => "vertex3", "vertex3" => "vertex1", "vertex4" => "vertex2"}

    true.should eq(result == ans)
  end

end
