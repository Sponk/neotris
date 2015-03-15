-- Implements an L-Shaped block

dofile("SDK/Graphics2D.lua")
dofile("block.lua")

jblockGraphic = "maps/red.png"

JBlock = class(Block,
			   function(obj, posx, posy, size, boardx, boardy)
				  obj.blocks = {}
				  obj.x = boardx
				  obj.y = boardy
				  obj.size = size
				  
				  for y = 1, 5, 1 do
					 obj.blocks[y] = {}					
				  end
				  	
				  obj.blocks[3][1] = Sprite(0, 0, size, size, jblockGraphic, "") 
				  obj.blocks[3][2] = Sprite(0, 0, size, size, jblockGraphic, "")  
				  obj.blocks[3][3] = Sprite(0, 0, size, size, jblockGraphic, "")  
				  obj.blocks[2][3] = Sprite(0, 0, size, size, jblockGraphic, "")

				  obj.type = "JBlock"
				  
				  obj:addToCanvas(mainCanvas)
			   end
)
