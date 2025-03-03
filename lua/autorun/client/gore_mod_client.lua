if CLIENT then
    local function HL2goremod()
        spawnmenu.AddToolMenuOption("Options", "Gore", "Noob gore mod", "Noob gore mod", "", "", function(panel)
            panel:ClearControls()
            panel:CheckBox("Noob gore mod enable", "Noob_gore_mod_enable")
            panel:Help("Disable Noob gore mod.")

            panel:Help("--Main Options--")
            panel:CheckBox("Enable decapitation", "decapitation") 
            panel:CheckBox("can gib ragdoll", "can_gib_ragdoll") 
            panel:CheckBox("can gib player", "can_gib_player") 
            panel:CheckBox("Enable skeletonizer", "Enable_skeletonizer") 
            panel:CheckBox("only headshot dismembers", "only_headshot_dismembers") 
            panel:CheckBox("agly intestine gore", "agly_intestine_gore") 
            panel:CheckBox("cannibalism", "cannibalism") 
            panel:CheckBox("burned corpse effect", "burned_corpse_effect") 


            panel:Help("--effects Options--")
            panel:CheckBox("gore blood effect", "gore_blood_effect")
            panel:CheckBox("lua particles effect", "lua_particles_effect")
			
            panel:Help("--Ragdoll Options--")
            panel:NumSlider("player corpse fade time", "player_corpse_fade_time", 1, 1000, 0)
            panel:NumSlider("ragdoll health", "ragdoll_health", 1, 9999, 0)
            panel:Help("defalt ragdoll health is 400")
			
            panel:Help("--DMG Options--") 
			panel:NumSlider("NPC dismember multiplier", "NPC_dismember_multiplier", -4, 4, 2)
			panel:NumSlider("limb health multiplier", "limb_health_multiplier", -4, 10, 2)
            panel:Help("defalt multiplier value is 1")

            panel:NumSlider("on npc Gibbing type", "on_explode_npc", 1, 3, 0)
            panel:Help("this value at 1 will only dismember the entire NPC at 2 it will be partial above 3 nothing will happen")
			
            panel:Help("--GIB Options--")         
            panel:CheckBox("rib gib", "rib_gib")       
            panel:CheckBox("decapitation gib", "decapitation_gib")    
            panel:NumSlider("gib fade time", "gib_fade_time", 1, 1000, 0)
            panel:NumSlider("amounts of ribs", "amounts_of_ribs", 1, 23, 0)
            panel:NumSlider("amounts of head gibs", "amounts_of_head_gibs", 1, 99, 0)

            panel:Help("extra")
            panel:CheckBox("debug_mode", "debug_mode")
        end)
    end
    hook.Add("PopulateToolMenu", "AddHL2goreSettings", HL2goremod)
end

net.Receive( "head_gibs_particles", function( len, ply )
    local ent = net.ReadEntity()
	shit_blood(ent)
end )
function shit_blood(ent)
	if not ent:IsValid() then return end
	local head_bone = ent:LookupBone( "ValveBiped.Bip01_Head1" )
	if head_bone == nil then return end
	
	local Position = ent:GetBonePosition(head_bone+math.random(-5,5),math.random(-5,5),math.random(-5,5))

	local Emitter = ParticleEmitter( Position )

	local Position_sigma = ent:GetBonePosition(head_bone)
	for i=1,math.random(10,30) do
	local Particle = Emitter:Add( "effects/blood2", Position_sigma )
	if Particle then
		Particle:SetDieTime( 60 )

		Particle:SetStartAlpha( math.random( 200, 255 ) )
		Particle:SetColor( 255, 0, 0 )
		Particle:SetStartSize( math.random( 1, 2,5 ) )

		Particle:SetEndAlpha( 0 )
		Particle:SetEndSize( 1 )
		Particle:SetVelocityScale(true)
		Particle:SetLighting( true)

		Particle:SetGravity( Vector( 0, 0, -350 ) )
		Particle:SetVelocity(Vector( math.random(-40,40), math.random(-40,40), math.random(50,140) ))
		Particle:SetCollide( true )	
	end
	end
	Emitter:Finish()
end