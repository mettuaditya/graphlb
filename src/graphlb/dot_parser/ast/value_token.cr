
module Dot
  module AST
    abstract class ValueToken < Token
      abstract def value : ValueType
    end
  end
end
