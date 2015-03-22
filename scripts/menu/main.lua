-- This file contains the main menu!

dofile("../SDK/Graphics2D.lua")

showCursor()
local windowSize = getWindowScale()

local width = windowSize[1] * 0.3
local height = windowSize[2] * 0.08
local fontsize = windowSize[2] * 0.04

local xpos = windowSize[1]/2 - width/2
local padding = windowSize[2] * 0.05

-- Size of title graphics is 640x200
local banner = Sprite(windowSize[1]/2 - 640/2, 15, 640, 200, "maps/banner.png", "")
local ypos = padding + 200

setDefaultFontSize(fontsize)
local startGameButton = Button(xpos, ypos, width, height, "Start Game", "start_game")

ypos = ypos + 2*padding
local highscoresButton = Button(xpos, ypos, width, height, "Highscores", "show_highscores")

ypos = ypos + 2*padding
local creditsButton = Button(xpos, ypos, width, height, "Credits", "show_credits")

ypos = ypos + 2*padding
local quitGameButton = Button(xpos, ypos, width, height, "Quit", "quit_game")

mainCanvas:addWidget(startGameButton)
mainCanvas:addWidget(quitGameButton)
mainCanvas:addWidget(creditsButton)
mainCanvas:addWidget(highscoresButton)
mainCanvas:addWidget(banner)
setCanvasClearColor(mainCanvas.canvas, {0.01,0.01,0.01,1.0})

function start_game()
   clearGui(1)
   loadLevel("levels/gamesetup.level")
end

function quit_game()
   quit()
end

function show_highscores()
   clearGui(1)
   loadLevel("levels/highscores.level")
end

function show_credits()
   clearGui(1)
   loadLevel("levels/credits.level")
end

-- Create config directories
local highscoreFilename = os.getenv("HOME")
if highscoreFilename == nil then
   highscoreFilename = os.getenv("APPDATA") .. "\\Neotris\\"
else
   highscoreFilename = highscoreFilename .. "/.neotris/"
end

if not isFileExist(highscoreFilename) then
   createDirectory(highscoreFilename)
end
