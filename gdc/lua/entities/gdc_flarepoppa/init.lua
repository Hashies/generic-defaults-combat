
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

util.PrecacheSound("arty/artyfire.wav")

function ENT:Initialize()   

	self.ammos = 10
	self.clipsize = 10
	self.armed = false
	self.loading = false
	self.reloadtime = 0
	self.infire = false
	self.Force = 70
	self.Entity:SetModel( "models/props_pipes/pipecluster08d_extender64.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     
	self.Entity:SetColor(100,100,100,255)
	
          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
	phys:Wake() 
	end 
 
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire", "Force", "Reload"} )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire", "Shots"})
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 60
	local ent = ents.Create( "gdc_l60" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	return ent

end

function ENT:flare()

		local ent = ents.Create( "gdca_flare" )
		ent:SetPos( self.Entity:GetPos() +  self.Entity:GetUp() * 70)
		ent:SetAngles( self.Entity:GetAngles() )
		ent:Spawn()
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter((self.Entity:GetUp()*15+VectorRand():GetNormalized()) * self.Force)
		self.Entity:EmitSound( "Flare.single" )
		self.ammos = self.ammos-1	
		end

function ENT:Think()
if FIELDS == nil and COMBATDAMAGEENGINE == nil then return end
Wire_TriggerOutput(self.Entity, "Shots", self.ammos)
	if self.ammos <= 0 then
	self.reloadtime = CurTime()+10
	self.ammos = self.clipsize
	end
	
	if (self.reloadtime < CurTime()) then
		Wire_TriggerOutput(self.Entity, "Can Fire", 1)
	else
		Wire_TriggerOutput(self.Entity, "Can Fire", 0)
	end
	
	if (self.inFire == true) then
		if (self.reloadtime < CurTime()) then
		
			self:flare()
			
		end
	end

	self.Entity:NextThink( CurTime() + 0.15)
	return true
end

function ENT:TriggerInput(k, v)

if(k=="Force") then 
if v then self.Force = v end end

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
 
 
