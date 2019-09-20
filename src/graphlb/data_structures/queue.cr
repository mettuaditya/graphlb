module Graphlb::DataStructures

  # In crystal, elements in an array are added in dynamics fashion means
  # the size of the array is not fixed which makes them quite similar
  # to linked list.
  #
  # Here we have implemented the Queue Data Structure using an Array. A Queue follows First-in-First-out.
  class Queue(A)

    # Initializes the Queue with empty array
    def initialize
      @array = Array(A).new
    end

    # pushes the value present inside the val into the queue
    #
    # @param : val , the value we want to append into the queue
    #
    # @return : returns the array of elements in the queue
    def push(val)
      @array << val
    end

    # pops the value that is first inserted
    #
    # @return : first element inserted
    def pop
      @array.shift?
    end

    # returns the first-most element in the queue without deleting it
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
