-- Button Panel View

-- Moon cards version 2
-- Development by Matthew Maday
-- DBA - Weekend Warrior Collective
-- a 100% not-for-profit developer collective

LoadButtons = {}

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------

function LoadButtons:new(params)

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

		-- transition.to( screen, { x=(display.contentWidth-screen.myWidth)*.5,y=0, time=400, delay=0,alpha=1.0,transition=easing.outQuad,rotation=newAngle})
	
		screen:alignContent()

	end


	--------
	function screen:initialize(params, event)

		self.images       = {}
		self.texts		  = {} 			
		self.groups       = {}
		self.timer        = nil
		self.tween        = nil
		self.myWidth	  = display.viewableContentWidth
		self.myHeight     = display.viewableContentHeight

		if self.myWidth > self.myHeight then
			local tmp     = self.myWidth
			self.myWidth  = self.myHeight
			self.myHeight = tmp
		end

		self.centerX, self.centerY = self.myWidth*.5, self.myHeight*.5

		local options = {
			width              = 106,   -- width of one frame
			height             = 38.5,  -- height of one frame
			numFrames 		   = 6,     -- total number of frames in spritesheet
		    sheetContentWidth  = 320,   -- width of original 1x size of entire sheet
    		sheetContentHeight = 77     -- height of original 1x size of entire sheet
		}

		self.images[#self.images+1] = {buttonSheet=nil}
		self.images.buttonSheet = graphics.newImageSheet("content/images/buttons.png", options)
		
		-- about button
		self.images[#self.images+1] = {about=nil}
		self.images.about  = self:getButton(self.images.buttonSheet, "about", 1,4,options.width,options.height)
		self.images.about.x, self.images.about.y = options.width*.5, options.height*.5
		-- share button
		self.images[#self.images+1] = {share=nil}
		self.images.share  = self:getButton(self.images.buttonSheet, "share", 2,5,options.width,options.height)
		self.images.share.x, self.images.share.y = options.width*1.5, options.height*.5

		-- refresh button
		self.images[#self.images+1] = {refresh=nil}
		self.images.refresh  = self:getButton(self.images.buttonSheet, "refresh", 3,6,options.width,options.height)
		self.images.refresh.x, self.images.refresh.y = options.width*2.5, options.height*.5

		
		--transition.to( screen, { x=(display.contentWidth-screen.myWidth)*.5,y=0, time=400, delay=0,alpha=1.0,transition=easing.outQuad})
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
		
		self.images.buttonSheet:removeSelf() 
		-- --screen.texts.body:removeSelf()
		-- screen.groups.card:removeSelf()
		-- screen.images.cardBkg:removeSelf()

		self.images.buttonSheet = nil
		-- screen.texts.body = nil
		-- screen.groups.card = nil
		-- screen.images.cardBkg = nil

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

		-- screen.x,screen.y = (display.contentWidth-self.myWidth)*.5,(display.contentHeight-self.myHeight)*.5

		if system.orientation == "portrait" or system.orientation == "portraitUpsideDown" then
			
			screen.x, screen.y = (display.contentWidth-self.myWidth)*.5,self.myHeight-screen.height

		else


		end

	end
	--------
	function screen:getButton(image,name,pos,endpos,w,h)

		local options = {{ name=name, frames={pos,endpos}, time=0, loopCount=2 }}
		local img = display.newSprite(image, options)

		img:setFrame(1)
		self:insert(img)
		
		function img:touch(event)
			screen:onButtonTouch(event)
		end
		img:addEventListener("touch",img)
		return img
	end
	--------

	Runtime:addEventListener( "orientation", onOrientationChange )

	screen:initialize(params)
	return screen

end

return LoadButtons
