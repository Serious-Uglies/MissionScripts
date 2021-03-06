--- 1980s setting of Serious Uglies ---
--- @author: kreisch

-- First we define a random number to determine which lane will go active

local HQBlue = GROUP:FindByName("HQBlue")
local CommandCenterBlue = COMMANDCENTER:New( HQBlue, "Overlord" )
local HQRED = GROUP:FindByName("HQRED")
local CommandCenterRed = COMMANDCENTER:New( HQRED, "MasterEvil" )

local autoGFT_East_Blue
local autoGFT_East_Red
local autoGFT_West_Blue
local autoGFT_West_Red

function Conflict_East_Border()
  -- BLUE UNITS
  autoGFT_East_Blue = autogft_Setup:new()
    :addBaseZone("Vladikavkaz_Blue_Base")
    :startUsingRoads()
    :setSpeed(90)
    :addControlZone("East_Border_Obj3")
    :addControlZone("East_Border_Obj2")
    :addControlZone("East_Border_Obj1")
  
  -- RED UNITS
  Roadblock = SPAWN:New("Kazbegi_RoadOutpost"):Spawn()
  Defensive = SPAWN:New("Kazbegi_RoadOutpost-1"):Spawn()
  
  autoGFT_East_Red = autogft_Setup:new()
    :addBaseZone("Kazbegi_Red_Base-1")
    :startUsingRoads()
    :setSpeed(90)
    :addControlZone("East_Border_Obj3")
    :addControlZone("East_Border_Obj2")
    :addControlZone("East_Border_Obj1")
    
    ---- Spawn JTAC
    Spawn_Drone_Name = SPAWN:New( "US_BAI_RECCE_Reaper_East" ):Spawn():GetName()
    ctld.JTACAutoLase(Spawn_Drone_Name, 1688)
    
    
    --- Define CAS now
    env.info("Loading A2G CAS Zone EAST")
          -- Initialize A2G
          --
          -- Define a SET_GROUP object that builds a collection of groups that define the recce network.
          -- Here we build the network with all the groups that have a name starting with CCCP Recce.
          
          local DetectionSetGroupUSBAI = SET_GROUP:New()
          DetectionSetGroupUSBAI:FilterPrefixes( { "US_BAI_RECCE" } )
          DetectionSetGroupUSBAI:FilterStart()
          
          local DetectionUSBAI = DETECTION_AREAS:New( DetectionSetGroupUSBAI, 1000 )
          
          -- Setup the A2A dispatcher, and initialize it.
          A2GDispatcherBlue = AI_A2G_DISPATCHER:New( DetectionUSBAI )
          
          
          -- Add defense coordinates.
          A2GDispatcherBlue:AddDefenseCoordinate( "HQ", HQBlue:GetCoordinate() )
          A2GDispatcherBlue:SetDefenseReactivityHigh() -- High defense reactivity. So far proximity of a threat will trigger a defense action.
          A2GDispatcherBlue:SetDefenseRadius( 9000000 ) -- Defense radius wide enough to also trigger defenses far away.
          
          -- Communication to the players within the coalition. The HQ services the communication of the defense actions.
          --A2GDispatcherBlue:SetCommandCenter( CommandCenterBlue )
          
          -- Show a tactical display.
          --A2GDispatcherBlue:SetTacticalDisplay( false )
          --A2GDispatcherBlue:SetTacticalMenu("A2G Dispatcher", "HQ")
          
          
          -- Setup the patrols.
          
          -- The patrol zone.
          local PatrolZonePowerPlant = ZONE_POLYGON:NewFromGroupName("Zone_EastBorder_CAS")
          
          A2GDispatcherBlue:SetSquadron( "US_A10_CAS", AIRBASE.Caucasus.Mozdok, { "US_A10_CAS" })
          A2GDispatcherBlue:SetSquadronFuelThreshold("US_A10_CAS",0.2)
          --A2GDispatcherBlue:SetSquadronTanker("US_A10_CAS","Arco31")
          A2GDispatcherBlue:SetSquadronBaiPatrol2( "US_A10_CAS", PatrolZonePowerPlant, 800, 1200, 2000, 5000, "BARO", 5000, 230, 1000, 5000, "BARO" ) -- New API
          A2GDispatcherBlue:SetSquadronBaiPatrolInterval( "US_A10_CAS", 1, 30, 40, 1 )
          A2GDispatcherBlue:SetSquadronTakeoffInAir("US_A10_CAS",2000)
          A2GDispatcherBlue:SetSquadronOverhead( "US_A10_CAS", 1 )
          
                    ----##################################################################------
          -- Feel the russian style!
          -- Define a SET_GROUP object that builds a collection of groups that define the recce network.
          -- Here we build the network with all the groups that have a name starting with CCCP Recce.
          
          local DetectionSetGroupRUBAI = SET_GROUP:New()
          DetectionSetGroupRUBAI:FilterPrefixes( { "TaskForce_RU" } )
          DetectionSetGroupRUBAI:FilterStart()
          
          local DetectionRUBAI = DETECTION_AREAS:New( DetectionSetGroupRUBAI, 1000 )
          
          -- Setup the A2A dispatcher, and initialize it.
          A2GDispatcherRed = AI_A2G_DISPATCHER:New( DetectionRUBAI )
          
          
          -- Add defense coordinates.
          A2GDispatcherRed:AddDefenseCoordinate( "HQ", HQRED:GetCoordinate() )
          A2GDispatcherRed:SetDefenseReactivityHigh() -- High defense reactivity. So far proximity of a threat will trigger a defense action.
          A2GDispatcherRed:SetDefenseRadius( 9000000 ) -- Defense radius wide enough to also trigger defenses far away.

          -- Setup the patrols.
          -- The patrol zone.
          local PatrolZonePowerPlant = ZONE_POLYGON:NewFromGroupName("Zone_EastBorder_CAS")
          
          A2GDispatcherRed:SetSquadron( "RU_Cas_East", AIRBASE.Caucasus.Tbilisi_Lochini, { "RU_Cas_East" })
          A2GDispatcherRed:SetSquadronFuelThreshold("RU_Cas_East",0.2)
          A2GDispatcherRed:SetSquadronBaiPatrol2( "RU_Cas_East", PatrolZonePowerPlant, 800, 1200, 2000, 5000, "BARO", 5000, 230, 1000, 5000, "BARO" ) -- New API
          A2GDispatcherRed:SetSquadronBaiPatrolInterval( "RU_Cas_East", 1, 30, 40, 1 )
          A2GDispatcherRed:SetSquadronTakeoffInAir("RU_Cas_East",2000)
    env.info("Loaded A2G CAS Zone EAST")

end

function stop()
  autoGFT_East_Blue:stopReinforcing()
end

function Conflict_West_Border()
  -- Spawn the Units (Buildings) which represent the reinforcement factories
  Roadblock = SPAWN:New("KvemoSba_RoadOutpost"):Spawn()
  Factories = SPAWN:New("KvemoSbaGround-2"):Spawn()
    
  -- BLUE UNITS
  autogft_Setup:new()
    :addBaseZone("Alagir_Blue_Base")
    :startUsingRoads()
    :setSpeed(90)
    :addIntermidiateZone("West_Border_Ob1")
    :addIntermidiateZone("West_Border_Ob2")
    :addIntermidiateZone("West_Border_Ob3")
    :addControlZone("KvemoSba_Red_Base")
  
  -- RED UNITS
  autogft_Setup:new()
    :addBaseZone("KvemoSba_Red_Base")
    :startUsingRoads()
    :linkBase("Vladikavkaz_Blue_Base", "KvemoSba_RoadOutpost")
    :linkBase("Vladikavkaz_Blue_Base", "KvemoSbaGround-2")
    :setSpeed(90)
    :addIntermidiateZone("West_Border_Ob3")
    :addIntermidiateZone("West_Border_Ob2")
    :addIntermidiateZone("West_Border_Ob1")
    :addControlZone("Alagir_Blue_Base")
    
    
        ---- Spawn JTAC
    Spawn_Drone_Name = SPAWN:New( "US_BAI_RECCE_Reaper_West" ):Spawn():GetName()
    ctld.JTACAutoLase(Spawn_Drone_Name, 1688)
    
    --- Define CAS now
    env.info("Loading A2G CAS Zone West")
          -- Initialize A2G
          --
          -- Define a SET_GROUP object that builds a collection of groups that define the recce network.
          -- Here we build the network with all the groups that have a name starting with CCCP Recce.
          
          local DetectionSetGroupUSBAI = SET_GROUP:New()
          DetectionSetGroupUSBAI:FilterPrefixes( { "US_BAI_RECCE" } )
          DetectionSetGroupUSBAI:FilterStart()
          
          local DetectionUSBAI = DETECTION_AREAS:New( DetectionSetGroupUSBAI, 1000 )
          
          -- Setup the A2A dispatcher, and initialize it.
          A2GDispatcherBlue = AI_A2G_DISPATCHER:New( DetectionUSBAI )
          
          
          -- Add defense coordinates.
          A2GDispatcherBlue:AddDefenseCoordinate( "HQ", HQBlue:GetCoordinate() )
          A2GDispatcherBlue:SetDefenseReactivityHigh() -- High defense reactivity. So far proximity of a threat will trigger a defense action.
          A2GDispatcherBlue:SetDefenseRadius( 9000000 ) -- Defense radius wide enough to also trigger defenses far away.
          
          -- Communication to the players within the coalition. The HQ services the communication of the defense actions.
          --A2GDispatcherBlue:SetCommandCenter( CommandCenterBlue )
          
          -- Show a tactical display.
          --A2GDispatcherBlue:SetTacticalDisplay( false )
          --A2GDispatcherBlue:SetTacticalMenu("A2G Dispatcher", "HQ")
         
          -- Setup the patrols.
          -- The patrol zone.
          local PatrolZonePowerPlant = ZONE_POLYGON:NewFromGroupName("Zone_WestBorder_CAS")
          
          A2GDispatcherBlue:SetSquadron( "US_A10_CAS", AIRBASE.Caucasus.Mozdok, { "US_A10_CAS" })
          A2GDispatcherBlue:SetSquadronFuelThreshold("US_A10_CAS",0.2)
          --A2GDispatcherBlue:SetSquadronTanker("US_A10_CAS","Arco31")
          A2GDispatcherBlue:SetSquadronBaiPatrol2( "US_A10_CAS", PatrolZonePowerPlant, 800, 1200, 2000, 5000, "BARO", 5000, 230, 1000, 5000, "BARO" ) -- New API
          A2GDispatcherBlue:SetSquadronBaiPatrolInterval( "US_A10_CAS", 1, 30, 40, 1 )
          A2GDispatcherBlue:SetSquadronTakeoffInAir("US_A10_CAS",2000)
          A2GDispatcherBlue:SetSquadronOverhead( "US_A10_CAS", 1 )
          
          
          ----##################################################################------
          -- Feel the russian style!
          -- Define a SET_GROUP object that builds a collection of groups that define the recce network.
          -- Here we build the network with all the groups that have a name starting with CCCP Recce.
          
          local DetectionSetGroupRUBAI = SET_GROUP:New()
          DetectionSetGroupRUBAI:FilterPrefixes( { "TaskForce_RU" } )
          DetectionSetGroupRUBAI:FilterStart()
          
          local DetectionRUBAI = DETECTION_AREAS:New( DetectionSetGroupRUBAI, 1000 )
          
          -- Setup the A2A dispatcher, and initialize it.
          A2GDispatcherRed = AI_A2G_DISPATCHER:New( DetectionRUBAI )
          
          
          -- Add defense coordinates.
          A2GDispatcherRed:AddDefenseCoordinate( "HQ", HQRED:GetCoordinate() )
          A2GDispatcherRed:SetDefenseReactivityHigh() -- High defense reactivity. So far proximity of a threat will trigger a defense action.
          A2GDispatcherRed:SetDefenseRadius( 9000000 ) -- Defense radius wide enough to also trigger defenses far away.

          -- Setup the patrols.
          -- The patrol zone.
          local PatrolZonePowerPlant = ZONE_POLYGON:NewFromGroupName("Zone_WestBorder_CAS")
          
          A2GDispatcherRed:SetSquadron( "RU_Cas_East", AIRBASE.Caucasus.Tbilisi_Lochini, { "RU_Cas_East" })
          A2GDispatcherRed:SetSquadronFuelThreshold("RU_Cas_East",0.2)
          A2GDispatcherRed:SetSquadronBaiPatrol2( "RU_Cas_East", PatrolZonePowerPlant, 800, 1200, 2000, 5000, "BARO", 5000, 230, 1000, 5000, "BARO" ) -- New API
          A2GDispatcherRed:SetSquadronBaiPatrolInterval( "RU_Cas_East", 1, 30, 40, 1 )
          A2GDispatcherRed:SetSquadronTakeoffInAir("RU_Cas_East",2000)
          
          
    env.info("Loaded A2G CAS Zone West")
end






local switch = math.random (2,2)

if switch == 1 then
    Conflict_East_Border()
end

if switch == 2 then
  Conflict_West_Border()
end



