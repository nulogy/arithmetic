module Arithmetic
  class Expression
    def initialize(expression)
      @parsed_expression = expression
    end

    def eval
      @result ||= @parsed_expression.eval
    end

    def to_s
      @string ||= @parsed_expression.to_s
    end
  end
end
