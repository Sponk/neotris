-- Implements an J-Shaped block

dofile("SDK/Graphics2D.lua")
dofile("block.lua")

lblockGraphic = "maps/silver.png"

LBlock = class(Block,
			   function(obj, posx, posy, size, boardx, boardy)
				  obj.blocks = {}
				  obj.x = boardx
				  obj.y = boardy
				  obj.size = size
				  
				  for y = 1, 5, 1 do
					 obj.blocks[y] = {}					
				  end

				  	
				  obj.blocks[2][1] = Sprite(posx, posy,
												  size, size, lblockGraphic, "")
				  
				  obj.blocks[2][2] = Sprite(posx, posy+size,
												  size, size, lblockGraphic, "")
				  
				  obj.blocks[2][3] = Sprite(posx, posy + 2*size,
												  size, size, lblockGraphic, "")

				  
				  obj.blocks[3][3] = Sprite(posx+size, posy+2*size,
												  size, size, lblockGraphic, "")

				  
				  mainCanvas:addWidget(obj.blocks[2][1])
				  mainCanvas:addWidget(obj.blocks[2][2])
				  mainCanvas:addWidget(obj.blocks[2][3])
				  mainCanvas:addWidget(obj.blocks[3][3])

				  obj.type = "LBlock"
				  
			   end
)
