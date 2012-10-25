module Arithmetic
  class Parser
    def initialize(exp)
      @expression = exp
      @node_stack = []
    end

    def parse
      tokens = tokenize(@expression)
      op_stack = []
     
      tokens.each do |token|
        if token.is_a? Operator
          # clear stack of higher priority operators
          while (!op_stack.empty? &&
                 op_stack.last != "(" &&
                 op_stack.last.priority >= token.priority)
            push_operator(op_stack.pop)
          end
     
          op_stack.push(token)
        elsif token == "("
          op_stack.push(token)
        elsif token == ")"
          while op_stack.last != "("
            push_operator(op_stack.pop)
          end
     
          # throw away the '('
          op_stack.pop
        else
          push_operand(token)
        end
      end
     
      until op_stack.empty?
        push_operator(op_stack.pop)
      end
     
      parsed_expression = @node_stack.pop
      raise InvalidExpression.new(@expression) unless @node_stack.empty?
      parsed_expression
    end

    private

    def push_operand(operand)
      raise InvalidExpression.new(@expression) unless is_a_number?(operand)
      @node_stack.push(LeafNode.new(operand))
    end

    def push_operator(operator)
      right = @node_stack.pop
      left = @node_stack.pop
      raise InvalidExpression.new(@expression) if left == nil || right == nil

      @node_stack.push(OperatorNode.new(operator, left, right))
    end
   
    def tokenize(exp)
      tokens = exp
        .gsub('*', ' * ')
        .gsub('/', ' / ')
        .gsub('+', ' + ')
        .gsub('-', ' - ')
        .gsub('(', ' ( ')
        .gsub(')', ' ) ')
        .split(' ')
      tokens.map do |token|
        Operators.get(token) || token
      end
    end

    def is_a_number?(str)
      !!str.match(/^[\d\.]+$/)
    end
  end

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
  end

  module Operators
    extend self

    @operators = {
      "+" => Operator.new("+", 0, lambda {|x, y| x + y}),
      "-" => Operator.new("-", 0, lambda {|x, y| x - y}),
      "*" => Operator.new("*", 1, lambda {|x, y| x * y}),
      "/" => Operator.new("/", 1, lambda {|x, y| x / y})
    }

    def get(token)
      @operators[token]
    end

    def priority(token)
      @operators[token].priority
    end
  end
   
  class LeafNode
    attr_accessor :operand
   
    def initialize(operand)
      @operand = operand
    end

    def to_s(order=nil, na=nil)
      @operand
    end
   
    def eval
      BigDecimal.new(@operand)
    end
  end

  class OperatorNode
    attr_accessor :operator, :left, :right
   
    def initialize(operator, left, right)
      @operator = operator
      @left = left
      @right = right
    end
   
    def to_s(order=:infix, top=true)
      left_s, right_s = @left.to_s(order, false), @right.to_s(order, false)

      strs = case order
             when :prefix then [@operator, left_s, right_s]
             when :infix then [left_s, @operator, right_s]
             when :postfix then [left_s, right_s, @operator]
             else []
             end
      result = strs.join(" ") 
      result = "(" + result + ")" unless top
      result
    end
   
    def eval
      @operator.eval(@left.eval, @right.eval)
    end
  end

  class InvalidExpression < Exception
  end
end
