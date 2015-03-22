-- This file contains primitives save and load highscores.

dofile("SDK/class.lua")

function string:split(sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function compareHighscores(a,b)
  return b.score < a.score
end

function getSortedKeys(list, compare)
   local keys = {}
   for k,o in pairs(list) do
	  table.insert(keys, k)
   end

   table.sort(keys,
			  function(a, b)
				 return compare(list[a], list[b])
			  end
   )

   return keys
end

local HighscoreEntry = class(
   function(obj, name, score)
	  obj.name = name
	  obj.score = score
   end
)

function HighscoreEntry:toString()
   return self.name .. ";" .. self.score
end

HighscoreList = class(
   function(obj)
	  obj.highscores = {}
   end
)

function HighscoreList:add(playername, score)
   if self.highscores[playername] == nil
   or self.highscores[playername].score < score then
	  
	  self.highscores[playername] = HighscoreEntry(playername, score)
   end
end

function HighscoreList:load(filename)
   local file = io.open(filename, "r")
   local line = ""
   local data = {}

   if file == nil then
	  print("Could not load highscore!")
	  return
   end
   
   
   while line ~= nil do
	  line = file:read("*line")
	  if line == nil then break end
	  
	  data = line:split(";")

	  self:add(data[1], tonumber(data[2]))
   end

    file:close()
end

function HighscoreList:save(filename)

   local keys = getSortedKeys(self.highscores, compareHighscores)
   -- table.sort(self.highscores, compareHighscores)
   
   local file = io.open(filename, "w")

   if file == nil then
	  print("Could not save highscore!")
	  return
   end
   
   --for n,e in pairs(self.highscores) do
   for i = 1, #keys, 1 do
	  file:write(self.highscores[keys[i]]:toString() .. "\n")
   end
   file:close()
end

function HighscoreList:getSublist(start, ending)
   local keys = getSortedKeys(self.highscores, compareHighscores)
   local sublist = {}
   for i = start, math.min(#keys, ending), 1 do
	  sublist[i] = self.highscores[keys[i]]
   end

   return sublist
end

function HighscoreList:print()
   for n,e in pairs(self.highscores) do
	  print(n, " --> ", e:toString())
   end
end

--[[ local highscore = HighscoreList()

highscore:add("Testman", 32156)
highscore:add("Jonas", 500)
highscore:add("Someman", 1251)
highscore:add("LOLMAN", 123)
highscore:add("Empty", 321)
highscore:save("test.txt")
   
highscore:print()

print("--> Creating new highscore list!")
highscore = HighscoreList()
highscore:load("test.txt")

highscore:print()

subl = highscore:getSublist(1, 10)

for i = 1, #subl, 1 do
   print(subl[i]:toString())
end
--]]
