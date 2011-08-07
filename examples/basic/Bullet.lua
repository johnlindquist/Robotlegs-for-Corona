--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]


Bullet = {}

function Bullet:new(startX, startY, targetPoint)
	local img = display.newImage("bullet.png")
	img.name = "Bullet"
	img.speed = 6
	img.x = startX
	img.y = startY
	img.targetX = targetPoint.x
	img.targetY = targetPoint.y
	-- TODO: use math.deg vs. manual conversion
	img.rot = math.atan2(img.y -  img.targetY,  img.x - img.targetX) / math.pi * 180 -90;
	img.angle = (img.rot -90) * math.pi / 180;
	
	physics.addBody( img, { density = 1.0, friction = 0.3, bounce = 0.2, 
								bodyType = "kinematic", 
								isBullet = true, isSensor = true, isFixedRotation = true,
								filter = { categoryBits = 8, maskBits = 1 }
							} )
								
	
	function onHit(self, event)
		if(event.other.name == "Player") then
			-- TODO: watch this; not sure which instance it's talking too
			event.other:onBulletHit()
			self:destroy()
		end
	end

	img.collision = onHit
	img:addEventListener("collision", img)
	
	function img:destroy()
		self:dispatchEvent({name="removeFromGameLoop", target=self})
		self:removeSelf()
	end
	
	function img:tick(millisecondsPassed)
		-- TODO: make sure using milliseconds vs. hardcoding step speed
		self.x = self.x + math.cos(self.angle) * self.speed
	   	self.y = self.y + math.sin(self.angle) * self.speed
		if(self.x > stage.width or self.x < 0 or self.y < 0 or self.y > stage.height) then
			self:destroy()
		end
	end
	
	return img
end

return Bullet