#!/usr/bin/env ruby

File.open("float.s", "w") do |f| 
  orig = File.read("cheat.s")
  orig.gsub!(/(float_mul:.+?cfi_startproc)(.+?ret.+?)(\.cfi_endproc)/m, "\\1\n#{File.read("float_mul.s")}\n\\3")
  f.write orig
end
