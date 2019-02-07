module Graphlb::DataStructures
  class TreeNode

    getter name : String
    getter parent : Nil|TreeNode
    property content : Nil|Int32

    def initialize(name,content = nil)
      if name.nil?
        raise "Node name has to be provided"
      end
      @name = name
      if content.nil?
        @content = nil
      else
        @content = content
      end
      @children_hash = Hash(String ,TreeNode).new
      @children = [] of TreeNode | Nil

      self.set_as_root!

    end

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

    def replace!(old_child, new_child)
      child_index = @children.index(old_child)

      old_child = remove! old_child
      add new_child, child_index

      old_child
    end

    def [](name_or_index, num_as_name=false)
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

    def replace_with(node)
      @parent.replace!(self, node)
    end

    def root
      root = self
      until root.is_root?
        root = root.parent
      end
      root
    end

    def set_as_root!
      self.parent = nil
    end

    def parent=(parent)
      @parent = parent
      # @node_depth = nil

    end

    def remove_from_parent!
      @parent.remove!(self) unless is_root?
    end

    def <<(child)
      add(child)
    end

    def add(child, at_index = -1)
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

    def insertion_range
      max = @children.size
      min = -(max + 1)
      min..max
    end

    def rename(new_name)
      old_name = @name

      if is_root?
        self.name=(new_name)
      else
        @parent.rename_child old_name, new_name
      end

      old_name
    end

    def remove!(child)
      return nil unless child
      @children_hash.delete(child.name)
      @children.delete(child)
      child.set_as_root!
      child
    end

    def is_root?
      @parent.nil?
    end

    def is_leaf?
      !has_children?
    end

    def has_children?
      @children.size != 0
    end

    def first_sibling
      is_root? ? self : parent.children.first
    end

    def is_first_sibling?
      first_sibling == self
    end

    def last_sibling
      is_root? ? self : parent.children.last
    end

    def is_last_sibling?
      last_sibling == self
    end

    def is_only_child?
      is_root? ? true : parent.children.size == 1
    end

    def next_sibling
      return nil if is_root?

      idx = parent.children.index(self)
      parent.children.at(idx + 1) if idx
    end

    def previous_sibling
      return nil if is_root?

      idx = parent.children.index(self)
      parent.children.at(idx - 1) if idx && idx > 0
    end

    def each(&block)             # :yields: node

    return self.to_enum unless block_given?

    node_stack = [self]   # Start with this node

    until node_stack.empty?
      current = node_stack.shift    # Pop the top-most node
      if current                    # Might be 'nil' (esp. for binary trees)
        yield current               # and process it
        # Stack children of the current node at top of the stack
        node_stack = current.children.concat(node_stack)
      end
    end

    self if block_given?
    end

    def preordered_each(&block)  # :yields: node
      each(&block)
    end

    def postordered_each(&block)
      return self.to_enum(:postordered_each) unless block_given?

      # Using a marked node in order to skip adding the children of nodes that
      # have already been visited. This allows the stack depth to be controlled,
      # and also allows stateful backtracking.
      marked_node = Struct.new(:node, :visited)
      node_stack = [marked_node.new(self, false)] # Start with self

      until node_stack.empty?
        peek_node = node_stack[0]
        if peek_node.node.has_children? and not peek_node.visited
          peek_node.visited = true
          # Add the children to the stack. Use the marking structure.
          marked_children =
          peek_node.node.children.map {|node| marked_node.new(node, false)}
          node_stack = marked_children.concat(node_stack)
          next
        else
          yield node_stack.shift.node           # Pop and yield the current node
        end
      end

      self if block_given?
    end

    def breadth_each(&block)
      return self.to_enum(:breadth_each) unless block_given?

      node_queue = [self]       # Create a queue with self as the initial entry

      # Use a queue to do breadth traversal
      until node_queue.empty?
        node_to_traverse = node_queue.shift
        yield node_to_traverse
        # Enqueue the children from left to right.
        node_to_traverse.children { |child| node_queue.push child }
      end

      self if block_given?
    end

    def children
      if block_given?
        @children.each {|child| yield child}
        self
      else
        @children.clone
      end
    end

    def each_leaf(&block)
      if block_given?
        self.each { |node| yield(node) if node.is_leaf? }
        self
      else
        self.select { |node| node.is_leaf? }
      end
    end

    def siblings
      # if block_given?
      #   parent.children.each { |sibling| yield sibling if sibling != self }
      #   self
      return [] of TreeNode if is_root?
      siblings = [] of TreeNode | Nil
      if parent.children.nil?
        return nil
      else
        parent.children {|my_sibling| siblings << my_sibling if my_sibling != self && !my_sibling.nil?}
        siblings
      end
    end
  end
end
