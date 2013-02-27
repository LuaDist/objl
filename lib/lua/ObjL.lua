#!/usr/bin/env lua

--[[ Objective-Lua (ObjL)
(c) 2006 John Ohno
Licensed under the GNU LGPL

A simple OO layer to Lua, based loosely on 
that of Objective C.

This system provides classes with multiple 
inheritence and forwarding (in-program, 
interprocess, and over network).
--]]

if cheia then -- if we're using LuaCheia
	cheia.load("socket")
else
	require("socket")
end

package.path=package.path..";/usr/local/ObjL/?.lua"

require("objl_base")
require("objl_obj")
require("objl_comm")

if package then
	module("ObjLua")
end

