require 'bigdecimal'
require 'arithmetic/expression'
require 'arithmetic/parser'
require 'arithmetic/nodes'
require 'arithmetic/operators'

module Arithmetic
  # make lazy?
  def self.parse(expression)
    Expression.new(Parser.new(expression).parse)
  end

  def self.is_operand?(token)
    !token.is_a?(Arithmetic::Operator) && token != "(" && token != ")"
  end
end
