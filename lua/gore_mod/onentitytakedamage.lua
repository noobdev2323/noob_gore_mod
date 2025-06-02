hook.Add("EntityTakeDamage", "pai_do_reabilitado",function(target, dmginfo) --gib script
	if GetConVar("Noob_gore_mod_enable"):GetBool() then
			local npc_model = target:GetModel()
			if not no_gib_ragdoll[npc_model] and target:LookupBone("ValveBiped.Bip01_Pelvis") and target:IsNPC()  then
				if dmginfo:IsDamageType(DMG_ACID) and not target:IsRagdoll() then
					if GetConVar("Enable_skeletonizer"):GetBool() then
						target:SetModel("models/player/skeleton.mdl")
						target:TakeDamage(target:Health(), attacker, attacker)
					end
				end
			end 
		if target:IsRagdoll() and GetConVar("can_gib_ragdoll"):GetBool() and target.GORE_Corpse and CurTime() > target.gib_Corpse_StartT and not dmginfo:IsDamageType(DMG_NEVERGIB) then 
			local hit = GetClosestPhysBone(target,dmginfo:GetDamagePosition()) --get hit physbone
			local physbone = target:TranslatePhysBoneToBone(hit)
			local bone_name = target:GetBoneName( physbone ) 
			if target.boneHealth[bone_name] then
				target.boneHealth[bone_name] = target.boneHealth[bone_name] - dmginfo:GetDamage()
				if GetConVar("debug_mode"):GetBool() then
					print("health"..target.boneHealth[bone_name])
				end
			end
			if target.boneHealth["ValveBiped.Bip01_Head1"] <= 0 && !target.Head_gibbed then 
				target.Head_gibbed = true 
				madness_gib_head(target)
			end 
			if GetConVar("only_headshot_dismembers"):GetBool() == false and target.boneHealth[bone_name] then		
			if bone_name == "ValveBiped.Bip01_L_Forearm" and not target.L_arm_gibbed == true then
				if target.boneHealth[bone_name] <= 0 then 
					target.L_arm_gibbed = true 
					gib_PhysBone(target,"ValveBiped.Bip01_L_Forearm")
					bonemerge_prop(target,"models/noob_dev2323/gib/upperarm_L.mdl")
					local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
					shitgib(target,"models/mosi/fnv/props/gore/gorearm02.mdl","ValveBiped.Bip01_L_Forearm",false ,forceVector,false,false)
				end
			end 	
			if bone_name == "ValveBiped.Bip01_L_Hand" and not target.L_arm_gibbed == true and not target.L_hand_gibbed == true then
				if target.boneHealth[bone_name] <= 0 and not target.L_hand_gibbed == true  then 
					target.L_hand_gibbed = true 
					gib_PhysBone(target,"ValveBiped.Bip01_L_Hand")
					bonemerge_prop(target,"models/noob_dev2323/gib/L_arm.mdl")
					local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
					shitgib(target,"models/mosi/fnv/props/gore/gorearm03.mdl","ValveBiped.Bip01_L_Hand",false ,forceVector,false,false)
				end
			end 	
			if bone_name == "ValveBiped.Bip01_R_Forearm" and not target.R_arm_gibbed == true then 
				if target.boneHealth[bone_name] <= 0 then 
					target.R_arm_gibbed = true 
					gib_PhysBone(target,"ValveBiped.Bip01_R_Forearm")
					bonemerge_prop(target,"models/noob_dev2323/gib/upperarm_r.mdl")
					local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
					shitgib(target,"models/mosi/fnv/props/gore/gorearm02.mdl","ValveBiped.Bip01_R_Forearm",false ,forceVector,false,false)
				end
			end 	
			if bone_name == "ValveBiped.Bip01_R_Hand" and not target.R_arm_gibbed == true or not target.R_hand_gibbed == true then 
				if target.boneHealth[bone_name] <= 0 and not target.R_hand_gibbed == true then 
					target.R_hand_gibbed = true 
					gib_PhysBone(target,"ValveBiped.Bip01_R_Hand")
					bonemerge_prop(target,"models/noob_dev2323/gib/R_arm.mdl") 
					local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
					shitgib(target,"models/mosi/fnv/props/gore/gorearm03.mdl","ValveBiped.Bip01_R_Hand",false ,forceVector,false,false)
				end
			end 	
			if bone_name == "ValveBiped.Bip01_R_Calf" and not target.R_leg_gibbed then 
				if target.boneHealth[bone_name] <= 0 then 
					target.R_leg_gibbed = true 
					gib_PhysBone(target,"ValveBiped.Bip01_R_Calf")
					bonemerge_prop(target,"models/noob_dev2323/gib/R_leg_gap.mdl")
					local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
					shitgib(target,"models/mosi/fnv/props/gore/gorearm01.mdl","ValveBiped.Bip01_R_Calf",false ,forceVector,false,false)
					if not target.R_foot_gibbed then
						shitgib(target,"models/mosi/fnv/props/gore/goreleg01.mdl","ValveBiped.Bip01_R_Foot",false ,forceVector,false,false)
					end
				end
			end 
			if bone_name == "ValveBiped.Bip01_L_Calf" and not target.L_leg_gibbed then 
				if target.boneHealth[bone_name] <= 0 then 
					target.L_leg_gibbed = true 
					gib_PhysBone(target,"ValveBiped.Bip01_L_Calf")
					bonemerge_prop(target,"models/noob_dev2323/gib/L_leg_gap.mdl")
					local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
					shitgib(target,"models/mosi/fnv/props/gore/goreleg02.mdl","ValveBiped.Bip01_L_Calf",false ,forceVector,false,false)
					if not target.L_foot_gibbed then
						shitgib(target,"models/mosi/fnv/props/gore/goreleg01.mdl","ValveBiped.Bip01_L_Foot",false ,forceVector,false,false)
					end
				end
			end	 		
			if bone_name == "ValveBiped.Bip01_L_Foot" and not target.L_foot_gibbed and not target.L_leg_gibbed == true then 
				if target.boneHealth[bone_name] <= 0 then 
					target.L_foot_gibbed = true 
					gib_PhysBone(target,"ValveBiped.Bip01_L_Foot")
					bonemerge_prop(target,"models/noob_dev2323/gib/L_foot.mdl")
					local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
					shitgib(target,"models/mosi/fnv/props/gore/goreleg01.mdl","ValveBiped.Bip01_L_Foot",false ,forceVector,false,false)
				end
			end 
			if bone_name == "ValveBiped.Bip01_R_Foot" and not target.R_foot_gibbed and not target.R_leg_gibbed == true then 
				if target.boneHealth[bone_name] <= 0 then 
					target.R_foot_gibbed = true 
					gib_PhysBone(target,"ValveBiped.Bip01_R_Foot")
					bonemerge_prop(target,"models/noob_dev2323/gib/R_foot.mdl")
					local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
					shitgib(target,"models/mosi/fnv/props/gore/goreleg01.mdl","ValveBiped.Bip01_R_Foot",false ,forceVector,false,false)
				end
			end 
		end
	
		if !dmginfo:IsBulletDamage() then
			local dmg_force = dmginfo:GetDamage()
			if dmginfo:IsExplosionDamage() and dmg_force >= 10 then dmginfo:ScaleDamage(3) end --escale the damege on explosions     
			target:SetHealth(target:Health() - dmginfo:GetDamage())
			if target:Health() <= 0 then ragdoll_gib(target,dmginfo) end
		end 
		end 
	end
end)