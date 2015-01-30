class Expression

  attr_accessor :exp, :tokens, :rpn, :result

  def initialize exp

    @exp = exp
    @tokens = self.class.tokenize @exp
    @rpn = self.class.shunt @tokens
    @result = self.class.evaluate @rpn
  end

  # tokenize by regex, can NOT process negative numbers
  def self.tokenize expression
    expression.scan /\d+\.\d+|\d+\.|\.\d+|\d+|\+|-|\*|\/|\(|\)|sqrt/
  end

  # shunting-yard algorithm
  PRECEDENCE = {
    '+' => 0,
    '-' => 0,
    '*' => 1,
    '/' => 1,
  }
  OPERATORS = PRECEDENCE.keys
  FUNCTIONS = ['sqrt']

  def self.shunt tokens
    stack = []
    output = []

    while !tokens.empty?
      token = tokens.shift
      case token
      when *FUNCTIONS
        stack.push token
      when *OPERATORS
        while OPERATORS.include?(stack.last) and PRECEDENCE[token] <= PRECEDENCE[stack.last]
          output.push stack.pop
        end
        stack.push token
      when '('
        stack.push token
      when ')'
        while !stack.empty? and stack.last != '('
          output.push stack.pop
        end
        raise 'mismatched parentheses' if stack.empty?
        stack.pop
        output.push stack.pop if FUNCTIONS.include? stack.last
      else
        output.push token
      end
    end

    while !stack.empty?
      token = stack.pop
      raise 'mismatched parentheses' if ['(', ')'].include? token
      output.push token
    end

    output
  end

  # evaluate
  def self.evaluate tokens
    stack = []
    while !tokens.empty?
      token = tokens.shift
      case token
      when 'sqrt'
        stack.push Math.sqrt stack.pop
      when *OPERATORS
        b = stack.pop
        a = stack.pop
        case token
        when '+'
          c = a + b
        when '-'
          c = a - b
        when '*'
          c = a * b
        when '/'
          c = a / b
        end
        stack.push c
      else
        if token.to_i.to_s == token
          stack.push token.to_i
        else
          stack.push token.to_f
        end
      end
    end
    if stack.length == 1
      stack.last
    else
      raise
    end
  end
end
