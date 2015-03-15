-- Implements an Z-Shaped block

dofile("SDK/Graphics2D.lua")
dofile("block.lua")

zblockGraphic = "maps/light-blue.png"

ZBlock = class(Block,
			   function(obj, posx, posy, size, boardx, boardy)
				  obj.blocks = {}
				  obj.x = boardx
				  obj.y = boardy
				  obj.size = size
				  
				  for y = 1, 5, 1 do
					 obj.blocks[y] = {}					
				  end

				  	
				  obj.blocks[1][2] = Sprite(0, 0, size, size, zblockGraphic, "") 
				  obj.blocks[2][2] = Sprite(0, 0, size, size, zblockGraphic, "")  
				  obj.blocks[2][3] = Sprite(0, 0, size, size, zblockGraphic, "")  
				  obj.blocks[3][3] = Sprite(0, 0, size, size, zblockGraphic, "")

				  obj.type = "ZBlock"
				  
				  obj:addToCanvas(mainCanvas)
			   end
)
