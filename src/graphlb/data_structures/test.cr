require "../data_structures/tree.cr"

include Graphlb::DataStructures

rootnode = TreeNode.new("root",2)
puts (rootnode.is_leaf?)
puts (rootnode.is_root?)
puts (rootnode.has_children?)
