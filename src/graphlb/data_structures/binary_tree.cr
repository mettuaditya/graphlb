
# Provides a binary tree data structure with ability to
# store two node elements as children at each node in the tree.

require "./tree.cr"

module Graphlb::DataStructures

  # Provides a Binary tree implementation. This node allows only two child nodes
  # (left and right child). It also provides direct access to the left or right
  # child, including assignment to the same.
  #
  # This inherits from the {TreeNode} class.
  class BinaryTreeNode < TreeNode

    # Left child of the receiver node. Note that left Child == first Child.
    #
    # @return [BinaryTreeNode] The left most (or first) child.
    def left_child
      children.first
    end

    # Right child of the receiver node. Note that right child == last child
    # unless there is only one child.
    #
    # Returns *nil* if the right child does not exist.
    #
    # @return [BinaryTreeNode] The right child, or *nil* if the right side
    # child does not exist.
    def right_child
      children[1]
    end

    # *true* if the receiver node is the left child of its parent.
    # Always returns *false* if it is a root node.
    #
    # @return [Boolean] *true* if this is the left child of its parent.
    def is_left_child?
      return false if is_root?
      self == parent.left_child
    end


    # *true* if the receiver node is the right child of its parent.
    # Always returns *false* if it is a root node.
    #
    # @return [Boolean] *true* if this is the right child of its parent.
    def is_right_child?
      return false if is_root?
      self == parent.right_child
    end

    # A protected method to allow insertion of child nodes at the specified
    # location. Note that this method allows insertion of +nil+ nodes.
    #
    # @param [BinaryTreeNode] child The child to add at the specified
    #                                     location.
    #
    # @param [Integer] at_index The location to add the entry at (0 or 1).
    #
    # @return [BinaryTreeNode] The added child.
    #
    # @raise [Error] If the index is out of limits.
    protected def set_child_at(child, at_index)

      unless (0..1).include? at_index
        raise "A binary tree cannot have more than two children."
      else
        @children[at_index]        = child
        @children_hash[child.name] = child if child # Assign the name mapping
        child.parent               = self if child
        child
      end
    end


    # Sets the left child of the receiver node. If a previous child existed, it
    # is replaced.
    #
    # @param [BinaryTreeNode] child The child to add as the left-side
    # node.
    #
    # @return [BinaryTreeNode] The assigned child node.
    def left_child=(child)
      set_child_at child, 0
    end

    # Sets the right child of the receiver node. If a previous child existed, it
    # is replaced.
    #
    # @param [BinaryTreeNode] child The child to add as the right-side
    # node.
    #
    # @return [BinaryTreeNode] The assigned child node.
    #
    def right_child=(child)
      set_child_at child, 1
    end

    # Swaps the left and right child nodes of the receiver node with each other.
    def swap_children
      self.left_child, self.right_child = self.right_child, self.left_child
    end

  end

end
