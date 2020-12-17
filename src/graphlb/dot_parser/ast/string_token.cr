module Dot
  module AST
    class StringToken < ValueToken
      def value : ValueType
        string
      end
    end
  end
end
