require "./spec_helper"

include Graphlb

describe Graphlb do
  graph = DirectedGraph.new()
  start = graph.add_vertex("start")
  mid1 = graph.add_vertex("mid1")
  mid2 = graph.add_vertex("mid2")
  stop = graph.add_vertex("stop")

  graph.edge(start,mid1,2.0)
  graph.edge(start,mid2,3.0)
  graph.edge(mid1,stop,20.0)
  graph.edge(mid2,stop,7.0)
  graph.edge(stop,start,3.0)
  graph.edge(mid1,mid2,0.5)

  dij = Dijkstras.new()
  dist,prev = dij.run(graph,start)
  result = dij.path_constructor(prev,start,mid2)

  ans = ["start", "mid1", "mid2"]

  it "works" do
    true.should eq(result == ans)
  end
end
