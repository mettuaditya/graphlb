module Graphlb::DataStructures
  # A stack Data Structure formed using an Array
  # A stack follows Last-in-First-out
  class Stack(A)

    # Initializes the stack with empty
    def initialize
      @array = Array(A).new
    end

    # pushes the value present inside the val into the stack
    def push(val)
      @array << val
    end

    # pops the value that is last inserted
    def pop
      @array.pop?
    end

    # returns the top-most element in the stack
    def top
      @array.last?
    end

    # returns true if the stack is empty
    def empty?
      @array.empty?
    end

    # returns all the values that are present in the stack
    def values
      @array
    end
  end
end
