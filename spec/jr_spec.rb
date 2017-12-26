require 'spec_helper'
require "jr"

RSpec.describe Jr do
  it "has a version number" do
    expect(Jr::VERSION).not_to be nil
  end
end

module Jr
  RSpec.describe Runtime do
    subject { Runtime.new }

    describe "addition" do
      it "adds two numbers" do
        expect(subject.evaluate('1 + 2')).to eql Vector[[3]]
      end

      it "adds two arrays" do
        expect(subject.evaluate('1 2 + 4 5')).to eql Vector[[5, 7]]
      end

      it "adds an array to a number" do
        expect(subject.evaluate('1 2 4 + 8')).to eql Vector[[9, 10, 12]]
      end

      it "adds a number to an array" do
        expect(subject.evaluate('10 + 1 2 3')).to eql Vector[[11, 12, 13]]
      end

      it "evalutes a nested expression" do
        expect(subject.evaluate('1 2 + 4 + 8')).to eql Vector[[13, 14]]
      end
    end

    describe "subtraction" do
      it "works" do
        expect(subject.evaluate('10 - 1 2 3')).to eql Vector[[9, 8, 7]]
      end
    end

    describe "multiplication" do
      it "works" do
        expect(subject.evaluate('1 2 3 * 4 5 6')).to eql Vector[[4, 10, 18]]
      end
    end

    describe "division" do
      it "works" do
        expect(subject.evaluate('10 20 30 % 5')).to eql Vector[[2, 4, 6]]
      end
    end

    describe "infix expressions" do
      it "are always parsed from right to left" do
        expect(subject.evaluate('1 2 3 * 2 + 8')).to eql Vector[[10, 20, 30]]
      end

      it "parses arrays inside parens" do
        expect(subject.evaluate('(1 2 3)')).to eql Vector[[1, 2, 3]]
      end

      it "parses expressions inside parens" do
        expect(subject.evaluate('(1 + 3)')).to eql Vector[[4]]
      end

      it "parses parens as right side of infix expressions" do
        expect(subject.evaluate('10 - (2 + 3)')).to eql Vector[[5]]
      end

      it "parses parens as left side of infix expressions" do
        expect(subject.evaluate('(5 + 7) % 2')).to eql Vector[[6]]
      end

      it "parses parens inside nested infix expressions" do
        expect(subject.evaluate('3 * 4 + 8 % 2')).to eql Vector[[24]]    # (3 * (4 + (8 / 2)))
        expect(subject.evaluate('3 * (4 + 8) % 2')).to eql Vector[[18]]  # (3 * ((4 + 8) / 2))
      end

      it "parses nested parens" do
        expect(subject.evaluate('(((3)))')).to eql Vector[[3]]
      end
    end

    describe "prefix plus" do
      it "just returns its arguments" do
        expect(subject.evaluate('+ 1 2 3')).to eql Vector[[1, 2, 3]]
      end
    end

    describe "prefix minus" do
      it "negates its arguments" do
        expect(subject.evaluate('- 1 2 3')).to eql Vector[[-1, -2, -3]]
      end

      it "double negates its arguments" do
        expect(subject.evaluate('--1 2 3')).to eql Vector[[1, 2, 3]]
      end
    end

    describe "mixed expressions" do
      it "handles prefix on infix " do
        expect(subject.evaluate('+ 1 2 3 + 4')).to eql Vector[[5, 6, 7]]
      end

      it "handles infix with prefix" do
        expect(subject.evaluate('1 2 3 + - 4')).to eql Vector[[-3, -2, -1]]
      end
    end

  end
end
