-----------------------------------------------------------------------------------------
-- UI Libraries 
-----------------------------------------------------------------------------------------

-- external libraries
require "display"
local strObj = require ("classes.str")

module(..., package.seeall)

-----------------------------------------------------------------------------------------
-- Functions Libraries 
-----------------------------------------------------------------------------------------

insertImage = function(pGroup,pFile,pName,x,y,pRef,pAlpha)
   
   -- define the path - remember to include the folder in the path if not on base level
	local pImage     = display.newImage(pFile)
	pImage.name      = pName
	pImage.x         = x
	pImage.y         = y
	pImage:setReferencePoint(pRef)

	pGroup:insert(pImage)

   return pGroup  
end
--------
insertText = function(pGroup,pText,pName,pFont,pFontSize,x,y,pWidth,pColor,pRef)

	local pText     = display.newText( pGroup, pText, x, y, pFont, pFontSize )
	pText.name      = pName
	pText.x         = x
	pText.y         = y

	pText:setReferencePoint(pRef)
	pText:setTextColor(pColor[1], pColor[2], pColor[3])

	pGroup:insert(pText)

   return pGroup  

end
--------
insertWrappedText = function(pGroup,pText,pName,pFont,pFontSize,x,y,pWidth,pColor,pRef)

	local pText     = strObj.wrappedText( pText, pWidth, pFontSize, pFont, pColor )
	pText.name      = pName
	pText.x         = x
	pText.y         = y

	pText:setReferencePoint(pRef)

	pGroup:insert(pText)

   return pGroup  
end
--------
randomDirectionDegrees = function(speed, inc)
	
	-- generates an angle, based on 360 degrees, 
	-- and returns an x,y incremental value

    -- speed defines the range (default is 100/inc)
    -- speed defines the increment (default is speed/100)

	local degrees = math.random(360)
	local radius  = math.random(speed/inc)
	local rads    = degrees * (math.pi / 180.0)

	return radius/2 * math.cos(rads), radius/2 * math.sin(rads)

end
--------
spawn = function(params)

	-- object references
	object 			= display.newImage(params.image)   
	object.objTable = params.objTable
	object.index    = #object.objTable + 1
	object.myName   = "Object : "..object.index
	object.group    = params.group
	object.group:insert(object)
	object.objTable[object.index] = object

	-- object properties
	object.width 	  = params.width or object.width
	object.height 	  = params.height or object.height
	object.x 		  = params.x
	object.y 		  = params.y
	object.alpha  	  = params.alpha or 1
	object.Valpha 	  = params.alpha or 1
	object.blendSpeed = params.blendSpeed or .004
	object.rotSpeed   = params.rotation or 0
	object.myTimer    = params.myTimer or 0

	-- physics properties
	if object.hasBody then
		object.density 	= params.density
		object.friction = params.friction
		object.bounce   = params.bounce
		object.isSensor = params.isSensor
		object.bodyType = params.bodyType
		physics.addBody(object, object.bodyType, {density=object.density,friction=object.friction,bounce=object.bounce,isSensor=object.isSensor})
	end
	
	-- motion properties
    object.speed	= params.speed or {0,0} 

	return object
end
--------
processSpawns = function (self,event)
	
	-- print(self.myTimer)
	if self.myTimer == 0 then

		if self.y > (display.contentHeight+100) or self.y < -100 or 
	       self.x > (display.contentWidth+100) or self.x < -100 then

	       	local x,y 	  = randomDirectionDegrees(100, 100) 
			self.x		  = display.contentWidth*.5
			self.y		  = display.viewableContentHeight*.5
			self.width    = 1
			self.height   = 1
			self.alpha	  = 0
			self.Valpha   = 0
			self.initX 	  = self.x
	     	self.speed	  = {x,y}
	     	self.myTimer  = math.random(100)

	    else

	    	self.Valpha   = self.Valpha + self.blendSpeed
	    	self.Valpha   = (self.Valpha > 1) and 1 or self.Valpha

	    	self.width    = self.width + .10
	    	self.height   = self.height + .10
	    	self.alpha    = self.Valpha
	    	self.y        = self.y + self.speed[2]
	    	self.x        = self.x + self.speed[1]
			self.rotation = (self.rotation > 360) and 0 or (self.rotation + self.rotSpeed)

		end
	else
		self.myTimer = self.myTimer - 1
	end
end
--------