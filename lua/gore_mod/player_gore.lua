if (engine.ActiveGamemode() == "teamfortress") then return end
local function colideBone(ragdoll,phys_bone)
	local colide = ragdoll:GetPhysicsObjectNum( phys_bone ) --get bone id
	colide:EnableCollisions(false)
	colide:EnableGravity(false)
	colide:SetMass(0.01)
	colide:EnableDrag(false)
	colide:IsPenetrating(true)
	colide:Wake()		
end
local gib_ragdoll_list = {  
    ["models/breen.mdl"] = true,  
    ["models/humans/guard.mdl"] = true,  
    ["models/alyx.mdl"] = true,  
    ["models/humans/scientist_female.mdl"] = true,  
    ["models/gman.mdl"] = true,  
    ["models/vj_blackmesa/hassassin.mdl"] = true,  
    ["models/humans/marine.mdl"] = true,  
    ["models/humans/scientist.mdl"] = true,  
    ["models/lostcoast/fisherman/fisherman.mdl"] = true,  
    ["models/zombie/zombie_soldier.mdl"] = true,  
    ["models/kleiner.mdl"] = true,  
    ["models/mossman.mdl"] = true,  
    ["models/monk.mdl"] = true,  
    ["models/odessa.mdl"] = true,  
    ["models/magnusson.mdl"] = true,  
    ["models/eli.mdl"] = true,  
    ["models/player/enhaced_soldier_stripped/enhaced_soldier_stripped.mdl"] = true,  
    ["models/barney.mdl"] = true,  
	["models/stalker.mdl"] = true,  
}
local head_gib_fix = {
    ["models/player/police.mdl"] = true,  
    ["models/player/t_guerilla_exp_pm.mdl"] = true,  
    ["models/player/monk.mdl"] = true,  
    ["models/player/breen.mdl"] = true,    
    ["models/player/eli.mdl"] = true,    
}
local female_head_gib_fix = {  
    ["models/player/alyx.mdl"] = true,  
    ["models/player/police_fem.mdl"] = true,  
    ["models/player/mossman.mdl"] = true,  
    ["models/player/mossman_arctic.mdl"] = true,  
    ["models/player/group01/female_01.mdl"] = true,  
    ["models/player/group01/female_02.mdl"] = true,  
    ["models/player/group01/female_03.mdl"] = true,  
    ["models/player/group01/female_04.mdl"] = true,  
    ["models/player/group01/female_05.mdl"] = true,  
    ["models/player/group01/female_06.mdl"] = true,  
    ["models/player/group03/female_01.mdl"] = true,  
    ["models/player/group03/female_02.mdl"] = true,  
    ["models/player/group03/female_03.mdl"] = true,  
    ["models/player/group03/female_04.mdl"] = true,  
    ["models/player/group03/female_05.mdl"] = true,  
    ["models/player/group03/female_06.mdl"] = true,  
    ["models/player/group03m/female_01.mdl"] = true,  
    ["models/player/group03m/female_02.mdl"] = true,  
    ["models/player/group03m/female_03.mdl"] = true,  
    ["models/player/group03m/female_04.mdl"] = true,  
    ["models/player/group03m/female_05.mdl"] = true,  
    ["models/player/group03m/female_06.mdl"] = true,  
    ["models/player/p2_chell.mdl"] = true,  
}

local function TransferBones( base, ragdoll ) -- Transfers the bones of one entity to a ragdoll's physics bones (modified version of some of RobotBoy655's code)
	if !IsValid( base ) or !IsValid( ragdoll ) then return end
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum( i )
		if ( IsValid( bone ) ) then
			local pos, ang = base:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
			if ( pos ) then bone:SetPos( pos ) end
			if ( ang ) then bone:SetAngles( ang ) end
		end
	end
end

local function SetEntityStuff( ent1, ent2 ) -- Transfer most of the set things on entity 2 to entity 1
	if !IsValid( ent1 ) or !IsValid( ent2 ) then return false end
	ent1:SetModel( ent2:GetModel() )
	ent1:SetPos( ent2:GetPos() )
	ent1:SetAngles( ent2:GetAngles() )
	ent1:SetColor( ent2:GetColor() )
	ent1:SetSkin( ent2:GetSkin() )
	ent1:SetFlexScale( ent2:GetFlexScale() )
	for i = 0, ent2:GetNumBodyGroups() - 1 do ent1:SetBodygroup( i, ent2:GetBodygroup( i ) ) end
	for i = 0, ent2:GetFlexNum() - 1 do ent1:SetFlexWeight( i, ent2:GetFlexWeight( i ) ) end
	for i = 0, ent2:GetBoneCount() do
		ent1:ManipulateBoneScale( i, ent2:GetManipulateBoneScale( i ) )
		ent1:ManipulateBoneAngles( i, ent2:GetManipulateBoneAngles( i ) )
		ent1:ManipulateBonePosition( i, ent2:GetManipulateBonePosition( i ) )
		ent1:ManipulateBoneJiggle( i, ent2:GetManipulateBoneJiggle( i ) )
	end
end

hook.Add("Think","ServerRagdollShit",function()
    if SERVER then
	    for k,pl in ipairs(player.GetAll()) do  
		    if (!pl:Alive()) then
    			if (IsValid(pl.RagdollEntity)) then
	    			pl:SetMoveType(MOVETYPE_NONE)
				    pl:SetPos(pl.RagdollEntity:GetPos())
			    end
		    end
	    end
    end

end)
hook.Add("DoPlayerDeath","ServerRagdoll",function(ply, attacker, dmginfo)
    if SERVER then
		if GetConVar("can_gib_player"):GetBool() and GetConVar("Noob_gore_mod_enable"):GetBool() then
		local damageForce = dmginfo:GetDamageForce():Length()
        timer.Simple(0.1, function()
            if ply:GetRagdollEntity():IsValid() then
                ply:GetRagdollEntity():Remove()
            end
        end)
        local ragdoll = ents.Create("prop_ragdoll")

        ragdoll:SetModel(ply:GetModel())
        if dmginfo:IsDamageType(DMG_ACID) and GetConVar("Enable_skeletonizer"):GetBool() then
            ragdoll:SetModel("models/player/skeleton.mdl")
        end
        ragdoll:SetPos(ply:GetPos())
        ragdoll:SetAngles(ply:GetAngles())
        ragdoll:SetColor( ply:GetColor() ) 
        ragdoll:SetSkin( ply:GetSkin() )
        ragdoll:SetFlexScale( ply:GetFlexScale() )
        ragdoll:Spawn()
        ragdoll:Activate()
        ApplyCorpseEffects(ragdoll)
		if dmginfo:IsDamageType(DMG_SLASH)  then
			decap_head(ragdoll,ragdoll) 
            generic_gib_head(ragdoll)
        end 
		if dmginfo:IsDamageType(DMG_BLAST) and damageForce >= 160 then
			ragdoll_gib(ragdoll,dmginfo)
        end 
		if ply:LastHitGroup() == HITGROUP_HEAD and damageForce > 1000 then
            generic_gib_head(ragdoll)
		end
		if ply:LastHitGroup() == HITGROUP_CHEST and damageForce > 1000 then
            for i=1,GetConVar("amounts_of_ribs"):GetFloat() do
                local forceVector = Vector(math.random(-500, 500), math.random(-256, 300), math.random(-100, 80))
                shitgib(ragdoll,"models/Gibs/HGIBS_rib.mdl","ValveBiped.Bip01_Spine2",true ,forceVector)
            end
		end
        if ply:LastHitGroup() == HITGROUP_STOMACH and damageForce > 1000 then
            if GetConVar("agly_intestine_gore"):GetBool() then
                bonemerge_prop(ragdoll,"models/noob_dev2323/gib/intestine.mdl")
            end
		end
        if ply:LastHitGroup() == HITGROUP_RIGHTARM and damageForce > 1000 then
            ragdoll.R_arm_gibbed = true 
            gib_PhysBone(ragdoll,"ValveBiped.Bip01_R_Forearm")
            bonemerge_prop(ragdoll,"models/noob_dev2323/gib/upperarm_r.mdl")
        end
        if ply:LastHitGroup() == HITGROUP_LEFTARM and damageForce > 1000 then
            ragdoll.L_arm_gibbed = true 
            gib_PhysBone(ragdoll,"ValveBiped.Bip01_L_Forearm")
            bonemerge_prop(ragdoll,"models/noob_dev2323/gib/upperarm_L.mdl")
        end
        if ply:LastHitGroup() == HITGROUP_RIGHTLEG and damageForce > 1000 then
            ragdoll.R_leg_gibbed = true 
            gib_PhysBone(ragdoll,"ValveBiped.Bip01_R_Calf")
            bonemerge_prop(ragdoll,"models/noob_dev2323/gib/R_leg_gap.mdl")
        end
        if ply:LastHitGroup() == HITGROUP_LEFTLEG and damageForce > 1000 then
            ragdoll.L_leg_gibbed = true 
            gib_PhysBone(ragdoll,"ValveBiped.Bip01_L_Calf")
            bonemerge_prop(ragdoll,"models/noob_dev2323/gib/L_leg_gap.mdl")
        end
        if (!GetConVar("ai_serverragdolls"):GetBool()) then
            ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        end
        if (ply:IsOnFire()) then
			ragdoll:SetMaterial("models/charple/charple1_sheet") -- set material		
            ragdoll:Ignite(10,70)
        end
		
        TransferBones(ply,ragdoll)
        ply.RagdollEntity = ragdoll
        --if (!GetConVar("ai_serverragdolls"):GetBool()) then
		    ragdoll:Fire("FadeAndRemove","",GetConVar("player_corpse_fade_time"):GetFloat())
        --end
        local phys = ragdoll:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:AddVelocity(ply:GetVelocity() * 8 + dmginfo:GetDamageForce())
        end
        if (dmginfo:IsDamageType(DMG_DISSOLVE)) then
            timer.Simple(0.15, function()
                local dissolver = ents.Create( "env_entity_dissolver" )
                dissolver:SetPos( ragdoll:LocalToWorld(ragdoll:OBBCenter()) )
                dissolver:SetKeyValue( "dissolvetype", 0 )
                dissolver:Spawn()
                dissolver:Activate()
                local name = "Dissolving_"..math.random()
                ragdoll:SetName( name )
                dissolver:Fire( "Dissolve", name, 0 )
                dissolver:Fire( "Kill", name, 0.10 )
            end)
        end
		end
    end
end)