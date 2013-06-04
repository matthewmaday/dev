--------------------------------------------------------------------------------------
-- Common use brand identity scene
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------

local storyboard = require ("storyboard")
local scene      = storyboard.newScene()
local uiObj      = require ("classes.ui")


--------------------------------------------------------------------------------------
-- local variable declaritions
--------------------------------------------------------------------------------------

screenGroup      = nil				-- the group that holds all of the graphics
local logoGroup        = display.newGroup() -- a group 
local gCollector       = {}
local gStar            = {150,nil,2}
local gTimer           = nil
local gOrientation     = system.orientation
local screenGroupOffset = {-100,-60}

local myHeight, myWidth = display.contentHeight, display.contentWidth
local myCenterX, myCenterY = myWidth*.5, myHeight*.5


--------------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------------

-- onOrientationChange( event )
-- touchScreen(event)
-- rotateStar(event,object)
-- initStar(event)

local function resetWidthHeight()

if myWidth > myHeight then
	local w = myWidth
	myWidth = myHeight
	myHeight = w
end

   myCenterX, myCenterY = myWidth*.5, myHeight*.5

end
--------
local function onOrientationChange( event )

	if system.orientation == "portrait" or system.orientation == "portraitUpsideDown" then
		print("reset in portrait")

		myWidth,myHeight  = display.contentWidth, display.contentHeight
		myCenterX, myCenterY = myWidth*.5, myHeight*.5

		screenGroup.y = screenGroupOffset[2]
		screenGroup.x = (myWidth-screenGroup.width)*.5

	else
		print("reset in landscape")
		screenGroup.x = (myWidth-screenGroup.width)*.5
		screenGroup.y = screenGroupOffset[2]
	end

-- screenGroup.x,screenGroup.y = screenGroupOffset[1],screenGroupOffset[2]

print(event.delta-screenGroup.rotation)
 local delta = event.delta
	if screenGroup.rotation == 0 and delta < 0 then
		local newAngle = delta-screenGroup.rotation
	else
		local newAngle = delta-screenGroup.rotation
	end

-- 	gOrientation     = system.orientation

-- 	-- -- rotate text so it remains upright
-- 	local newAngle = screenGroup.rotation+delta

-- 	if newAngle == 0 then
-- 		newAngle = 360
-- 	end
-- print(event.delta)
-- screenGroup.rotation = newAngle

	transition.to( screenGroup, { time=150, rotation=newAngle } )
end



local function touchScreen(event)
	if event.phase == "began" then
		storyboard.gotoScene( "start", "fade", 400 )
	elseif event.phase == "ended" then
	end
end
--------
local function rotateStar(event,object)

--print(gTimer)-- = timer.performWithDelay(2000, initStar,0 )
	local center = {0,554}

	gStar[1] = uiObj.rotateOnCircle(gStar[2], center,360, gStar[3], gStar[1], 300)
	gStar[3] = gStar[3] - .029
	gStar[2].alpha = (gStar[1]-150)/70

	if gStar[3] < 0 then
		Runtime:removeEventListener("enterFrame", rotateStar)
	end

end

--------------------------------------------------------------------------------------
-- INIT storyboard scene
--------------------------------------------------------------------------------------

-- scene:createScene(event)
-- scene:enterScene(event)
-- scene:exitScene(event)
-- scene:destroyScene(event)

function scene:createScene(event)

	resetWidthHeight()

	screenGroup = self.view
	screenGroup.width,screenGroup.height = 698,myHeight

	-- background rect that fades in
	local img = display.newRect(screenGroup, 0,0,698,myCenterY*1.4)
	img:setReferencePoint( display.TopCenterReferencePoint )
	img.x,img.y     = 0,myCenterY+60
	img:setFillColor(255,255,255)
	img.alpha = 0.0

	gCollector[#gCollector+1] = img

	transition.to( img, { time=4000, delay=0, alpha=1.0} )

	-- burst image
	gCollector[#gCollector+1] = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/logo_burst.png",
	name="burst",width=698,height=373,x=0,y=455,alpha=0.0,
	reference=display.BottomCenterReferencePoint})

	transition.to( gCollector[#gCollector], { time=2000, delay=2000, alpha=.5, } )

	-- logo image
	gCollector[#gCollector+1] = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/logo.png",
	name="logo",width=132,height=125,x=30,y=575,alpha=1.0,
	reference=display.BottomCenterReferencePoint})

	transition.to( gCollector[#gCollector], { x= 0,time=7000, delay=0, alpha=1.0, transition=easing.outQuad} )

	-- title image
	gCollector[#gCollector+1] = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/logo_title.png",
	name="title",width=202,height=10,x=0,y=660,alpha=0.0,
	reference=display.TopCenterReferencePoint})

	transition.to( gCollector[#gCollector], { y= 650,time=1000, delay=2000, alpha=1.0, transition=easing.inQuad} )

	-- star image
	gStar[2] = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/logo_star.png",
	name="star",width=14,height=12,x=-30,y=300,alpha=0.0,
	reference=display.TopCenterReferencePoint})

	Runtime:addEventListener("enterFrame", rotateStar)
	screenGroup:setReferencePoint( display.TopLeftReferencePoint )

	return screenGroup

end      
--------
function scene:enterScene(event)

	Runtime:addEventListener("touch",touchScreen)
	screenGroup.y = screenGroupOffset[2]
	screenGroup.x = (myWidth-screenGroup.width)*.5

end
--------
function scene:exitScene(event)
	
	-- remove listener events
	Runtime:removeEventListener("touch",touchScreen)
	scene:removeEventListener("createScene", scene)
	scene:removeEventListener("enterScene", scene)
	scene:removeEventListener("exitScene", scene)
	scene:removeEventListener("destroyScene", scene)
	Runtime:removeEventListener( "orientation", onOrientationChange )
	Runtime:removeEventListener("enterFrame", rotateStar)

	-- clean up globals

		if gStar[2] ~= nil then
		--gStar[2]:removeSelf()
		--gStar[2] = nil
		gStar = nil
	end


	screenGroup:removeSelf()
	screenGroup = nil

	-- for i=1,#gCollector, 1 do
	-- 	gCollector[i]:removeSelf()
	-- 	gCollector[i] = nil
	-- end


	-- gCollector = nil
	-- logoGroup  = nil
	-- if gTimer ~= nil then
	-- 	timer.cancel(gTimer)
	-- 	gTimer = nil
	-- end
end
--------
function scene:destroyScene(event)

end

--------------------------------------------------------------------------------------
-- scene execution
--------------------------------------------------------------------------------------



Runtime:addEventListener( "orientation", onOrientationChange )
scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)



return scene




