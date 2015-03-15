-- This file configure the credits screen
dofile("../SDK/Graphics2D.lua")

local windowSize = getWindowScale()

local width = windowSize[1] * 0.3
local height = windowSize[2] * 0.08
local fontsize = windowSize[2] * 0.04

local xpos = windowSize[1]/2 - width/2

local backButton = Button(xpos, windowSize[2] - 2*height, width, height, "Back", "back")

local creditsText = loadTextFile("scripts/credits.txt")
local creditsLabel = Label(windowSize[1]*0.05, windowSize[2]*0.05, 1, 1, creditsText)

mainCanvas:addWidget(backButton)
mainCanvas:addWidget(creditsLabel)

function back()
   clearGui(1)
   loadLevel("levels/menu.level")
end
