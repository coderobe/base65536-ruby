#!/usr/bin/env ruby

=begin
  Base65536
  Copyright (C) 2016 Nightbug

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end

require 'json'

module Base65536
  def self.encode(buf)
    get_block_start = JSON.parse(File.read('./get-block-start.json'))
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
end
