#!/usr/bin/env ObjL

print("==================Array Test=================")
arr=class({[1]="hello", [2]="to", [3]="you"})
print("Testing array access. Should say 'hello'")
print(arr[1])
print("Testing slicing. Should say 'hello to' twice")
print(unpack(arr[{1,2}]))
print(unpack(arr{1,2}))
print("Testing slice modification. Should say 'hello from me' and then 'hello to you'")
arr[{2,3}]="from"
arr[3]="me"
print(unpack(arr{1,3}))
arr[{2,3}]="to"
arr[3]="you"
print(unpack(arr{1,3}))
print("Testing reversal. Should say 'you to hello'")
print(unpack(-arr))
print("Done.")

