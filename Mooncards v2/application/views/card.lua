-- General Card View

-- Moon cards version 2
-- Development by Matthew Maday
-- DBA - Weekend Warrior Collective
-- a 100% not-for-profit developer collective

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
		self.groups       = {}
		self.timer        = nil
		self.tween        = nil
		self.myWidth	  = display.contentHeight
		self.myHeight     = display.contentWidth

		if self.myWidth > self.myHeight then
			local tmp     = self.myWidth
			self.myWidth  = self.myHeight
			self.myHeight = tmp
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
		self.texts.banner.x, self.texts.banner.y, self.texts.banner.alpha = self.groups.card.width*.5, -12, 0
		self.texts.banner:setReferencePoint(display.CenterReferencePoint)

		transition.to( self.texts.banner, { time=1000, y=44, delay=0, alpha=1.0,transition=easing.outQuad} )

		transition.to( screen, { x=(display.contentWidth-screen.myWidth)*.5,y=0, time=400, delay=0,alpha=1.0,transition=easing.outQuad})
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
	function screen:alignContent()

	screen.x,screen.y = (display.contentWidth-self.myWidth)*.5,(display.contentHeight-self.myHeight)*.5

		if system.orientation == "portrait" or system.orientation == "portraitUpsideDown" then
			
			--card
			if self.groups.card.tween ~= nil then
				transition.cancel(self.groups.card.tween)
				self.groups.card.tween = nil
			end

			self.groups.card.xScale,self.groups.card.yScale, self.groups.card.alpha = 1.0,1.0,.5
			self.groups.card.tween = transition.to( self.groups.card, { x= self.centerX,y=self.centerY-30, 
				time=400, delay=0,alpha=1.0,transition=easing.outQuad, onComplete=function()
				transition.cancel(screen.groups.card.tween)
				end
			}) 

			-- banner
			self.images.bannerBkg.y = -20
			transition.to( self.images.bannerBkg, { time=1000, y=50, delay=0, alpha=1.0,transition=easing.outQuad} )
			
			-- banner text
			self.texts.banner.y = -20
			transition.to( self.texts.banner, { time=1000, y=44, delay=0, alpha=1.0,transition=easing.outQuad} )

		else

			-- card

			if self.groups.card.tween ~= nil then
				transition.cancel(self.groups.card.tween)
				self.groups.card.tween = nil
			end

			self.groups.card.xScale,self.groups.card.yScale, self.groups.card.alpha = .75,.75, .5
			self.groups.card.tween = transition.to( self.groups.card, { x= 80 ,y=self.centerX, 
				time=400, delay=0,alpha=1.0,transition=easing.outQuad, onComplete=function()
				transition.cancel(screen.groups.card.tween)
				end
			})
			
			-- banner
			self.images.bannerBkg.y = -20
			transition.to( self.images.bannerBkg, { time=1000, y=50, delay=0, alpha=1.0,transition=easing.outQuad} )

			-- banner text
			self.texts.banner.y = -20
			transition.to( self.texts.banner, { time=1000, y=44, delay=0, alpha=1.0,transition=easing.outQuad} )

		end

	end
	--------

	Runtime:addEventListener( "orientation", onOrientationChange )

	screen:initialize(params)
	return screen

end

return LoadCard
