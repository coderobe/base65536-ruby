# base65536-ruby

[Base64](https://en.wikipedia.org/wiki/Base64) is used to encode arbitrary binary data as "plain" 
text using a small, extremely safe repertoire of 64 (well, 65) characters. Base64 remains highly 
suited to text systems where the range of characters available is very small -- i.e., anything 
still constrained to plain ASCII. Base64 encodes 6 bits, or 3/4 of an octet, per character.

However, now that Unicode rules the world, the range of characters which can be considered "safe" 
in this way is, in many situations, significantly wider. Base65536 applies the same basic 
principle to a carefully-chosen repertoire of 65,536 (well, 65,792) Unicode code points, encoding 
16 bits, or 2 octets, per character. This allows up to 280 octets of binary data to fit in a 
Tweet.

In theory, this project could have been a one-liner. In practice, naively taking each pair of 
bytes and smooshing them together to make a single code point is a bad way to do this because you 
end up with:

* Control characters
* Whitespace
* Unpaired surrogate pairs
* Normalization corruption
* No way to tell whether the final byte in the sequence was there in the original or not

For details of how these code points were chosen and why they are thought to be safe, 
[see the project `base65536gen`](https://github.com/ferno/base65536gen).

