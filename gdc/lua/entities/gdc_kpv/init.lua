
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

function ENT:Initialize()   

	self.ammomodel = "models/props_c17/canister01a.mdl"
	self.armed = false
	self.loading = false
	self.reloadtime = 0
	self.InFireAPI = false
	self.InFireAPIT = false
	self.InFireHEI = false
	self.heat = 0
	self.Entity:SetModel( "models/props_lab/pipesystem02b.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     
	self.Entity:DrawShadow( false )
	
          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake() 
	end 
 
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire API", "Fire API-T", "Fire HEI"} )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire", "Heat"})
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	
	local ent = ents.Create( "gdc_kpv" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:fireapi()
		local ent = ents.Create( "gdca_14.5x114_api" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 100)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		self.heat = self.heat+6	
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetUp() * -15000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.5)
		util.Effect( "gdca_muzzle", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 12, 5, 0.2, 200 )
		self.Entity:EmitSound( "KPV.single" )
	
end

function ENT:fireapit()
		local ent = ents.Create( "gdca_14.5x114_apit" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 100)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		self.heat = self.heat+6
				
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetUp() * -15000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.5)
		util.Effect( "gdca_muzzle", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 12, 5, 0.2, 200 )
		self.Entity:EmitSound( "KPV.single" )

end

function ENT:firehei()
		local ent = ents.Create( "gdca_14.5x114_hei" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 100)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		self.heat = self.heat+6
				
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetUp() * -5000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.5)
		util.Effect( "gdca_muzzle", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 12, 5, 0.2, 200 )
		self.Entity:EmitSound( "KPV.single" )
	
end

function ENT:Think()

	
	if (self.reloadtime < CurTime()) then
	Wire_TriggerOutput(self.Entity, "Can Fire", 1)
	else
	Wire_TriggerOutput(self.Entity, "Can Fire", 0)
	end

			if self.heat>0 then
			Wire_TriggerOutput(self.Entity, "Heat", self.heat)
			self.heat = self.heat-3
			end

			if self.heat>100 then
			self.reloadtime = CurTime()+4		// Overheat for 4 seconds
			end
	
	if self.InFireAPI then
	if (self.reloadtime < CurTime()) then
	self:fireapi()
	end
	end
	
	if self.InFireAPIT and !self.InFireAPI then
	if (self.reloadtime < CurTime()) then
	self:fireapit()
	end
	end

	if self.InFireHEI and !self.InFireAPI and !self.InFireAPIT then
	if (self.reloadtime < CurTime()) then
	self:firehei()
	end
	end

	self.Entity:NextThink( CurTime() + .14)
	return true
end

function ENT:TriggerInput(k, v)
		if(k=="Fire API") then
		if((v or 0) >= 1) then
		self.InFireAPI = true
		else
		self.InFireAPI = false
		end
		end
	
		if(k=="Fire API-T") then
		if((v or 0) >= 1) then
		self.InFireAPIT = true
		else
		self.InFireAPIT = false
		end
		end

		if(k=="Fire HEI") then
		if((v or 0) >= 1) then
		self.InFireHEI = true
		else
		self.InFireHEI = false
		end
		end
	
end
 
 
