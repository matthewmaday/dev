

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------

local storyboard = require ("storyboard")
local scene      = storyboard.newScene()
local easingx    = require("classes.easing")  -- cool library i found- important easing"x"
local physics    = require "physics"
local uiObj      = require ("classes.ui")

physics.start()
physics.setGravity(0,0 )

screenGroup      = ""
spawnTable       = {}

--------------------------------------------------------------------------------------
-- INIT storyboard scene
--------------------------------------------------------------------------------------

function scene:createScene(event)

	screenGroup = self.view

	-- background
	local img   = display.newImageRect(screenGroup, "images/home_bkg.png", 360, 300)
	img:setReferencePoint( display.CenterReferencePoint )
	img.x,img.y = display.contentCenterX, display.contentHeight-88

	-- burst animation
	burst             = display.newImageRect(screenGroup, "images/home_burst.png", 600, 600)
	burst.x, burst.y  = display.contentCenterX,display.contentCenterY
	burst.speed = 1

	for i=1,30 do

		local x,y 	  = uiObj.randomDirectionDegrees(100, 100) 
		spawnTable[i] = uiObj.spawn(
		{
			image 		= "images/home_star.png",
			objTable 	= spawnTable,
			group 		= screenGroup,
			hasBody 	= true,
			density 	= 1,
			friction 	= .4,
			bounce 		= .4,
			isSensor 	= false,
			bodyType 	= "static",
			x			= display.viewableContentWidth*.5,
			y			= display.viewableContentHeight*.5,
			speed       = {x,y},
			width       = 1,
			height      = 1,
			blendSpeed  = .004,
			rotation    = (math.random(1,2)*2)-3, -- will return -1 or +1
			alpha       = 0,
			myTimer		= math.random(1,300)

		})

		spawnTable[i].enterFrame = uiObj.processSpawns
		Runtime:addEventListener("enterFrame", spawnTable[i])

	end

	-- center moon
	local img = display.newImageRect(screenGroup, "images/home_sunmoon.png", 104, 107)
	img:setReferencePoint( display.CenterReferencePoint )
	img.x, img.y = display.contentCenterX, display.contentCenterY 
	img.alpha    = 0

	transition.to( img, { time=2000, delay=100, alpha=1.0, } )

	local img   = display.newImageRect(screenGroup, "images/home_title.png", 289, 49)
	img.y,img.x = display.viewableContentHeight*.10,display.contentWidth*.5
	
	img.alpha   = 0

	transition.to( img, { time=2000, delay=0, alpha=1.0, } )

	local img   = display.newImageRect("images/home_begin.png", 104, 37)
	img.y,img.x = display.contentHeight - (display.contentHeight*.07),display.contentWidth*.5
	img.alpha   = 0

	transition.to( img, { time=1000, delay=1000, alpha=1.0, } )
	screenGroup:insert(img)

end
--------
local function rotate(self)
	self.rotation = (self.rotation > 360) and 0 or (self.rotation + .1)
end


--------------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------------

function touchScreen(event)
	if event.phase == "began" then
		storyboard.gotoScene( "card", "fade", 400 )
	elseif event.phase == "ended" then
	end
end

--------------------------------------------------------------------------------------
-- INIT storyboard scene
--------------------------------------------------------------------------------------



function scene:enterScene(event)
	Runtime:addEventListener("touch",touchScreen)
	burst.enterFrame = rotate
	Runtime:addEventListener("enterFrame", burst)
end
--------
function scene:exitScene(event)
	
	-- remove listener events
	Runtime:removeEventListener("touch",touchScreen)
	Runtime:removeEventListener("enterFrame", burst)
	scene:removeEventListener("createScene", scene)
	scene:removeEventListener("enterScene", scene)
	scene:removeEventListener("exitScene", scene)
	scene:removeEventListener("destroyScene", scene)

	-- clean up globals

	burst:removeSelf( )
	--spawnTable:removeSelf( )
	screenGroup:removeSelf()
	screenGroup,burst, spawnTable = nil, nil, nil

end
--------
function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene




