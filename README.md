A Lua module made for easy implementation of classes through just one function.

# Usage
To begin using the module, you will need to do:
```lua
local Object = require('object')
```

## Creating a class
```lua
local Fruit = Object:extend('Fruit')
```
## Creating a constructor
```lua
function Fruit:new(name, mass)
	self.name = name or self.classname
	self.mass = mass or 1
	self.peeled = false
end
```
## Creating a class instance
```lua
local newFruit = Fruit('New Fruit', 3)
print(newFruit)         -- 'Fruit'
print(newFruit.name)    -- 'New Fruit'
print(newFruit.mass)    -- 3
print(newFruit.peeled)  -- false
```
## Creating methods
```lua
function Fruit:bite(numTimes)
	if numTimes == nil then numTimes = 1 end
	local massLost = 0
	for i = 1, numTimes do
		if self.mass <= 0 then return massLost end
		massLost = math.floor(self.mass * 0.5)
		self.mass = self.mass - massLost
	end
	return massLost
end

function Fruit:peel()
	if self.peeled then return end
	self.peeled = true
end

-- Example usage
local newFruit = Fruit(nil, 5)
print(newFruit.peeled) -- false
newFruit:peel()
print(newFruit.peeled) -- true
print(newFruit.mass)   -- 5
newFruit:bite(2)
print(newFruit.mass)   -- 1
```
## Creating metamethods
```lua
function Fruit:__tostring()
	if self.mass > 0 then
		return ('A %s%s with a mass of %d'):format(self.peeled and 'peeled ' or '', self.name, self.mass)
	else 
		return "There's nothing left!"
	end
end

function Fruit:__call(...)
	return self:bite(...)
end

-- Example usage
local newFruit = Fruit('Banana')
print(newFruit) -- 'A Banana with a mass of 1'
newFruit()
print(newFruit) -- "There's nothing left!"
```
## Creating a subclass
```lua
local Pineapple = Fruit:extend()

function Pineapple:new(mass, tanginess)
	self.tanginess = tanginess or 50
end
```
## Calling a method from a superclass
```lua
function Pineapple:bite(numTimes)
	if self.peeled then self.super.bite(self, numTimes) end -- You wouldn't eat a pineapple that isn't peeled, would you?
end
```
## Creating static variables
```lua
local Apple = Fruit:extend()

Apple.repelsDoctor = true

-- Example usage
local newApple = Apple()
print(newApple.repelsDoctor) -- true
```
## Checking object types
```lua
local newPineapple = Pineapple()
print(Apple:is(newPineapple)) 	  -- false
print(Fruit:is(newPineapple)) 	  -- true
print(Pineapple:is(newPineapple)) -- true
```
