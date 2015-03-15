-- Implements an I-Shaped block

dofile("SDK/Graphics2D.lua")
dofile("block.lua")

iblockGraphic = "maps/gold.png"

IBlock = class(Block,
			   function(obj, posx, posy, size, boardx, boardy)
				  obj.blocks = {}
				  obj.x = boardx
				  obj.y = boardy
				  obj.size = size
				  
				  for y = 1, 5, 1 do
					 obj.blocks[y] = {}					
				  end

				  	
				  obj.blocks[3][1] = Sprite(0, 0, size, size, iblockGraphic, "") 
				  obj.blocks[3][2] = Sprite(0, 0, size, size, iblockGraphic, "")  
				  obj.blocks[3][3] = Sprite(0, 0, size, size, iblockGraphic, "")  
				  obj.blocks[3][4] = Sprite(0, 0, size, size, iblockGraphic, "")

				  obj.type = "IBlock"
				  
				  obj:addToCanvas(mainCanvas)
			   end
)

function IBlock:calculateRotation()
   local tmp = {}

   for x = 1, 5, 1 do
	  tmp[x] = {}
	  for y = 1, 5, 1 do
		 tmp[x][y] = self.blocks[y][x]
	  end
   end
   
   return tmp 			 
end
