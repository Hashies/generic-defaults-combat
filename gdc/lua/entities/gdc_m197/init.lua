
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

util.PrecacheSound("arty/artyfire.wav")

function ENT:Initialize()   

	self.ammomodel = "models/props_c17/canister01a.mdl"
	self.ammos = 50
	self.clipsize = 50
	self.armed = false
	self.loading = false
	self.reloadtime = 0
	self.infire = false
	self.Entity:SetModel( "models/props_lab/pipesystem01b.mdl" ) 
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     
	self.Entity:SetColor(100,100,100,255)
	
          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake() 
	end 
 
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire", "Reload"} )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire", "Shots"})
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	
	
	local ent = ents.Create( "gdc_m197" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	
	
	return ent

end

function ENT:firerac5()

		local ent = ents.Create( "gdca_20x102he" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 100)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		ent:Activate()
		
		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
			phys:ApplyForceCenter( self.Entity:GetUp() * -2000 ) 
		end 
		
		self.Entity:EmitSound( "M197.single" )
		self.ammos = self.ammos-1
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(0.6)
		util.Effect( "gdca_muzzle", effectdata )
		util.ScreenShake(self.Entity:GetPos(), 20, 5, 0.2, 300 )
	

end

function ENT:Think()
if FIELDS == nil and COMBATDAMAGEENGINE == nil then return end
Wire_TriggerOutput(self.Entity, "Shots", self.ammos)
	if self.ammos <= 0 then
	self.reloadtime = CurTime()+7
	self.ammos = self.clipsize
	end
	
	if (self.reloadtime < CurTime()) then
		Wire_TriggerOutput(self.Entity, "Can Fire", 1)
	else
		Wire_TriggerOutput(self.Entity, "Can Fire", 0)
	end
	
	if (self.inFire == true) then
		if (self.reloadtime < CurTime()) then
		
			self:firerac5()
			
		end
	end

	self.Entity:NextThink( CurTime() + .085)
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
	
if(k=="Reload") then
		if((v or 0) >= 1) then
			self.ammos = 0
		end
	end
	
end
 
 