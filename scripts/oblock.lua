-- Implements an O-Shaped block

dofile("SDK/Graphics2D.lua")
dofile("block.lua")

oblockGraphic = "maps/diamond.png"

OBlock = class(Block,
			   function(obj, posx, posy, size, boardx, boardy)
				  obj.blocks = {}
				  obj.x = boardx
				  obj.y = boardy
				  obj.size = size
				  
				  for y = 1, 5, 1 do
					 obj.blocks[y] = {}					
				  end
				  	
				  obj.blocks[2][2] = Sprite(0, 0, size, size, oblockGraphic, "") 
				  obj.blocks[2][3] = Sprite(0, 0, size, size, oblockGraphic, "")  
				  obj.blocks[3][2] = Sprite(0, 0, size, size, oblockGraphic, "")  
				  obj.blocks[3][3] = Sprite(0, 0, size, size, oblockGraphic, "")

				  obj.type = "OBlock"
				  
				  obj:addToCanvas(mainCanvas)
			   end
)

-- The O-Block does not need any rotation.
function OBlock:canRotate(field)
   return false
end
   
