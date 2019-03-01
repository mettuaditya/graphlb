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

  it "shortest path search from vertex 1" do

    bell = BellmanFord.new(graph,vertex1)
    result = bell.shortest_paths(vertex1)
    #puts (result)
    ans = [["vertex1"], ["vertex1", "vertex3", "vertex2"], ["vertex1", "vertex3"], ["vertex1", "vertex3", "vertex2", "vertex4"]]

    temp = bell.shortest_paths(vertex1)
    true.should eq(result == ans)
  end

  it "test shortest path search with unreachable vertex" do
    vertex5 = graph.add_vertex("vertex5")
    bell = BellmanFord.new(graph,vertex1)

    result = bell.shortest_paths(vertex1)
    #puts (result)
    ans = [["vertex1"], ["vertex1", "vertex3", "vertex2"], ["vertex1", "vertex3"], ["vertex1", "vertex3", "vertex2", "vertex4"], ["nil"]]
    true.should eq(result == ans)
  end

  expect_raises(Exception,"graph contains negative cycle") do
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

    bell = BellmanFord.new(graph,vertex1)
  end

  # can't use an undirected graph with a negative weighted
  # edge here, because a negative weighted undirected edge is
  # already a negative weighted cycle and therefore Bellman-Ford
  # can't be applied for such graph

  it "test shortest path search with negative edges" do
    graph = DirectedGraph.new()
    vertex1 = graph.add_vertex("vertex1")
    vertex2 = graph.add_vertex("vertex2")
    vertex3 = graph.add_vertex("vertex3")
    vertex4 = graph.add_vertex("vertex4")

    graph.add_edge(vertex1,vertex2,10.0)
    graph.add_edge(vertex2,vertex3,1.0)
    graph.add_edge(vertex1,vertex3,1.0)
    graph.add_edge(vertex2,vertex4,1.0)
    graph.add_edge(vertex3,vertex4,-1.0)
    graph.add_edge(vertex3,vertex2,1.0)


    bell = BellmanFord.new(graph,vertex1)
    result = bell.shortest_paths(vertex1)
    #puts (result)
    ans = [["vertex1"], ["vertex1", "vertex3", "vertex2"], ["vertex1", "vertex3"], ["vertex1", "vertex3", "vertex4"]]

    true.should eq(result == ans)
  end
end
