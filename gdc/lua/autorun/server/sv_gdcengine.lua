GDCENGINE = 1

gdc = {}

function gdc.registerent( ent, health, armor )
	local h = ent:GetPhysicsObject():GetMass() * 4
	ent.cbt = {};
	ent.cbt.health = health or math.Clamp( h, 1, 4000 )
	ent.cbt.armor = armor or 8
	ent.cbt.maxhealth = health or math.Clamp( h, 1, 4000 )
end

function gdc.validate( ent )

	if (ent:IsValid() and !ent:IsPlayer() and !ent:IsNPC() and ent:GetClass() != "gdc_debrizzle" and !ent:IsWorld() and !ent:IsWeapon() and string.find(ent:GetClass(), "func_") != 1 ) then
	if ent.cbt then return true else gdc.registerent(ent) end
	return true
	end
	return false
end

function gdc.gdchit( entity, damage )
	local valid = gdc.validate(entity)
	if valid then

		if ((entity.cbt.health) < damage) then
		return 2					// Remove it, it's dead
		else

		entity.cbt.health = entity.cbt.health - damage		
		return 1					// Do damage to it
		end
	else
	return 1
	end
end

cbt_dealgdchit = gdc.gdchit

									//cbt_dealcaphit deals a bullet damage type
function gdc.caphit( entity, damage )

	local attack = gdc.gdchit( entity, damage )
	if attack == 2 then
		local tmp = entity:GetModel()
		local wreck = ents.Create( "gdc_debrizzle" )
		wreck:SetModel( entity:GetModel() )
		wreck:SetAngles( entity:GetAngles() )
		wreck:SetMaterial(entity:GetMaterial() )
		wreck:SetColor(entity:GetColor() )
		wreck:SetPos( entity:GetPos() )
		wreck:Spawn()

		local phys = wreck:GetPhysicsObject()

		if entity:GetPhysicsObject():GetVelocity():Length() > 0 then
		//phys:ApplyForceCenter(entity:GetPhysicsObject():GetVelocity()*phys:GetMass())
		phys:SetVelocity(entity:GetPhysicsObject():GetVelocity()*66)
		phys:ApplyForceOffset(VectorRand():GetNormalized()*50,entity:GetPos()+VectorRand():GetNormalized()*50 )

		elseif entity:GetParent():IsValid() then
		//phys:ApplyForceCenter(entity:GetParent():GetPhysicsObject():GetVelocity()*phys:GetMass())
		phys:SetVelocity(entity:GetParent():GetPhysicsObject():GetVelocity())
		phys:ApplyForceOffset(VectorRand():GetNormalized()*50,entity:GetPos()+VectorRand():GetNormalized()*50 )
		end

		wreck:Activate()
		entity:Remove()
		end
return attack
end

cbt_dealcaphit = gdc.caphit


// This is the function that controls spherical explosion damage.
function gdc.gdcsplode( position, radius, damage, shell)

	local targets = ents.FindInSphere( position, radius)
	
	for _,i in pairs(targets) do	
		
		local tracedata = {}
		tracedata.start = position
		tracedata.endpos = i:LocalToWorld(i:OBBCenter())
		tracedata.filter = shell
		tracedata.mask = MASK_SHOT
		local trace = util.TraceLine(tracedata) 
		
		if trace.Entity == i then
		local hitat = trace.HitPos
		local dist = (position-i:LocalToWorld(i:OBBCenter())):Length()
		local destructy = damage*math.Clamp((radius-dist)/(radius/2),0,1)	// Mutiply damage by distance fraction
		cbt_dealcaphit( i, destructy)
		end
	end
	
end

cbt_gdcsplode = gdc.gdcsplode

