module Graphlb::DataStructures

  # TreeNode Class Description
  #
  # This class models the nodes for an *N-ary* tree data structure. The
  # nodes are *named*, and have a place-holder for the node data (i.e.,
  # _content_ of the node). The node names are required to be *unique*
  # amongst the sibling/peer nodes. Note that the name is implicitly
  # used as an _ID_ within the data structure).
  #
  # The node's _content_ is *not* required to be unique across
  # different nodes in the tree, and can be +nil+ as well.
  #
  # The class provides various methods to navigate the tree, traverse
  # the structure, modify contents of the node, change position of the
  # node in the tree, and to make structural changes to the tree.
  #
  # A node can have any number of *child* nodes attached to it and
  # hence can be used to create N-ary trees.  Access to the child
  # nodes can be made in order (with the conventional left to right
  # access), or randomly.
  #
  # The node also provides direct access to its *parent* node as well
  # as other superior parents in the path to root of the tree.  In
  # addition, a node can also access its *sibling* nodes, if present.
  #
  class TreeNode

    # Name of this node.  Expected to be unique within the tree.
    #
    # Note that the name attribute really functions as an *ID* within
    # the tree structure, and hence the uniqueness constraint is
    # required.
    getter name : String

    # Parent of this node.  Will be +nil+ for a root node.
    getter parent : Nil|TreeNode

    # Content of this node.  Can be +nil+.  Note that there is no
    # uniqueness constraint related to this attribute.
    property content : Nil|Int32

    # Creates a new node with a name and optional content.
    # The node name is expected to be unique within the tree.
    #
    # The content can be of type Int32, and defaults to +nil+.
    #
    # @param [Object] name Name of the node. Conventional usage is to pass a
    #   String
    #
    # @param [Object] content Content of the node.
    #
    # @raise [ArgumentError] Raised if the node name is empty.
    def initialize(name,content = nil) #No testcase
      if name.nil?
        raise "Node name has to be provided"
      end
      @parent = nil
      @name = name
      if content.nil?
        @content = nil
      else
        @content = content
      end
      @children_hash = Hash(String ,TreeNode).new
      @children = [] of TreeNode

      self.set_as_root!

    end

    # An array of ancestors of this node in reversed order
    # (the first element is the immediate parent of this node).
    #
    # Returns +nil+ if this is a root node.
    #
    # @return [Array<TreeNode>] An array of ancestors of this node
    # @return [nil] if this is a root node.
    def parentage
      return nil if is_root?

      parentage_array = [] of TreeNode
      prev_parent = self.parent
      while prev_parent
        parentage_array << prev_parent
        prev_parent = prev_parent.parent
      end
      parentage_array
    end

    # Replaces the specified child node with another child node on this node.
    #
    # @param [TreeNode] old_child The child node to be replaced.
    # @param [TreeNode] new_child The child node to be replaced with.
    #
    # @return [TreeNode] The removed child node
    def replace!(old_child, new_child)
      child_index = @children.index(old_child)

      old_child = remove! old_child
      add new_child, child_index

      old_child
    end

    # Returns the requested node from the set of immediate children.
    #
    # - If the +name+ argument is an _Integer_, then the in-sequence
    #   array of children is accessed using the argument as the
    #   *index* (zero-based).  However, if the second _optional_
    #   +num_as_name+ argument is +true+, then the +name+ is used
    #   literally as a name, and *NOT* as an *index*
    #
    # - If the +name+ argument is *NOT* an _Integer_, then it is taken to
    #   be the *name* of the child node to be returned.
    #
    # If a non-+Integer+ +name+ is passed, and the +num_as_name+
    # parameter is also +true+, then a warning is thrown (as this is a
    # redundant use of the +num_as_name+ flag.)
    #
    # @param [String|Number] name_or_index Name of the child, or its
    #   positional index in the array of child nodes.
    #
    # @param [Boolean] num_as_name Whether to treat the +Integer+
    #   +name+ argument as an actual name, and *NOT* as an _index_ to
    #   the children array.
    #
    # @return [TreeNode] the requested child node.  If the index
    #   in not in range, or the name is not present, then a +nil+
    #   is returned.
    #
    #  @raise [Error] Raised if the +name_or_index+ argument is +nil+.
    def [](name_or_index, num_as_name=false) #no testcase
      raise "Name_or_index needs to be provided!" if name_or_index == nil

      if name_or_index.is_a?(Int32) &&  !num_as_name
        @children[name_or_index]
      else
        if num_as_name && !(name_or_index.is_a?(Int32))
          raise "Redundant use of the `num_as_name` flag for non-integer node name"
        end
        @children_hash[name_or_index]
      end
    end

    # Replaces the node with another node
    #
    # @param [TreeNode] node The node to replace this node with
    #
    # @return [TreeNode] The replaced child node
    def replace_with(node)
      @parent.replace!(self, node)
    end

    # Root node for the (sub)tree to which this node belongs.
    # A root node's root is itself.
    #
    # @return [TreeNode] Root of the (sub)tree.
    def root
      root = self
      until root.not_nil!.is_root?
        root = root.not_nil!.parent
      end
      root
    end

    # Method to set this node as a root node.
    #
    # @return +nil+.
    def set_as_root! # no testcase
      self.parent = nil
    end

    # Method to set the parent node for this node.
    # This method should *NOT* be invoked by client code.
    #
    # @param [TreeNode] parent The parent node.
    #
    # @return [TreeNode] The parent node.
    def parent=(parent) #no testcase
      @parent = parent
      @node_depth = 0
    end

    # Removes this node from its parent. This node becomes the new root for its
    # subtree.
    #
    # If this is the root node, then does nothing.
    #
    # @return [TreeNode] +self+ (the removed node) if the operation is
    #                                successful, +nil+ otherwise.
    def remove_from_parent!
      @parent.remove!(self) unless is_root?
    end

    # Convenience synonym for {TreeNode#add} method.
    #
    # This method allows an easy mechanism to add node hierarchies to the tree
    # on a given path via chaining the method calls to successive child nodes.
    #
    # @example Add a child and grand-child to the root
    #   root << child << grand_child
    #
    # @param [TreeNode] child the child node to add.
    #
    # @return [TreeNode] The added child node.
    #
    def <<(child)
      add(child)
    end

    # Adds the specified child node to this node.
    #
    # This method can also be used for *grafting* a subtree into this
    # node's tree, if the specified child node is the root of a subtree (i.e.,
    # has child nodes under it).
    #
    # this node becomes parent of the node passed in as the argument, and
    # the child is added as the last child ("right most") in the current set of
    # children of this node
    #
    # @param [TreeNode] child The child node to add.
    #
    # @param [optional, Number] at_index The optional position where the node is
    #                                    to be inserted.
    #
    # @return [TreeNode] The added child node.
    #
    # @raise [Error]  This exception is raised if another child node with
    #                 the same name exists, or if an invalid insertion
    #                 position is specified.
    #
    # @raise [Error]  This exception is raised if a +nil+ node is passed
    #                 as the argument.
    def add(child, at_index = -1)
      raise "Attempting to add a nil node" unless child
      raise "Attempting add node to itself" if self == child
      raise "Attempting add root as a child" if child == root
      raise "child #{child.name} already added!" if @children_hash.includes?(child.name)

      if insertion_range.includes?(at_index)
        @children.insert(at_index,child)
      else
        raise "attempting to insert a child at a non-existing location"
      end

      @children_hash[child.name] = child
      child.parent = self
      child
    end

     # Return a range of valid insertion positions.  Used in the #add method.
    def insertion_range #no testcase
      max = @children.size
      min = -(max + 1)
      min..max
    end

    # Renames the node and updates the parent's reference to it
    #
    # @param [Object] new_name Name of the node. Conventional usage is to pass a
    #                          String (Integer names may cause *surprises*)
    #
    # @return [Object] The old name
    def rename(new_name)
      old_name = @name

      if is_root?
        self.name=(new_name)
      else
        @parent.rename_child old_name, new_name
      end

      old_name
    end

    # Removes the specified child node from this node.
    #
    # This method can also be used for *pruning* a sub-tree, in cases where the removed child node is
    # the root of the sub-tree to be pruned.
    #
    # The removed child node is orphaned but accessible if an alternate reference exists.  If accessible via
    # an alternate reference, the removed child will report itself as a root node for its sub-tree.
    #
    # @param [TreeNode] child The child node to remove.
    #
    # @return [TreeNode] The removed child node, or +nil+ if a +nil+ was passed in as argument.
    def remove!(child)
      return nil unless child
      @children_hash.delete(child.name)
      @children.delete(child)
      child.set_as_root!
      child
    end

    # Returns *true* if this is a root node.  Note that
    # orphaned children will also be reported as root nodes.
    #
    # @return [Boolean] +true+ if this is a root node.
    def is_root?
      @parent.nil?
    end

    # Returns *true* if this node has content.
    #
    # @return [Boolean] +true+ if the node has content.
    def has_content?
      @content != nil
    end

    # Returns *true* if this node is a _leaf_ - i.e., one without
    # any children.
    #
    # @return [Boolean] +true+ if this is a leaf node.
    #
    def is_leaf?
      !has_children?
    end

    # Returns *true* if the this node has any child node.
    #
    # @return [Boolean] +true+ if child nodes exist.
    #
    def has_children?
      @children.size != 0
    end

    # First sibling of this node. If this is the root node, then returns
    # itself.
    #
    # 'First' sibling is defined as follows:
    #
    # First sibling:: The left-most child of this node's parent, which may be
    # this node itself
    #
    # @return [TreeNode] The first sibling node.
    def first_sibling
      is_root? ? self : parent.not_nil!.children.first
    end


    # Returns *true* if this node is the first sibling at its level.
    #
    # @return [Boolean] *true* if this is the first sibling.
    def is_first_sibling?
      first_sibling == self
    end

    # Last sibling of this node.  If this is the root node, then returns
    # itself.
    #
    # 'Last' sibling is defined as follows:
    #
    # Last sibling:: The right-most child of this node's parent, which may be
    # this node itself
    #
    # @return [TreeNode] The last sibling node.
    def last_sibling
      is_root? ? self : parent.not_nil!.children.last
    end

    # Returns *true* if this node is the last sibling at its level.
    #
    # @return [Boolean] +true+ if this is the last sibling.
    def is_last_sibling?
      last_sibling == self
    end

    # Returns *true* if this node is the only child of its parent.
    #
    # As a special case, a root node will always return +true+.
    #
    # @return [Boolean] +true+ if this is the only child of its parent.
    def is_only_child?
      is_root? ? true : parent.not_nil!.children.size == 1
    end

    # Next sibling for this node.
    # The _next_ node is defined as the node to right of this node.
    #
    # Will return +nil+ if no subsequent node is present, or if this is a root
    # node.
    #
    # @return [treeNode] the next sibling node, if present.
    def next_sibling
      return nil if is_root?

      idx = parent.not_nil!.children.index(self)
      parent.not_nil!.children[idx + 1] if idx
    end

    # Previous sibling of this node.
    # _Previous_ node is defined to be the node to left of this node.
    #
    # Will return +nil+ if no predecessor node is present, or if this is a root
    # node.
    #
    # @return [treeNode] the previous sibling node, if present.
    def previous_sibling
      return nil if is_root?

      idx = parent.not_nil!.children.index(self)
      parent.not_nil!.children[idx - 1] if idx && idx > 0
    end


    # Traverses each node (including this node) of the (sub)tree rooted at this
    # node by yielding the nodes to the specified block.
    #
    # The traversal is *depth-first* and from *left-to-right* in pre-ordered
    # sequence.
    #
    # @param [Object] block
    # @yieldparam node [TreeNode] Each node.
    #
    # @return [TreeNode] this node
    def each(&block)             # :yields: node

      node_stack = [self]   # Start with this node

      until node_stack.empty?
        current = node_stack.shift    # Pop the top-most node
        if current                    # Might be 'nil' (esp. for binary trees)
          yield current               # and process it
          # Stack children of the current node at top of the stack
          node_stack = current.children.concat(node_stack)
        end
      end

      self
    end

    # Traverses each node (including this node) of the (sub)tree rooted at this
    # node
    #
    #  @return [Enumerator] an enumerator on this tree
    def each
      return self.to_enum
    end

    # An array of all the immediate children of this node. The child
    # nodes are ordered "left-to-right" in the returned array.
    #
    # @param [object] block
    #
    # @yieldparam child [TreeNode] Each child node.
    #
    # @return [TreeNode] This node
    #
    def children(&block)
        @children.each {|child| yield child}
    end

    # Method oveloading of the children method
    #
    # An array of all the immediate children of this node. The child
    # nodes are ordered "left-to-right" in the returned array.
    #
    # @return [Array<TreeNode>] An array of the child nodes.
    #
    def children
      @children
    end

    # Yields every leaf node of the (sub)tree rooted at this node to the
    # specified block.
    #
    # May yield this node as well if this is a leaf node.
    # Leaf traversal is *depth-first* and *left-to-right*.
    #
    # @param [Object] block
    # @yieldparam node [TreeNode] Each leaf node.
    #
    # @return [TreeNode] this node,
    def each_leaf(&block)
        self.each { |node| yield(node) if node.is_leaf? }
        self
    end

    # Method oveloading of the each_leaf method without block parameter
    #
    # @return [Array<TreeNode>] An array of the leaf nodes
    #
    def each_leaf
      self.select { |node| node.is_leaf? }
    end

    # An array of siblings for this node. This node is excluded.
    #
    # @return [Array<TreeNode>] Array of siblings of this node. Will
    #                            return an empty array for *root*
    def siblings
      return [] of TreeNode if is_root?
      siblings = [] of TreeNode
      if parent.nil?
        raise "There are no siblings of the node/root node"
      else
        parent.not_nil!.children {|my_sibling| siblings << my_sibling if my_sibling != self }
        siblings
      end
    end

    # Height of the (sub)tree from this node.  Height of a node is defined as:
    #
    # Height:: Length of the longest downward path to a leaf from the node.
    #
    # - Height from a root node is height of the entire tree.
    # - The height of a leaf node is zero.
    #
    # @return [Integer] Height of the node.
    def node_height
        return 0 if is_leaf?
        1 + @children.collect { |child| child.node_height }.max
    end

    # Depth of this node in its tree.  Depth of a node is defined as:
    #
    # Depth:: Length of the node's path to its root. Depth of a root node is
    # zero.
    #
    # @return [Integer] Depth of this node.
    def node_depth
      return 0 if is_root?
      1 + parent.not_nil!.node_depth
    end

    # The incoming edge-count of this node.
    #
    # In-degree is defined as:
    # In-degree:: Number of edges arriving at the node (0 for root, 1 for
    # all other nodes)
    #
    # - In-degree = 0 for a root or orphaned node
    # - In-degree = 1 for a node which has a parent
    #
    # @return [Integer] The in-degree of this node.
    def in_degree
      is_root? ? 0 : 1
    end

    # The outgoing edge-count of this node.
    #
    # Out-degree is defined as:
    # Out-degree:: Number of edges leaving the node (zero for leafs)
    #
    # @return [Integer] The out-degree of this node.
    def out_degree
      is_leaf? ? 0 : children.size
    end

    # Helper function for print_tree method to print the
    # tree with given root
    def lam (node,prefix)
      puts "#{prefix} #{node.name}"
    end

    # Pretty prints the (sub)tree rooted at this node.
    #
    # @param [Integer] level The indentation level (4 spaces) to start with.
    # @param [Integer] max_depth optional maximum depth at which the printing
    #                            with stop.
    def print_tree(level = self.node_depth, max_depth = nil)
      prefix = ""
      if is_root?
        prefix += "*"
      else
        prefix += '|' unless parent.not_nil!.is_last_sibling?
        prefix += (" " * (level - 1) * 4)
        prefix += (is_last_sibling? ? '+' : '|')
        prefix += "---"
        prefix += (has_children? ? '+' : '>')
      end

      lam(self, prefix)

      # Exit if the max level is defined, and reached.
      return unless max_depth.nil? || level < max_depth

      children { |child| child.print_tree(level + 1,max_depth) if child } # Child might be 'nil'
    end

  end
end
