AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   

self.Owner = self:GetOwner()
self.flightvector = self.Entity:GetUp() * ((900*39.37)/66)             	-- Velocity in m/s, inches to meters conversion, ticks per second.FIRST NUMMER = SPEED
self.timeleft = CurTime() + 4
self.Entity:SetModel( "models/led.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_NONE )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- CHEESECAKE!    >:3       
     
Tracer = ents.Create("env_spritetrail")
Tracer:SetKeyValue("lifetime","0.1")
Tracer:SetKeyValue("startwidth","30")
Tracer:SetKeyValue("endwidth","1")
Tracer:SetKeyValue("spritename","trails/laser.vmt")
Tracer:SetKeyValue("rendermode","5")
Tracer:SetKeyValue("rendercolor","255 150 100")
Tracer:SetPos(self.Entity:GetPos())
Tracer:SetParent(self.Entity)
Tracer:Spawn()
Tracer:Activate()

Glow = ents.Create("env_sprite")
Glow:SetKeyValue("model","orangecore2.vmt")
Glow:SetKeyValue("rendercolor","255 150 100")
Glow:SetKeyValue("scale","0.15")
Glow:SetPos(self.Entity:GetPos())
Glow:SetParent(self.Entity)
Glow:Spawn()
Glow:Activate()

self:Think()
end   

function ENT:Think()


		if self.timeleft < CurTime() then
					self.exploded = true
					self.Entity:Remove()
					
	end

	Table	={} 			//Table name is table name
	Table[1]	=self.Owner 		//The person holding the gat
	Table[2]	=self.Entity 		//The cap

	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos() + self.flightvector
		trace.filter = Table
	local tr = util.TraceLine( trace )

				if tr.HitSky then
				self.Entity:Remove()
				return true
				end

					if tr.Hit and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then
					util.BlastDamage(self.Entity, self.Entity, tr.HitPos, 100, 10)
					local effectdata = EffectData()
					effectdata:SetOrigin(tr.HitPos)
					effectdata:SetScale(1.25)
					effectdata:SetRadius(tr.MatType)
					effectdata:SetNormal(tr.HitNormal)
					util.Effect("gdcw_universal_impact",effectdata)
					util.ScreenShake(tr.HitPos, 10, 5, 0.1, 200 )
					util.Decal("ExplosiveGunshot", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
					end

			if tr.Hit and tr.Entity:IsPlayer() || tr.Entity:IsNPC() then
				local dmginfo = DamageInfo()
					dmginfo:SetDamage( math.Rand(35,55) )
					hitgroup = tr.HitGroup
	if hitgroup == HITGROUP_HEAD 					then 	dmginfo:ScaleDamage( 5 ) 			end
	if hitgroup == HITGROUP_STOMACH 					then 	dmginfo:ScaleDamage( 1 ) 			end
	if hitgroup == HITGROUP_CHEST 					then 	dmginfo:ScaleDamage( math.Rand(1,1.5) ) 	end
	if  hitgroup == HITGROUP_LEFTARM || hitgroup == HITGROUP_RIGHTARM  	then 	dmginfo:ScaleDamage( math.Rand(0.3,0.5) ) 	end
	if  hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_RIGHTLEG  	then 	dmginfo:ScaleDamage( math.Rand(0.3,0.6) ) 	end
					dmginfo:SetDamageType( DMG_BULLET ) 	--Bullet damage
					dmginfo:SetAttacker( self.Owner ) 		--Shooter gets credit
					dmginfo:SetInflictor( self.Entity ) 		--Bullet gets credit
					dmginfo:SetDamageForce( self.flightvector/200 ) 	--A few newtons...
				tr.Entity:TakeDamageInfo( dmginfo ) 			--Take damage!
					local effectdata = EffectData()
					effectdata:SetOrigin(tr.HitPos)
					effectdata:SetNormal(self.flightvector:GetNormalized())
					effectdata:SetScale(1.2)
					util.Effect( "gdcw_bloodychunkyviolence", effectdata ) 	// Nothing violent here!
					util.Effect( "BloodImpact", effectdata )			// Nothing violent here either!
				end



	self.flightvector = self.flightvector - self.flightvector/150 + Vector(math.Rand(-0.15,0.15), math.Rand(-0.15,0.15),math.Rand(-0.1,0.1)) + Vector(0,0,-0.06)
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(90,0,0))
	self.Entity:NextThink( CurTime() )
	return true
	end
 
 