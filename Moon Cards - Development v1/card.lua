-- Development by Matthew Maday
-- DBA - Weekend Warrior Collective
-- a 100% not-for-profit developer collective

-- This is the opening scene

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------

	local fileio     = require ("classes.fileio")
	local strObj     = require ("classes.str")
	local uiObj      = require ("classes.ui")
--local easyfb = require ("classes.easyfb")   -- NEEDED LATRE FOR FACEBOOK INTEGRATION
	local json       = require "json"
	local widget     = require( "widget" )
	local easingx    = require("classes.easing")  -- cool library i found- important easing"x"
	local storyboard = require ("storyboard")


-----------------------------------------------------------------------------------------
-- Global Variables 
-----------------------------------------------------------------------------------------

	gRecord       	  = ""
	gPrefs            = ""
	gPrefsObj         = fileio.new(system.pathForFile( "prefs.txt", system.DocumentsDirectory))
	
	local gCollector           = {}
	local screenGroup          = display.newGroup()
	local scene                = storyboard.newScene()

	local myHeight, myWidth    = display.contentHeight, display.contentWidth
	local myCenterX, myCenterY = myWidth*.5, myHeight*.5


-----------------------------------------------------------------------------------------
-- faceBook Functions 
-----------------------------------------------------------------------------------------




-----------------------------------------------------------------------------------------
-- local Functions 
-----------------------------------------------------------------------------------------

local function alignContent()

	screenGroup.x,screenGroup.y = (display.contentWidth-myWidth)*.5,(display.contentHeight-myHeight)*.5

	if system.orientation == "portrait" or system.orientation == "portraitUpsideDown" then
		gCollector.card.x = myCenterX
		gCollector.card.xScale,gCollector.card.yScale = 1.0,1.0
		gCollector.card.y = myCenterY-(myHeight*.07)
		
	else
		gCollector.card.x = myCenterX-(myWidth*.2)
		gCollector.card.xScale,gCollector.card.yScale = .75,.75
		gCollector.card.y = myCenterY-(myHeight*.01)
		
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
local function readDataFile(pObject)
	local str = pObject:readFile()

	if str == "" then
		return str
	else
		return json.decode( str)
	end

end
--------
local function initExternalData()

	local pFile  = fileio.new(system.pathForFile( "data/data.txt", system.pathForFile()))
	gScreenText  = readDataFile(pFile)
	gPrefs       = readDataFile(gPrefsObj)

	if gPrefs == "" then

		local tmpFileObj    = fileio.new(system.pathForFile( "data/prefs.txt", system.pathForFile()))
		local prefsTemplate = fileio.readFile(tmpFileObj, "")

		pPrefs:writeFile(prefsTemplate)
		gPrefs = readDataFile(gPrefsObj)

	end
end
--------

local function selectRecord()

	if #gPrefs.status.remaining == 0 then

		gPrefs.status.remaining = {}
		for i=1,#gPrefs.status.total,1 do
			gPrefs.status.remaining[#gPrefs.status.remaining+1] = gPrefs.status.total[i]
		end

	end
		
	local recordNum = math.random(#gPrefs.status.remaining)
	gRecord = gScreenText[gPrefs.status.remaining[recordNum]]

	table.remove(gPrefs.status.remaining,recordNum)
	gPrefsObj:writeFile(json.encode( gPrefs ))

end
--------
local function initScroll()

	gCollector[#gCollector+1] = {text=nil}
	gCollector.text = widget.newScrollView
	{
		left           = 0,
		top            = myHeight*.15,
		width          = 300, 
		height         = myHeight-200,   -- controls the where the text considers 'bottom'
		bottomPadding  = 140,
		hideBackground = true,
		id             = "onBottom",
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		listener = scrollListener,
	}

end
--------
local function reduceToZero(num,inc)

	local r = 0

	if num > 0 then
		r = num-inc
	else
		r = num+inc
	end

	if math.abs(r) <= inc then
		return 0
	else 
		return r
	end

end
--------
local function initScreen()
  



	

	

 

end
--------
local function makeModel(pState)

	-- if pState == 1 then
	-- 	model = display.newRect(0, 0, 960, 440)
	-- 	model:setReferencePoint(display.TopLeftReferencePoint)
	-- 	model.x = 0
	-- 	model.alpha = 0.0
	-- 	model.isHitTestable = true -- Only needed if alpha is 0
	-- 	model:addEventListener("touch", function() return true end)
	-- 	model:addEventListener("tap", function() return true end)
	-- else
	-- 	if model ~= nil then
	-- 		model:removeSelf( )
	-- 		model = nil
	-- 	end
	-- end

end
--------
local function updateUI()

	-- if gCollector.card.y < 0 then

	-- transition.to( gCollector.card, { x=gCollector.card.x, 
	-- 	 y=myCenterY-(myHeight*.47), 
	-- 	 time=300, 
	-- 	 delay=2,
	-- 	 transition=easing.outQuad , 
	-- 	 alpha=1.0 })
	-- end

end
--------
local function refreshScreen()

	-- selectRecord()
	-- lotsOfTextObject.text = gRecord.text
	-- scrollView:scrollToPosition({x = 1,y = 0,time = 0})
	
	-- lotsOfTextObject:setReferencePoint( display.TopCenterReferencePoint )
	-- lotsOfTextObject.x    = myCenterX
	-- lotsOfTextObject.y    = 10

	-- bannerText.text = gRecord.title

end
--------
local function killPopup()

	-- popup:removeSelf( )
	-- popup = nil

end
--------
local function gowebsite(event)

	-- if event.phase == "ended" then
	-- 	system.openURL("www.evergreentherapies.com")
	-- end
end
--------
local pressButton = function( event )

-- 	if event.target.id == "about" and event.phase == "ended" then
		
-- 		if popup ~= nil then

-- 			makeModel(0)
-- 			transition.to( popup, {time=300, delay=2, transition=easing.inQuad, onComplete = killPopup, alpha=0 })
	
-- 		else

-- 		makeModel(1)
-- 			popup = display.newGroup()
-- 			local img   = display.newImageRect(popup, "images/popup.png", 313, 302)
-- 			img:setReferencePoint( display.CenterReferencePoint )
-- 			img.x = 156
-- 			img.y = 151
-- 			img.alpha = 1.0
-- 			popup:insert(img)

-- 			local pText    = "Melissa Granchi is a Psychotherapist, Wellness \n Consultant, and Yoga Teacher. Utilizing her \ntraining in psychology, Yoga and nutrition, \nMelissa guides you in the integration of your \nbody, mind and soul. \n\nFor additional information please go to:"
-- 			local pTextObj = display.newText( popup, pText, 0,  0, "Papyrus", 12 )

-- 			pTextObj:setReferencePoint(display.TopLeftReferencePoint)
-- 			pTextObj.x     = 30
-- 			pTextObj.y     = 30
-- 			pTextObj:setTextColor(70, 70, 70)

-- 			popup:insert(pTextObj)

-- -- look into stage:setFocus( object [,touchID] ) for touch issue

-- 			local h = pTextObj.height+30
-- 			weblink = display.newText( popup, "www.evergreentherapies.com", 0,  0, "Papyrus", 12 )
-- 			weblink:setReferencePoint(display.TopLeftReferencePoint)
-- 			weblink.x = 30
-- 			weblink.y = h 
-- 			weblink:setTextColor(196, 94, 51)

-- 			weblink:addEventListener("touch", gowebsite)
-- 			popup:insert(weblink)

-- 			popup:setReferencePoint( display.BottomCenterReferencePoint )
-- 			popup.x = myCenterX + 10
-- 			popup.y = myHeight - 30

-- 			transition.from( popup, { 
-- 		 	time=300, 
-- 		 	delay=2,
-- 		 	transition=easing.inQuad,
-- 		 	alpha=0 })

-- 		end

-- 	elseif event.target.id == "refresh" and event.phase == "ended" then

-- 	if popup ~= nil then

-- 			makeModel(0)
-- 			transition.to( popup, {time=300, delay=2, transition=easing.inQuad, onComplete = killPopup, alpha=0 })
	
-- 		end

-- 		gCollector.card.y=-20
-- 		gCollector.card.alpha = 0
-- 		refreshScreen()
-- 	elseif event.target.id == "fb" and event.phase == "ended" then

-- 	end

end
--------
local function loadButtons()

	-- local btnPanel = display.newGroup()

	-- local img   = display.newRect(0,0,640,100)
	-- img.strokeWidth = 0
	-- img:setFillColor(32,98,117)
	
	-- img.x = 20
	-- img.y = 30
	-- img:setReferencePoint( display.TopCenterReferencePoint )

	-- btnPanel:insert(img)

	-- local btn = widget.newButton
	-- {
	-- 	id          = "about",
	-- 	width       = 103,
	-- 	height      = 40,
	-- 	defaultFile = "images/card_about0.png",
	-- 	overFile = "images/card_about1.png",
	-- 	onEvent = pressButton,
	-- }

	-- btn.x = 0
	-- btn.y = 0

	-- btnPanel:insert(btn)

	-- local btn = widget.newButton
	-- {
	-- 	id = "refresh",
	-- 	width = 118,
	-- 	height = 40,
	-- 	defaultFile = "images/card_refresh0.png",
	-- 	overFile = "images/card_refresh1.png",
	-- 	onEvent = pressButton,
	-- }

	-- btn.x = 110
	-- btn.y = 0

	-- btnPanel:insert(btn)

	-- local btn = widget.newButton
	-- {
	-- 	id = "fb",
	-- 	width = 100,
	-- 	height = 40,
	-- 	defaultFile = "images/card_share0.png",
	-- 	overFile = "images/card_share1.png",
	-- 	onEvent = pressButton,
	-- }

	-- btn.x = 103+118
	-- btn.y = 0

	-- btnPanel:insert(btn)
	-- btnPanel:setReferencePoint( display.TopCenterReferencePoint )
	-- btnPanel.x = myCenterX - 88 
	-- btnPanel.y = myHeight - 40
 end

-----------------------------------------------------------------------------------------
-- storyboard Functions 
-----------------------------------------------------------------------------------------
local function constructCard()

	-- create the card display group
	gCollector[#gCollector+1] = {card=nil}
	gCollector.card = display.newGroup()

  	-- Insert the card background
	local bkg    = display.newImageRect(gCollector.card, "images/card_card.png", 320, 428)
	bkg:setReferencePoint( display.TopLeftReferencePoint )
	bkg.x, bkg.y, bkg.alpha = 0,0,100
	gCollector.card:insert( bkg )
	screenGroup:insert(gCollector.card)
	gCollector.card:setReferencePoint( display.CenterReferencePoint )
	gCollector.card.x, gCollector.card.y = myCenterX, myCenterY-(myHeight*.07)

	-- insert the text that scrolls within the card
	local pText = display.newText( gRecord.text, 0, 0, 200, 0, "Papyrus", 16)
	pText:setTextColor(0,0,0) 
	pText:setReferencePoint( display.TopLeftReferencePoint )
	pText.x, pText.y = pText.width*.2, 0
	gCollector.text:insert( pText )
	gCollector.card:insert( gCollector.text )

	-- insert the mask that sits over the text within the card
	local mask = graphics.newMask( "images/mask.png" )
	gCollector.text:setMask( mask )
	gCollector.text.maskX = bkg.width*.5
	gCollector.text.maskY = bkg.height*.33

end
--------
local function constructBanner()

	-- create the card display group
	gCollector[#gCollector+1] = {banner=nil}
	gCollector.banner = display.newGroup()

  	-- Insert the banner background
	local bkg    = display.newImageRect(gCollector.banner, "images/card_banner.png", 340, 82)
	bkg:setReferencePoint( display.TopLeftReferencePoint )
	bkg.x, bkg.y, bkg.alpha = 0,0,100
	gCollector.banner:insert( bkg )
	screenGroup:insert(gCollector.banner)
	gCollector.banner:setReferencePoint( display.CenterReferencePoint )
	gCollector.banner.x, gCollector.banner.y = myCenterX, myCenterY-(myHeight*.4)

 	-- Insert the banner text
	bannerText = display.newText( gCollector.banner, gRecord.title, display.contentWidth*.5, myCenterY-(myHeight*.39), "Papyrus", 16 )

	-- bannerText:setReferencePoint(display.CenterReferencePoint)
	-- bannerText.x = myCenterX
	-- bannerText:setTextColor(255, 255, 255)

	-- banner:insert(bannerText)

	-- screenGroup:insert(banner)
	-- banner.alpha = 0
	-- banner.y = myCenterY-(myHeight*.55)

	-- transition.to( banner, { x=banner.x, 
	-- 	y=display.contentCenterY-(myHeight*.49), 
	-- 	time=2000, 
	-- 	delay=300,
	-- 	transition=easingx.easeOutElastic, 
	-- 	alpha=1.0, } )

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
	local img = display.newRect(screenGroup, 0,myCenterY,myWidth,myHeight*.5)
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
	
	constructCard()
	constructBanner()
	alignContent()

end
--------
local function rotate()
	gCollector.burst.rotation = (gCollector.burst.rotation > 360) and 0 or (gCollector.burst.rotation + .1)
end

function touchScreen(event)

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

	Runtime:removeEventListener("touch",touchScreen)
end
--------
function scene:destroyScene(event)

	Runtime:removeEventListener("touch",touchScreen)

end

--------------------------------------------------------------------------------------
-- scene execution
--------------------------------------------------------------------------------------

	initExternalData()
	initScroll()
	selectRecord()
	-- initScreen()
	-- loadButtons()

Runtime:addEventListener( "orientation", onOrientationChange )
scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

Runtime:addEventListener("enterFrame",updateUI)

return scene





