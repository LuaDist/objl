#!/usr/bin/env lua

--[[ ObjL-Object: The Objective-Lua object model
(c) 2006 John Ohno
Licensed under the GNU LGPL

Should represent the base superclass table for an 
ObjL object
--]]

if ObjL_Object == nil then ObjL_Object = {forwards={}} end

--require("comm.lua")

function ObjL_Object:serialize()
	return ObjL.serialize(self)
end

function class(...)
	local c={}
	local arg=arg or {}
	c.forwards=ObjL_Object.forwards
	table.insert(arg, 1, ObjL_Object)
	setmetatable(c, {
	__call=function(t, k, v)
		v=v or nil
		if type(k) == "table" then
			local res={}
			for i=k[1],k[2] do
				res[(i-k[1])+1]=t[i]
			end
			return res
		end
		return rawget(t, k)(unpack(v))
	end,
	__index=function(t, k)
		if type(k) == "table" then
			local res={}
			for i=k[1],k[2] do
				res[(i-k[1])+1]=t[i]
			end
			return res
		end
		for i=1,table.getn(arg) do
			if type(arg[i])=="table" and arg[i][k] then return arg[i][k] end
		end
		if t.forwards[k] then return t.forwards[k]() end
	end,
	__add=function(a, b)
		res={}
		a=a or {}
		b=b or {}
		for k, i in pairs(a) do res[k]=i end
		for k, i in pairs(b) do res[k]=i end
		return res
	end,
	__newindex=function(t, k, v)
		if type(k) == "table" then
			for i=k[1]+1,k[2] do
				table.remove(t, i)
			end
			k=k[1]
		end
		if t.forwards[k] then t.forwards[k](v) end
		if type(v) == "function" then
			rawset(t,"___"..tostring(k),string.dump(v))
		else
			rawset(t,"___"..tostring(k),nil)
		end
		rawset(t, k, v)
	end,
	__sub=function(a, b)
		res={}
		for k, i in pairs(a) do if not b[k] then res[k]=i end end
		for k, i in pairs(b) do if not a[k] then res[k]=i end end
		return res
	end,
	__mul=function(a, b)
		res={}
		for i=1,b do
			table.insert(res, a)
		end
		return res
	end,
	__concat=__add,
	__unm=function(a)
		res={}
		for i=table.getn(a),1 do
			table.insert(res, a[i])
		end
		return res
	end,
	__tostring=function(o)
		return ObjL.serialize(o)
	end
	})
	c.__index = c
	function c:new(o)
		o=o or {}
		o.super=c
		setmetatable(o, c)
		return o
	end
	return c
end


