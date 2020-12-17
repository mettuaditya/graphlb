module Dot
  module AST
    class NullToken < ValueToken
      STRING_VAL = "null"

      def initialize(peg_tuple : Pegmatite::Token)
        super(peg_tuple, STRING_VAL)
      end

      def string
        STRING_VAL
      end

      def value : ValueType
        nil
      end
    end
  end
end
