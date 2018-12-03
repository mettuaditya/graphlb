require "./spec_helper"

include Graphlb::DataStructures
include Graphlb::Algorithms

describe Graphlb do

  it "BFs works" do
    graph = UnDirectedGraph.new()
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

    dij = Prims.new()
    result = dij.run(graph,start)
    ans = {"start" => nil, "mid1" => "start", "mid2" => "mid1", "stop" => "start"}
    true.should eq(result == ans)
  end
  it "If graph has two components" do
    graph = UnDirectedGraph.new()
    start = graph.add_vertex("start")
    mid1 = graph.add_vertex("mid1")
    mid2 = graph.add_vertex("mid2")
    stop = graph.add_vertex("stop")
    ind = graph.add_vertex("ind")

    graph.add_edge(start,mid1,2.0)
    graph.add_edge(start,mid2,3.0)
    graph.add_edge(mid1,stop,20.0)
    graph.add_edge(mid2,stop,7.0)
    graph.add_edge(stop,start,3.0)
    graph.add_edge(mid1,mid2,0.5)

    dij = Prims.new()
    result= dij.run(graph,start)
    ans = {"start" => nil, "mid1" => "start", "mid2" => "mid1", "stop" => "start","ind" => nil}

    true.should eq(result == ans)
  end


end
