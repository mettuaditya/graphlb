require "../data_structures/directedgraph.cr"
require "../algorithms/depth_first_search.cr"

module Graphlb::Algorithms

  class Bipartite

    @colour_map = {} of Node => Bool
    def initialize(graph)

      if graph.is_a?(DirectedGraph) then
        raise "Bipartite matching is done only for Undirected gaphs"
      else
        bfs = BFS.new()
        vertex_set = graph.get_vertices
        visited_set = [] of Node
        @previous = {} of Node => Node | Nil
        @vertex_set.each do |v|
          if visited_set.include?(v)
            next
          end
          visited, prev = bfs.reachable(v)
          @visited_set = @visited_set + visited
          prev.delete_if { |key,value| value.nil?}
          @previous.merge(prev)
        end
        bipartite_set()
      end
    end

    def bipartite_set()
      while (@colour_map.size != @visited_set.size)
        @visited_set.each do |v|
          assign_colour(v)
        end
      end
      set_s = @colour_map.select {|key,value| value == false}
      set_t = @colour_map.select {|key,value| value == true}

      check_set(set_s)
      check_set(set_t)

      return set_s,set_t
    end

    def assign_colour(key)
      if @previous[key].nil? then
        @colour_map[key] = true
      else
        @colour_map[key] = !@colour_map[value]
      end
    end

    def check_set(set)
      set.each do |v|
        v.edges.keys do |u|
          if set.include?(u) then
            return "no bipartite possible"
          end
        end
      end
    end
    
  end
end
