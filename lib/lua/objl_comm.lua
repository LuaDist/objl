#!/usr/bin/env lua

--[[ ObjL-Comm: ObjectiveLua inter-object communication
(c) 2006 John Ohno
Licensed under the GNU LGPL

This file should provide a simple model for communication 
of messages between objects. May call via sockets.

--]]
--[[
if cheia!=nil then
	cheia.load("socket")
else
	require("luasocket")
end
--]]
function ObjL_Object:receive(msg, args)
	args=args or nil
	if type(self[msg]) == "function" then
		return self[msg](args)
	elseif type(self.forwards[msg])=="function" then
		return self.forwards[msg](args)
	else
		if args then
			self[msg]=args
		end
		return self[msg]
	end
end

function ObjL_Object:forward(msg, func, address, port, msg2)
	msg2=msg2 or msg
	address=address or nil
	port = port or nil
	if address then
		if port then
			if type(func) ~= "string" then
				return nil, "Argument 'func' was not a string and type was socket. For non-socket, do not specify address and port."
			end
			func2= function (args) 
				local c, err=socket.connect(address, port)
				if c==nil then
					return nil, err
				end
				c:send("OBJL FWD:\nOBJ:"..func.."\nMSG:"..msg2.."\nARGS:".. ObjL.serialize(args).."\nOBJL EOF\n\n")
				ObjL.makethread(function () local s="" status="" while status~="closed" do status, res= c:receive(2^16) if status=="timeout" then coroutine.yield(c) else s=s..res end end return s end)
			end
			self.forwards[msg]=func2
--			return true
			self[msg]=func2
		end
	end
	if type(func) ~= "function" then return nil, "Argument 'func' was not a function, and type was not socket (make sure both address and port are not nil for a socket type)." end
	self[msg]=function (args) return func(args) end
	return true
end

function ObjL_Object:forwardvar(msg, var, address, port, msg2)
	msg2=msg2 or msg
	address=address or nil
	port=port or nil
	if address and port then
		self.forwards[msg]=function(args)
			local c, err=socket.connect(address, port)
			if c==nil then
				return nill, err
			end
			c:send("OBJL FWD\nOBJ:"..var.."\nMSG:"..msg2.."\nARGS:"..ObjL.serialize(args).."\nOBJL EOF\n\n")
			ObjL.makethread(function () local s="" status="" while status~="closed" do status,res=c:recieve(2^16) if status=="timeout" then coroutine.yield(c) else s=s..res end end return s end)
		end
	end
	self.forwards[msg]=function(args)
		args=args or nil 
		if args then
			var=args
		end
		return var
	end
end

function ObjL.serve(address, port, backlog)
	local co=coroutine.create(function ()
		local tcp=socket.tcp()
		tcp:bind(address, port)
		tcp:listen(backlog)
		tcp:settimeout(0)
		while true do
			local x, status=tcp.accept()
			if status=="timeout" then
				coroutine.yield(tcp)
			else
				table.insert(ObjL.threads, coroutine.create(
					function ()
						x:settimeout(0)
						local s=""
						while status~="closed"
						do
							local s2=""
							local status=""
							while s2 and status~="closed" do
								s2, status=x.receive()
								if status=="timeout" then
									coroutine.yield(x)
								end
								s=s..s2
							end
							local _, _, func, msg, args=string.find(s, "OBJL FWD:\nOBJ:(.+)\nMSG:(.+)\nARGS:(.+)\nOBJL EOF\n\n")
							x:send(_G[func].receive(msg, ObjL.unserialize(args)))
						end
					end))
				end
			end
		end)
		table.insert(ObjL.threads, co)
end


