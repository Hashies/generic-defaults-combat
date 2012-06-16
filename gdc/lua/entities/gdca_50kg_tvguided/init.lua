AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   

self.flightvector = self.Dropper.Velo
self.Rotate = self.Dropper.TVRotate
self.Timeleft = CurTime() + 20
self.ArmedTime = CurTime() + 1
self.Armed = false
self.Entity:SetModel( "models/props_phx/ww2bomb.mdl" ) 
self.Entity:PhysicsInit( SOLID_VPHYSICS )
self.Entity:SetMoveType( MOVETYPE_NONE )
self.Entity:SetSolid( SOLID_VPHYSICS )
self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
self.Entity:SetColor(200,200,200,255)
 
end   

 function ENT:Think()
	
		if (self.Timeleft < CurTime()) || (!self.Entity:IsInWorld()) then
		self.Entity:Remove()				
		end

		if !self.Armed then
		if self.ArmedTime < CurTime() and self.flightvector:Length()>20 then
		self.Armed = true				
		end	end

	local trace = {}
		trace.start 	= self.Entity:GetPos()
		trace.endpos 	= self.Entity:GetPos() + self.flightvector
		trace.filter 	= self.Entity 
		trace.mask 	= MASK_SHOT + MASK_WATER			// Trace for stuff that bullets would normally hit
	local tr = util.TraceLine( trace )


				if self.Armed and tr.Hit then
					if tr.HitSky || tr.StartSolid then
					self.Entity:Remove()
					return true
					end

					if tr.MatType==83 then				//83 is wata
					local effectdata = EffectData()
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )		// In case you hit sideways water?
					effectdata:SetScale( 70 )			// Big splash for big bullets
					util.Effect( "watersplash", effectdata )
					self.Entity:Remove()
					return true
					end

					util.BlastDamage(self.Entity, self.Entity, tr.HitPos, 1500, 200)
					local effectdata = EffectData()
					effectdata:SetOrigin(tr.HitPos)				// Position of Impact
					effectdata:SetNormal(tr.HitNormal)			// Direction of Impact
					effectdata:SetStart(self.flightvector:GetNormalized())	// Direction of Round
					effectdata:SetEntity(self.Entity)			// Who done it?
					effectdata:SetScale(6)					// Size of explosion
					effectdata:SetRadius(tr.MatType)			// Texture of Impact
					effectdata:SetMagnitude(20)				// Length of explosion trails	
				util.Effect( "gdca_cinematicboom", effectdata )
				util.ScreenShake(tr.HitPos, 20, 5, 1, 4500 )
				util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
				if GDCENGINE then	
				local attack = gdc.gdcsplode( tr.HitPos, 800, 1000, self.Entity)	// Position, Radius, Damage, Self		
				end	
				self.Entity:Remove()
				end

		self.Rotate 	= Angle(math.Clamp(self.Dropper.TVRotate.p,-20,10),math.Clamp(self.Dropper.TVRotate.y,-20,20),0)
		local AddVector = (self.Entity:GetAngles():Forward()-(self.Entity:GetAngles()+self.Rotate):Forward())*(math.Clamp(self.flightvector:Length(),0,50)/80)

	self.Entity:SetAngles(self.flightvector:Angle())
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.flightvector = self.flightvector+AddVector + Vector(0,0,-0.111)
	self.Entity:NextThink( CurTime() )
	return true
end
 
 
