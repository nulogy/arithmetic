class Arithmetic::Expression
  attr_reader :original_expression

  def initialize(expression)
    @original_expression = expression
    @parsed_expression = Parser.new(expression).parse
    @result = @parsed_expression.eval
  end

  def eval
    @result
  end

  def to_s
    @parsed_expression.to_s(:infix)
  end
end
