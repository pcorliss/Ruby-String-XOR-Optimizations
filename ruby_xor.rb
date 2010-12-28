#require './example'
#e = Example::Class.new
#e.xor_multi([[4,3,2],[2,3,4]])
#e.xor_multi([5,4,3,2,1])
#e.xor_multi([['./file_random.txt',128,0],['./file_random2.txt',128,0]],"./file.out.txt",128)
#e.xor_multi([['./file_random.txt',128,0],['./file_random2.txt',128,0],['./file_zero.txt',128,0]],"./file.out.txt",128)


#require './xor'
#xor = XOR::Class.new

#begin_time = Time.now
#xor.xor_multi([
#  ['./random_100M_1.img',104857600,0],
#  ['./random_100M_2.img',104857600,0],
#  ['./random_100M_3.img',104857600,0],
#  ['./random_100M_4.img',104857600,0],
#  ['./random_100M_5.img',104857600,0]
#],
#"./file.out.txt",104857600)
#end_time = Time.now
#puts "Elapsed:#{(end_time - begin_time)} seconds"


#x = Xor2.new

#begin_time = Time.now
#x.gen_parity(['./random_5M_1.img','./random_5M_2.img','./random_5M_3.img','./random_5M_4.img','./random_5M_5.img',],"ruby_out.txt")
#x.gen_parity(['./kangaroo.txt','./lion.txt','./cow.txt'],"ruby_out.txt")
#end_time = Time.now
#puts "Elapsed:#{(end_time - begin_time)} seconds"




#x = Xor2.new

#begin_time = Time.now
#x.gen_parity(['./random_100M_1.img','./random_100M_2.img','./random_100M_3.img','./random_100M_4.img','./random_100M_5.img',],"ruby_out.txt")
#end_time = Time.now
#puts "Elapsed:#{(end_time - begin_time)} seconds"


class Array
  def ^ (second)
    s = []
    [self.size,second.size].max.times do |i|
      s.push((self[i] || 0) ^ (second[i] || 0))
    end
    return s
  end
end

class Enumerator:bytes
  def ^ (second)
    s = []
    [self.size,second.size].max.times do |i|
      s.push((self[i] || 0) ^ (second[i] || 0))
    end
    return s
  end
end


class String
  def ^ (second)
    s = ""
    s.force_encoding("ASCII-8BIT")
    [self.size,second.size].max.times do |i|
      s << ((self[i] || 0).ord ^ (second[i] || 0).ord)
    end
    return s
  end
  
  def xor(second)
    s = ""
    s.force_encoding("ASCII-8BIT")
    [self.size,second.size].max.times.zip(self.each_byte.to_a,second.each_byte.to_a) do |i,a,b|
      s << a ^ b
    end
  end
end


class Xor
  def gen_parity(files,outfile)
    bytes = ""
    files.each do |file|
      fh = File.open(file,'rb')
      bytes ^= fh.read
      fh.close
    end
    write(outfile,bytes)
  end
  
  def write(filename,bytes)
    fh = File.open(filename,'wb')
    fh.write(bytes)
    fh.close
  end

end



class Xor2
  def gen_parity(files,outfile)
    puts Time.now
    bytes = nil
    files.each do |file|
      fh = File.open(file,'rb')
      if bytes.nil?
        bytes = fh.read.bytes.to_a
      else
        bytes = fh.read.bytes.to_a.each_with_index { |byte,i| byte ^ bytes[i]}
      end
      fh.close
    end
    puts Time.now
    puts "Finished XOR."
    #File.open(outfile,'wb') { |output| bytes.each { |byte| output.print byte.chr} }
    #fh = File.open(outfile,'wb')
    #fh.write(bytes.each { |b| b.chr })
    puts Time.now
  end

end



class Xor3
  def gen_parity(files,outfile)
    puts Time.now
    bytes = []
    fhs = []
    
    files.each do |file|
      fhs.push(File.open(file,'rb'))
    end

    while !fhs.first.eof? do
      bytes.push(fhs.inject(0) { |xor,fh| xor ^ fh.read(1).bytes.first})
    end

    puts Time.now
    puts "Finished XOR."
    #File.open(outfile,'wb') { |output| bytes.each { |byte| output.print byte.chr} }
    #puts Time.now
  end

end


class XorTest
  def xor0(file_data)
    bytes = ""
    #file_data is treated as a binary string
    file_data.each do |fd|
      bytes ^= fd
    end
  end
  
  def xor1(file_data)
    bytes = nil
    #file_data is treated as Enumerable:bytes
    #Check a method using "each_byte"
    file_data.each do |fd|
      if bytes.nil?
        bytes = fd.bytes.to_a
      else
        bytes ^= fd.bytes.to_a
      end
    end
  end
  
  def xor2(file_data)
    bytes = []
    file_data.each do |fd|
      bytes ^= fd.bytes
    end
    return bytes
  end
end


