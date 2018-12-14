require "./spec_helper"

include Graphlb::DataStructures
include Graphlb::Algorithms

describe Graphlb do

  it "positive weights" do
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

    dij = BellmanFord.new()
    dist,prev = dij.run(graph,start)
    result = dij.path_constructor(prev,start,mid2)
    ans = ["start", "mid1", "mid2"]

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

    dij = BellmanFord.new()
    dist,prev = dij.run(graph,start)

  end
end
