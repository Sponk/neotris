-- This file configure the credits screen
dofile("../SDK/Graphics2D.lua")
dofile("../highscore.lua")

local windowSize = getWindowScale()

local width = windowSize[1] * 0.3
local height = windowSize[2] * 0.08
local fontsize = windowSize[2] * 0.04

local xpos = windowSize[1]/2 - width/2

local backButton = Button(xpos, windowSize[2] - 2*height, width, height, "Back", "back")

local highscoreLabel = Label(xpos, windowSize[2]*0.05, 1, 1, "")

mainCanvas:addWidget(backButton)
mainCanvas:addWidget(highscoreLabel)

local highscoreList = HighscoreList()
local highscoreDirectory = os.getenv("HOME")
local highscoreFilename = ""
if highscoreDirectory == nil then
   highscoreDirectory = os.getenv("APPDATA")
   highscoreDirectory = highscoreDirectory .. "\\Neotris\\"
   highscoreFilename = highscoreDirectory  .. "score.hsc"
else
   highscoreDirectory = highscoreDirectory .. "/.neotris/"
   highscoreFilename = highscoreDirectory .. "score.hsc"
end
highscoreList:load(highscoreFilename)
highscoreList:print()

local topten = highscoreList:getSublist(1, 10)
local text = ""
for i = 1, #topten, 1 do
   text = text .. topten[i].name .. "\t\t\t" .. topten[i].score .. "\n"
end

highscoreLabel:setLabel(text)

function back()
   clearGui(1)
   loadLevel("levels/menu.level")
end
