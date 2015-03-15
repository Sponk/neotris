-- This file contains the implementation of the block preview logic.

local windowSize = getWindowScale()
local size = math.ceil(windowSize[2] * 0.05)
local blocks = {
   OBlock(0,0,size,0,0),
   LBlock(0,0,size,0,0),
   JBlock(0,0,size,0,0),
   SBlock(0,0,size,0,0),
   ZBlock(0,0,size,0,0),
   IBlock(0,0,size,0,0),
   TBlock(0,0,size,0,0)
}

local frameFile = "maps/scraps_bricks_preview.png"
local frameSheet = SpriteSheet(frameFile, 64, 64, 0)
   
local border = {}

local previewWindow = {
   width = 5,
   height = 5
}

function createPreviewWindow(x, y)
   previewWindow.startx = x + size
   previewWindow.starty = y + size

   local numx = 5
   local numy = 5

   local xframe = 2
   
   for i = 1, numx, 1 do
	  local t = Tile(x+(i-1)*size, y, size, size, frameSheet, xframe, 0, "")
	  mainCanvas:addWidget(t)
	  border[#border] = t
   end

   for i = 1, numx, 1 do
	  local t = Tile(x+(i-1)*size, y+numy*size, size, size, frameSheet, xframe, 0, "")
	  mainCanvas:addWidget(t)
	  border[#border] = t
   end

   for i = 1, numy+1, 1 do
	  local t = Tile(x+numx*size, y+(i-1)*size, size, size, frameSheet, xframe, 0, "")
	  mainCanvas:addWidget(t)
	  border[#border] = t
   end
   
   for i = 1, numy, 1 do
	  local t = Tile(x, y+(i-1)*size, size, size, frameSheet, xframe, 0, "")
	  mainCanvas:addWidget(t)
	  border[#border] = t
   end

end

function setBlockVisibility(block, vis)
   for x = 1, 5, 1 do
	  for y = 1, 5, 1 do
		 if block.blocks[x][y] ~= nil then
			block.blocks[x][y]:setVisible(vis)
		 end
	  end
   end
end

for i = 1, #blocks, 1 do
   setBlockVisibility(blocks[i], false)
end

function setPreviewWindow(blocktype)
   for i = 1, #blocks, 1 do
	  if blocks[i].type == blocktype then
		 setBlockVisibility(blocks[i], true)
		 blocks[i]:updateSprites(previewWindow.startx, previewWindow.starty)
	  else
		 setBlockVisibility(blocks[i], false)
	  end
   end
end
