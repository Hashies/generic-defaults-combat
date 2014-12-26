
AddCSLuaFile()
DEFINE_BASECLASS( "base_wire_entity" )
ENT.RenderGroup		= RENDERGROUP_BOTH

function ENT:Initialize()   


	self.heat = 0
	self.ammos = 1
	self.match = 1
	self.clipsize = 1
	self.armed = 1
	self.loading = false
	self.reloadtime = 0
	self.matchtime	= 0
	self.infire  = false
	self.infire2 = false
	self.Tracer  = 0
        self.TracerTimer = 1
	self.Velo = Vector(0,0,0)
	self.Pos2 = self.Entity:GetPos()
	self.Entity:SetModel( "models/props_lab/pipesystem02b.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     
	self.Entity:DrawShadow( false )
	
          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake() 
	end 
 
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire", "Fire Tracer","Tracer On"} )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire", "Heat"})
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	
	
	local ent = ents.Create( "gdc_gau19" )
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
		self.heat = self.heat+3
		self.TracerTimer = 1
		else										// Else fire the tracer and reset to ball
		local traca = ents.Create( "gdca_12.7x99_ball" )
		traca:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 150)
		traca:SetAngles( self.Entity:GetAngles() )
		traca:Spawn()
		traca:Activate()
		self.heat = self.heat+3
		self.TracerTimer = self.TracerTimer+1
		end
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetUp() * -12000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.4)
		effectdata:SetRadius(6)
		effectdata:SetMagnitude(self.Velo:Length())
		effectdata:SetAngles(self.Velo:Angle())
		util.Effect( "gdca_lowcalmuzzle", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 7, 5, 0.2, 200 )
		self.Entity:EmitSound( "GAU19.Emit" )
		self.ammos = self.ammos-1
	

end

function ENT:firetracer()

	local ent = ents.Create( "gdca_12.7x99_tracer" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 150)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		self.heat = self.heat+3		
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
			phys:ApplyForceCenter( self.Entity:GetUp() * -12000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.4)
		effectdata:SetRadius(6)
		effectdata:SetMagnitude(self.Velo:Length())
		effectdata:SetAngles(self.Velo:Angle())
		util.Effect( "gdca_lowcalmuzzle", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 7, 5, 0.2, 200 )
		self.Entity:EmitSound( "GAU19.Emit" )
	

end

function ENT:Think()
	self.Velo = (self.Entity:GetPos()-self.Pos2)*16.7
	self.Pos2 = self.Entity:GetPos()

			if self.heat>0 then
			Wire_TriggerOutput(self.Entity, "Heat", self.heat)
			self.heat = self.heat-1
			end

			if self.heat>100 then
			self.reloadtime = CurTime()+4		// Overheat for 4 seconds
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

	self.Entity:NextThink( CurTime() + 0.06)
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
	

		if(k=="Tracer On") then
		if((v or 0) >= 1) then
			self.Tracer = v or 0
		else
			self.Tracer = 0
		end
		end
end
 
