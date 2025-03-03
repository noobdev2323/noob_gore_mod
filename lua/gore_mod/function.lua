
function colideBone(ragdoll,phys_bone)
	local colide = ragdoll:GetPhysicsObjectNum( phys_bone ) --get bone id
	colide:EnableCollisions(false)
	colide:SetMass(0.1)
	colide:EnableDrag(false)
end
function shitgib(ragdoll,model,bone,meat,forceVector,getpos,random_rotate)
    local npc_model = ragdoll:GetModel()
	if ragdoll:LookupBone(bone) == nil and not getpos then return end
	if gib_black_list[npc_model] then return end
	local chunk = ents.Create( "gib_chunk" )
	chunk:SetModel(model)
	if getpos then 
		local centerPos = ragdoll:GetPos() + ragdoll:OBBCenter()
		local gibMaxs = ragdoll:OBBMaxs() 
		local gibMins = ragdoll:OBBMins()
		chunk:SetPos(centerPos + Vector(math.random(gibMins.x, gibMaxs.x), math.random(gibMins.y, gibMaxs.y), 10))
	else
		chunk:SetPos(ragdoll:GetBonePosition(ragdoll:LookupBone(bone)))
	end
	if random_rotate then
		chunk:SetAngles(select(2, ragdoll:GetBonePosition(ragdoll:LookupBone(bone)))-Angle(90,90,0))
	else
		chunk:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180))) 
	end
	chunk:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
	

	if meat == true then chunk:SetMaterial( "models/flesh" ) end
	chunk:Spawn()	
    local chunk = chunk:GetPhysicsObject()
    if IsValid(chunk) then  chunk:AddVelocity(forceVector) end    
end
/*--------------------------------------------------
function tinygibs(model,shit_pos,forceVector)
	local chunk = ents.Create( "gib_chunk" )
	chunk:SetModel(model)
	chunk:SetPos(shit_pos)
	chunk:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180))) 

	chunk:Spawn()	
    local chunk = chunk:GetPhysicsObject()
    if IsValid(chunk) then  chunk:AddVelocity(forceVector) end   
			local bloodspray = EffectData()
			bloodspray:SetOrigin(shit_pos)
			bloodspray:SetScale(8)
			bloodspray:SetFlags(3)
			bloodspray:SetColor(0)
			util.Effect("BloodImpact",bloodspray)	
end 
--------------------------------------------------*/

local gibs_table = {"models/mosi/fnv/props/gore/goretorso03.mdl", "models/mosi/fnv/props/gore/goretorso03.mdl", "models/mosi/fnv/props/gore/goretorso02.mdl", "models/mosi/fnv/props/gore/goreleg02.mdl", "models/mosi/fnv/props/gore/gorehead01.mdl","models/mosi/fnv/props/gore/gorearm01.mdl"} --to make custom defalt gib
function ragdoll_gib(ragdoll,DMG)
	if ragdoll.ragdoll_destroid then return	end --to avoid gib ragdoll 2 times
	ragdoll.ragdoll_destroid = true
	for i=1,5 do
		local forceVector = Vector(math.random(-250, 350), math.random(-250, 350), math.random(-250, 350))
		shitgib(ragdoll,"models/props_junk/watermelon01_chunk02a.mdl","ValveBiped.Bip01_Head1",true,forceVector,true,false   )
	end
	for _, v in ipairs(gibs_table) do
		local forceVector = Vector(math.random(-250, 350), math.random(-250, 350), math.random(-250, 350))
		shitgib(ragdoll,v,"ValveBiped.Bip01_Pelvis",false,forceVector,true)
	end
	ragdoll:EmitSound('noob_dev2323/bsmod/gib_splat.wav', 75, 100, 0.4)
	ragdoll:Remove() --delete ragdoll
end
function make_head_gibs(ragdoll)
	for i=1,GetConVar("amounts_of_head_gibs"):GetFloat() do
		local forceVector = Vector(math.random(-250, 350), math.random(-250, 350), math.random(-250, 350))
		shitgib(ragdoll,"models/props_junk/watermelon01_chunk02a.mdl","ValveBiped.Bip01_Head1",true,forceVector)
	end
	sound.Play("noob_dev2323/bsmod/headshotdie" .. math.random(1,3) .. ".wav", ragdoll:GetPos(), 75, 100, 1)
end
function bonemerge_prop(ragdoll,model)
	local npc_model = ragdoll:GetModel()
	local attachments = ragdoll:GetAttachments()
	local Attachment = nil
    for _, att in pairs( attachments ) do 
		Attachment = att.name 	
	end
	if Attachment == nil then
		return
	end
	if not prop_parent_blacklist[npc_model] then 
		ragdoll.bonemerge_prop = ents.Create("prop_physics") 
		ragdoll.bonemerge_prop:SetModel(model)
		ragdoll.bonemerge_prop:SetLocalPos(ragdoll:GetPos())
		ragdoll.bonemerge_prop:SetOwner(ragdoll)
		ragdoll.bonemerge_prop:SetParent(ragdoll)
		ragdoll.bonemerge_prop:Fire("SetParentAttachment",Attachment)
		ragdoll.bonemerge_prop:Spawn()
		ragdoll.bonemerge_prop:Activate()
		ragdoll.bonemerge_prop:SetSolid(SOLID_NONE)
		ragdoll.bonemerge_prop:AddEffects(EF_BONEMERGE)
	end
end
function make_head_gap(owner,ragdoll)
	local npc_model = owner:GetModel()
	local gib_model = nil
	if head_gib_fix[npc_model] then
		gib_model = "models/noob_dev2323/gib/l4d/head_gore2.mdl"
	elseif female_head_gib_fix[npc_model] then
		gib_model = "models/noob_dev2323/gib/l4d/head_gore2.mdl"
	else
		gib_model = "models/noob_dev2323/gib/l4d/head_gore2.mdl"
	end
	bonemerge_prop(ragdoll,gib_model) 
end
function GetClosestPhysBone(ent,pos)
	local closest_distance = -1
	local closest_bone = -1
	
	for i=0, ent:GetPhysicsObjectCount()-1 do
		local bone = ent:TranslatePhysBoneToBone(i)
		
		if bone then 
			local phys = ent:GetPhysicsObjectNum(i)
			
			if IsValid(phys) then
				local distance = phys:GetPos():Distance(pos)
				
				if (distance < closest_distance || closest_distance == -1) then
					closest_distance = distance
					closest_bone = i
				end
			end
		end
	end
	return closest_bone
end
function generic_gib_head(ragdoll)
	ragdoll.Head_gibbed = true 
	if GetConVar("debug_mode"):GetBool() then
		for i, ply in ipairs( player.GetAll() ) do ply:ChatPrint( "head gibbed" ) end
	end
	if GetConVar("lua_particles_effect"):GetBool() then
		net.Start( "head_gibs_particles" )
			net.WriteEntity(ragdoll)
		net.Broadcast()
	end
	local head_bone = ragdoll:LookupBone( "ValveBiped.Bip01_Head1" )
	if head_bone then
		ragdoll:ManipulateBoneScale(head_bone,Vector(0,0,0))
		local bone = ragdoll:TranslateBoneToPhysBone(head_bone)
		colideBone(ragdoll,bone)
		local children = ragdoll:GetChildBones(head_bone)
		for k, v in pairs(children) do
			ragdoll:ManipulateBoneScale(v,Vector(0,0,0))
			local children = ragdoll:GetChildBones(v)
			for k, v in pairs(children) do
				ragdoll:ManipulateBoneScale(v,Vector(0,0,0))
			end
		end 			
	end
	make_head_gap(ragdoll,ragdoll)
end
function decap_head(owner,ragdoll)
	if GetConVar("decapitation_gib"):GetBool() then
		local head_gibModel = "models/noob_dev2323/gib/limbs/l4d_head1.mdl" 
		if (owner:GetModel() == "models/breen.mdl") or (owner:GetModel() == "models/player/breen.mdl")then	
			head_gibModel = "models/headspack/breenhead.mdl" 
		elseif (owner:GetModel() == "models/kleiner.mdl") then	
			head_gibModel = "models/headspack/kleinerhead.mdl" 
		elseif (owner:GetModel() == "models/monk.mdl") or (owner:GetModel() == "models/player/monk.mdl") then	
			head_gibModel = "models/headspack/monkhead.mdl" 
		elseif (owner:GetModel() == "models/eli.mdl") then	
			head_gibModel = "models/headspack/elihead.mdl" 
		elseif (owner:GetModel() == "models/odessa.mdl") or (owner:GetModel() == "models/player/odessa.mdl") then	
			head_gibModel = "models/headspack/odessahead.mdl" 
		elseif (owner:GetModel() == "models/mossman.mdl") or (owner:GetModel() == "models/player/mossman.mdl") or (owner:GetModel() == "models/player/mossman_arctic.mdl") then	
			head_gibModel = "models/headspack/mossmanhead.mdl" 
		elseif (owner:GetModel() == "models/gman.mdl") or (owner:GetModel() == "models/player/gman_high.mdl") then	
			head_gibModel = "models/headspack/gmanhead.mdl" 
		elseif (owner:GetModel() == "models/alyx.mdl") or (owner:GetModel() == "models/player/alyx.mdl") then	
			head_gibModel = "models/headspack/alyxhead.mdl" 
		elseif (owner:GetModel() == "models/barney.mdl") or (owner:GetModel() == "models/player/barney.mdl") then	
			head_gibModel = "models/headspack/barneyhead.mdl" 
		elseif (owner:GetModel() == "models/stalker.mdl") then	
			head_gibModel = "models/headspack/stalkerhead.mdl" 
		elseif (owner:GetModel() == "models/player/guerilla.mdl") or (owner:GetModel() == "models/player/t_guerilla_exp_pm.mdl") then	
			head_gibModel = "models/headlessbody/guerillahead.mdl" 
		elseif (owner:GetModel() == "models/player/phoenix.mdl") or (owner:GetModel() == "models/player/t_phoenix_exp_pm.mdl") then	
			head_gibModel = "models/headlessbody/arctichead.mdl" 
		elseif (owner:GetModel() == "models/player/swat.mdl") or (owner:GetModel() == "models/player/ct_gign_exp_pm.mdl") then	
			head_gibModel = "models/headlessbody/gignhead.mdl" 
		elseif (owner:GetModel() == "models/player/urban.mdl") or (owner:GetModel() == "models/player/ct_urban_exp_pm.mdl") then	
			head_gibModel = "models/headlessbody/gignhead.mdl" 
		elseif (owner:GetModel() == "models/player/leet.mdl") or (owner:GetModel() == "models/player/leet.mdl") then	
			head_gibModel = "models/headlessbody/leethead.mdl" 
		elseif (owner:GetModel() == "models/chicken_zombie/zombie_chiken_man_npc.mdl") and owner:GetBodygroup(1) == 0 then	
			head_gibModel = "models/gibs_chicken/head_gib.mdl" 
		elseif (owner:GetModel() == "models/player/vengeance/skeleton_with_hands/skeleton_with_hands.mdl") or (owner:GetModel() == "models/player/skeleton.mdl") or (owner:GetModel() == "models/akuld/hl1dmskel/dm_skel.mdl") then	
			head_gibModel = "models/skeleton/shit/head.mdl" 
		elseif (owner:GetModel() == "models/combine_soldier.mdl") or (owner:GetModel() == "models/combine_soldier_prisonguard.mdl") then	
			head_gibModel = "models/noob_dev2323/gib/combine_soldier_head.mdl" 
		elseif (owner:GetModel() == "models/police.mdl") or (owner:GetModel() == "models/noob_dev2323/gib_Police.mdl") or (owner:GetModel() == "models/player/police.mdl") or (owner:GetModel() == "models/player/police_fem.mdl")  then	
			head_gibModel = "models/headspack/metrocophead.mdl" 
		elseif (owner:GetModel() == "models/combine_super_soldier.mdl") or (owner:GetModel() == "models/player/combine_super_soldier.mdl") then	
			head_gibModel = "models/headspack/csshead.mdl" 
		elseif (owner:GetModel() == "models/humans/group01/male_07.mdl") or (owner:GetModel() == "models/player/group03m/male_07.mdl") or (owner:GetModel() == "models/player/group01/male_07.mdl")  then	
			head_gibModel = "models/synergy/gibs/male_07_head.mdl" 
		elseif (owner:GetModel() == "models/humans/group01/female_02.mdl") or (owner:GetModel() == "models/player/group01/female_02.mdl") or (owner:GetModel() == "models/player/group03m/female_02.mdl")  then	
			head_gibModel = "models/synergy/gibs/female_02_head.mdl" 
		elseif (owner:GetModel() == "models/humans/group01/male_09.mdl") or (owner:GetModel() == "models/player/group01/male_09.mdl") or (owner:GetModel() == "models/player/group03m/male_09.mdl")  then	
			head_gibModel = "models/synergy/gibs/male_09_head.mdl" 
		end
		local forceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(100, 350))
		shitgib(ragdoll,head_gibModel,"ValveBiped.Bip01_Head1",false,forceVector,false,false)
	end
end
function gib_PhysBone(ragdoll,bone1)
    if ragdoll:LookupBone(bone1) == nil then return end
    if !ragdoll.gib_bone then ragdoll.gib_bone = {} table.insert(gib_PhysBone_RAGDOLLS, ragdoll) end

    local bone_id = ragdoll:LookupBone(bone1)

	if GetConVar("debug_mode"):GetBool() then
		for i, ply in ipairs( player.GetAll() ) do ply:ChatPrint( bone1.." gibbed" ) end
	end

    ragdoll:ManipulateBoneScale(bone_id,Vector(0,0,0))
    local bone = ragdoll:TranslateBoneToPhysBone(bone_id)
    local phys_bone = ragdoll:GetPhysicsObjectNum(bone)
			
    if phys_bone:IsValid() then
        ragdoll:RemoveInternalConstraint(bone)
        ragdoll.gib_bone[bone_id] = bone_id
        colideBone(ragdoll,bone)
    end
    local children = ragdoll:GetChildBones(bone_id)
    for k, v in pairs(children) do --no more shit code
		local bone_name = ragdoll:GetBoneName( v )
        gib_PhysBone(ragdoll,bone_name)
    end
end
gib_PhysBone_RAGDOLLS = {}
hook.Add("Think", "ForcePhysbonePositions_Think", function()
	for _,ragdoll in ipairs( gib_PhysBone_RAGDOLLS ) do
		if ragdoll.gib_bone then
			ForcePhysBonePos(ragdoll) 
		end
	end
end)

function ForcePhysBonePos(ragdoll)
	for k, v in pairs(ragdoll.gib_bone) do
		local bone = ragdoll:TranslateBoneToPhysBone(k)
		local bone_parent = ragdoll:TranslateBoneToPhysBone(ragdoll:GetBoneParent(k ))
		local children = ragdoll:GetChildBones(k)
		local gibbed_physobj = ragdoll:GetPhysicsObjectNum(bone)
		local parent_physobj = ragdoll:GetPhysicsObjectNum(bone_parent)
		gibbed_physobj:SetPos( parent_physobj:GetPos() )
		gibbed_physobj:SetAngles( parent_physobj:GetAngles() )
		for k, v in pairs(children) do
			local shit = ragdoll:TranslateBoneToPhysBone(v)
			local shit2 = ragdoll:GetPhysicsObjectNum(shit)
	
			shit2:SetPos( parent_physobj:GetPos() )
			shit2:SetAngles( parent_physobj:GetAngles() )
		end
	end
end


function ApplyCorpseEffects(ent)
	if ent:LookupBone("ValveBiped.Bip01_Spine") == nil then return end
	ent.GORE_Corpse = true
	ent.gib_Corpse_StartT = CurTime() + 1
	ent:SetHealth(GetConVar("ragdoll_health"):GetFloat()) 
	local defalt_value = 50*GetConVar("limb_health_multiplier"):GetFloat()
	ent.boneHealth = {}
	ent.boneHealth["ValveBiped.Bip01_Head1"] = defalt_value
	
	ent.boneHealth["ValveBiped.Bip01_L_Hand"] = defalt_value
	ent.boneHealth["ValveBiped.Bip01_R_Hand"] = defalt_value
	
	ent.boneHealth["ValveBiped.Bip01_L_Forearm"] = defalt_value
	ent.boneHealth["ValveBiped.Bip01_R_Forearm"] = defalt_value
	
	ent.boneHealth["ValveBiped.Bip01_R_Calf"] = defalt_value
	ent.boneHealth["ValveBiped.Bip01_L_Calf"] = defalt_value
	
	ent.boneHealth["ValveBiped.Bip01_L_Foot"] = defalt_value
	ent.boneHealth["ValveBiped.Bip01_R_Foot"] = defalt_value
	
	ent.boneHealth["ValveBiped.Bip01_R_Hand"] = defalt_value*2
	ent.boneHealth["ValveBiped.Bip01_L_Hand"] = defalt_value*2
end