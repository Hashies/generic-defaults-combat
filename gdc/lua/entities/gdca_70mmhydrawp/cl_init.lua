 include('shared.lua')     
 //[[---------------------------------------------------------     
 //Name: Draw     Purpose: Draw the model in-game.     
 //Remember, the things you render first will be underneath!  
 //-------------------------------------------------------]]  
 function ENT:Draw()      
 // self.BaseClass.Draw(self)  
 -- We want to override rendering, so don't call baseclass.                                   
 // Use this when you need to add to the rendering.        
 self.Entity:DrawModel()       // Draw the model.   
 end
 
   function ENT:Initialize()
	pos = self:GetPos()
	self.emitter = ParticleEmitter( pos )
 end
 
 function ENT:Think()
	
	pos = self:GetPos()
		for i=1, (5) do
			local particle = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + (self:GetUp() * -50 * i))
			if (particle) then
				particle:SetVelocity((self:GetUp() * -2000) )
				particle:SetDieTime( math.Rand( 3, 7 ) )
				particle:SetStartAlpha( math.Rand( 50, 70 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 40, 50 ) )
				particle:SetEndSize( math.Rand( 150, 200 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-1, 1) )
				particle:SetColor( 250 , 250 , 250 ) 
 				particle:SetAirResistance( 100 ) 
 				particle:SetGravity( VectorRand():GetNormalized()*math.Rand(50, 100) ) 
			end

			for i=1, 10 do
				local particle = self.emitter:Add( "effects/fire_cloud1", pos + (self:GetUp() * -25 * i) )

				particle:SetVelocity((self:GetUp() * -500) )
				particle:SetDieTime( 0.06 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 20 )
				particle:SetEndSize( math.Rand( 25, 35 ) )
				particle:SetRoll( math.Rand( -5, 5 ) )
				particle:SetRollDelta( 0 )
				particle:SetAirResistance(10)
				particle:SetColor( 255,255,255 )

			end
		
		end
end
