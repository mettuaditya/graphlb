require "./spec_helper"

include Graphlb::DataStructures
include Graphlb::Algorithms

describe Graphlb do

  graph = DirectedGraph.new()
  start = graph.add_vertex("start")
  mid1 = graph.add_vertex("mid1")
  mid2 = graph.add_vertex("mid2")
  stop = graph.add_vertex("stop")

  graph.add_edge(start,mid1,2.0)
  graph.add_edge(start,mid2,3.0)
  graph.add_edge(mid1,stop,20.0)
  graph.add_edge(mid2,stop,7.0)
  graph.add_edge(stop,start,3.0)
  graph.add_edge(mid1,mid2,0.5)


  it "positive weights" do

    bell = BellmanFord.new(graph,start)
    result = bell.shortest_path(start,mid2)
    ans = ["start", "mid1", "mid2"]

    temp = bell.shortest_paths(start)
    true.should eq(result == ans)
  end

  it "test shortest path search with unreachable vertex" do
    vertex5 = graph.add_vertex("vertex5")
    bell = BellmanFord.new(graph,start)

    result = bell.shortest_path(start,vertex5)
    ans = ["nil"]
    true.should eq(result == ans)
  end

  expect_raises(Exception,"graph contains negative cycle") do
    graph = DirectedGraph.new()
    start = graph.add_vertex("start")
    mid1 = graph.add_vertex("mid1")
    mid2 = graph.add_vertex("mid2")
    stop = graph.add_vertex("stop")

    graph.add_edge(start,mid1,-2.0)
    graph.add_edge(mid2,start,-3.0)
    graph.add_edge(mid1,stop,20.0)
    graph.add_edge(mid2,stop,7.0)
    graph.add_edge(stop,start,3.0)
    graph.add_edge(mid1,mid2,0.5)

    bell = BellmanFord.new(graph,start)
  end

  it "test shortest path search with negative edges" do
    graph = DirectedGraph.new()
    start = graph.add_vertex("start")
    mid1 = graph.add_vertex("mid1")
    mid2 = graph.add_vertex("mid2")
    stop = graph.add_vertex("stop")

    graph.add_edge(start,mid1,-2.0)
    graph.add_edge(mid2,start,3.0)
    graph.add_edge(mid1,stop,20.0)
    graph.add_edge(mid2,stop,7.0)
    graph.add_edge(stop,start,3.0)
    graph.add_edge(mid1,mid2,0.5)

    bell = BellmanFord.new(graph,start)
    result = bell.shortest_paths(start)
    ans = [["start"],["start","mid1"],["start","mid1","mid2"],["start","mid1","mid2","stop"]]

    true.should eq(result == ans)
  end
end
