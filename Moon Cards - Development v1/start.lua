

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------

local storyboard = require ("storyboard")
local scene      = storyboard.newScene()
local physics    = require "physics"
local uiObj      = require ("classes.ui")

physics.start()
physics.setGravity(0,0 )

--------------------------------------------------------------------------------------
-- local variable declaritions
--------------------------------------------------------------------------------------

screenGroup         = nil
spawnTable          = {}
local gCollector    = {}

local myHeight, myWidth = display.contentHeight, display.contentWidth
local myCenterX, myCenterY = myWidth*.5, myHeight*.5

--------------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------------

local function onOrientationChange( event )

	print("Change")
 	local delta = event.delta

	if screenGroup.rotation == 0 and delta < 0 then
		local newAngle = delta-screenGroup.rotation
	else
		local newAngle = delta-screenGroup.rotation
	end

	screenGroup.x,screenGroup.y = (display.contentWidth-myWidth)*.5,(display.contentHeight-myHeight)*.5
	transition.to( screenGroup, { time=150, rotation=newAngle } )

	gCollector.title.y = display.contentHeight*.2

end
--------
function constructScene()

	if myWidth > myHeight then
		myHeight = myWidth
	elseif myHeight > myWidth then
		myWidth = myHeight
	end

	myCenterX, myCenterY = myWidth*.5, myHeight*.5

	-- background
	local img = display.newRect(screenGroup, 0,myCenterY,myWidth,myHeight*.5)
	img:setReferencePoint( display.TopLeftReferencePoint )
	img.x,img.y     = 0,myCenterY
	img:setFillColor(32,98,117)

	-- burst animation
	burst             = display.newImageRect(screenGroup, "images/home_burst.png", 600, 600)
	burst.x, burst.y  = myCenterX,myCenterY
	burst.speed = 1
	burst.enterFrame = rotate
	Runtime:addEventListener("enterFrame", burst)

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

end


--------------------------------------------------------------------------------------
-- INIT storyboard scene
--------------------------------------------------------------------------------------


--------
local function rotate()

	burst.rotation = (burst.rotation > 360) and 0 or (burst.rotation + .1)
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

	Runtime:addEventListener("enterFrame",rotate)
	Runtime:addEventListener("touch",touchScreen)
	screenGroup:setReferencePoint( display.TopLeftReferencePoint )
	screenGroup.x,screenGroup.y = (display.contentWidth-myWidth)*.5,(display.contentHeight-myHeight)*.5


	constructScene()

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
	Runtime:removeEventListener( "orientation", onOrientationChange )

	-- clean up globals

	burst:removeSelf( )
	burst = nil
	--spawnTable:removeSelf( )
	screenGroup:removeSelf()
	screenGroup,burst, spawnTable = nil, nil, nil

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




