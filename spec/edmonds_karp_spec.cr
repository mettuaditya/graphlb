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
    graph.add_edge(mid1,stop,20.0)
    graph.add_edge(mid2,stop,7.0)
    graph.add_edge(start,mid2,3.0)
    dij = EdmondsKarp.new()
    result = dij.run(graph,start,stop)
    ans = 5.0
    true.should eq(result == ans)
  end

  it "positive weights" do
    graph = DirectedGraph.new()
    vertex0 = graph.add_vertex("vertex0")
    vertex1 = graph.add_vertex("vertex1")
    vertex2 = graph.add_vertex("vertex2")
    vertex3 = graph.add_vertex("vertex3")
    vertex4 = graph.add_vertex("vertex4")
    vertex5 = graph.add_vertex("vertex5")

    graph.add_edge(vertex0,vertex1,16.0)
    graph.add_edge(vertex0,vertex2,13.0)
    graph.add_edge(vertex1,vertex2,10.0)
    graph.add_edge(vertex2,vertex1,4.0)
    graph.add_edge(vertex1,vertex3,12.0)
    graph.add_edge(vertex2,vertex4,14.0)
    graph.add_edge(vertex3,vertex2,9.0)
    graph.add_edge(vertex4,vertex3,7.0)
    graph.add_edge(vertex3,vertex5,20.0)
    graph.add_edge(vertex4,vertex5,4.0)

    dij = EdmondsKarp.new()
    result = dij.run(graph,vertex0,vertex5)
    ans = 23.0
    true.should eq(result == ans)
  end

  expect_raises(Exception,"graph contains negative capacities") do
    graph = DirectedGraph.new()
    vertex0 = graph.add_vertex("vertex0")
    vertex1 = graph.add_vertex("vertex1")
    vertex2 = graph.add_vertex("vertex2")
    vertex3 = graph.add_vertex("vertex3")
    vertex4 = graph.add_vertex("vertex4")
    vertex5 = graph.add_vertex("vertex5")

    graph.add_edge(vertex0,vertex1,-23.0)
    graph.add_edge(vertex0,vertex5,2.0)
    graph.add_edge(vertex5,vertex1,3.0)
    graph.add_edge(vertex1,vertex2,20.0)
    graph.add_edge(vertex5,vertex4,40.0)
    graph.add_edge(vertex2,vertex4,25.0)
    graph.add_edge(vertex2,vertex3,60.0)
    graph.add_edge(vertex4,vertex3,70.0)

    dij = EdmondsKarp.new()
    result = dij.run(graph,vertex0,vertex3)
    ans = 23.0
    true.should eq(result == ans)
  end

  expect_raises(Exception,"same source and sink") do
    graph = DirectedGraph.new()
    start = graph.add_vertex("start")
    mid1 = graph.add_vertex("mid1")
    mid2 = graph.add_vertex("mid2")
    stop = graph.add_vertex("stop")


    graph.add_edge(start,mid1,2.0)
    graph.add_edge(mid1,stop,20.0)
    graph.add_edge(mid2,stop,7.0)
    graph.add_edge(start,mid2,3.0)
    dij = EdmondsKarp.new()
    result = dij.run(graph,start,start)
  end

  expect_raises(Exception,"source and sink are not reachable") do
    graph = DirectedGraph.new()
    start = graph.add_vertex("start")
    mid1 = graph.add_vertex("mid1")
    mid2 = graph.add_vertex("mid2")
    stop = graph.add_vertex("stop")
    ind = graph.add_vertex("ind")

    graph.add_edge(start,mid1,2.0)
    graph.add_edge(mid1,stop,20.0)
    graph.add_edge(mid2,stop,7.0)
    graph.add_edge(start,mid2,3.0)
    dij = EdmondsKarp.new()
    result = dij.run(graph,start,ind)
  end
end
