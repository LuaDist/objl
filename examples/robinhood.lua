#!/usr/bin/env ObjL

--[[ Simulates the classic RobinHood/FriarTuck hack
(c) 2006 John Ohno
Licensed under the GNU LGPL
--]]

character={}
character.message="Hello, world!"
function character:say() print (self.message) end

repeater={}
function repeater:rep() self:say() self:othersay() end

Character=class(character, repeater)

robinhood=Character:new({message="Hold on my dear friar, I'll save you!"})
friartuck=Character:new({message="Help me Robin Hood, I'm in peril!"})

function friartuck:othersay() self:say () self:rep() end

robinhood:forward("othersay", friartuck.othersay, nil, nil, nil)
--function friartuck:othersay() coroutine.yield() say() coroutine.yield() rep() end
friartuck:forward("rep", robinhood.rep, nil, nil, nil)

--ObjL.serve("127.0.0.1", 1337, 10)

ObjL.makethread(robinhood:othersay({}))

ObjL.mainloop()

