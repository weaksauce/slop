require "test_helper"

describe Slop::Parser do
  subject { Slop::Parser.new }

  describe ".new" do
    it "yields an OptionBuilder" do
      x = nil
      Slop::Parser.new { |o| x = o }
      x.must_be_kind_of Slop::OptionBuilder
    end
  end

  describe "#parse" do
    it "returns the original item list" do
      items = %w(foo bar)
      subject.parse(items).must_equal items
    end

    it "defaults to parsing ARGV" do
      begin
        old_argv = ARGV.clone
        ARGV.replace %w(foo bar)
        subject.parse.must_equal ARGV
      ensure
        ARGV.replace old_argv
      end
    end

    describe "with valid options" do
      before do
        subject.builder.string "foo"
        subject.builder.boolean "bar"
        subject.parse %w(--foo hello --bar)
      end

      it "increments the option count" do
        subject.find_option("foo").count.must_equal 1
      end

      it "sets the options argument" do
        subject.find_option("foo").argument.must_equal "hello"
        subject.find_option("bar").argument.must_equal nil
      end
    end

    describe "option=argument" do
      before do
        subject.builder.string "foo"
        subject.parse %w(--foo=hello)
      end

      it "assigns the argument" do
        subject.find_option("foo").argument.must_equal "hello"
      end
    end

    describe "multiple options" do
      before do
        subject.builder.boolean "a"
        subject.builder.boolean "b"
        subject.builder.string "c"
        subject.parse %w(-abc foo)
      end

      it "sets the boolean options to true" do
        subject.a?.must_equal true
        subject.b?.must_equal true
        subject["c"].must_equal "foo"
      end

      it "raises for unknown options" do
        -> { subject.parse %w(-abd) }.must_raise(RuntimeError)
      end
    end
  end

  describe "#[]" do
    before do
      subject.builder.on "foo", default: "hello"
    end

    it "fetches the option and calls .value on it" do
      subject["foo"].must_equal "hello"
    end

  end

  describe "method_missing" do
    before do
      subject.builder.on "foo"
    end

    it "checks an options count" do
      subject.foo?.must_equal false
      subject.find_option("foo").count += 1
      subject.foo?.must_equal true
    end

    it "raises if not a valid option" do
      -> { subject.bar? }.must_raise(NoMethodError)
    end

  end

end
