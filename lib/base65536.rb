#!/usr/bin/env ruby
# base65536.rb -- Ruby implementation of base65536
# Copyright (c) 2016 Nightbug
# Licensed under the terms of the MIT license.  See the LICENSE file in the
# root directory of this gem for more information.

require 'json'

module Base65536
  def self.encode(buf)
    get_block_start = JSON.parse(File.read(File.expand_path '../get-block-start.json', __FILE__))
    strs = []
    i = 0
    while i < buf.length
      b1 = buf[i]
      b2 = i + 1 < buf.length ? buf[i + 1] : -1
      codepoint = get_block_start[b2.to_s] + b1
      str = [codepoint].pack('U*')
      strs << str
      i += 2
    end
    strs.join('')
  end

  def self.decode(str)
    get_b2 = JSON.parse(File.read(File.expand_path '../get-b2.json', __FILE__))
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
end

