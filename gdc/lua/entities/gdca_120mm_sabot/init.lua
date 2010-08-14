AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
self.penetrate = 100
self.flightvector = self.Entity:GetUp() * 550
self.timeleft = CurTime() + 5
self.Entity:SetModel( "models/led.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_NONE )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- CHEESECAKE!    >:3            

self:Think()
 
end   

function ENT:Think()

		if self.timeleft < CurTime() then
					self.exploded = true
					self.Entity:Remove()
					
	end

	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos() + self.flightvector*1.3
		trace.filter = self.Entity
	local tr = util.TraceLine( trace )


				if tr.HitSky then
				self.Entity:Remove()
				return true
				end


				if tr.Hit then
					util.BlastDamage(self.Entity, self.Entity, tr.HitPos, 200, 300)
					local effectdata = EffectData()
					effectdata:SetOrigin(tr.HitPos)
					effectdata:SetNormal(tr.HitNormal)
					effectdata:SetScale(3)
					effectdata:SetRadius(2)
					util.Effect( "gdca_apiring", effectdata )
					util.Effect( "gdca_impact", effectdata )
					util.ScreenShake(tr.HitPos, 10, 5, 0.3, 1000 )
					util.Decal("fadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
					if tr.Entity:IsValid() then
					local attack = gcombat.hcghit( tr.Entity, 4000, 100, tr.HitPos, tr.HitPos)
					end 

				end


	local trace = {}
		trace.start = tr.HitPos + self.flightvector:GetNormalized()*self.penetrate
		trace.endpos = tr.HitPos
		trace.filter = self.Entity 
	local pr = util.TraceLine( trace )

		if pr.StartSolid and !pr.Entity:IsValid() || tr.Hit and !pr.Hit || self.penetrate<0 then
		self.Entity:Remove()
		end

		if tr.Hit and pr.Hit and !(pr.StartSolid and pr.Entity:IsValid()) then
		self.penetrate = self.penetrate - (tr.HitPos:Distance(pr.HitPos))
		if self.penetrate<0 || pr.StartSolid and !pr.Entity:IsValid() then self.Entity:Remove() end
		end

		if !pr.StartSolid and tr.Hit and pr.Hit and self.penetrate>0 then
			util.BlastDamage(self.Entity, self.Entity, pr.HitPos, 300, 70)
			local effectdata = EffectData()
			effectdata:SetOrigin(pr.HitPos)
			effectdata:SetNormal(self.flightvector:GetNormalized())
			effectdata:SetScale(3)
			effectdata:SetRadius(2.5)
			util.Effect( "gdca_penetrate", effectdata )
			util.ScreenShake(tr.HitPos, 10, 5, 0.1, 1000 )
			util.Decal("fadingScorch", pr.HitPos + pr.HitNormal, pr.HitPos - pr.HitNormal)
			end

	self.flightvector =  self.flightvector + Vector(math.Rand(-0.5,0.5), math.Rand(-0.5,0.5),math.Rand(-0.5,0.5)) + Vector(0,0,-0.20)

	if !pr.Hit then
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	else 	self.Entity:SetPos(pr.HitPos + self.flightvector:GetNormalized()*10)
	end
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
	self.Entity:NextThink( CurTime() )
	return true
	end
 
 
