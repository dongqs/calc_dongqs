require 'spec_helper'

describe CalcDongqs do

  it "final tests" do
    [
      '2 + ( ( 4 + 6 ) * (9 - 2) - 5 - 1) + 1',
      '2 + ( ( 4 + 6 ) * sqrt(5) + 3) / 2  + 1',
      '1 + ( 2 - sqrt( 3 ) ) * 5',
      '1 + ( 2 * 5 - sqrt( 3 ) ) * 5',
      '1 + ( 2 * ( 5 - sqrt( 3 ) ) ) * 5',
      '1 + ( 2 * ( 5 - sqrt( 3 + 2) ) ) * 5',
      '1 + ( 2 * ( 5 - sqrt( 3 + sqrt(5) ) ) ) * 5',
      '1 + ( 2 * ( 5 - sqrt( 3 + sqrt(5) ) ) / 10 ) * 5',
      '1 + ( 2 * ( 5 - sqrt( 3 + sqrt(5) ) * 3 ) / 10 ) * 5',
      '1 + ( 2 * ( 5 - sqrt( 3 + sqrt(5) ) * 3 ) / ( 10 * 5 ) ) * 5',
      '1 + ( 2 * ( 5 - sqrt( 3 + sqrt(5 / 2) ) * 3 ) / ( 10 * 5 ) ) * 5',
    ].each do |exp|
      expect(Expression.new(exp).result).to eq eval(exp.gsub('sqrt', 'Math.sqrt'))
    end
  end

  describe ".tokenize" do

    it "tokenize" do
      expect(Expression.tokenize('1 + 2')).to eq %w[ 1 + 2 ]
      expect(Expression.tokenize('1.2 + 2')).to eq %w[ 1.2 + 2 ]
      expect(Expression.tokenize('.2 + 2')).to eq %w[ .2 + 2 ]
      expect(Expression.tokenize('1. + 2')).to eq %w[ 1. + 2 ]
    end

    it "without spaces" do
      expect(Expression.tokenize('1+2-3*4/5')).to eq %w[ 1 + 2 - 3 * 4 / 5 ]
    end

    it "with parentheses" do
      expect(Expression.tokenize('1 + ( 2 - 3 )')).to eq %w[ 1 + ( 2 - 3 ) ]
    end

    it "with functions" do
      expect(Expression.tokenize('( 4 + 6 ) * sqrt(5) + 3 ')).to eq %w[ ( 4 + 6 ) * sqrt ( 5 ) + 3 ]
    end

    it "with unbalanced parentheses" do
      expect {
        Expression.tokenize('1 + ( 2 - 3').to eq %w[ 1 + ( 2 - 3 ]
      }.to raise_error
    end
  end

  describe ".shunt" do

    it "basic" do
      expect(Expression.shunt(%w[ 1 ])).to eq %w[ 1 ]
      expect(Expression.shunt(%w[ 1 + 2 ])).to eq %w[ 1 2 + ]
      expect(Expression.shunt(%w[ 1 + 2 - 3 ])).to eq %w[ 1 2 + 3 - ]
    end

    it "precedence" do
      expect(Expression.shunt(%w[ 1 + 2 * 3 ])).to eq %w[ 1 2 3 * + ]
      expect(Expression.shunt(%w[ 1 * 2 + 3 ])).to eq %w[ 1 2 * 3 + ]
    end

    it "with parentheses" do
      expect(Expression.shunt(%w[ ( 1 + 2 ) * 3 ])).to eq %w[ 1 2 + 3 * ]
      expect(Expression.shunt(%w[ 1 + ( ( 2 + 3 ) * 4 ) ])).to eq %w[ 1 2 3 + 4 * + ]
    end

    it "with mismatched parentheses" do
      expect { Expression.shunt(%w[ ( 1 + 2 * 3 ]) }.to raise_error
      expect { Expression.shunt(%w[ 1 + 2 ) * 3 ]) }.to raise_error
    end

    it "function" do
      expect(Expression.shunt(%w[ 1 + sqrt ( 2 ) ])).to eq %w[ 1 2 sqrt + ]
      expect(Expression.shunt(%w[ 1 + sqrt ( 2 + 3 ) ])).to eq %w[ 1 2 3 + sqrt + ]
      expect(Expression.shunt(%w[ sqrt ( 5 ) + 3 ])).to eq %w[ 5 sqrt 3 + ]
      expect(Expression.shunt(%w[ ( 4 + 6 ) * sqrt ( 5 ) + 3 ])).to eq %w[ 4 6 + 5 sqrt * 3 + ]
    end

    it "function with mismatched parentheses" do
      expect { Expression.shunt(%w[ 1 + sqrt 2 ) ]) }.to raise_error
      expect { Expression.shunt(%w[ 1 + sqrt ( 2 + 3 ]) }.to raise_error
    end
  end

  describe ".evaluate" do

    it "operators" do
      expect(Expression.evaluate(%w[ 1 ])).to eq 1
      expect(Expression.evaluate(%w[ 1 2 + ])).to eq 3
      expect(Expression.evaluate(%w[ 1 2 + 3 - ])).to eq 0
    end

    it "functions" do
      expect(Expression.evaluate(%w[ 1 2 sqrt + ])).to eq (1 + Math.sqrt(2))
    end
  end
end
