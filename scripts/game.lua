-- Contains the main game logic

dofile("SDK/Graphics2D.lua")
dofile("lblock.lua")
dofile("tblock.lua")
dofile("zblock.lua")
dofile("sblock.lua")
dofile("oblock.lua")
dofile("iblock.lua")
dofile("jblock.lua")

dofile("preview.lua")

hideCursor()

math.randomseed(os.time())
local blockTypes = {LBlock, TBlock, ZBlock, SBlock, OBlock, IBlock, JBlock}
print("There are " .. #blockTypes .. " block types.")

local scoreList = {[0]=0, 10, 100, 200, 400, 800}
local levelupLines = 10
local linesSinceLevelup = 0
local maxLevel = 8

local gameOver = false
local nextMove = 0
local delay = 1000

local windowSize = getWindowScale()

local fontsize = windowSize[2]*0.05
local tilesize = math.ceil(windowSize[2]*0.04)
local gridWidth = 10
local gridHeight = 20

local grid = {}

for i = 0, gridHeight, 1 do
   grid[i] = {}
end

grid.width = gridWidth
grid.height = gridHeight

-- Coordinate of the top left corner of the field
grid.startx = (windowSize[1] / 2) - (grid.width*tilesize)/2
grid.starty = 0

local blockBuffer = nil
function getRandomBlock()
   local start = math.floor(gridWidth / 2)
   local rand = math.random(1, #blockTypes)
   
   local blockType = blockTypes[rand]
   local blk = blockType(grid.startx+start*tilesize,grid.starty,tilesize, start-2, 1)
   return blk
end

blockBuffer = getRandomBlock()
function getNextBlock()
   local blk = blockBuffer
   blockBuffer = getRandomBlock()

   setBlockVisibility(blk, true)
   setBlockVisibility(blockBuffer, false)
   setPreviewWindow(blockBuffer.type)
   
   blk:placeBlocks(blk.x, blk.y, grid)
   blk:updateSprites(grid.startx, grid.starty)

   return blk
end

-- Generate frame around the grid
local frame = {}
local frameRes = tilesize
local frameFile = "maps/scraps_bricks_preview.png"
local numx = math.ceil((gridWidth*tilesize)/frameRes) + 2
local numy = gridHeight + 2
local frameSheet = SpriteSheet(frameFile, 64, 64, 0)

local xpos = grid.startx - 2*frameRes
local ypos = grid.starty + (numy-2)*tilesize

for x = 1, numx, 1 do
   local tile = Tile(xpos+x*frameRes, ypos, frameRes, frameRes, frameSheet, 0, 0, "")
   mainCanvas:addWidget(tile)
end

for y = 1, numy, 1 do
   local tile = Tile(xpos+frameRes, ypos-y*frameRes, frameRes, frameRes, frameSheet, 0, 0, "")
   mainCanvas:addWidget(tile)
end

for y = 1, numy, 1 do
   local tile = Tile(xpos+numx*frameRes, ypos-y*frameRes, frameRes, frameRes, frameSheet, 0, 0, "")
   mainCanvas:addWidget(tile)
end

-- Generate GUI
setDefaultFontSize(fontsize)
-- setDefaultFont("fonts/fifteen/FifteenNarrow.ttf")

scoreLabel = Label(xpos+(numx+1)*frameRes, grid.starty + frameRes, 100, 30, "Score: 0");

linesLabel = Label(xpos+(numx+1)*frameRes, grid.starty + 3*frameRes, 100, 30, "Lines: 0")

levelLabel = Label(xpos+(numx+1)*frameRes, grid.starty + 5*frameRes, 100, 30, "Level: 0")

gameOverLabel = Label(windowSize[1]/2 - 200 - frameRes, windowSize[2]/2 - 30, 200, 30, "GAME OVER")


-- Create the preview window
createPreviewWindow(xpos+(numx+3)*frameRes, grid.starty + 8*frameRes)

mainCanvas:addWidget(scoreLabel)
mainCanvas:addWidget(linesLabel)
mainCanvas:addWidget(levelLabel)

-- Set clear color
setCanvasClearColor(mainCanvas.canvas, {0.001,0.01,0.01,1.0})

-- Load the music!
local music = loadSound("sounds/theme.ogg")
setSoundLooping(music, 1)
playSound(music)

local lineRemovedSound = loadSound("sounds/bfxr_sounds/Randomize4.wav")
local blockLandedSound = loadSound("sounds/bfxr_sounds/Explosion.wav")
local levelupSound = loadSound("sounds/Level Up!/chipquest.wav")

setSoundGain(music, 0.5)

local player = {score = 0, lines = 0, level = 0}
local currentBlock = getNextBlock()

function onLevelup()
   if player.level < maxLevel then
	  playSound(levelupSound)
	  delay = delay * 0.7
	  player.level = player.level + 1
	  linesSinceLevelup = 0
   end
end

function onGameOver()
   gameOver = true

   mainCanvas:addWidget(gameOverLabel)
   gameOverLabel:setVisible(true)
end

function onExit()
   clearGui(1)
   loadLevel("levels/menu.level")
end

function repositionSprites(field)
   for y = 1, field.height, 1 do
	  for x = 1, field.width, 1 do
		 if field[x][y] ~= nil then
			field[x][y]:setPosition(field.startx+tilesize*(x-1), field.starty+tilesize*(y-1))
		 end
	  end
   end
end

function removeLines(field)
   local lines = 0
   local isFull = true

   local y = field.height
   while y >= 1 do
	  isFull = true
	  for x = 1, field.width, 1 do
		 if field[x][y] == nil then
			isFull = false
		 end
	  end

	  if isFull then
		 lines = lines + 1

		 for x = 1, field.width, 1 do
			destroyWidget(field[x][y].widget)
			field[x][y] = nil
		 end

		 for j = y, 2, -1 do
			for x = 1, field.width, 1 do
			   field[x][j] = field[x][j-1]
			end
		 end

		 y = field.height
	  else
		 y = y - 1
	  end
   end

   repositionSprites(field)
   return lines
end

function onBlockLanded()
   local removedLines = removeLines(grid)

   if removedLines > 0 then
	  playSound(lineRemovedSound)

	  player.lines = player.lines + removedLines
	  player.score = player.score + scoreList[removedLines]

	  linesSinceLevelup = linesSinceLevelup + removedLines
	  
	  if linesSinceLevelup >= levelupLines then
		 onLevelup()
	  end
	  
	  scoreLabel:setLabel("Score: " .. player.score)
	  linesLabel:setLabel("Lines: " .. player.lines)
	  levelLabel:setLabel("Level: " .. player.level)
   else
	  playSound(blockLandedSound)
   end

   currentBlock = getNextBlock()
   if not currentBlock:canMoveDown(grid) then
	 onGameOver()
   end
end

function onSceneUpdate()

   if gameOver then
	  if onKeyDown("ESCAPE") then
		 onExit()
	  end
	  return
   end
   
   local curtime = getSystemTick()

   if onKeyDown("UP") and currentBlock:canRotate(grid) then
	  currentBlock:rotate(grid)
   end
   
   if onKeyDown("LEFT") and currentBlock:canMoveLeft(grid) then
	  currentBlock:moveLeft(grid)
   end

   if onKeyDown("RIGHT") and currentBlock:canMoveRight(grid) then
	  currentBlock:moveRight(grid)
	  onRight = true
   end

   if onKeyDown("DOWN") then
	  while currentBlock:canMoveDown(grid) do
		 currentBlock:moveDown(grid)
	  end

	  onBlockLanded()
	  return
   end
   
   if curtime >= nextMove then
	  nextMove = curtime + delay
	  
	  if currentBlock:canMoveDown(grid) then
		 currentBlock:moveDown(grid)
	  else
		 onBlockLanded()
	  end

	 -- printField(grid)
   end

   if onKeyDown("ESCAPE") then onExit() end
end
