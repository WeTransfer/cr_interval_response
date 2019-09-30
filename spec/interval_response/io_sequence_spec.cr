require "../spec_helper"

describe IntervalResponse::IOSequence do
  it "combines a number of memory IOs into one" do
    a = IO::Memory.new("Hello")
    b = IO::Memory.new(" the amazing world!")
    c = IO::Memory.new(" Missed you much.")

    seq = IntervalResponse::IOSequence.new
    seq.add(a, size: a.size.to_u64)
    seq.add(b, size: b.size.to_u64)
    seq.add(c, size: c.size.to_u64)

    all_intervals = seq.intervals_within(0, 58789)
    all_intervals.size.should eq(3)

    only_a_and_b = seq.intervals_within(0, 6)
    only_a_and_b.size.should eq(2)

    only_a = seq.intervals_within(0, 2)
    only_a.size.should eq(1)
  end
end
