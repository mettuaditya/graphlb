require "./spec_helper"

include Graphlb::DataStructures
include Graphlb::Algorithms

describe Graphlb do

  it "DFS works" do
    graph = DirectedGraph.new()
    start = graph.add_vertex("start")
    mid1 = graph.add_vertex("mid1")
    mid2 = graph.add_vertex("mid2")
    stop = graph.add_vertex("stop")

    graph.add_edge(start,mid1,2.0)
    graph.add_edge(mid2,start,3.0)
    graph.add_edge(mid1,stop,20.0)
    graph.add_edge(mid2,stop,7.0)
    graph.add_edge(stop,start,3.0)
    graph.add_edge(mid1,mid2,0.5)

    dij = BFS.new()
    result= dij.run(graph,start)
    ans = ["start", "mid1", "stop", "mid2"]

    true.should eq(result == ans)
  end
  it "If graph has two components" do
    graph = DirectedGraph.new()
    start = graph.add_vertex("start")
    mid1 = graph.add_vertex("mid1")
    mid2 = graph.add_vertex("mid2")
    stop = graph.add_vertex("stop")
    ind = graph.add_vertex("ind")

    graph.add_edge(start,mid1,2.0)
    graph.add_edge(mid2,start,3.0)
    graph.add_edge(mid1,stop,20.0)
    graph.add_edge(mid2,stop,7.0)
    graph.add_edge(stop,start,3.0)
    graph.add_edge(mid1,mid2,0.5)

    dij = BFS.new()
    result= dij.run(graph,start)
    puts (result)
    ans = ["start", "mid1", "stop", "mid2"]

    true.should eq(result == ans)
  end


end
