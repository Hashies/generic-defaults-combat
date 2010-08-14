AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   

self.flightvector = self.Entity:GetUp() * 80
self.timeleft = CurTime() + 10
self.Entity:SetModel( "models/props_junk/garbage_glassbottle001a.mdl" )
self.Entity:SetGravity( 0.5 ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_NONE )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- CHEESECAKE!    >:3           
self.Entity:SetColor(255,255,0,255)
 
end   

 function ENT:Think()
	
		if self.timeleft < CurTime() then
		self.Entity:Remove()					
		end

	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos() + self.flightvector
		trace.filter = self.Entity 
	local tr = util.TraceLine( trace )


			if tr.HitSky then
			self.Entity:Remove()
			return true
			end	
	
			if tr.Hit then

				for k, v in pairs ( ents.FindInSphere( self.Entity:GetPos(), 600 ) ) do	// Find anything within 50 feet
				if v:IsPlayer() || v:IsNPC() then		// If its alive then
				v:Ignite( 3, 100 ) end		// Fry it for 3 seconds, and make it catch anything around it on fire too
				end			

				util.BlastDamage(self.Entity, self.Entity, tr.HitPos, 600, 30)
				local effectdata = EffectData()
				effectdata:SetOrigin(tr.HitPos)
				effectdata:SetNormal(tr.HitNormal)
				effectdata:SetScale(4)
				effectdata:SetRadius(4.3)
				util.Effect( "gdca_whitephosphorus", effectdata )
				util.ScreenShake(tr.HitPos, 10, 5, 1, 3000 )
				util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

				local attack = gcombat.hcgexplode( tr.HitPos, 200, 100, 6)
				self.Entity:Remove()
				end
	
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.flightvector = self.flightvector + Vector(math.Rand(-0.1,0.1), math.Rand(-0.1,0.1),math.Rand(-0.1,0.1)) + Vector(0,0,-0.3)
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
	self.Entity:NextThink( CurTime() )
	return true
end
 
 
