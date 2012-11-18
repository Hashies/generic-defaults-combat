AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

function ENT:Initialize()   

	self.ammos = 1
	self.match = 1
	self.Velo = Vector(0,0,0)
	self.Pos2 = self.Entity:GetPos()
	self.clipsize = 1
	self.armed = 1
	self.loading = false
	self.reloadtime = 0
	self.matchtime	= 0
	self.infire  = false
	self.infire2 = false
	self.infire3 = false
	self.Tracer  = 0
        self.TracerTimer = 1
	self.Entity:SetModel( "models/props_lab/pipesystem02c.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     
	self.Entity:DrawShadow( false )
	
          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake() 
	end 
 
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire", "Fire Tracer","Tracer On","Fire Match Grade"} )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire"})
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	
	
	local ent = ents.Create( "gdc_m2hb" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	
	
	return ent

end

function ENT:fire()

		if	 (self.TracerTimer>=self.Tracer) and (self.Tracer>=1)	then		// If it's not the tracer round, shoot a ball
		local balla = ents.Create( "gdca_12.7x99_tracer" )
		balla:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 150)
		balla:SetAngles( self.Entity:GetAngles() )
		balla:Spawn()
		balla:Activate()
		self.TracerTimer = 1
		else										// Else fire the tracer and reset to ball
		local traca = ents.Create( "gdca_12.7x99_ball" )
		traca:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 150)
		traca:SetAngles( self.Entity:GetAngles() )
		traca:Spawn()
		traca:Activate()
		self.TracerTimer = self.TracerTimer+1
		end
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetUp() * -12700 ) 
		end 

		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.4)
		effectdata:SetRadius(5)
		effectdata:SetMagnitude(self.Velo:Length())
		effectdata:SetAngles(self.Velo:Angle())
		util.Effect( "gdca_lowcalmuzzle", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 7, 5, 0.05, 200 )
		self.Entity:EmitSound( "M2HB.Emit" )
		self.ammos = self.ammos-1
	

end

function ENT:firetracer()

	local ent = ents.Create( "gdca_12.7x99_tracer" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 150)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetUp() * -12700 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.4)
		effectdata:SetRadius(5)
		effectdata:SetMagnitude(self.Velo:Length())
		effectdata:SetAngles(self.Velo:Angle())
		util.Effect( "gdca_lowcalmuzzle", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 7, 5, 0.2, 200 )
		self.Entity:EmitSound( "M2HB.Emit" )
		self.ammos = self.ammos-1
end

function ENT:firematch()

	local ent = ents.Create( "gdca_12.7x99_match" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 100)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
			phys:ApplyForceCenter( self.Entity:GetUp() * -12700 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.4)
		effectdata:SetRadius(5)
		effectdata:SetMagnitude(self.Velo:Length())
		effectdata:SetAngles(self.Velo:Angle())
		util.Effect( "gdca_lowcalmuzzle", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 7, 5, 0.2, 200 )
		self.Entity:EmitSound( "M2HB.Emit" )
		self.match = self.match-1
end

function ENT:Think()
	self.Velo = (self.Entity:GetPos()-self.Pos2)*66
	self.Pos2 = self.Entity:GetPos()

	if self.ammos <= 0 then
	self.reloadtime = CurTime()+0.13
	self.ammos = self.clipsize
	end

	if self.match <= 0 then
	self.matchtime = CurTime()+1
	self.match = self.clipsize
	end

	if (self.reloadtime < CurTime()) then
	Wire_TriggerOutput(self.Entity, "Can Fire", 1)
	else
	Wire_TriggerOutput(self.Entity, "Can Fire", 0)
	end
	
	if self.inFire then
	if (self.reloadtime < CurTime()) then
	self:fire()
	end
	end
	
	if self.inFire2 and !self.inFire then
	if (self.reloadtime < CurTime()) then
	self:firetracer()			
	end
	end

	if self.inFire3 and !self.inFire and !self.inFire2 then
	if (self.matchtime < CurTime()) then
	self:firematch()		
	end
	end

	self.Entity:NextThink( CurTime()+0.01)
	return true
end

function ENT:TriggerInput(k, v)

		if(k=="Fire") then
		if((v or 0) >= 1) then
			self.inFire = true
		else
			self.inFire = false
		end
		end
	
		if(k=="Fire Tracer") then
		if((v or 0) >= 1) then
			self.inFire2 = true
		else
			self.inFire2 = false
		end
		end
	
		if(k=="Fire Match Grade") then
		if((v or 0) >= 1) then
			self.inFire3 = true
		else
			self.inFire3 = false
		end
		end

		if(k=="Tracer On") then
		if((v or 0) >= 1) then
			self.Tracer = v or 0
		else
			self.Tracer = 0
		end
		end
end
 
 
