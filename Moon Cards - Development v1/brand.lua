-- Development by Matthew Maday
-- DBA - Weekend Warrior Collective
-- a 100% not-for-profit developer collective

-- This is the brand scene

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------

local storyboard = require ("storyboard")
local scene      = storyboard.newScene()
local uiObj      = require ("classes.ui")

--------------------------------------------------------------------------------------
-- local variable declaritions
--------------------------------------------------------------------------------------

local screenGroup          = nil				-- the group that holds all of the graphics
local gCollector           = {}                 -- the array of all graphics used
local gStar                = {150,nil,2}
local gTimer               = nil
local myHeight, myWidth    = display.contentHeight, display.contentWidth
local myCenterX, myCenterY = myWidth*.5, myHeight*.5

--------------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------------

-- onOrientationChange( event )
-- touchScreen(event)
-- rotateStar(event,object)
-- initStar(event)

local function onOrientationChange( event )

 	local delta = event.delta

	if screenGroup.rotation == 0 and delta < 0 then
		local newAngle = delta-screenGroup.rotation
	else
		local newAngle = delta-screenGroup.rotation
	end

	transition.to( screenGroup, { x=(display.contentWidth-myWidth)*.5,y=0, 
	time=400, delay=0,alpha=1.0,transition=easing.outQuad,rotation=newAngle})
	
end
--------
local function touchScreen(event)
	if event.phase == "began" then
		storyboard.gotoScene( "start", "fade", 400 )
	elseif event.phase == "ended" then
	end
end
--------
local function rotateStar(event,object)

	local center = {myCenterX,myCenterY-38}

	gStar[1] = uiObj.rotateOnCircle(gStar[2], center,360, gStar[3], gStar[1], 300)
	gStar[3] = gStar[3] - .029
	gStar[2].alpha = (gStar[1]-150)/70

	if gStar[3] < 0 then
		Runtime:removeEventListener("enterFrame", rotateStar)
	end

end
--------
function constructScene()

	if myWidth > myHeight then
		myHeight = myWidth
	elseif myHeight > myWidth then
		myWidth = myHeight
	end

	myCenterX, myCenterY = myWidth*.5, myHeight*.5

	-- background rect that fades in
	local img = display.newRect(screenGroup, 0,0,myWidth*2,myCenterY)
	img:setReferencePoint( display.TopLeftReferencePoint )
	img.x,img.y     = 0,0
	img:setFillColor(255,255,255)
	img.alpha = 0.0

	gCollector[#gCollector+1] = img

	transition.to( img, { time=4000, delay=0, alpha=1.0} )

	-- burst image
	gCollector[#gCollector+1] = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/logo_burst.png",
	name="burst",width=698,height=373,x=myCenterX,y=myCenterY-200,alpha=0.0,
	reference=display.BottomCenterReferencePoint})

	transition.to( gCollector[#gCollector], { time=2000, delay=2000, alpha=.5, } )

	-- logo image
	gCollector[#gCollector+1] = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/logo.png",
	name="logo",width=132,height=125,x=myCenterY+30,y=myCenterY-60,alpha=1.0,
	reference=display.BottomCenterReferencePoint})

	transition.to( gCollector[#gCollector], { x= myCenterY,time=7000, delay=0, alpha=1.0, transition=easing.outQuad} )

	-- title image
	gCollector[#gCollector+1] = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/logo_title.png",
	name="title",width=202,height=10,x=myCenterX,y=myCenterY+25,alpha=0.0,
	reference=display.TopCenterReferencePoint})

	transition.to( gCollector[#gCollector], { y= myCenterY+15,time=1000, delay=2000, alpha=1.0, transition=easing.inQuad} )

	-- star image
	gStar[2] = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/logo_star.png",
	name="star",width=14,height=12,x=myCenterX,y=myCenterY,alpha=0.0,
	reference=display.TopCenterReferencePoint})

	Runtime:addEventListener("enterFrame", rotateStar)

end

--------------------------------------------------------------------------------------
-- INIT storyboard scene
--------------------------------------------------------------------------------------

-- scene:createScene(event)
-- scene:enterScene(event)
-- scene:exitScene(event)
-- scene:destroyScene(event)

function scene:createScene(event)

	if myWidth > myHeight then
		myHeight = myWidth
	elseif myHeight > myWidth then
		myWidth = myHeight
	end

	myCenterX, myCenterY = myWidth*.5, myHeight*.5

	screenGroup = self.view
	screenGroup.width,screenGroup.height = myWidth,myHeight

	-- create a blank background - important for orientation and predictable image placement
	local img = display.newRect(screenGroup, 0,0,myWidth,myHeight)
	img:setReferencePoint( display.TopLeftReferencePoint )
	img.x,img.y     = 0,0
	img:setFillColor(0,0,0)

	return screenGroup

end      
--------
function scene:enterScene(event)

	Runtime:addEventListener("touch",touchScreen)
	screenGroup:setReferencePoint( display.TopLeftReferencePoint )
	screenGroup.x,screenGroup.y = (display.contentWidth-myWidth)*.5,0

	constructScene()

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




