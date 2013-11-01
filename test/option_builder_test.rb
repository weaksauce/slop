require "test_helper"

describe Slop::OptionBuilder do
  let(:parser) { Slop::Parser.new }
  subject      { Slop::OptionBuilder.new(parser) }

  describe "#on" do
    it "returns a Slop::Option" do
      subject.on("foo").must_be_kind_of Slop::Option
    end

    it "appends a new option to options attribute" do
      subject.options.options.must_equal []
      option = subject.on("foo")
      subject.options.options.must_equal [option]
    end
  end

  describe "method_missing" do
    it "sets the value config attribute" do
      option = subject.string("foo")
      option.attributes[:value].must_equal :string
      option.value_processor.must_be_kind_of Slop::Values::StringValue
      option.attributes.must_equal({ expects_argument: true,
        value: :string, long: "foo" })
    end
  end
end
