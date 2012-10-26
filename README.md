arithmetic
==========

Simple arithmetic evaluator for Ruby

Based on http://rosettacode.org/wiki/Arithmetic_evaluation#Ruby but adds:

* tests
* support for nicer errors on invalid expressions
* optional spaces between operators and operands
* uses BigDecimal instead of floats

Shortcomings:

* only supports `+ - * /` operators
* no localization

Usage
=====

    expression = Arithmetic.parse("-2 * (1+3.5)")
    expression.eval # => -18
    expression.to_s # => "-2 * (1 + 3.5)"

    Arithmetic.parse("2 + wtf?") # => raises Arithmetic::InvalidExpression with the 
                                 # original expression as the message

I18N support
============

Please ensure that decimal separators are decimals ('`.`'). Use a gem like Delocalize to perform this conversion.
