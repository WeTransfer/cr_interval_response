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
    first_touched = interval_under(offset)

    # The range starts to the right of available range
    return [] of Interval unless first_touched

    last_touched = interval_under(offset + length) || @intervals.last
    @intervals[first_touched.index..last_touched.index]
  end

  private def interval_under(offset) : Interval?
    @intervals.bsearch { |interval| interval.offset >= offset }
  end
end
