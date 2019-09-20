module Dot
  module AST
    alias ValueType =
      Nil |
      Bool |
      String |
      NumberToken::Value |
      IdentifierToken::Value
  end
end
