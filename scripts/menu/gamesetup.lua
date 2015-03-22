-- This file contains the game setup screen!

dofile("../SDK/Graphics2D.lua")

showCursor()
local windowSize = getWindowScale()

local width = windowSize[1] * 0.3
local height = windowSize[2] * 0.08
local fontsize = windowSize[2] * 0.04

local xpos = windowSize[1]/2 - width/2
local padding = windowSize[2] * 0.05

local nameInput = InputField(xpos, padding, width, height, "PlayerName", "")
local startButton = Button(xpos, 3*padding, width, height, "Start Game", "start_game")

mainCanvas:addWidget(nameInput)
mainCanvas:addWidget(startButton)

local highscoreFilename = os.getenv("HOME")
if highscoreFilename == nil then
   highscoreFilename = os.getenv("APPDATA") .. "\\Neotris\\"
else
   highscoreFilename = highscoreFilename .. "/.neotris/"
end

function start_game()

   -- FIXME: Ugly hack! Should be done in the engine
   -- without files!

   local f = io.open(highscoreFilename .. "playername.txt", "w")
   f:write(nameInput:getLabel())
   f:close()
   
   clearGui(1)
   loadLevel("levels/main.level")
end
