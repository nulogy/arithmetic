module Arithmetic
  class Expression
    attr_reader :original_expression

    def initialize(expression)
      @original_expression = expression
      @parsed_expression = Parser.new(expression).parse
    end

    def eval
      @result ||= @parsed_expression.eval
    end

    def to_s
      @parsed_expression.to_s(:infix)
    end
  end
end
