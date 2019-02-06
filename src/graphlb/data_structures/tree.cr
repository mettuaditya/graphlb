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
      @children = [] of TreeNode

      self.set_as_root!

    end

    def set_as_root!
      self.parent = nil
    end

    def parent=(parent)
      @parent = parent
      # @node_depth = nil

    end

    def <<(child)
      add(child)
    end

    def add(child, at_index = -1)
      raise "child #{child.name} already added!" if @children_hash.include?(child.name)

      if insertion_range.include?(at_index)
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

    def remove!(child)
      return nil unless child
      @children_hash.delete(child.name)
      @children.delete(child)
      child.set_as_root!
      child
    end

    def remove_all!
      @children.each{|child| child.set_as_root!}

      @children_hash.clear
      @children.clear
      self
    end

    def has_children?
      if @children.nil?
        return false
      else
        @children.size != 0
      end
    end

    def is_leaf?
      !has_children?
    end

    def has_content?
      @content != nil
    end

    def is_root?
      @parent.nil?
    end

    def first_child
      @children.first
    end

    def last_child
      @children.last
    end
  end

end
