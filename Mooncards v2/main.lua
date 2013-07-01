-- Moon cards version 2
-- Development by Matthew Maday
-- DBA - Weekend Warrior Collective
-- a 100% not-for-profit developer collective

-- This is the main scene

display.setStatusBar( display.HiddenStatusBar )

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------
local fileio     = require ("library.core.fileio")
local json       = require "json"
--------------------------------------------------------------------------------------
-- variable declaritions
--------------------------------------------------------------------------------------

local screen  = display.newGroup()
gComponents   = {focus=nil, legacy=nil, support=nil}
gRecords      = nil
gScreenText   = nil
gPrefs        = nil
--------------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------------

local function touchScreen(event)

	if event.phase == "began" then 

		if gComponents.focus ~= nil then
			gComponents.focus:transitionAwayFrom() 
		end
	end

end
--------
function selectRecord()

	print("gPrefs = ",gPrefs)
	-- if #gPrefs.status.remaining == 0 then

	-- 	gPrefs.status.remaining = {}
	-- 	for i=1,#gPrefs.status.total,1 do
	-- 		gPrefs.status.remaining[#gPrefs.status.remaining+1] = gPrefs.status.total[i]
	-- 	end

	-- end
		
	-- local recordNum = math.random(#gPrefs.status.remaining)
	-- gRecord = gScreenText[gPrefs.status.remaining[recordNum]]

	-- table.remove(gPrefs.status.remaining,recordNum)
	-- gPrefsObj:writeFile(json.encode( gPrefs ))

end
--------
function initExternalData()


	local pFile  = fileio.new(system.pathForFile( "data/data.txt", system.ResourceDirectory))
	local str = pFile:readFile()
	gScreenText  =  json.decode( str)

	local pPrefs  = fileio.new(system.pathForFile( "prefs.txt", system.DocumentsDirectory))
	local str     = pPrefs:readFile()
	print("THE str = ",str)

	if str == "" then

		print("need to create a file for prefs")
		pPrefs = nil
		local pTmpPrefs = fileio.new(system.pathForFile( "data/prefs.txt", system.ResourceDirectory))
		str       = pTmpPrefs:readFile()
		print("THE str = ",str)
		pTmpPrefs = nil
		gPrefs =  json.decode( str)

		pPrefs  = fileio.new(system.pathForFile( "prefs.txt", system.DocumentsDirectory))
		print("pPrefs = ",pPrefs)
		pPrefs:writeFile(str)

	 end

	selectRecord()

end
--------

--------
local function processScene()

	if gComponents.focus ~= nil then
		gComponents.focus:process()
	end

	if gComponents.support ~= nil then
		local pEnd = #gComponents.support

		for i=1,pEnd,1 do 
			gComponents.support[i]:process()
		end
	end
end
--------------------------------------------------------------------------------------
-- INIT scene components
--------------------------------------------------------------------------------------

local function loadBrand(scene)


	print("adding new brand")
	require "application.views.brand"

	gComponents.focus = LoadBrand:new(nil)
	gComponents.focus:activate()
	gComponents.focus:show()
	


end
--------
local function loadBackground(scene)


	print("adding background to the animation")
	require "application.views.background"

	gComponents.support = {}

	gComponents.support[1] = LoadBackground:new(nil)
	gComponents.support[1]:activate()
	gComponents.support[1]:show()
	


end
--------
local function loadTitle(scene)


	print("adding new brand")
	require "application.views.title"

	gComponents.focus = LoadTitle:new(nil)
	gComponents.focus:activate()
	gComponents.focus:show()
	


end
--------
local function loadCard(scene)


	print("adding new brand")
	require "application.views.card"

	gComponents.support[2] = LoadCard:new(nil)
	gComponents.support[2]:activate()
	gComponents.support[2]:show()
	
end
--------
function goToScene(scene)


	-- if a scene is already active, kill it
	if gComponents.focus ~= nil then

		gComponents.focus:transitionAwayFrom()
		gComponents.legacy = gComponents.focus
		gComponents.focus = nil

	end

	-- load a new scene

	if scene == 1 then
		loadBrand()
	elseif scene == 2 then
		loadBackground()
		loadTitle()
	elseif scene == 3 then
		loadCard()
	end

end

--------------------------------------------------------------------------------------
-- scene execution
--------------------------------------------------------------------------------------

print("----------------------------------------------------------------------------")
print("start application")
print("----------------------------------------------------------------------------")
Runtime:addEventListener("touch",touchScreen)
Runtime:addEventListener("enterFrame",processScene)

initExternalData()

goToScene(1)


-------------------------------------------------------------------
local monitorMem = function()

    collectgarbage()
    print( "MemUsage: " .. collectgarbage("count") )

    local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
    print( "TexMem:   " .. textMem )
end

 -- Runtime:addEventListener( "enterFrame", monitorMem )

return screen



