require 'spec_helper'

describe Arithmetic do
  it "evaluates simple expressions" do
    test_eval("2").should == 2.0
  end

  it "evaluates addition" do
    test_eval("2 + 2").should == 4.0
  end

  it "evaluates subtraction" do
    test_eval("2.1 - 2").should == 0.1
  end

  it "handles negative numbers" do
    test_eval("3--2").should == 5
  end

  it "handles negative numbers with parens" do
    test_eval("-(3+2)").should == -5
  end

  it "handles leading minus signs" do
    test_eval("-3+2").should == -1
  end

  it "has unary minus take precedence over multiplication" do
    test_eval("-3 * -2").should == 6
  end

  it "evaluates division" do
    test_eval("10.5 / 5").should == 2.1
  end

  it "evaluates multiplication" do
    test_eval("2 * 3.1").should == 6.2
  end

  it "evaluates parens" do
    test_eval("2 * (2.1 + 1)").should == 6.2
  end

  it "evaluates regardless of whitespace" do
    test_eval("2*(1+\t1)").should == 4
  end

  it "evaluates order of operations" do
    expect( test_eval("2 * 2.1 + 1 / 2") ).to eq 4.7
  end

  it "evaluates multiple levels of parens" do
    test_eval("2*(1/(1+3))").should == 0.5
  end

  it "formats the expression" do
    test_to_s("   -1+\n    2*     \t3").should == '-1 + (2 * 3)'
  end

  it "formats the expression using a custom visitor" do
    test_to_s("-1 + 2 * 3", ->(n) { "x#{n}x" }).should == 'x-xx1x x+x x(xx2x x*x x3xx)x'
  end

  it "handles ridiculous precision" do
    test_eval("1.111111111111111111111111111111111111111111 + 2").should == BigDecimal.new('3.111111111111111111111111111111111111111111')
  end

  it "handles simple numbers" do
    test_eval(2).should == 2
  end

  context "invalid expressions" do
    it "handles blank expressions" do
      exp_should_error nil
      exp_should_error ""
      exp_should_error "        "
    end

    it "handles missing operand" do
      exp_should_error "1 *"
      exp_should_error "1 * + 1"
    end

    it "handles missing operator" do
      exp_should_error "1 2 * 3"
    end

    it "handles invalid characters" do
      exp_should_error "1 * hi_there!"
    end

    it "handles invalid operators" do
      exp_should_error "1 & 2"
    end

    it "handles unmatched leading paren" do
      exp_should_error "(1 + 2"
    end

    it "handles unmatched trailing paren" do
      exp_should_error "1 + 2)"
    end
  end

  describe ".is_a_number?" do
    it "returns true if argument is a number" do
      expect(Arithmetic.is_a_number?('23.5')).to eq(true)
    end

    it "returns false if argument is not a number" do
      expect(Arithmetic.is_a_number?('2aa23')).to eq(false)
    end

    it "returns false if argument is not convertible to string" do
      expect(Arithmetic.is_a_number?(Object.new)).to eq(false)
    end
  end

  def exp_should_error(exp)
    expect {test_init exp}.to raise_error Arithmetic::InvalidExpression
  end

  def test_eval(exp)
    test_init(exp).eval
  end

  def test_to_s(exp, visitor=nil)
    test_init(exp).to_s(*visitor)
  end

  def test_init(exp)
    Arithmetic::parse(exp)
  end
end
