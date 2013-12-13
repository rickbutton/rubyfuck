class Rubyfuck::Runtime

  attr_accessor :p
  attr_reader :options

  def initialize(options, initial_p = nil, initial_mem = nil)
    @mem = initial_mem || [0]*3000
    @p = initial_p || 0
    @options = options
  end

  def val
    @mem[@p]
  end

  def val_at(at)
    @mem[at]
  end

  def val_at_offset(offset)
    @mem[@p + offset]
  end

  def val=(value)
    @mem[@p] = value % 256
  end

  def set_val_at(at, value)
    @mem[at] = value % 256
  end

  def set_val_at_offset(offset, value)
    @mem[@p + offset] = value % 256
  end
end

