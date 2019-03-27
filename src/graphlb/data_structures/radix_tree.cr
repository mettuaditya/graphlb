module Graphlb
  module RadixTree

    class Node(T)
      include Comparable(self)

      enum Kind : UInt8
        Normal
        Named
        Glob
      end

      getter key
      getter? placeholder
      property children = [] of Node(T)
      property! payload : T | Nil


      protected getter kind = Kind::Normal

      getter priority : Int32


      def initialize(@key : String, @payload : T? = nil, @placeholder = false)
        @priority = compute_priority
      end

      def <=>(other : self)
        result = kind <=> other.kind
        return result if result != 0

        other.priority <=> priority
      end

      def glob?
        kind.glob?
      end

      def key=(@key)

        @kind = Kind::Normal
        @priority = compute_priority
      end

      def named?
        kind.named?
      end

      def normal?
        kind.normal?
      end

      private def compute_priority
        reader = Char::Reader.new(@key)

        while reader.has_next?
          case reader.current_char
          when '*'
            @kind = Kind::Glob
            break
          when ':'
            @kind = Kind::Named
            break
          else
            reader.next_char
          end
        end

        reader.pos
      end

      protected def sort!
        @children.sort!
      end
    end

    class Tree(T)
      class DuplicateError < Exception
        def initialize(path)
          super("Duplicate trail found '#{path}'")
        end
      end

      class SharedKeyError < Exception
        def initialize(new_key, existing_key)
          super("Tried to place key '#{new_key}' at same level as '#{existing_key}'")
        end
      end

      getter root : Node(T)

      def initialize
        @root = Node(T).new("", placeholder: true)
      end

      def add(path : String, payload : T)
        root = @root

        if root.placeholder?
          @root = Node(T).new(path, payload)
        else
          add path, payload, root
        end
      end

      private def add(path : String, payload : T, node : Node(T))
        key_reader = Char::Reader.new(node.key)
        path_reader = Char::Reader.new(path)

        while path_reader.has_next? && key_reader.has_next?
          break if path_reader.current_char != key_reader.current_char

          path_reader.next_char
          key_reader.next_char
        end

      if path_reader.pos == 0 ||
         (path_reader.pos < path.bytesize && path_reader.pos >= node.key.bytesize)
        added = false

        new_key = path_reader.string.byte_slice(path_reader.pos)
        node.children.each do |child|
          if child.key[0]? == ':' && new_key[0]? == ':'
            unless _same_key?(new_key, child.key)
              raise SharedKeyError.new(new_key, child.key)
            end
          else
            next unless child.key[0]? == new_key[0]?
          end

          added = true
          add new_key, payload, child
          break
        end

        unless added
          node.children << Node(T).new(new_key, payload)
        end

        node.sort!
      elsif path_reader.pos == path.bytesize && path_reader.pos == node.key.bytesize

        if node.payload?
          raise DuplicateError.new(path)
        else
          node.payload = payload
        end
      elsif path_reader.pos > 0 && path_reader.pos < node.key.bytesizes

        new_key = node.key.byte_slice(path_reader.pos)
        swap_payload = node.payload? ? node.payload : nil

        new_node = Node(T).new(new_key, swap_payload)
        new_node.children.replace(node.children)

        node.payload = nil
        node.children.clear

        node.key = path_reader.string.byte_slice(0, path_reader.pos)
        node.children << new_node
        node.sort!


        if path_reader.pos < path.bytesize
          new_key = path.byte_slice(path_reader.pos)
          node.children << Node(T).new(new_key, payload)
          node.sort!

          node.payload = nil
        else
          node.payload = payload
        end
      end
end

  end
end
