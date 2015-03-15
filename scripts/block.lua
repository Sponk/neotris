-- Implements an abstract block class

dofile("SDK/Graphics2D.lua")


function printField(field)

   print("*******************************************************")
   local line = ""
   for x = 1, field.height, 1 do
	  for y = 1, field.width, 1 do
		 if field[y][x] ~= nil then
			line = line .. " x "
		 else
			line = line .. " - "
		 end
	  end

	  print(line)
	  line = ""
   end
   print("*********************************************************")
end


Block = class(
   function(obj)
	  obj.type = "Block"
   end
)

function Block:updateSprites(startx, starty)
   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if self.blocks[x][y] ~= nil then
			self.blocks[x][y]:setPosition(startx+(self.x+(x-1))*self.size,
										  starty+(self.y+(y-1))*self.size)
		 end
	  end
   end
end

function Block:placeBlocks(xpos, ypos, field)
   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if x+xpos > 0 and y+ypos > 0 and field[x+xpos][y+ypos] == nil then
			field[x+xpos][y+ypos] = self.blocks[x][y]
		 end
	  end
   end
end

function Block:canMoveRight(field)
   local ret = true
   self:deleteFromField(field)
   
   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if self.blocks[x][y] ~= nil and (field[self.x+x+1][self.y+y] ~= nil
										  or self.x+x+1 > field.width) then
			ret = false
		 end
	  end
   end

   self:placeBlocks(self.x,self.y,field)
   -- printField(field)
   return ret
end

function Block:canMoveLeft(field)
   local ret = true

   self:deleteFromField(field)
   
   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if self.blocks[x][y] ~= nil and (field[self.x+x-1][self.y+y] ~= nil
										  or self.x+x-1 <= 0) then
			ret = false
		 end
	  end
   end

   self:placeBlocks(self.x,self.y,field)
   
   return ret
end

function Block:canMoveDown(field)

   local ret = true

   -- printField(field)
   
   self:deleteFromField(field)
   
   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if self.blocks[x][y] ~= nil and (field[self.x+x][self.y+y+1] ~= nil
										  or self.y+y+1 > field.height) then
			ret = false
		 end
	  end
   end
   
   self:placeBlocks(self.x,self.y,field)
   
   return ret
end

function Block:calculateRotation()
   local tmp = {}
   for i = 1, 5, 1 do
	  tmp[i] = {}
	  for j = 1, 5, 1 do
		 tmp[i][j] = self.blocks[j][(4-i)]
	  end
   end
   return tmp
end

function Block:canRotate(field)
   local blocks = self:calculateRotation()

   self:deleteFromField(field)
   local ret = true
   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if blocks[x][y] ~= nil and (field[self.x+x][self.y+y] ~= nil
										 or self.x+x > field.width or self.x+x <= 0										     or self.y+y > field.height) then
			ret = false
		 end
	  end
   end
   self:placeBlocks(self.x, self.y, field)

   return ret
end

function Block:rotate(field)
   self:deleteFromField(field)

   self.blocks = self:calculateRotation()
   
   self:placeBlocks(self.x, self.y, field)
   self:updateSprites(field.startx, field.starty)
   
   -- printField(field)
end

function Block:deleteFromField(field)   
   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if self.blocks[x][y] ~= nil then
			field[x+self.x][y+self.y] = nil
		 end
	  end
   end
end

function Block:moveDown(field)
   self:deleteFromField(field)
   
   self.y = self.y + 1
   self:placeBlocks(self.x, self.y, field)

   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if self.blocks[x][y] ~= nil then
			self.blocks[x][y]:translate(0, self.size)
		 end
	  end
   end
end

function Block:moveLeft(field)
   self:deleteFromField(field)
   
   self.x = self.x - 1
   self:placeBlocks(self.x, self.y, field)
   self:updateSprites(field.startx, field.starty)
end

function Block:moveRight(field)
   self:deleteFromField(field)
   
   self.x = self.x + 1
   self:placeBlocks(self.x, self.y, field)

   self:updateSprites(field.startx, field.starty)
end

function Block:addToCanvas(canvas)
   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if self.blocks[x][y] ~= nil then
			canvas:addWidget(self.blocks[x][y])
		 end
	  end
   end
end
