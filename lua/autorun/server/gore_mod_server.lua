CreateConVar("Noob_gore_mod_enable", "1", FCVAR_ARCHIVE, "Enable or disable gore")

CreateConVar("gore_blood_effect", "1", FCVAR_ARCHIVE, "gore_blood_effect")
CreateConVar("lua_particles_effect", "1", FCVAR_ARCHIVE, "gore_blood_effect")
CreateConVar("can_gib_player", "1", FCVAR_ARCHIVE, "can_gib_player")
CreateConVar("can_gib_ragdoll", "1", FCVAR_ARCHIVE, "can_gib_ragdoll")
CreateConVar("debug_mode", "0", FCVAR_ARCHIVE, "debug_mode")
CreateConVar("decapitation_gib", "1", FCVAR_ARCHIVE, "decapitation_gib")
CreateConVar("decapitation", "1", FCVAR_ARCHIVE, "decapitation")
CreateConVar("only_headshot_dismembers", "0", FCVAR_ARCHIVE, "only_headshot_dismembers")
CreateConVar("cannibalism", "1", FCVAR_ARCHIVE, "cannibalism")
CreateConVar("Enable_skeletonizer", "1", FCVAR_ARCHIVE, "Enable_skeletonizer")
CreateConVar("agly_intestine_gore", "1", FCVAR_ARCHIVE, "agly_intestine_gore")
CreateConVar("burned_corpse_effect", "1", FCVAR_ARCHIVE, "burned_corpse_effect")
CreateConVar("ragdoll_health", "400", FCVAR_ARCHIVE, "ragdoll_health")
CreateConVar("limb_health_multiplier", "1", FCVAR_ARCHIVE, "limb_health_multiplier")
CreateConVar("NPC_dismember_multiplier", "1", FCVAR_ARCHIVE, "NPC_dismember_multiplier")
CreateConVar("rib_gib", "1", FCVAR_ARCHIVE, "rib_gib")
CreateConVar("on_explode_npc", "1", FCVAR_ARCHIVE, "on_explode_npc")
CreateConVar("amounts_of_ribs", "3", FCVAR_ARCHIVE, "amounts_of_ribs")
CreateConVar("amounts_of_head_gibs", "5", FCVAR_ARCHIVE, "amounts_of_head_gibs")
CreateConVar("gib_fade_time", "30", FCVAR_ARCHIVE, "gib_fade_time") 
CreateConVar("player_corpse_fade_time", "30", FCVAR_ARCHIVE, "player_corpse_fade_time")

util.AddNetworkString( "head_gibs_particles" ) 



hook.Add( "ScaleNPCDamage", "ScaleNPCDamageExample", function( npc, hitgroup, dmginfo )
    if GetConVar("Noob_gore_mod_enable"):GetBool() and IsValid(npc) then
	local npc_model = npc:GetModel()
	local damageForce = dmginfo:GetDamageForce():Length()
    if gib_ragdoll_list[npc_model] or combine_list[npc_model] or npc:GetClass() == "npc_citizen" or npc:GetClass() == "npc_zombie" or npc:GetClass() == "npc_kleiner"  or npc:GetClass() == "terminator_nextbot_fakeply"  or npc:GetClass() == "npc_vj_test_humanply" then

		if hitgroup == HITGROUP_CHEST and damageForce > 1200*GetConVar("NPC_dismember_multiplier"):GetFloat() and GetConVar("rib_gib"):GetBool() then     
            npc.spawn_ribs = true
        end
		if damageForce > 1000*GetConVar("NPC_dismember_multiplier"):GetFloat() then
			if hitgroup == HITGROUP_HEAD then
				npc.generic_gib_head = true
				npc.blood_effect_head = true
				if dmginfo:IsDamageType(DMG_SLASH) then
				
				else
					npc.gibs = true
				end 
			end		
			if hitgroup == HITGROUP_STOMACH  then
    	        npc.intestine = true
			end		
			if hitgroup == HITGROUP_RIGHTARM then 
     	       npc.gib_my_R_arm = true
			end
			if hitgroup == HITGROUP_LEFTARM then
   	         npc.gib_my_L_arm = true
			end
			if hitgroup == HITGROUP_RIGHTLEG then
     	       npc.gib_my_R_leg = true
			end
			if hitgroup == HITGROUP_LEFTLEG then
     	       npc.gib_my_L_leg = true
			end
		end
		if dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_CRUSH) and damageForce >= 160 then
            npc.gib = true 
            npc.dmgpos = dmginfo:GetDamagePosition()
        end
	end 
	  
	end    
end)
include( "gore_mod/function.lua" )
include( "gore_mod/npc_list.lua" )
include( "gore_mod/player_gore.lua" )
include( "gore_mod/onCreateRagdoll.lua" )
include( "gore_mod/onEntityTakeDamage.lua" )