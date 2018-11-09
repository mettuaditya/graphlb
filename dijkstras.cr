require "./directedgraph.cr"

def dijkstra (graph, source)

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

  while !vertex_set.empty?
      u = vertex_set.min_by {|n| dist.fetch(n,Float64::INFINITY)}
      vertex_set.delete(u)
      u.edges.keys.each do |neighbour|
        temp = dist[u] + u.edges[neighbour]
        if temp < dist[neighbour]
          dist[neighbour] = temp
          prev[neighbour] = u
        end
      end
  end
  #puts dist
  #puts prev
  return dist,prev
end
# def dijkstra (graph, source, target)
#
#   vertex_set = [] of Node
#   vertices = graph.get_vertices()
#   dist = {} of Node => Float64
#   prev = {} of Node => Node | Nil
#   i = 0
#   size = vertices.size
#   while i < size
#     dist[vertices[i]] = Float64::INFINITY
#     prev[vertices[i]] = nil
#     vertex_set << vertices[i]
#     i = i + 1
#   end
#   dist[source] = 0.0
#
#   while !vertex_set.empty?
#       u = vertex_set.min_by {|n| dist.fetch(n,Float64::INFINITY)}
#       vertex_set.delete(u)
#       if u == target
#         return dist[u],prev
#       else
#         u.edges.keys.each do |neighbour|
#           temp = dist[u] + u.edges[neighbour]
#           if temp < dist[neighbour]
#             dist[neighbour] = temp
#             prev[neighbour] = u
#           end
#         end
#       end
#   end
#   return dist[target],prev[target]
#   #puts dist
#   #puts prev
# end

def path_constructor (prev,source,target)

  set = [] of String
  temp = target
  while (!temp.nil? && temp != source)
    set.insert(0,temp.name)
    temp = prev[temp]
  end
  set.insert(0,source.name)
  return set
end

# graph = Graph.new()
# start = graph.add_vertex("start")
# mid1 = graph.add_vertex("mid1")
# mid2 = graph.add_vertex("mid2")
# stop = graph.add_vertex("stop")
#
# graph.edge(start,mid1,2.0)
# graph.edge(start,mid2,3.0)
# graph.edge(mid1,stop,20.0)
# graph.edge(mid2,stop,7.0)
# graph.edge(stop,start,3.0)
# graph.edge(mid1,mid2,0.5)
# #puts (graph.get_vertices())
#
# dist,prev = dijkstra(graph,start)
# puts stop
# puts prev[stop]
# puts (path_constructor(prev,start,mid2))
# #puts ("#{dist}-->#{prev}")
# # dist.keys.each do |i|
# #   puts "#{i.name} ==> #{dist[i]} ==> #{prev[i]}"
# # end
