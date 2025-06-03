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
			local hit = GetClosestPhysBone_recoded(target,dmginfo) --get hit physbone
			if hit == nil then
				return 
			end
			local bone = target:TranslatePhysBoneToBone(hit)
			local bone_name = target:GetBoneName( bone ) 		

			if target.boneHealth[bone_name] then
				target.boneHealth[bone_name] = target.boneHealth[bone_name] - dmginfo:GetDamage()
				if GetConVar("debug_mode"):GetBool() then
					print("health"..target.boneHealth[bone_name])
				end
				if target.boneHealth["ValveBiped.Bip01_Head1"] <= 0 && !target.Head_gibbed then 
					target.Head_gibbed = true
					generic_gib_head(target)
					make_head_gibs(target)
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