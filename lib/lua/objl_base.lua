#!/usr/bin/env lua

--[[ ObjL-Base: Base backend for Objective-Lua
(c) 2006 John Ohno
Licensed under the GNU LGPL

Should provide basic structures for ObjL 
backend.
--]]

ObjL={}
ObjL.threads={}

function ObjL.makethread(f)
	if type(f) == "string" then
		f=loadstring(f)
	end
	if type(f) ~= "function" then
		return nil, "Argument was not a function or valid source string."
	end
	table.insert(ObjL.threads, coroutine.create(f))
	return ObjL.threads[table.getn(ObjL.threads)]
end

function ObjL.mainloop()
	local th={}
	for i=1,table.getn(ObjL.threads) do
		local c, status=coroutine.resume(ObjL.threads[i])
		if status=="dead" or not c then
			table.remove(ObjL.threads, i)
		else
			table.insert(th, ObjL.threads[i])
		end
	end
	socket.select(th)
end

function ObjL.serialize(o)
	local s=""
	if type(o) == "number" then
		return o
	elseif type(o) == "string" then
		return string.format("%q", o)
	elseif type(o) == "table" then
		s=s.."{ "
		for k, v in pairs(o) do
			s=s.." "..k.."="..serialize(v)..", "
		end
		s=s.." }"
		return s
	elseif type(o) == "function" then
		return "loadstring([[" .. string.dump(o) .. "]])"
	elseif type(o) == "lightuserdata" then
		return "nil"
	else
		return "loadstring([["..string.dump(function () return o end).."]])"
	end
end

function ObjL.unserialize(o)
	return loadstring("return "..o)
end

function ObjL.help()
	print([[
ObjL - Objective Lua
(c) 2006 John Ohno
Licensed under the GNU LGPL

ObjL.serialize(o)	return a string representation of table /o/
ObjL.unserialize(o)	return a table loaded from the string /o/
ObjL.serve(a, p, b)	create a server coroutine at port /p/ on address /a/, 
			with backlog /b/, to serve up Objective Lua functions 
			from forwarded objects
ObjL.makethread(f)	make a thread out of function f, add it to 
			ObjL.threads, and return it
ObjL.mainloop()		run all the threads in ObjL.threads, i.e. the server 
			and all other socket routines, plus whatever else 
			one has added
class(...)		return a class based upon the objects/classes passed
			and the ObjL_Object superclass
Class/object functions:
class.new(o)		return a new object of type /class/, with the optional 
			inheriting class /o/
object.recieve(msg, args)
			call the function /msg/ in the current object, with 
			the arguments /args/
object.forward(msg, func, a, p, msg2)
			forward the function /msg/ in the current object to 
			the function /func/ if /a/ and /p/ are nil, otherwise 
			forward it to the function /msg/ in the object /func/ 
			on the server at address /a/ and port /p/
object.forwardvar(msg, var, a, p, msg2)
			same as /forward/ except for variables
]])
end


