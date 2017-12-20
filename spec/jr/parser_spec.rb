require 'spec_helper'
require "jr"

RSpec.describe Jr::Parser  do
  subject { Jr::Parser.new }

  it "parses arrays" do
    expect(subject.parse("1 23 456")).to eql [1, 23, 456]
  end

  it "parses expressions" do
    expect(subject.parse("1 + 2 3")).to eql Jr::Addition.new([1], [2,3])
  end
end
