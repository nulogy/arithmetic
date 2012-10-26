require 'bigdecimal'
require 'arithmetic/expression'
require 'arithmetic/parser'

module Arithmetic
  def self.parse(expression)
    Expression.new(Parser.new(expression).parse)
  end
end
