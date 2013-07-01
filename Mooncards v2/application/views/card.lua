-- General Title Class

LoadCard = {}

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------

function LoadCard:new(params)

	local screen   = display.newGroup()
	
	------------------------------------------------------------------------------------------
	-- Primary Views
	------------------------------------------------------------------------------------------

	-- initialize()
	-- show()
	-- hide()

	local function onOrientationChange( event )

		if screen == nil then return -1 end
		if screen.state ~= "idle" then return -1 end

	 	local delta = event.delta

		if screen.rotation == 0 and delta < 0 then
			local newAngle = delta-screen.rotation
		else
			local newAngle = delta-screen.rotation
		end

		transition.to( screen, { x=(display.contentWidth-screen.myWidth)*.5,y=0, time=400, delay=0,alpha=1.0,transition=easing.outQuad,rotation=newAngle})
	
		screen:alignContent()

	end

	--------
	function screen:initialize(params, event)

		self.images       = {}
		self.texts		  = {} 			
		self.listeners    = {}
		self.groups       = {}
		self.timer        = nil
		self.tween        = nil
		self.myWidth	  = display.contentHeight
		self.myHeight     = display.contentWidth
		self.starSpeed    = 2
		self.starDegree   = 150

		if self.myWidth > self.myHeight then
			self.myHeight = self.myWidth
		elseif self.myHeight > self.myWidth then
			self.myWidth = self.myHeight
		end

		self.centerX, self.centerY = self.myWidth*.5, self.myHeight*.5

		-- create the card display group
		self.groups[#self.groups+1] = {card=nil}
		self.groups.card = display.newGroup()

	  	-- Insert the card background
	  	self.images[#self.images+1] = {cardBkg=nil}
		self.images.cardBkg = display.newImageRect(self.groups.card, "content/images/card_card.png", 320, 428)
		self.images.cardBkg:setReferencePoint( display.TopLeftReferencePoint )
		self.images.cardBkg.x, self.images.cardBkg.y, self.images.cardBkg.alpha = 0,0,100
		self.groups.card:insert( self.images.cardBkg )
		screen:insert(self.groups.card)

		self.groups.card:setReferencePoint( display.CenterReferencePoint )
		self.groups.card.x, self.groups.card.y =self.centerX, self.centerY-(self.myHeight*.07)

		-- banner
		self.images[#self.images+1] = {bannerBkg=nil}
		self.images.bannerBkg = display.newImageRect("content/images/card_banner.png", 340, 82) 
		self.images.bannerBkg.x, self.images.bannerBkg.y, self.images.bannerBkg.alpha = self.groups.card.width*.5, -20, 0
		self.images.bannerBkg:setReferencePoint(display.CenterReferencePoint)
		self.groups.card:insert(self.images.bannerBkg)

		transition.to( self.images.bannerBkg, { time=1000, y=50, delay=0, alpha=1.0,transition=easing.outQuad} )

		-- banner text
		self.texts[#self.texts+1] = {banner=nil}
		self.texts.banner = display.newText( self.groups.card, gRecord.title,  self.groups.card.width*.5, -20, "Papyrus", 16 )
		self.texts.banner.x, self.texts.banner.y, self.texts.banner.alpha = self.groups.card.width*.5, -20, 0
		self.texts.banner:setReferencePoint(display.CenterReferencePoint)


		transition.to( self.texts.banner, { time=1000, y=50, delay=0, alpha=1.0,transition=easing.outQuad} )




	-- self.texts.banner = display.newText( self.texts.banner, gRecord.title,  display.contentWidth*.5, myCenterY-(myHeight*.39), "Papyrus", 16 )
	-- self.texts.banner:setReferencePoint(display.CenterReferencePoint)
	-- self.texts.banner:setTextColor(255, 255, 255)
	
	-- self.texts.banner.x,self.texts.banner.y = self.texts.banner.width*.5, self.texts.banner.height*.44


 -- 	-- Insert the banner text
 -- 	gCollector[#gCollector+1] = {bannerText=nil}
	-- gCollector.bannerText = display.newText( gCollector.banner, gRecord.title,  display.contentWidth*.5, myCenterY-(myHeight*.39), "Papyrus", 16 )
	-- gCollector.bannerText:setReferencePoint(display.CenterReferencePoint)
	-- gCollector.bannerText:setTextColor(255, 255, 255)
	-- gCollector.bannerText.x,gCollector.bannerText.y = gCollector.banner.width*.5, gCollector.banner.height*.44

	-- gCollector.banner:insert(gCollector.bannerText)



		-- create body text block
		-- self.texts[#self.texts+1] = {body=nil}
		-- self.texts.body = display.newText( gRecord.text, 0, 0, 200, 0, "Papyrus", 16)
		-- self.texts.body:setTextColor(0,0,0) 
		-- self.texts.body:setReferencePoint( display.TopLeftReferencePoint )
		-- self.texts.body.x, self.texts.body.y = self.texts.body.width*.2, 0


		-- -- blue image at the bottom of the screen
		-- self.images[#self.images+1] = {blackRect=nil}
		-- self.images.blackRect = display.newRect(screen, 0,0,self.myWidth*1.5,self.myHeight)
		-- self.images.blackRect:setReferencePoint( display.TopLeftReferencePoint )
		-- self.images.blackRect.x,self.images.blackRect.y = 0,self.centerY
		-- self.images.blackRect:setFillColor(32,98,117)
		-- self:insert(self.images.blackRect)



-- insert the text that scrolls within the card
	-- if gCollector.cardText ~= nil then
	-- 	gCollector.cardText:removeSelf( )
	-- 	gCollector.cardText = nil
	-- else
	-- 	gCollector[#gCollector+1] = {cardText=nil}
	-- end

	-- selectRecord()








	-- gCollector.cardText = display.newText( gRecord.text, 0, 0, 200, 0, "Papyrus", 16)
	-- gCollector.cardText:setTextColor(0,0,0) 
	-- gCollector.cardText:setReferencePoint( display.TopLeftReferencePoint )
	-- gCollector.cardText.x, gCollector.cardText.y = gCollector.cardText.width*.2, 0
	
	


	-- gCollector[#gCollector+1] = {text=nil}
	-- gCollector.text = widget.newScrollView
	-- {left=0,top=0,width=280,height=277,scrollWidth=400,scrollHeight=277,bottomPadding=0,hideBackground=true,id="onBottom",
	-- 	horizontalScrollDisabled = true,verticalScrollDisabled = false,listener = scrollListener,}

	-- gCollector.text:insert( gCollector.cardText )
	-- gCollector.card:insert( gCollector.text )
	-- gCollector.text.x, gCollector.text.y = 0,100

	-- -- insert the mask that sits over the text within the card
	-- local mask = graphics.newMask( "images/mask.png" )
	-- gCollector.text:setMask( mask )
	-- gCollector.text.maskX,gCollector.text.maskY = gCollector.cardBkg.width*.5,gCollector.cardBkg.height*.26









		screen:alignContent()
		
		self.state = "idle"
	end
	--------
	function screen:show(time)

		transition.to(self, {time = time, alpha = 1, onComplete = function()
			screen.state = "idle"
		end
		})
	end
	--------
	function screen:hide(time)
		transition.to(self, {time = time, alpha = 0, onComplete = function()
			screen.state = "paused"
		end
		})
	end	
	--------
	function screen:activate()

		Runtime:addEventListener( "orientation", onOrientationChange )

	end
	--------
	function screen:process()

		if self.state ~= "idle" then return -1 end
		-- self.images.burst.rotation = (self.images.burst.rotation > 360) and 0 or (self.images.burst.rotation + .1)


   end
	--------
	function screen:pause()

		if self.state == "idle" then
			self.state = "paused"
		elseif self.state == "paused" then
			self.state = "idle"
		end 

	end	
	--------
	function screen:destory()

		local pEnd = #self.images
		
		--screen.texts.body:removeSelf()
		screen.groups.card:removeSelf()
		screen.images.cardBkg:removeSelf()

		screen.texts.body = nil
		screen.groups.card = nil
		screen.images.cardBkg = nil


		screen:removeSelf()
		screen = nil
	end
	--------
	function screen:transitionAwayFrom()

		if self.state ~= "idle" then return -1 end

		self.state = "paused"
		Runtime:removeEventListener( "orientation", onOrientationChange )
		

		transition.to( screen, { time=400, delay=0,alpha=0,transition=easing.outQuad, onComplete = function()
			screen:destory()
		end
		})

		goToScene(4)

	end	
	--------
	function screen:timeout()
		-- not used in this scene
	end
	--------

	--------
	function screen:alignContent()

	screen.x,screen.y = (display.contentWidth-self.myWidth)*.5,(display.contentHeight-self.myHeight)*.5

		if system.orientation == "portrait" or system.orientation == "portraitUpsideDown" then
			
			--card

			if self.groups.card.tween ~= nil then
				transition.cancel(self.groups.card.tween)
				self.groups.card.tween = nil
			end

			self.groups.card.xScale,self.groups.card.yScale, self.groups.card.alpha = 1.0,1.0,.5
			self.groups.card.tween = transition.to( self.groups.card, { x= self.centerX,y=self.centerY-(self.myHeight*.07), 
				time=400, delay=0,alpha=1.0,transition=easing.outQuad, onComplete=function()
				transition.cancel(screen.groups.card.tween)
				end
			}) 

			-- banner
			self.images.bannerBkg.y = -20
			transition.to( self.images.bannerBkg, { time=1000, y=50, delay=0, alpha=1.0,transition=easing.outQuad} )
			

			-- -- banner
			-- transition.cancel( gCollector.banner )
			-- gCollector.banner.xScale,gCollector.banner.yScale = 1.0,1.0
			-- transition.to( gCollector.banner, { x= self.centerX,y=self.centerY-(myHeight*.38), time=400, delay=0,alpha=1.0,
			-- transition=easing.outQuad})

			-- -- buttons
			-- transition.cancel( gCollector.buttons )
			-- gCollector.buttons.x, gCollector.buttons.y,gCollector.buttons.rotation = 0, myHeight,0
			-- transition.to( gCollector.buttons, { x= 0,y=myHeight-40, time=400, delay=0,alpha=1.0,
			-- transition=easing.outQuad})

		else

			-- card

			if self.groups.card.tween ~= nil then
				transition.cancel(self.groups.card.tween)
				self.groups.card.tween = nil
			end

			self.groups.card.xScale,self.groups.card.yScale, self.groups.card.alpha = .75,.75, .5
			self.groups.card.tween = transition.to( self.groups.card, { x= self.centerX-(self.myWidth*.2),y=self.centerY-(self.myHeight*.14), 
				time=400, delay=0,alpha=1.0,transition=easing.outQuad, onComplete=function()
				transition.cancel(screen.groups.card.tween)
				end
			})
			
			-- banner
			self.images.bannerBkg.y = -20
			transition.to( self.images.bannerBkg, { time=1000, y=50, delay=0, alpha=1.0,transition=easing.outQuad} )

			-- transition.cancel( gCollector.banner )
			-- gCollector.banner.xScale,gCollector.banner.yScale = .75,.75
			-- transition.to( gCollector.banner, { x= self.centerX-(myWidth*.2), y=self.centerY-(myHeight*.24), time=400, delay=0,alpha=1.0,
			-- transition=easing.outQuad})

			-- -- buttons
			-- transition.cancel( gCollector.buttons )
			-- gCollector.buttons.x, gCollector.buttons.y,gCollector.buttons.rotation = myWidth, gCollector.buttons.width,-90
			-- transition.to( gCollector.buttons, { x= myWidth-40,y=gCollector.buttons.width, time=400, delay=0,alpha=1.0,
			-- transition=easing.outQuad})

		end

	end
	--------

	Runtime:addEventListener( "orientation", onOrientationChange )

	screen:initialize(params)
	return screen

end

return LoadCard
