-- Development by Matthew Maday
-- DBA - Weekend Warrior Collective
-- a 100% not-for-profit developer collective

-- This is the opening scene

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------

-- appId  = "162620770581111"
local storyboard = require ("storyboard")
local scene      = storyboard.newScene()
local physics    = require "physics"
local uiObj      = require ("classes.ui")

physics.start()
physics.setGravity(0,0 )

--------------------------------------------------------------------------------------
-- local variable declaritions
--------------------------------------------------------------------------------------

local screenGroup         = nil
local spawnTable          = {}
local gCollector          = {}

local myHeight, myWidth = display.contentHeight, display.contentWidth
local myCenterX, myCenterY = myWidth*.5, myHeight*.5

--------------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------------

-- alignContent()
-- onOrientationChange( event )
-- constructScene()
-- rotate()
-- touchScreen(event)

local function alignContent()

	transition.to( screenGroup, { x=(display.contentWidth-myWidth)*.5,y=(display.contentHeight-myHeight)*.5, 
	time=400, delay=0,transition=easing.outQuad})


	if system.orientation == "portrait" or system.orientation == "portraitUpsideDown" then
		
		transition.to( gCollector.title, { y=display.contentHeight*.1, time=400, delay=0,
		transition=easing.outQuad})

		transition.to( gCollector.continue, { y=display.contentHeight*.9, time=400, delay=0,
		transition=easing.outQuad})

	else

		transition.to( gCollector.title, { y=display.contentHeight*.3, time=400, delay=0,
		transition=easing.outQuad})

		transition.to( gCollector.continue, { y=display.contentHeight*1.05, time=400, delay=0,
		transition=easing.outQuad})

	end

end
--------
local function onOrientationChange( event )

 	local delta = event.delta

	if screenGroup.rotation == 0 and delta < 0 then
		local newAngle = delta-screenGroup.rotation
	else
		local newAngle = delta-screenGroup.rotation
	end

	alignContent()
	transition.to( screenGroup, { time=150, rotation=newAngle } )	

end
--------
local function constructScene()

	if myWidth > myHeight then
		myHeight = myWidth
	elseif myHeight > myWidth then
		myWidth = myHeight
	end

	myCenterX, myCenterY = myWidth*.5, myHeight*.5

	-- background
	local img = display.newRect(screenGroup, 0,myCenterY,myWidth*1.5,myHeight*1.5)
	img:setReferencePoint( display.TopLeftReferencePoint )
	img.x,img.y     = 0,myCenterY
	img:setFillColor(32,98,117)

	-- burst animation
	gCollector[#gCollector+1] = {burst=nil}
	gCollector.burst=(uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/home_burst.png",
	name="sun",width=600,height=600,x=myCenterX,y=myCenterY,alpha=1.0,
	reference=display.CenterReferencePoint}))

	gCollector.burst.speed = 1
	gCollector.burst.enterFrame = rotate
	Runtime:addEventListener("enterFrame", gCollector.burst)

	for i=1,30 do

		local x,y 	  = uiObj.randomDirectionDegrees(myCenterX, myCenterY) 
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
			x			= myCenterX,
			y			= myCenterY,
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
	gCollector[#gCollector+1] = {sun=nil}
	gCollector.sun=(uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/home_sunmoon.png",
	name="sun",width=104,height=107,x=myCenterX,y=myCenterY,alpha=0.0,
	reference=display.CenterReferencePoint}))

   	transition.to( gCollector.sun, { time=2000, delay=100, alpha=1.0, } )

   	-- title
   	gCollector[#gCollector+1] = {title=nil}
	gCollector.title = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/home_title.png",
	name="title",width=289,height=49,x=myCenterX,y=myHeight*.1,alpha=0.0,
	reference=display.CenterReferencePoint})

	transition.to( gCollector[#gCollector], { time=2000, delay=0, alpha=1.0, } )

	-- continue button
	gCollector[#gCollector+1] = {continue=nil}
	gCollector.continue = uiObj.insertImage({group=screenGroup,objTable=gCollector,image="images/home_begin.png",
	name="begin",width=104,height=37,x=myCenterX,y=myHeight*.9,alpha=0.0,
	reference=display.CenterReferencePoint})

	transition.to( gCollector.continue, { time=2000, delay=0, alpha=1.0, } )

	alignContent()

end
--------
local function rotate()
	gCollector.burst.rotation = (gCollector.burst.rotation > 360) and 0 or (gCollector.burst.rotation + .1)
end
--------
function touchScreen(event)
	if event.phase == "began" then
		storyboard.gotoScene( "brand", "fade", 400 )
	elseif event.phase == "ended" then
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

	local gCollector          = {}

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


	Runtime:addEventListener("enterFrame",rotate)
	Runtime:addEventListener("touch",touchScreen)
	Runtime:addEventListener( "orientation", onOrientationChange )

	screenGroup:setReferencePoint( display.TopLeftReferencePoint )
	screenGroup.x,screenGroup.y = (display.contentWidth-myWidth)*.5,(display.contentHeight-myHeight)*.5

	constructScene()

	print("MEMORY USED IN SCENE START---------------------------------------------------------")
	print(system.getInfo("textureMemoryUsed")/1024)

end
--------
function scene:exitScene(event)
	




	-- remove listener events
	Runtime:removeEventListener("touch",touchScreen)
	Runtime:removeEventListener("enterFrame", gCollector.burst)
	Runtime:removeEventListener( "orientation", onOrientationChange )
	Runtime:removeEventListener("enterFrame", gCollector.burst)

	-- clean up globals
	screenGroup, spawnTable = nil, nil
	gCollector.burst = nil

	gCollector = {}
end


--------------------------------------------------------------------------------------
-- scene execution
--------------------------------------------------------------------------------------
	

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)



return scene




