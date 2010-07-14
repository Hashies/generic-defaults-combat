AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   

self.flightvector = self.Entity:GetUp() * 220
self.timeleft = CurTime() + 10
self.Entity:SetModel( "models/combatmodels/tankshell.mdl" )
self.Entity:SetGravity( 0.5 ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_NONE )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- CHEESECAKE!    >:3           
self.Entity:SetColor(255,255,0,255)
 
end   

 function ENT:Think()

	if (self.smoking == false) then
		self.smoking = true
	
		FireTrail = ents.Create("env_spritetrail")
		FireTrail:SetKeyValue("lifetime","0.3")
		FireTrail:SetKeyValue("startwidth","20")
		FireTrail:SetKeyValue("endwidth","200")
		FireTrail:SetKeyValue("spritename","trails/smoke.vmt")
		FireTrail:SetKeyValue("rendermode","5")
		FireTrail:SetKeyValue("rendercolor","200 200 200")
		FireTrail:SetPos(self.Entity:GetPos())
		FireTrail:SetParent(self.Entity)
		FireTrail:Spawn()
		FireTrail:Activate()
	end 

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
					util.BlastDamage(self.Entity, self.Entity, tr.HitPos, 700, 50)
					local effectdata = EffectData()
					effectdata:SetOrigin(tr.HitPos)
					effectdata:SetNormal(tr.HitNormal)	
					effectdata:SetStart(tr.HitPos)
					util.Effect( "gdca_70mmhydrawp_effect", effectdata )
					util.ScreenShake(tr.HitPos, 10, 5, 1, 1500 )
					util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			
					local attack = gcombat.hcgexplode( tr.HitPos, 200, 200, 5)
					self.Entity:Remove()
					end
	
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.flightvector = self.flightvector + Vector(math.Rand(-0.8,0.8), math.Rand(-0.8,0.8),math.Rand(-0.8,0.8)) + Vector(0,0,-0.10)
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
	self.Entity:NextThink( CurTime() )
	return true
end
 
 
