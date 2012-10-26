module Arithmetic
  class Operator
    attr_reader :string, :priority

    def initialize(string, priority, function)
      @string = string
      @priority = priority
      @function = function
    end

    def eval(*args)
      @function.call(*args)
    end

    def to_s
      @string
    end

    def arity
      @function.arity
    end
  end

  module Operators
    extend self

    UNARY_MINUS = Operator.new("-", 2, lambda {|x| -x})
    MINUS = Operator.new("-", 0, lambda {|x, y| x - y})

    @operators = {
      "+" => Operator.new("+", 0, lambda {|x, y| x + y}),
      "-" => MINUS,
      "*" => Operator.new("*", 1, lambda {|x, y| x * y}),
      "/" => Operator.new("/", 1, lambda {|x, y| x / y})
    }

    def get(token)
      @operators[token]
    end
  end
end
