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
		for i=0, (3) do
			local particle = self.emitter:Add( "particle/particle_smokegrenade", pos + (self:GetUp() * -30 * i))
			if (particle) then
				particle:SetVelocity((self:GetUp() * -2000) )
				particle:SetDieTime( math.Rand( 3, 7 ) )
				particle:SetStartAlpha( math.Rand( 40, 50 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 40 )
				particle:SetEndSize( math.Rand( 150, 200 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-1, 1) )
				particle:SetColor( 200 , 200 , 200 ) 
 				particle:SetAirResistance( 100 ) 
 				particle:SetGravity( Vector( 100, 0, 0 ) ) 
			end

			for i=1, 7 do
				local particle = self.emitter:Add( "effects/fire_cloud1", pos + (self:GetUp() * -10 * i) )

				particle:SetVelocity((self:GetUp() * -500) )
				particle:SetDieTime( 0.15 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 10 )
				particle:SetEndSize( math.Rand( 20, 25 ) )
				particle:SetRoll( math.Rand( -5, 5 ) )
				particle:SetRollDelta( 0 )
				particle:SetAirResistance(10)
				particle:SetColor( 255,230,230 )

			end
		
		end
end
