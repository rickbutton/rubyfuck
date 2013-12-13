require "rubyfuck"

describe Rubyfuck::Interpreter do
  describe "#run" do
    it "runs the tree with a runtime" do
      tree = double(:tree)
      runtime = double(:runtiem)
      Rubyfuck::Runtime.stub(:new).and_return(runtime)
      expect(tree).to receive(:run).with(runtime)
      described_class.new(double(:options)).run(tree)
    end
  end
end
