require "spec_helper"

describe Rubyfuck::Runtime do
  describe "#val" do
    it "returns the value in the current cell" do
      r = described_class.new(nil, 1, [1,2,3])  
      expect(r.val).to eq(2)
    end
  end 
  describe "#val_at" do
    it "returns the value at the index" do
      r = described_class.new(nil, nil, [1,2,3])
      expect(r.val_at(2)).to eq(3)
    end
  end
  describe "#val_at_offset" do
    it "returns the value at the offset from the current cell" do
      r = described_class.new(nil, 1, [1,2,3])
      expect(r.val_at_offset(1)).to eq(3)
    end
  end
  describe "#val=" do
    it "sets the value in the current cell" do
      mem = [1,2,3]
      r = described_class.new(nil, 1, mem)
      r.val = 89
      expect(mem[1]).to eq(89)
    end
    it "bounds values to < 256" do
      mem = [1,2,3]
      r = described_class.new(nil, 1, mem)
      r.val = 257
      expect(mem[1]).to eq(1)
    end
  end

  describe "#set_val_at" do
    it "sets the value at the index" do
      mem = [1,2,3]
      r = described_class.new(nil, 1, mem)
      r.set_val_at(2, 89)
      expect(mem[2]).to eq(89)
    end
    it "bounds values to < 256" do
      mem = [1,2,3]
      r = described_class.new(nil, 1, mem)
      r.set_val_at(2, 257)
      expect(mem[2]).to eq(1)
    end
  end

  describe "#set_val_at_offset" do
    it "sets the value at the offset from the current cell" do
      mem = [1,2,3]
      r = described_class.new(nil, 1, mem)
      r.set_val_at_offset(1, 89)
      expect(mem[2]).to eq(89)
    end
    it "bounds values to < 256" do
      mem = [1,2,3]
      r = described_class.new(nil, 1, mem)
      r.set_val_at_offset(1, 257)
      expect(mem[2]).to eq(1)
    end
  end
end
