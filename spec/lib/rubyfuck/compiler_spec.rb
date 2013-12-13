require "spec_helper"

describe Rubyfuck::Compiler do
  describe ".compile" do
    it "returns the correct source for C" do
      test_body = "test"
      ast = double(:ast)
      ast.stub(:to_c).and_return(test_body)
      source = described_class.compile(ast, :c)
      expect(source).to eq(
        "#include <stdio.h>\nint main() {\nchar array[30000];\nchar *ptr = array;\n" +
        test_body +
        "return 0;\n}"
      )
    end
    it "raises an error when an invalid header is used" do
      expect { described_class.compile(double(:ast), :wrong) }.to raise_error
    end
  end
end
