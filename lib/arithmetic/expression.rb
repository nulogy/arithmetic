module Arithmetic
  class Expression
    def initialize(expression)
      @parsed_expression = expression
    end

    def eval
      @result ||= @parsed_expression.eval
    end

    def to_s(visitor=identity_function)
      @string ||= @parsed_expression.to_s(visitor)
    end

    private

    def identity_function
      ->(node) { node }
    end
  end
end
