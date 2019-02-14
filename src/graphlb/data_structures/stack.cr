module Graphlb::DataStructures

  # In crystal, elements in an array are added in dynamics fashion means
  # the size of the array is not fixed which makes them quite similar
  # to linked list.
  #
  # Here we have implemanted the stack data-structure using an array.A stack follows Last-in-First-out.
  class Stack(A)

    # Initializes the stack with empty Array
    def initialize
      @array = Array(A).new
    end

    # pushes the value present inside the val into the stack
    #
    # @param : val , the value we want to append into the stack
    #
    # @return : returns the array of elements in the stack
    def push(val)
      @array << val
    end

    # pops the value that is last inserted
    #
    # @return : last element inserted
    def pop
      @array.pop?
    end

    # returns the top-most element in the stack without deleting it.
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
