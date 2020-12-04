require "./spec_helper"
require "../src/graphlb/algorithms/dot"

include Graphlb::DataStructures
include Graphlb::Algorithms
include Graphlb::DOT

describe GraphDot do
  it "write dot files from a directed graph" do
    graph = DirectedGraph.new()
    start = graph.add_vertex("start")
    finish = graph.add_vertex("finish")
    graph.add_vertex("alone")

    graph.add_edge(start, finish, 2.0)

    dot = GraphDot.new(graph)
    dot.to_s.should eq("digraph dotgraph {\n" \
                       "start->finish [label=2.0];\n" \
                       "finish;\n" \
                       "alone;\n" \
                       "}\n")
  end

  it "write dot files from an undirected graph" do
    graph = UnDirectedGraph.new()
    one = graph.add_vertex("one")
    another = graph.add_vertex("another")
    graph.add_vertex("alone")

    graph.add_edge(one, another, 2.0)

    dot = GraphDot.new(graph)
    dot.to_s.should eq("graph dotgraph {\n" \
                       "one--another [label=2.0];\n" \
                       "alone;\n" \
                       "}\n")
  end

  it "saves a graph to PNG" do
    graph = DirectedGraph.new()
    start = graph.add_vertex("start")
    stop = graph.add_vertex("stop")
    graph.add_edge(start, stop, 1.0)

    png = File.tempfile(".png")
    dot = GraphDot.new(graph)
    dot.save_png(png.path)
    File.open(png.path, "rb") do |fp|
      bytes = Bytes.new(8)
      fp.read(bytes)
      bytes.to_a.should eq([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A] of UInt8) # PNG magic bytes
    end
  ensure
    png.try(&.delete)
  end
end
