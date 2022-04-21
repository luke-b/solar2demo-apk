
-- Abstract: Shape Tumbler
-- Version: 1.1
-- Sample code is MIT licensed; see https://solar2d.com/LICENSE.txt
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Shape Tumbler", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local worldGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Sample code by Eetu Rantanen.

-- Change the background to blue.
display.setDefault( "background", 0, 0.3, 0.8 )

-- Require and start the physics engine.
local physics = require("physics")
physics.start()
physics.setGravity( 0, 98.1 ) -- Setting a very high gravity.

-- Create a sword altar, the ground and a crate, and give them all physics bodies.
local swordShape = { -2, -62, 9, -62, 49, 10, 49, 95, -40, 95, -40, 10 }
local sword = display.newImage( "img/alter.png", 510, 490 )
physics.addBody( sword, "dynamic", { density=1, friction=0.9, bounce=0, shape=swordShape } )

local block = display.newImage( "img/pushBlock3.png", 480, 100 )
physics.addBody( block, "dynamic", { density=1, friction=2, bounce=0 } )
block.angularDamping = 3
-- block:setFillColor( 1, 0, 0 ) -- Uncomment this line to apply red tint to the block.

for i = 1, 4 do
	local ground = display.newImage( "img/platformBase2.png", i*250-160, 630 )
	physics.addBody( ground, "static", { density=1, friction=0.9, bounce=0 } )
end

local text = display.newText( "Drag the block with your mouse", 640, 40, native.systemFontBold, 40 )

local function dragObject( event, params )
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()

	if "began" == phase then
		stage:setFocus( body )
		body.isFocus = true
		body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )

	elseif body.isFocus then
		if "moved" == phase then
			body.tempJoint:setTarget( event.x, event.y )

		elseif "ended" == phase or "cancelled" == phase then
			stage:setFocus( nil )
			body.isFocus = false	
			body.tempJoint:removeSelf()

		end
	end

	return true
end
block:addEventListener( "touch", dragObject )
-- sword:addEventListener( "touch", dragObject ) -- Uncomment to make the sword draggable too.
