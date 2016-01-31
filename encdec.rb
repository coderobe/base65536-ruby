#!/usr/bin/env ruby

require 'json'

def encode(buf)
  get_block_start = JSON.parse(File.read('./get-block-start.json'))
  strs = []
  i = 0
  while i < buf.length
    b1 = buf[i]
    b2 = if i + 1 < buf.length then buf[i+1] else -1 end
    codepoint = get_block_start[b2.to_s] + b1
    str = [codepoint].pack('U*')
    strs << str
    i += 2
  end
  strs.join('')
end

def decode(str)
  get_b2 = JSON.parse(File.read('./get-b2.json'))
  bufs = []
  done = false
  i = 0
  codepoints = str.codepoints
  while i < str.length
    codepoint = codepoints[i]
    b1 = codepoint & ((1 << 8) - 1)
    b2 = get_b2[(codepoint - b1).to_s]
    fail "Not a valid Base65536 code point: #{codepoint}" if b2 == nil
    buf = b2 == -1 ? [b1].pack('U*') : [b1, b2].pack('U*')
    if buf.length == 1
      done and fail 'Base65536 sequence continued after final byte'
      done = true
    end
    bufs << buf
    i += 1
  end
  bufs.join ''
end

#tecstFile = File.read('./testfile')
#puts encode(testFile.bytes)

testVal = encode('nightbug is about to drop some dank shit yo MEMEN'.bytes)
puts testVal
puts decode testVal

