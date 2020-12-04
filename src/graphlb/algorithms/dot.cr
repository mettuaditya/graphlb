module Graphlb

  module DOT

    NODE_OPTS = [
        "color", # default: black; node shape color
        "comment", # any string (format-dependent)
        "distortion", # default: 0.0; node distortion for shape=polygon
        "fillcolor", # default: lightgrey/black; node fill color
        "fixedsize", # default: false; label text has no affect on node size
        "fontcolor", # default: black; type face color
        "fontname", # default: Times-Roman; font family
        "fontsize", #default: 14; point size of label
        "group", # name of node"s group
        "height", # default: .5; height in inches
        "label", # default: node name; any string
        "layer", # default: overlay range; all, id or id:id
        "orientation", # dafault: 0.0; node rotation angle
        "peripheries", # shape-dependent number of node boundaries
        "regular", # default: false; force polygon to be regular
        "shape", # default: ellipse; node shape; see Section 2.1 and Appendix E
        "shapefile", # external EPSF or SVG custom shape file
        "sides", # default: 4; number of sides for shape=polygon
        "skew" , # default: 0.0; skewing of node for shape=polygon
        "style", # graphics options, e.g. bold, dotted, filled; cf. Section 2.3
        "URL", # URL associated with node (format-dependent)
        "width", # default: .75; width in inches
        "z", #default: 0.0; z coordinate for VRML output
        "bottomlabel", # auxiliary label for nodes of shape M*
        "bgcolor",
        "rank",
        "toplabel" # auxiliary label for nodes of shape M*
    ]

    EDGE_OPTS = [
        "arrowhead", # default: normal; style of arrowhead at head end
        "arrowsize", # default: 1.0; scaling factor for arrowheads
        "arrowtail", # default: normal; style of arrowhead at tail end
        "color", # default: black; edge stroke color
        "comment", # any string (format-dependent)
        "constraint", # default: true use edge to affect node ranking
        "decorate", # if set, draws a line connecting labels with their edges
        "dir", # default: forward; forward, back, both, or none
        "fontcolor", # default: black type face color
        "fontname", # default: Times-Roman; font family
        "fontsize", # default: 14; point size of label
        "headlabel", # label placed near head of edge
        "headport", # n,ne,e,se,s,sw,w,nw
        "headURL", # URL attached to head label if output format is ismap
        "label", # edge label
        "labelangle", # default: -25.0; angle in degrees which head or tail label is rotated off edge
        "labeldistance", # default: 1.0; scaling factor for distance of head or tail label from node
        "labelfloat", # default: false; lessen constraints on edge label placement
        "labelfontcolor", # default: black; type face color for head and tail labels
        "labelfontname", # default: Times-Roman; font family for head and tail labels
        "labelfontsize", # default: 14 point size for head and tail labels
        "layer", # default: overlay range; all, id or id:id
        "lhead", # name of cluster to use as head of edge
        "ltail", # name of cluster to use as tail of edge
        "minlen", # default: 1 minimum rank distance between head and tail
        "samehead", # tag for head node; edge heads with the same tag are merged onto the same port
        "sametail", # tag for tail node; edge tails with the same tag are merged onto the same port
        "style", # graphics options, e.g. bold, dotted, filled; cf. Section 2.3
        "taillabel", # label placed near tail of edge
        "tailport", # n,ne,e,se,s,sw,w,nw
        "tailURL", # URL attached to tail label if output format is ismap
        "weight", # default: 1; integer cost of stretching an edge
        "id"
    ]

    GRAPH_OPTS = [
        "bgcolor", # background color for drawing, plus initial fill color
        "center", # default: false; center draing on page
        "clusterrank", # default: local; may be "global" or "none"
        "color", # default: black; for clusters, outline color, and fill color if
                 # fillcolor not defined
        "comment", # any string (format-dependent)
        "compound", # default: false; allow edges between clusters
        "concentrate", # default: false; enables edge concentrators
        "fillcolor", # default: black; cluster fill color
        "fontcolor", # default: black; type face color
        "fontname", # default: Times-Roman; font family
        "fontpath", # list of directories to search for fonts
        "fontsize", # default: 14; point size of label
        "label", # any string
        "labeljust", # default: centered; "l" and "r" for left- and right-justified
                     # cluster labels, respectively
        "labelloc", # default: top; "t" and "b" for top- and bottom-justified
                    # cluster labels, respectively
        "layers", # id:id:id...
        "margin", # default: .5; margin included in page, inches
        "mclimit", # default: 1.0; scale factor for mincross iterations
        "nodesep", # default: .25; separation between nodes, in inches.
        "nslimit", # if set to "f", bounds network simplex iterations by
                   # (f)(number of nodes) when setting x-coordinates
        "nslimit1", # if set to "f", bounds network simplex iterations by
                    # (f)(number of nodes) when ranking nodes
        "ordering", # if "out" out edge order is preserved
        "orientation", # default: portrait; if "rotate" is not used and the value is
                       # "landscape", use landscape orientation
        "page", # unit of pagination, e.g. "8.5,11"
        "rank", # "same", "min", "max", "source", or "sink"
        "rankdir", # default: TB; "LR" (left to right) or "TB" (top to bottom)
        "ranksep", # default: .75; separation between ranks, in inches.
        "ratio", # approximate aspect ratio desired, "fill" or "auto"
        "samplepoints", # default: 8; number of points used to represent ellipses
                        # and circles on output
        "searchsize", # default: 30; maximum edges with negative cut values to check
                      # when looking for a minimum one during network simplex
        "size", # maximum drawing size, in inches
        "style", # graphics options, e.g. "filled" for clusters
        "URL", # URL associated with graph (format-dependent)

        # maintained for backward compatibility or rdot internal
        "layerseq"
    ]

    class GraphDot
      @graph : Graph

      def initialize(@graph)
      end

      def to_s(io : IO)
        digraph = @graph.is_a?(DirectedGraph)
        io << "di" if digraph
        io << "graph dotgraph {\n"

        link = digraph ? "->" : "--"
        existing_nodes = Set({Node,Node}).new
        @graph.vertices.each do |v|
          if v.edges.empty?
            io << v.name << ";\n"
          else
            v.edges.each do |u, weight|
              unless digraph
                next if existing_nodes.includes?({u, v})

                existing_nodes << {v,u}
              end
              io << v.name << link << u.name << " [label=" << weight << "];\n"
            end
          end
        end
        io << "}\n"
      end

      def save_png(file_name : Path | String) : Nil
        dot = Process.new(command: "dot", args: ["-Tpng", "-o#{file_name}"], input: :pipe, error: :pipe)
        to_s(dot.input)
        raise dot.error.gets_to_end unless dot.wait.success?
      end
    end
  end
end
