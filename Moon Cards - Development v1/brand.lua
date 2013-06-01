

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------

local storyboard = require ("storyboard")
local scene      = storyboard.newScene()
local uiObj      = require ("classes.ui")
screenGroup      = nil
logoGroup        = display.newGroup()
gCollector       = {}
gStar            = {150,nil,2}
gTimer           = nil
gOrientation     = system.orientation

--------------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------------

-- touchScreen(event)
-- initBurst(event)

local function onOrientationChange( event )

	gOrientation     = system.orientation

	-- -- rotate text so it remains upright
	local newAngle = event.delta-screenGroup.rotation
	transition.to( screenGroup, { time=150, rotation=newAngle } )
end

Runtime:addEventListener( "orientation", onOrientationChange )



 
 


local function touchScreen(event)
	if event.phase == "began" then
		storyboard.gotoScene( "start", "fade", 400 )
	elseif event.phase == "ended" then
	end
end
--------
local function rotateStar(event,object)

	local center = {display.contentCenterX,display.contentCenterY}

	gStar[1] = uiObj.rotateOnCircle(gStar[2], center,360, gStar[3], gStar[1], 300)
	gStar[3] = gStar[3] - .029
	gStar[2].alpha = (gStar[1]-150)/70

	if gStar[3] < 0 then
		Runtime:removeEventListener("enterFrame", rotateStar)
	end

end
--------
local function initStar(event)

    	-- star image
	gStar[2] = display.newImageRect(logoGroup, "images/logo_star.png", 14,12)
	gStar[2]:setReferencePoint(display.BottomCenterReferencePoint)
	gStar[2].x,gStar[2].y 	  = display.contentCenterX,display.contentCenterY+70
	gStar[2].alpha = 0.0

	Runtime:addEventListener("enterFrame", rotateStar)

	timer.cancel(gTimer)
	gTimer = nil

end
--------------------------------------------------------------------------------------
-- INIT storyboard scene
--------------------------------------------------------------------------------------

-- scene:createScene(event)
-- scene:enterScene(event)
-- scene:exitScene(event)
-- scene:destroyScene(event)

function scene:createScene(event)

	screenGroup = self.view
	screenGroup.width, screenGroup.height = 480,480


	-- background rect that fades in
	local img = display.newRect(logoGroup, 0,0,display.contentWidth*1.5,display.contentCenterY*1.4)
	img:setReferencePoint( display.BottomCenterReferencePoint )
	img.x,img.y     = display.contentCenterX,display.contentCenterY+60
	img:setFillColor(255,255,255)
	img.alpha = 0.0

	gCollector[#gCollector+1] = img

	transition.to( img, { time=4000, delay=0, alpha=1.0} )

	-- burst image
	local img = display.newImageRect(logoGroup, "images/logo_burst.png", 698,373)
	img:setReferencePoint(display.BottomCenterReferencePoint)
	img.x,img.y 	  = display.contentCenterX,display.contentCenterY+70
	img.alpha = 0.0

	gCollector[#gCollector+1] = img

	transition.to( img, { time=2000, delay=2000, alpha=.5, } )

	-- logo image
	local img = display.newImageRect(logoGroup, "images/logo.png", 132,125)
	img:setReferencePoint(display.CenterReferencePoint)
	img.x 	  = display.contentCenterX+30
	img.y 	  = display.contentCenterY

	gCollector[#gCollector+1] = img
	transition.to( img, { x= display.contentCenterX,time=7000, delay=0, alpha=1.0, transition=easing.outQuad} )

	-- title image
	local img = display.newImageRect(logoGroup, "images/logo_title.png", 202,10)
	img:setReferencePoint(display.CenterReferencePoint)
	img.x,img.y 	  = display.contentCenterX,display.contentCenterY+80
	img.alpha = 0.0

	gCollector[#gCollector+1] = img

	transition.to( img, { y= display.contentCenterY+75,time=1000, delay=2000, alpha=1.0, transition=easing.inQuad} )
	
	gTimer = timer.performWithDelay(2000, initStar,0 )

	screenGroup:insert(logoGroup)
	screenGroup:setReferencePoint( display.CenterReferencePoint )
	print(screenGroup.x)
end      
--------
function scene:enterScene(event)
	Runtime:addEventListener("touch",touchScreen)
end
--------
function scene:exitScene(event)
	
	

	-- remove listener events
	Runtime:removeEventListener("touch",touchScreen)
	scene:removeEventListener("createScene", scene)
	scene:removeEventListener("enterScene", scene)
	scene:removeEventListener("exitScene", scene)
	scene:removeEventListener("destroyScene", scene)

	-- clean up globals
	screenGroup:removeSelf()
	screenGroup = nil

	for i=1,#gCollector, 1 do
		gCollector[i]:removeSelf()
		gCollector[i] = nil
	end
	if gStar[2] ~= nil then
		gStar[2]:removeSelf()
		gStar[2] = nil
		gStar = nil
	end

	
	gCollector = nil
	logoGroup  = nil
	if gTimer ~= nil then
		timer.cancel(gTimer)
		gTimer = nil
	end
end
--------
function scene:destroyScene(event)

end

--------------------------------------------------------------------------------------
-- scene execution
--------------------------------------------------------------------------------------

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene




