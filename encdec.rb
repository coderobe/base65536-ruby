#!/bin/ruby

require "json"
require "pry"

def encode(buf)
  strs = []
  i = 0
  while i < buf.length
    get_block_start = JSON.parse(File.read("./get-block-start.json"))
    get_b2 = JSON.parse(File.read("./get-b2.json"))
    b1 = buf[i]
    b2 = if i + 1 < buf.length then buf[i+1] else -1 end
    codePoint = get_block_start[b2.to_s] + b1
    str = [codePoint].pack("U*")
    strs << str
    i += 2
  end
  strs.join("")
end

#def decode(buf)
  #asd
#end

testFile = File.read("./testfile")
#puts encode(testFile.bytes)

puts encode("nightbug is about to drop some dank shit yo".bytes)


