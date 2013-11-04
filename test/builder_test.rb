require "test_helper"

describe Slop::Builder do
  let(:parser) { Slop::Parser.new }
  subject      { Slop::Builder.new(parser) }

  describe "#on" do
    it "returns a Slop::Option" do
      subject.on("foo").must_be_kind_of Slop::Option
    end

    it "appends a new option to options attribute" do
      subject.options.options.must_equal []
      option = subject.on("foo")
      subject.options.options.must_equal [option]
    end

    it "defaults type attribute to :string" do
      subject.on("foo").attributes[:type].must_equal :string
    end
  end

  describe "method_missing" do
    it "sets the Type config attribute" do
      option = subject.string("foo")
      option.attributes[:type].must_equal :string
      option.type.must_be_kind_of Slop::Types::StringType
      option.attributes.must_equal({ expects_argument: true,
        type: :string, long: "foo" })
    end
  end
end
