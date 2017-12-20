require 'spec_helper'
require "jr"

RSpec.describe Jr::Parser  do
  subject { Jr::Parser.new }

  it "parses arrays" do
    expect(subject.parse("1 23 456")).to eql Jr::Vector[1, 23, 456]
  end

  it "parses expressions" do
    expect(subject.parse("1 2 + 3 4")).to eql Jr::Addition.new([1, 2], [3, 4])
  end

  it "is right recursive" do
    expect(subject.parse("1 + 2 + 3 4")).to eql Jr::Addition.new([1], Jr::Addition.new([2], [3, 4]))
  end
end
