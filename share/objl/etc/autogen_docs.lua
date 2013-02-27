#!/usr/bin/env lua

--[[autogen_docs.lua -- Autogenerates skeleton documentation in text format for ObjL code.
(c) 2006 John Ohno
Licensed under the GNU LGPL
--]]

if arg[1]=="-h" or arg[1]=="-help" or arg[1]=="--help" then
	print(arg[0]..[[ -- Autogenerates documentation in text format for ObjL code.
This program reads ObjL code from stdin and outputs the documentation to stdout.]])
	os.exit()
end

local i=io.read("*all")

print("REQUIRES:")

for w in string.gfind(i, "require%(\"(.-)\"%)") do
	print("\t"..w)
end

print("FUNCTIONS:")
for w in string.gfind(i, "function (.-)\n") do
	print("\t"..w)
end


