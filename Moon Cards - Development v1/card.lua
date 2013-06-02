-----------------------------------------------------------------------------------------
--
-- Moon Cards
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar ) 

-----------------------------------------------------------------------------------------
-- INIT Libraries 
-----------------------------------------------------------------------------------------

	local fileio     = require ("classes.fileio")
	local strObj     = require ("classes.str")
	local uiObj      = require ("classes.ui")
--local easyfb = require ("classes.easyfb")   -- NEEDED LATRE FOR FACEBOOK INTEGRATION
	local json       = require "json"
	local widget     = require( "widget" )
	local easingx    = require("classes.easing")  -- cool library i found- important easing"x"
	local storyboard = require ("storyboard")
	
	require "sprite"
	require "graphics"
	require "display"



-----------------------------------------------------------------------------------------
-- Global Variables 
-----------------------------------------------------------------------------------------

	gRecord       	  = ""
	gPrefs            = ""
	gFileObj          = fileio.new(system.pathForFile( "data/data.txt", system.pathForFile()))
	gPrefsObj         = fileio.new(system.pathForFile( "prefs.txt", system.DocumentsDirectory))
	gMomentum         = {0,0}
	gCardGroup        = display.newGroup()
	gState            = "home" -- home, card, about




-----------------------------------------------------------------------------------------
-- local Variables 
-----------------------------------------------------------------------------------------

	local storyboard = require ("storyboard")
	local scene      = storyboard.newScene()

	local viewRect = {
	 	left   = 0,
	 	top    = 90,
	 	right  = display.viewableContentWidth,
	 	bottom = display.viewableContentHeight-90
	 }

	 local tileWidth   = 107
	 local tileHeight  = 33
	 local dragText    = 0



-----------------------------------------------------------------------------------------
-- faceBook Functions 
-----------------------------------------------------------------------------------------




-----------------------------------------------------------------------------------------
-- local Functions 
-----------------------------------------------------------------------------------------

local function readDataFile(pObject)
	local str = pObject:readFile()

	if str == "" then
		return str
	else
		return json.decode( str)
	end

end
--------
local function saveLangPrefs()

	gTestFile:writeFile(json.encode( gPrefs ))

end
--------
local function initScroll()

	scrollView = widget.newScrollView
	{
		left           = 0,
		top            = display.contentHeight*.15,
		width          = 300, 
		height         = display.contentHeight-200,   -- controls the where the text considers 'bottom'
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
local function selectRecord()

	if #gPrefs.status.remaining == 0 then

		gPrefs.status.remaining = {}
		for i=1,#gPrefs.status.total,1 do
			gPrefs.status.remaining[#gPrefs.status.remaining+1] = gPrefs.status.total[i]
		end

		-- gPrefs.status.remaining = gPrefs.status.total
	end
		
	local recordNum = math.random(#gPrefs.status.remaining)
	gRecord = gScreenText[gPrefs.status.remaining[recordNum]]

	table.remove(gPrefs.status.remaining,recordNum)
	gPrefsObj:writeFile(json.encode( gPrefs ))

end
--------
local function initScreen()
  
  	-- background
	local img   = display.newImageRect(gCardGroup, "images/home_bkg.png", 360, 300)
	img:setReferencePoint( display.CenterReferencePoint )
	img.x = display.contentCenterX
	img.y = display.contentHeight-88

	-- burst animation
	burst       = display.newImageRect(gCardGroup, "images/home_burst.png", 600, 600)
	burst.x     = display.contentCenterX
	burst.y     = display.contentCenterY
	burst.speed = 1

	card = display.newGroup()

  	-- background
	local img   = display.newImageRect(gCardGroup, "images/card_card.png", 320, 428)
	img:setReferencePoint( display.CenterReferencePoint )
	img.x = display.contentCenterX
	img.y = display.contentCenterY-(display.contentHeight*.07)
	img.alpha = 100
	card:insert( img )

	lotsOfTextObject = display.newText( gRecord.text, 0, 0, 200, 0, "Papyrus", 16)
	lotsOfTextObject:setTextColor(0,0,0) 
	lotsOfTextObject:setReferencePoint( display.TopCenterReferencePoint )
	lotsOfTextObject.x = display.contentCenterX
	lotsOfTextObject.y = 10
	lotsOfTextObject.name = "text"
	scrollView:insert( lotsOfTextObject )
	scrollView.name = "body"

	local mask = graphics.newMask( "images/mask.png" )
	scrollView:setMask( mask )

	scrollView:setReferencePoint( display.CenterReferencePoint )
	scrollView.maskX = display.contentCenterX
	scrollView.maskY = 134

	card:insert(scrollView)
	card.y = display.contentCenterY-(display.contentHeight*.6)
	card.alpha = 0

	gCardGroup:insert(card)

 	-- banner
 	local banner = display.newGroup()
	local img   = display.newImageRect(banner, "images/card_banner.png", 340, 82)
	img:setReferencePoint( display.CenterReferencePoint )
	img.x = display.contentCenterX
	img.y = display.contentCenterY-(display.contentHeight*.36)

	banner:insert(img)

	bannerText = display.newText( banner, 
		gRecord.title, 
		display.contentWidth*.5, 
		display.contentCenterY-(display.contentHeight*.39), 
		"Papyrus", 16 )

	bannerText:setReferencePoint(display.CenterReferencePoint)
	bannerText.x = display.contentCenterX
	bannerText:setTextColor(255, 255, 255)

	banner:insert(bannerText)

	gCardGroup:insert(banner)
	banner.alpha = 0
	banner.y = display.contentCenterY-(display.contentHeight*.55)

	transition.to( banner, { x=banner.x, 
		y=display.contentCenterY-(display.contentHeight*.49), 
		time=2000, 
		delay=300,
		transition=easingx.easeOutElastic, 
		alpha=1.0, } )

end
--------
local function makeModel(pState)

	if pState == 1 then
		model = display.newRect(0, 0, 960, 440)
		model:setReferencePoint(display.TopLeftReferencePoint)
		model.x = 0
		model.alpha = 0.0
		model.isHitTestable = true -- Only needed if alpha is 0
		model:addEventListener("touch", function() return true end)
		model:addEventListener("tap", function() return true end)
	else
		if model ~= nil then
			model:removeSelf( )
			model = nil
		end
	end

end
--------
local function updateUI()

	if card.y < 0 then

	transition.to( card, { x=card.x, 
		 y=display.contentCenterY-(display.contentHeight*.47), 
		 time=300, 
		 delay=2,
		 transition=easing.outQuad , 
		 alpha=1.0 })
	end

end
--------
local function refreshScreen()

	selectRecord()
	lotsOfTextObject.text = gRecord.text
	scrollView:scrollToPosition({x = 1,y = 0,time = 0})
	
	lotsOfTextObject:setReferencePoint( display.TopCenterReferencePoint )
	lotsOfTextObject.x    = display.contentCenterX
	lotsOfTextObject.y    = 10

	bannerText.text = gRecord.title

end
--------
local function killPopup()

	popup:removeSelf( )
	popup = nil

end
--------
local function gowebsite(event)

	if event.phase == "ended" then
		system.openURL("www.evergreentherapies.com")
	end
end
--------
local pressButton = function( event )

	if event.target.id == "about" and event.phase == "ended" then
		
		if popup ~= nil then

			makeModel(0)
			transition.to( popup, {time=300, delay=2, transition=easing.inQuad, onComplete = killPopup, alpha=0 })
	
		else

		makeModel(1)
			popup = display.newGroup()
			local img   = display.newImageRect(popup, "images/popup.png", 313, 302)
			img:setReferencePoint( display.CenterReferencePoint )
			img.x = 156
			img.y = 151
			img.alpha = 1.0
			popup:insert(img)

			local pText    = "Melissa Granchi is a Psychotherapist, Wellness \n Consultant, and Yoga Teacher. Utilizing her \ntraining in psychology, Yoga and nutrition, \nMelissa guides you in the integration of your \nbody, mind and soul. \n\nFor additional information please go to:"
			local pTextObj = display.newText( popup, pText, 0,  0, "Papyrus", 12 )

			pTextObj:setReferencePoint(display.TopLeftReferencePoint)
			pTextObj.x     = 30
			pTextObj.y     = 30
			pTextObj:setTextColor(70, 70, 70)

			popup:insert(pTextObj)

-- look into stage:setFocus( object [,touchID] ) for touch issue

			local h = pTextObj.height+30
			weblink = display.newText( popup, "www.evergreentherapies.com", 0,  0, "Papyrus", 12 )
			weblink:setReferencePoint(display.TopLeftReferencePoint)
			weblink.x = 30
			weblink.y = h 
			weblink:setTextColor(196, 94, 51)

			weblink:addEventListener("touch", gowebsite)
			popup:insert(weblink)

			popup:setReferencePoint( display.BottomCenterReferencePoint )
			popup.x = display.contentCenterX + 10
			popup.y = display.contentHeight - 30

			transition.from( popup, { 
		 	time=300, 
		 	delay=2,
		 	transition=easing.inQuad,
		 	alpha=0 })

		end

	elseif event.target.id == "refresh" and event.phase == "ended" then

	if popup ~= nil then

			makeModel(0)
			transition.to( popup, {time=300, delay=2, transition=easing.inQuad, onComplete = killPopup, alpha=0 })
	
		end

		card.y=-20
		card.alpha = 0
		refreshScreen()
	elseif event.target.id == "fb" and event.phase == "ended" then

	end

end
--------
local function loadButtons()

	local btnPanel = display.newGroup()

	local img   = display.newRect(0,0,640,100)
	img.strokeWidth = 0
	img:setFillColor(32,98,117)
	
	img.x = 20
	img.y = 30
	img:setReferencePoint( display.TopCenterReferencePoint )

	btnPanel:insert(img)

	local btn = widget.newButton
	{
		id          = "about",
		width       = 103,
		height      = 40,
		defaultFile = "images/card_about0.png",
		overFile = "images/card_about1.png",
		onEvent = pressButton,
	}

	btn.x = 0
	btn.y = 0

	btnPanel:insert(btn)

	local btn = widget.newButton
	{
		id = "refresh",
		width = 118,
		height = 40,
		defaultFile = "images/card_refresh0.png",
		overFile = "images/card_refresh1.png",
		onEvent = pressButton,
	}

	btn.x = 110
	btn.y = 0

	btnPanel:insert(btn)

	local btn = widget.newButton
	{
		id = "fb",
		width = 100,
		height = 40,
		defaultFile = "images/card_share0.png",
		overFile = "images/card_share1.png",
		onEvent = pressButton,
	}

	btn.x = 103+118
	btn.y = 0

	btnPanel:insert(btn)
	btnPanel:setReferencePoint( display.TopCenterReferencePoint )
	btnPanel.x = display.contentCenterX - 88 
	btnPanel.y = display.contentHeight - 40
 end

-----------------------------------------------------------------------------------------
-- storyboard Functions 
-----------------------------------------------------------------------------------------

function scene:createScene(event)
	local screenGroup = self.view

    

	gScreenText = readDataFile(gFileObj)
	gPrefs      = readDataFile(gPrefsObj)

	if gPrefs == "" then

		local tmpFileObj    = fileio.new(system.pathForFile( "data/prefs.txt", system.pathForFile()))
		local prefsTemplate = fileio.readFile(tmpFileObj, "")

		gPrefsObj:writeFile(prefsTemplate)
		gPrefs = readDataFile(gPrefsObj)

	end

	initScroll()
	selectRecord()
	initScreen()
	loadButtons()

end


function touchScreen(event)

end

--------------------------------------------------------------------------------------
-- INIT storyboard scene
--------------------------------------------------------------------------------------

function scene:enterScene(event)

	Runtime:addEventListener("touch",touchScreen)

end
--------
function scene:exitScene(event)

	Runtime:removeEventListener("touch",touchScreen)
end
--------
function scene:destroyScene(event)

	Runtime:removeEventListener("touch",touchScreen)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

Runtime:addEventListener("enterFrame",updateUI)

return scene





