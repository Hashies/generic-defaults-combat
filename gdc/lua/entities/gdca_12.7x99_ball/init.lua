AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   

math.randomseed(CurTime())
self.flightvector = self.Entity:GetUp() * 450
self.timeleft = CurTime() + 5
self.Entity:SetModel( "models/combatmodels/tankshell_25mm.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )	
self.Entity:SetMoveType( MOVETYPE_NONE )
self.Entity:SetSolid( SOLID_VPHYSICS )

	self:Think()
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
			util.BlastDamage(self.Entity, self.Entity, tr.HitPos, 150, 100)
			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetScale(1.5)
			effectdata:SetRadius(1.5)
			util.Effect( "gdca_impact", effectdata )
			util.ScreenShake(tr.HitPos, 10, 5, 0.3, 300 )
			util.Decal("ExplosiveGunshot", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)

			if (tr.Entity:IsValid()) then
			local attack = gcombat.hcghit( tr.Entity, 150, 100, tr.HitPos, tr.HitPos)
			end

			self.Entity:Remove()
			return true
		end

self.flightvector = self.flightvector + Vector(math.Rand(-0.5,0.5), math.Rand(-0.5,0.5),math.Rand(-0.5,0.5)) + Vector(0,0,-0.2)
self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
self.Entity:NextThink( CurTime() )
return true
end
 
 
