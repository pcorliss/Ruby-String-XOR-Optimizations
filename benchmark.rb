require 'digest/md5'
require 'benchmark'
require 'xor'

require './xor/xor'
require './ruby_xor'

data = load_files(["./rand_files/rand1_5M.img","./rand_files/rand2_5M.img"]); nil
e = XOR::Class.new

puts "Ensuring parity calculation is correct."
puts "xor1:"+Digest::MD5.hexdigest(data[0].xor1(data[1]))
puts "xor2:"+Digest::MD5.hexdigest(data[0].xor2(data[1]))
puts "xor3:"+Digest::MD5.hexdigest(data[0].xor3(data[1]))
puts "xor4:"+Digest::MD5.hexdigest(data[0].xor4(data[1]))
puts "xor5:"+Digest::MD5.hexdigest(data[0].xor5(data[1]))
puts "xor6:"+Digest::MD5.hexdigest(data[0].xor6(data[1]))
puts "xorc:"+Digest::MD5.hexdigest(e.xor_multi(data,data.first.size))
temp = data[0].clone
puts "xor!:"+Digest::MD5.hexdigest(temp.xor!(data[1]))

puts "Performing Benchmarks"

Benchmark.bm do |x|
  x.report('xor1 10 times:') do 10.times { data[0].xor1(data[1]) } end
  x.report('xor2 10 times:') do 10.times { data[0].xor2(data[1]) } end
  x.report('xor3 10 times:') do 10.times { data[0].xor3(data[1]) } end
  x.report('xor4 10 times:') do 10.times { data[0].xor4(data[1]) } end
  x.report('xor5 10 times:') do 10.times { data[0].xor5(data[1]) } end
  x.report('xor6 10 times:') do 10.times { data[0].xor6(data[1]) } end
  x.report('xorc 10 times:') do 10.times { e.xor_multi(data,data.first.size) } end
  x.report('xor! 10 times:') do 10.times { data[0].xor!(data[1]) } end
  x.report('xorc 1000 times:') do 1000.times { e.xor_multi(data,data.first.size) } end
  x.report('xor! 1000 times:') do 1000.times { data[0].xor!(data[1]) } end
end
