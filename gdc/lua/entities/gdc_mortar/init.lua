
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

util.PrecacheSound("arty/artyfire.wav")

function ENT:Initialize()   

	self.ammomodel = "models/props_c17/canister01a.mdl"
	self.ammos =1
	self.clipsize = 1
	self.armed = false
	self.loading = false
	self.reloadtime = 0
	self.infire = false
	self.infire2 = false
	self.InFireIlluminator = false
	self.Entity:SetModel( "models/props_pipes/pipecluster08d_extender64.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     
	self.Entity:DrawShadow( false )
	
          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake() 
	end 
 
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire HE", "Fire WP", "Fire Illuminator" } )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire"})
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	
	
	local ent = ents.Create( "gdc_mortar" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	
	
	return ent

end

function ENT:firewp()

		local ent = ents.Create( "gdca_81mm_wp" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 100)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		self.armed = false
		
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
			phys:ApplyForceCenter( self.Entity:GetUp() * -50000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 40)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.5)
		util.Effect( "gdca_tanksmoke", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 30, 5, 0.2, 300 )
		self.Entity:EmitSound( "81mm.single" )
		self.ammos = self.ammos-1
	

end

function ENT:firehe()

	local ent = ents.Create( "gdca_81mm_he" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 100)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		self.armed = false
		
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
			phys:ApplyForceCenter( self.Entity:GetUp() * -50000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 40)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.5)
		util.Effect( "gdca_tanksmoke", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 30, 5, 0.2, 300 )
		self.Entity:EmitSound( "81mm.single" )
		self.ammos = self.ammos-1
	

end

function ENT:fireilluminator()

	local ent = ents.Create( "gdca_81mm_illuminator" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 100)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()

		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetUp() * -81000 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 40)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.5)
		util.Effect( "gdca_tanksmoke", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 30, 5, 0.2, 300 )
		self.Entity:EmitSound( "81mm.single" )

		self.reloadtime = CurTime()+10
	

end

function ENT:Think()

	if self.ammos <= 0 then
	self.reloadtime = CurTime()+3
	self.ammos = self.clipsize
	end
	
	if (self.reloadtime < CurTime()) then
	Wire_TriggerOutput(self.Entity, "Can Fire", 1)
	else
	Wire_TriggerOutput(self.Entity, "Can Fire", 0)
	end
	
	if self.inFire then
	if (self.reloadtime < CurTime()) then
	self:firewp()	
	end
	end
	
	if self.inFire2 and !self.inFire then
	if (self.reloadtime < CurTime()) then
	self:firehe()	
	end
	end

	if self.InFireIlluminator and !self.inFire and !self.inFire2 then
	if (self.reloadtime < CurTime()) then
	self:fireilluminator()	
	end
	end

	self.Entity:NextThink( CurTime() + .01)
	return true
end

function ENT:TriggerInput(k, v)

			if(k=="Fire WP") then
			if((v or 0) >= 1) then
			self.inFire = true
			else
			self.inFire = false
			end
			end
	
			if(k=="Fire HE") then
			if((v or 0) >= 1) then
			self.inFire2 = true
			else
			self.inFire2 = false
			end
			end

			if(k=="Fire Illuminator") then
			if((v or 0) >= 1) then
			self.InFireIlluminator = true
			else
			self.InFireIlluminator = false
			end
			end
end
 
 
