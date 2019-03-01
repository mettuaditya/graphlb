require "./spec_helper"

include Graphlb::DataStructures
include Graphlb::Algorithms

describe Graphlb do

  it "DFS for directed graph" do
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

    dfs = DFS.new()
    result= dfs.run(graph,start)
    # puts (result)
    ans = ["start", "mid2", "stop", "mid1"]

    true.should eq(result == ans)
  end

  it "DFS for undirected graph" do
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

    dfs = DFS.new()
    result= dfs.run(graph,vertex1)
    ans = ["vertex1", "vertex3", "vertex4", "vertex2"]

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

    dfs = DFS.new()
    result= dfs.run(graph,start)
    ans = ["start", "mid1", "mid2", "stop"]

    true.should eq(result == ans)
  end


end
