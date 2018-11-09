require "./directedgraph.cr"

def bellman_ford (graph,source)
  vertex_set = [] of Node
  vertices = graph.get_vertices()
  dist = {} of Node => Float64
  prev = {} of Node => Node | Nil
  i = 0
  size = vertices.size
  while i < size
    dist[vertices[i]] = Float64::INFINITY
    prev[vertices[i]] = nil
    vertex_set << vertices[i]
    i = i + 1
  end
  dist[source] = 0.0
  i = 1
  while i < size-1
    vertices.each do |j|
      j.edges.keys.each do |neighbour|
        temp = dist[j] + j.edges[neighbour]
        if temp < dist[neighbour]
          dist[neighbour] = temp
          prev[neighbour] = j
        end
      end
    end
    i = i + 1
  end
  vertices.each do |j|
    j.edges.keys.each do |neighbour|
      temp = dist[j] + j.edges[neighbour]
      if temp < dist[neighbour]
        puts ("graph contains negative cycle")
      end
    end
  end

  return dist,prev
end

graph = Graph.new()
start = graph.add_vertex("start")
mid1 = graph.add_vertex("mid1")
mid2 = graph.add_vertex("mid2")
stop = graph.add_vertex("stop")

graph.edge(start,mid1,2.0)
graph.edge(start,mid2,3.0)
graph.edge(mid1,stop,20.0)
graph.edge(mid2,stop,7.0)
graph.edge(stop,start,3.0)
graph.edge(mid1,start,-2.5)
#puts (graph.get_vertices())

dist,prev = bellman_ford(graph,start)
# puts stop
# puts prev[stop]
# puts (path_constructor(prev,start,mid2))
#puts ("#{dist}-->#{prev}")
dist.keys.each do |i|
  puts "#{i.name} ==> #{dist[i]} ==> #{prev[i]}"
end
