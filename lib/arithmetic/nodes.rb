module Arithmetic 
  class OperandNode
    attr_accessor :operand
   
    def initialize(operand)
      @operand = operand
    end

    def to_s(na=nil)
      @operand
    end
   
    def eval
      BigDecimal.new(@operand)
    end
  end

  class OperatorNode
    attr_accessor :operator, :operands
   
    def initialize(operator, operands)
      @operator = operator
      @operands = operands
    end
   
    def to_s(top=true)
      strs = @operands.map {|o| o.to_s(false) }

      if @operator.arity == 1
        "#{@operator}#{strs.first}"
      else
        result = [strs.first, @operator, *strs[1..-1]].join(" ")
        result = "(" + result + ")" unless top
        result
      end
    end
   
    def eval
      @operator.eval(*@operands.map(&:eval))
    end
  end
end
