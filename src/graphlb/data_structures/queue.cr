module Graphlb::DataStructures
  # A Queue Data Structure formed using an Array
  # A Queue follows Last-in-First-out
  #
  class Queue(A)

    # Initializes the Queue with empty
    def initialize
      @array = Array(A).new
    end

    # pushes the value present inside the val into the Queue
    def push(val)
      @array << val
    end

    # pops the value that is first inserted
    def pop
      @array.shift?
    end

    # returns the first-most element in the queue
    def top
      @array.first?
    end

    # returns true if the Queue is empty
    def empty?
      @array.empty?
    end

    # returns all the values that are present in the Queue
    def values
      @array
    end
  end
end
