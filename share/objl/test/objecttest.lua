#!/usr/bin/env ObjL

print("===========ObjL Object Test Routine================")
print("Making template object.")
templateobject={a="hello"}
print("Testing field access in template object. Should say 'hello'.")
print(templateobject.a)
print("Creating template method.")
function templateobject:f() print (self.a) end
print ("Testing template object method. Should say 'hello'.")
templateobject:f()
print ("Creating class.")
x=class(templateobject)
print ("Testing accessing of a field. Should say 'hello'")
print(x.a)
print ("Testing method. Should say 'hello'")
x:f()
print ("Testing modification of field. Should say 'goodbye' twice.")
x.a="goodbye"
print(x.a)
x:f()
x.a="hello"
print ("Instantiating object.")
y=x:new()
print ("Testing object field and method. Should say 'goodbye' twice.")
print (y.a)
y:f()
print ("Testing modification of field. Should say 'hello' twice.")
y.a="hello"
print (y.a)
y:f()
print ("Creating another template object.")
to2={b="goodbye"}
function to2:j() print(self.b) end
print ("Testing multiple inheritence at pre-class level.")
z=class(templateobject, to2)
print ("Testing field access. Should say 'hello' and 'goodbye'")
print (z.a)
print (z.b)
print ("Testing field concatenation. Should say 'hellogoodbye'")
print (z.a..z.b)
print ("Testing methods. Should say 'hello' and 'goodbye'")
z:f()
z:j()
print ("Testing serialization.")
c=z.serialize()
print ("Testing unserialization. Should say 'hello' and 'goodbye'")
d=ObjL.unserialize(c)
k=d()
--k:f()
--k:j()
print ("Testing multiple inheritence at class level. Should say 'hellogoodbye'")
e=class(x, z)
print(e.a..e.b)
print ("Testing multiple inheritence at the pre-object level. Should say 'hellogoodbye', 'hello', and 'goodbye'")
g=y:new(to2)
print(g.a..g.b)
g:f()
g:j()
print ("Testing multiple inheritence at the object level. Should say 'hello' and 'goodbye' twice.")
h=z+f
print(h.a)
print(h.b)
--h:f()
--h:j()
print("Done.")
