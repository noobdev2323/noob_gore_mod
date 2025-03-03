local function onCreateRagdoll(owner, ragdoll)
if GetConVar("Noob_gore_mod_enable"):GetBool() then
	local npc_model = owner:GetModel()
	local npc_class = owner:GetModel()
	if owner.gib then
		if GetConVar("on_explode_npc"):GetFloat() == 1  then
			ragdoll_gib(owner,dmginfo)
			ragdoll:Remove()
		end		
		if GetConVar("on_explode_npc"):GetFloat() == 2  then
			local hit = GetClosestPhysBone(ragdoll,owner.dmgpos) --get hit physbone
			local physbone = ragdoll:TranslatePhysBoneToBone(hit)
			local bone_name = ragdoll:GetBoneName( physbone ) 
			if bone_name == "ValveBiped.Bip01_L_Foot" or bone_name == "ValveBiped.Bip01_L_Foot" and not ragdoll.gib_my_L_leg then 
				owner.gib_my_L_leg = true
			end 
			if bone_name == "ValveBiped.Bip01_R_Foot" or bone_name == "ValveBiped.Bip01_R_Foot" and not ragdoll.gib_my_R_leg then 
				owner.gib_my_R_leg = true
			end 
			if bone_name == "ValveBiped.Bip01_L_Forearm" or bone_name == "ValveBiped.Bip01_L_Hand" and not ragdoll.gib_my_L_arm then 
				owner.gib_my_L_arm = true
			end 
			if bone_name == "ValveBiped.Bip01_R_Forearm" or bone_name == "ValveBiped.Bip01_R_Hand" and not ragdoll.gib_my_R_arm then 
				owner.gib_my_R_arm = true
			end 
			if bone_name == "ValveBiped.Bip01_Head1" and not ragdoll.generic_gib_head then 
				owner.generic_gib_head = true
				owner.blood_effect_head = true
				owner.gibs = true
			end 
		end
	end
	if not no_gib_ragdoll[npc_model] or not npc_class_black_list[npc_class] then
		ApplyCorpseEffects(ragdoll) 
	end
	
	if owner:IsOnFire() and GetConVar("burned_corpse_effect"):GetBool() then --fire efect
		ragdoll:SetMaterial("models/charple/charple1_sheet") -- set material		
	end

	if owner.gibs then
		if owner.head_less then return end
		make_head_gibs(ragdoll)
	end
	if owner.head_less then
		decap_head(owner,ragdoll)
	end
	if owner.spawn_ribs then
		for i=1,GetConVar("amounts_of_ribs"):GetFloat() do
			local forceVector = Vector(math.random(-500, 500), math.random(-256, 300), math.random(-100, 80))
			shitgib(ragdoll,"models/Gibs/HGIBS_rib.mdl","ValveBiped.Bip01_Spine2",true ,forceVector)
		end
	end
	if GetConVar("only_headshot_dismembers"):GetBool() == false then
	if owner.gib_my_R_arm then
		ragdoll.R_arm_gibbed = true 
		gib_PhysBone(ragdoll,"ValveBiped.Bip01_R_Forearm")
		bonemerge_prop(ragdoll,"models/noob_dev2323/gib/upperarm_r.mdl")
		local forceVector = Vector(math.random(-500, 500), math.random(-256, 300), math.random(-100, 80))
		shitgib(ragdoll,"models/mosi/fnv/props/gore/gorearm02.mdl","ValveBiped.Bip01_R_Forearm",false ,forceVector,false,false)
	end
	if owner.gib_my_L_arm then
		ragdoll.L_arm_gibbed = true 
		gib_PhysBone(ragdoll,"ValveBiped.Bip01_L_Forearm")
		bonemerge_prop(ragdoll,"models/noob_dev2323/gib/upperarm_L.mdl") 

		local forceVector = Vector(math.random(-500, 500), math.random(-256, 300), math.random(-100, 80))
		shitgib(ragdoll,"models/mosi/fnv/props/gore/gorearm02.mdl","ValveBiped.Bip01_L_Forearm",false ,forceVector,false,false)
	end
	if owner.gib_my_R_leg then
		ragdoll.R_leg_gibbed = true 
		gib_PhysBone(ragdoll,"ValveBiped.Bip01_R_Calf")
		bonemerge_prop(ragdoll,"models/noob_dev2323/gib/R_leg_gap.mdl") 
		local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
		shitgib(ragdoll,"models/mosi/fnv/props/gore/goreleg02.mdl","ValveBiped.Bip01_R_Calf",false ,forceVector,false,false)
		shitgib(ragdoll,"models/mosi/fnv/props/gore/goreleg01.mdl","ValveBiped.Bip01_R_Foot",false ,forceVector,false,false)
	end
	if owner.gib_my_L_leg then
		ragdoll.L_leg_gibbed = true 
		gib_PhysBone(ragdoll,"ValveBiped.Bip01_L_Calf")
		bonemerge_prop(ragdoll,"models/noob_dev2323/gib/L_leg_gap.mdl")

		local forceVector = Vector(math.random(-150, 150), math.random(-150, 150), math.random(-150, 150))
		shitgib(ragdoll,"models/mosi/fnv/props/gore/goreleg02.mdl","ValveBiped.Bip01_L_Calf",false ,forceVector,false,false)
		shitgib(ragdoll,"models/mosi/fnv/props/gore/goreleg01.mdl","ValveBiped.Bip01_L_Foot",false ,forceVector,false,false)
	end
	end
	if owner.generic_gib_head then
		generic_gib_head(ragdoll)
	end	
	if owner.intestine then
		if GetConVar("agly_intestine_gore"):GetBool() then
			bonemerge_prop(ragdoll,"models/noob_dev2323/gib/intestine.mdl")
		end
	end
	if owner.blood_effect_head and GetConVar("gore_blood_effect"):GetBool() then
		if ragdoll:LookupAttachment( "forward" ) == 0 then return end
            for i=1,3 do
                local bloodeffect = ents.Create("info_particle_system")
                bloodeffect:SetKeyValue("effect_name","blood_advisor_pierce_spray")
                bloodeffect:SetPos(ragdoll:GetAttachment(ragdoll:LookupAttachment("forward")).Pos)
                bloodeffect:SetAngles(ragdoll:GetAttachment(ragdoll:LookupAttachment("forward")).Ang)
                bloodeffect:SetParent(ragdoll)
                bloodeffect:Fire("SetParentAttachment","forward")
                bloodeffect:Spawn()
                bloodeffect:Activate()
                bloodeffect:Fire("Start","",0)
                bloodeffect:Fire("Kill","",3.5)
            end		
	end
end
end

hook.Add("CreateEntityRagdoll", "ReplaceRagdoll", onCreateRagdoll)
