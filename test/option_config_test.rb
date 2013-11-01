require "test_helper"

describe Slop::OptionConfig do
  def v2h(*values)
    Slop::OptionConfig.build(values)
  end

  describe "::build" do
    it "adds short options" do
      v2h("f").must_equal({ short: "f" })
    end

    it "adds long options" do
      v2h("foo").must_equal({ long: "foo" })
    end

    it "adds both short and long options" do
      v2h("f", "foo").must_equal({ short: "f", long: "foo" })
    end

    it "adds short and description" do
      v2h("f", "Some description").must_equal({ short: "f",
        description: "Some description" })
    end

    it "adds long and description" do
      v2h("foo", "Some description").must_equal({ long: "foo",
        description: "Some description" })
    end

    it "adds short, long, and description" do
      v2h("f", "foo", "Some description").must_equal({ short: "f",
        long: "foo", description: "Some description" })
    end

    it "passes in custom options" do
      v2h("f", foo: "bar").must_equal({ short: "f", foo: "bar" })
    end
  end
end
