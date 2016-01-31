#!/bin/ruby

require "json"
require "pry"

def encode(buf)
  get_block_start = JSON.parse(File.read("./get-block-start.json"))
  strs = []
  i = 0
  while i < buf.length
    b1 = buf[i]
    b2 = if i + 1 < buf.length then buf[i+1] else -1 end
    codePoint = get_block_start[b2.to_s] + b1
    str = [codePoint].pack("U*")
    strs << str
    i += 2
  end
  strs.join("")
end

def decode(str)
  get_b2 = JSON.parse(File.read("./get-b2.json"))
  bufs = []
  done = false
  i = 0
  codePoints = str.each_codepoint.to_a
  while i < str.length
    codePoint = codePoints[i]
    b1 = codePoint & ((1 << 8) -1)
    b2 = get_b2[(codePoint - b1).to_s]
    raise "Not a valid Base65536 code point: #{codePoint}" if b2 == nil
    buf = if b2 == -1 then [b1].bytes else [b1, b2].bytes end
    if buf.length == 1 and done then raise "Base65536 sequence continued after final byte" end
    bufs << buf
    if codePoint >= (1 << 16) then i += 1 end
    i += 1
  end
  bufs
end

#tecstFile = File.read("./testfile")
#puts encode(testFile.bytes)

testVal = encode("nightbug is about to drop some dank shit yo".bytes)
puts testVal
puts decode testVal

