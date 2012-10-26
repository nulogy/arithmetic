require 'bigdecimal'
require 'arithmetic/expression'
require 'arithmetic/parser'
require 'arithmetic/nodes'

module Arithmetic
  # make lazy?
  def self.parse(expression)
    Expression.new(Parser.new(expression).parse)
  end
end
