class IntervalResponse::IOSequence
  class Interval
    getter io
    getter offset
    getter size
    getter index

    def initialize(io : IO, offset : UInt64, size : UInt64, index : Int32)
      @io = io
      @offset = offset
      @size = size
      @index = index
    end
  end

  def initialize
    @intervals = Array(Interval).new
    @size = 0_u64
  end

  def add(io : IO, size : UInt64)
    seg = Interval.new(io: io, offset: @size, size: size, index: @intervals.size)
    @size += size
    @intervals << seg
  end

  def intervals_within(offset : UInt64, length : UInt64)
    ia = idx_under(offset)
    ib = idx_under(offset + length)

    # The range starts to the right of available range
    return [] of Interval unless ia && ib

    @intervals[ia..ib]
  end

  private def idx_under(offset)
    # TODO: use bsearch
    if offset > @size
      return @intervals.last.index
    end

    intv = @intervals.find do |interval|
      interval.offset <= offset && (interval.offset + interval.size) > offset
    end

    if intv
      return intv.index
    end
  end
end
