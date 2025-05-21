-- some syntax
Var = 12

print("----------------")
print("Conditional statements")
print("----------------")
-- Lua's conditionals are similar to Python, but 'elseif' is a single word and 'then' is required.
-- All variables are global by default unless declared 'local', which can affect scope in conditionals.

if Var > 10 then
	print("Var is greater than 10")
elseif Var == 10 then
	print("Var is equal to 10")
else
	print("Var is less than 10")
end

print("----------------")
print("While Loops")
print("----------------")
-- 'while' loops in Lua require 'do' and 'end' keywords, unlike Python's indentation-based blocks.
-- Variable scope inside loops is global unless explicitly declared local.

while Var > 0 do
	print("Var is " .. Var)
	Var = Var - 1
end

print("----------------")
print("For Loops")
print("----------------")
-- Numeric 'for' loops in Lua have explicit start, end, and step values: for i = start, end, step.
-- The loop variable is local to the loop body, which differs from Python's for-in range behavior.

for i = 1, 10, 1 do
	Var = Var + i
	print("Var is " .. Var)
end

print("----------------")
print("Functions")
print("----------------")
-- Functions are first-class values in Lua and can be assigned to variables or passed as arguments.
-- Unlike Python, functions can be defined inline or assigned to table fields for OOP-like patterns.

function Add(a)
	local offset = 2
	Var = Var + a + offset
	print("Var is " .. Var)
end

Add(4)

print("----------------")
print("Tables")
print("----------------")
-- Tables are Lua's only data structuring mechanism: they act as arrays, dictionaries, and objects.
-- Unlike Python, tables use 1-based indexing by default, and keys can be any value except nil.
-- Metatables allow operator overloading and custom behaviors, which is not native in Python dicts/lists.

TestTable = {}

TestTable[1] = "Hello"
TestTable[2] = "Bye"
TestTable["key"] = "Value"

table.insert(TestTable, "World")

TestTable.subject = "science"
TestTable.ayy = "lmao"

TestTable[2] = nil

for i, str in pairs(TestTable) do
	print("TestTable[" .. i .. "] = " .. str)
end
