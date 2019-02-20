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

    dij = Dijkstras.new(graph,start)
    result = dij.shortest_path(start,mid2)
    ans = ["start", "mid1", "mid2"]

    true.should eq(result == ans)
  end

  expect_raises(Exception,"graph contains negative edge") do
    graph1 = DirectedGraph.new()
    start = graph1.add_vertex("start")
    mid1 = graph1.add_vertex("mid1")
    mid2 = graph1.add_vertex("mid2")
    stop = graph1.add_vertex("stop")

    graph1.add_edge(start,mid1,-2.0)
    graph1.add_edge(mid2,start,-3.0)
    graph1.add_edge(mid1,stop,20.0)
    graph1.add_edge(mid2,stop,7.0)
    graph1.add_edge(stop,start,3.0)
    graph1.add_edge(mid1,mid2,0.5)

    dij = Dijkstras.new(graph1,start)
  end

  it "test shortest path search with unreachable vertex" do
    vertex5 = graph.add_vertex("vertex5")
    dij = Dijkstras.new(graph,start)

    result = dij.shortest_path(start,vertex5)
    ans = ["nil"]
    true.should eq(result == ans)
  end


end
