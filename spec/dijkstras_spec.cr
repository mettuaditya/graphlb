require "./spec_helper"

include Graphlb::DataStructures
include Graphlb::Algorithms

describe Graphlb do

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

  dij = Dijkstras.new(graph,vertex1)
  it "test shortest path search" do


    result = dij.shortest_path(vertex1,vertex4)
    puts (result)
    ans = ["vertex1", "vertex3", "vertex2", "vertex4"]

    true.should eq(result == ans)
  end

  it "test shortest path search for source" do

    result = dij.shortest_path(vertex1,vertex1)
    puts (result)
    ans = ["vertex1"]

    true.should eq(result == ans)
  end

  it "test shortest paths search " do

    result = dij.shortest_paths(vertex1)
    puts (result)
    ans = [["vertex1"], ["vertex1", "vertex3", "vertex2"], ["vertex1", "vertex3"], ["vertex1", "vertex3", "vertex2", "vertex4"]]

    true.should eq(result == ans)
  end


  expect_raises(Exception, "graph contains negative edge") do
    graph1 = UnDirectedGraph.new()
    vertex1 = graph1.add_vertex("vertex1")
    vertex2 = graph1.add_vertex("vertex2")
    vertex3 = graph1.add_vertex("vertex3")
    vertex4 = graph1.add_vertex("vertex4")


    graph1.add_edge(vertex1,vertex2,10.0)
    graph1.add_edge(vertex2,vertex3,-7.0)
    graph1.add_edge(vertex1,vertex3,1.0)
    graph1.add_edge(vertex2,vertex4,1.0)
    graph1.add_edge(vertex3,vertex4,10.0)

    dij = Dijkstras.new(graph1,vertex1)
  end

  it "test shortest path search with unreachable vertex" do
    vertex5 = graph.add_vertex("vertex5")
    dij = Dijkstras.new(graph,vertex1)

    result = dij.shortest_path(vertex1,vertex5)
    puts (result)
    ans = ["nil"]
    true.should eq(result == ans)
  end
end
