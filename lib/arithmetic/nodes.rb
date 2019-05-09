module Arithmetic 
  class OperandNode
    attr_accessor :operand
   
    def initialize(operand)
      @operand = operand
    end

    def to_s(visitor, na=nil)
      visitor.call(@operand)
    end
   
    def eval
      if has_dangling_decimal_point?
        BigDecimal.new(@operand + "0")
      else
        BigDecimal.new(@operand)
      end
    end

    private

    def has_dangling_decimal_point?
      @operand.is_a?(String) && @operand.end_with?(".")
    end
  end

  class OperatorNode
    attr_accessor :operator, :operands
   
    def initialize(operator, operands)
      @operator = operator
      @operands = operands
    end
   
    def to_s(visitor, top=true)
      strs = @operands.map {|o| o.to_s(visitor, false) }

      if @operator.arity == 1
        "#{visitor.call(@operator)}#{strs.first}"
      else
        result = [strs.first, visitor.call(@operator), *strs[1..-1]].join(" ")
        result = visitor.call("(") + result + visitor.call(")") unless top
        result
      end
    end
   
    def eval
      @operator.eval(*@operands.map(&:eval))
    end
  end
end
