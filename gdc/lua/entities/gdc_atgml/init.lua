
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('entities/base_wire_entity/init.lua'); 
include('shared.lua')

function ENT:Initialize()   

	self.ammos = 1
	self.clipsize = 1
	self.armed = false
	self.loading = false
	self.reloadtime = 0
	self.infire = false
	self.Wobbliness 	= 1
	self.Zmod 		= 0.25
	self.DistanceCutoff 	= 5000
	self.Velo = Vector(0,0,0)
	self.Pos2 = self.Entity:GetPos()
	self.Entity:SetModel( "models/props_pipes/pipecluster08d_extender64.mdl" ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
	self.Entity:SetSolid( SOLID_VPHYSICS )        -- Toolbox     
	self.Entity:SetColor(130,170,100,255)
	self.Entity:DrawShadow( false )

          
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake() 
	end 
 
	self.Inputs = WireLib.CreateSpecialInputs(self, { "Fire ATGM", "Position", "Wobbliness", "Distance Cutoff", "Z Modulation" }, { "NORMAL", "VECTOR", "NORMAL", "NORMAL", "NORMAL" } )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire"})
end   

function ENT:SpawnFunction( ply, tr)
	
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create( "gdc_atgml" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:fireatgm()

		local GPSMISSILE = ents.Create( "gdca_atgm" )
		GPSMISSILE:SetPos( self.Entity:GetPos() + (self.Entity:GetUp()*300) + self.Velo)
		GPSMISSILE:SetAngles( self.Entity:GetAngles() )
		GPSMISSILE.Guider = self.Entity
		GPSMISSILE:Spawn()
		GPSMISSILE:Initialize()
		GPSMISSILE:Activate()
		GPSMISSILE.Target = self.Target or Vector(0,0,0)

		local phys = self.Entity:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetUp() * -800 ) 
		end 
		
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 30)
		effectdata:SetNormal(self:GetUp())
		effectdata:SetScale(1.5)
		effectdata:SetRadius(2)
		effectdata:SetMagnitude(self.Velo:Length())
		effectdata:SetAngle(self.Velo:Angle())
		util.Effect( "gdca_rocketlaunch", effectdata )
		self.Entity:EmitSound( "GML.Emit" )
		self.ammos = self.ammos-1
	

end

function ENT:Think()
	self.Velo = (self.Entity:GetPos()-self.Pos2)
	self.Pos2 = self.Entity:GetPos()

	if self.ammos <= 0 then
	self.reloadtime = CurTime()+10
	self.ammos = self.clipsize
	end
	
	if (self.reloadtime < CurTime()) then
	Wire_TriggerOutput(self.Entity, "Can Fire", 1)
	else
	Wire_TriggerOutput(self.Entity, "Can Fire", 0)
	end
	
	if self.inFire then
	if (self.reloadtime < CurTime()) and self.Target then
	self:fireatgm()	
	end
	end

	self.Entity:NextThink( CurTime() + .01)
	return true
end

function ENT:TriggerInput(k, v)
	self.Velo = (self.Entity:GetPos()-self.Pos2)
	self.Pos2 = self.Entity:GetPos()

	if (k == "Position") then
	self.Target = v or Vector(0,0,0)
	end

	if (k == "Wobbliness") then
	self.Wobbliness = v or 1
	end

	if (k == "Distance Cutoff") then
	self.DistanceCutoff = v or 5000
	end

	if (k == "Z Modulation") then
	self.Zmod = v else self.Zmod = 0.25
	end


		if(k=="Fire ATGM") then
		if((v or 0) >= 1) then
		self.inFire = true
		else
		self.inFire = false
		end
	end
end
 