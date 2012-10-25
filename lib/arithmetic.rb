require 'arithmetic/expression'
require 'bigdecimal'

module Operators
  extend self

  @op_priority = {"+" => 0, "-" => 0, "*" => 1, "/" => 1}
  @op_function = {
    "+" => lambda {|x, y| x + y},
    "-" => lambda {|x, y| x - y},
    "*" => lambda {|x, y| x * y},
    "/" => lambda {|x, y| x / y}
  }

  def get(token)
    @op_function[token]
  end

  def operator?(token)
    @op_priority.has_key?(token)
  end

  def priority(token)
    @op_priority[token]
  end
end
 
class LeafNode
  attr_accessor :info
 
  def initialize(info, exp)
    @info = info
    @expression = exp

    raise InvalidExpression.new(@expression) unless is_a_number?(@info)
  end

  def to_s(order=nil, na=nil)
    @info
  end
 
  def eval
    BigDecimal.new(@info)
  end

  private

  def is_a_number?(str)
    !!@info.match(/^[\d\.]+$/)
  end
end

class OperatorNode
  attr_accessor :info, :left, :right
 
  def initialize(info, left, right, expression)
    @info = info
    @left = left
    @right = right
    @expression = expression

    raise InvalidExpression.new(@expression) if @left == nil || @right == nil
  end
 
  def to_s(order=:infix, top=true)
    left_s, right_s = @left.to_s(order, false), @right.to_s(order, false)

    strs = case order
           when :prefix then [@info, left_s, right_s]
           when :infix then [left_s, @info, right_s]
           when :postfix then [left_s, right_s, @info]
           else []
           end
    result = strs.join(" ") 
    result = "(" + result + ")" unless top
    result
  end
 
  def eval
    Operators.get(@info).call(@left.eval, @right.eval)
  end
end
 
class Parser
  def initialize(exp)
    @expression = exp
  end

  def parse
    tokens = tokenize(@expression)
    op_stack, node_stack = [], []
   
    tokens.each do |token|
      if Operators.operator?(token)
        # clear stack of higher priority operators
        until (op_stack.empty? or
               op_stack.last == "(" or
               Operators.priority(op_stack.last) < Operators.priority(token))
          push_operator(op_stack.pop, node_stack)
        end
   
        op_stack.push(token)
      elsif token == "("
        op_stack.push(token)
      elsif token == ")"
        while op_stack.last != "("
          push_operator(op_stack.pop, node_stack)
        end
   
        # throw away the '('
        op_stack.pop
      else
        node_stack.push(LeafNode.new(token, @expression))
      end
    end
   
    until op_stack.empty?
      push_operator(op_stack.pop, node_stack)
    end
   
    parsed_expression = node_stack.pop
    raise InvalidExpression.new(@expression) unless node_stack.empty?
    parsed_expression
  end

  def push_operator(operator, node_stack)
    right = node_stack.pop
    left = node_stack.pop
    node_stack.push(OperatorNode.new(operator, left, right, @expression))
  end
 
  def tokenize(exp)
    exp
      .gsub('*', ' * ')
      .gsub('/', ' / ')
      .gsub('+', ' + ')
      .gsub('-', ' - ')
      .gsub('(', ' ( ')
      .gsub(')', ' ) ')
      .split(' ')
  end
end

class InvalidExpression < Exception
end
