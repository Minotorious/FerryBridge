--[[---------------------------------------------------------------------------\
| ||\\    //||       /|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ |
| || \\  // ||  (o_ / |                  SUPPLEMENTARY FILE                  | |
| ||  \\//  ||  //\/  |                         ----                         | |
| ||   \/   ||  V_/_  |                FERRY BRIDGE DEFINITION               | |
| ||        ||        |‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗/ |
\---------------------------------------------------------------------------]]--

local ferryBridge = ...

--[[--------------------------- PREFABS & MATERIALS ---------------------------]]--

ferryBridge:registerAssetId("models/ferryBridge.fbx/Prefab/StartPart", "PREFAB_FERRY_BRIDGE_START_PART")
ferryBridge:registerAssetId("models/ferryBridge.fbx/Prefab/CenterPart", "PREFAB_FERRY_BRIDGE_CENTER_PART")
ferryBridge:registerAssetId("models/ferryBridge.fbx/Prefab/EndPart", "PREFAB_FERRY_BRIDGE_END_PART")
ferryBridge:registerAssetId("models/ferryBridge.fbx/Prefab/RaftPart", "PREFAB_FERRY_BRIDGE_RAFT_PART")

ferryBridge:registerAssetId("models/ferryBridge.fbx/Materials/Material.Transparent", "MATERIAL_TRANSPARENT")

ferryBridge:overrideAsset({
    Id = "MATERIAL_TRANSPARENT",
    HasAlphaTest = true
})

--[[---------------------------- CUSTOM COMPONENTS ----------------------------]]--

--[[--------------------- ASSET PROCESSOR & NODE HANDLING ---------------------]]--
--[[--------------------------- COMPONENT ASSIGNMENT --------------------------]]--
--[[-------------------------------- COLLIDERS --------------------------------]]--

ferryBridge:registerAssetProcessor("models/ferryBridge.fbx", { DataType = "BUILDING_ASSET_PROCESSOR" })

ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/StartPart/Door", { DataType = "COMP_GROUNDED" })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/StartPart/DoorRaft", { DataType = "COMP_GROUNDED", GroundToWater = true })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/EndPart/Door.001", { DataType = "COMP_GROUNDED" })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/EndPart/DoorRaft.001", { DataType = "COMP_GROUNDED", GroundToWater = true })

ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/RaftPart", { DataType = "COMP_GROUNDED", GroundToWater = true })

ferryBridge:configurePrefabFlagList("models/ferryBridge.fbx/Prefab/StartPart", { "BRIDGE" })
ferryBridge:configurePrefabFlagList("models/ferryBridge.fbx/Prefab/CenterPart", { "BRIDGE" })
ferryBridge:configurePrefabFlagList("models/ferryBridge.fbx/Prefab/EndPart", { "BRIDGE" })
ferryBridge:configurePrefabFlagList("models/ferryBridge.fbx/Prefab/RaftPart", { "PLATFORM" })

ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/StartPart/Cube", { DataType = "COMP_FERRY_BRIDGE", Enabled = true })

--[[------------------------ BUILDINGS & BUILDING PARTS -----------------------]]--

ferryBridge:registerAsset({
    DataType = "BUILDING",
    Id = "FERRY_BRIDGE",
    Name = "FERRY_BRIDGE_NAME",
    Description = "FERRY_BRIDGE_DESC",
    BuildingType = BUILDING_TYPE.TRANSPORTATION,
    AssetCoreBuildingPart = "FERRY_BRIDGE_CORE_PART",
    AssetBuildingPartList = {
        "FERRY_BRIDGE_RAFT_PART"
    },
    IsManuallyUnlocked = true,
    IsDestructible = true,
    IsEditable = true,
    IsClearTrees = true
})

ferryBridge:registerAsset({
    DataType = "BUILDING_PART",
    Id = "FERRY_BRIDGE_START_PART",
    Name = "FERRY_BRIDGE_START_PART_NAME",
    IsShowInUi = false,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
        CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_START_PART"
    },
    BuildingZone = {
        ZoneEntryList = {
            {
                Polygon = polygon.createRectangle({ 8, 14 }, { 0, 0 }),
                Type = { DEFAULT = true, GRASS_CLEAR = true }
            }
        }
    }
})

ferryBridge:registerAsset({
    DataType = "BUILDING_PART",
    Id = "FERRY_BRIDGE_CENTER_PART",
    IsShowInUi = false,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
        CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_CENTER_PART"
    }
})

ferryBridge:registerAsset({
    DataType = "BUILDING_PART",
    Id = "FERRY_BRIDGE_END_PART",
    Name = "FERRY_BRIDGE_END_PART_NAME",
    IsShowInUi = false,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
        CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_END_PART"
    },
    BuildingZone = {
        ZoneEntryList = {
            {
                Polygon = polygon.createRectangle({ 8, 14 }, { 0, 0 }),
                Type = { DEFAULT = true, GRASS_CLEAR = true }
            }
        }
    }
})

ferryBridge:registerAsset({
    DataType = "BUILDING_PART",
    Id = "FERRY_BRIDGE_CORE_PART",
    Name = "FERRY_BRIDGE_CORE_PART_NAME",
    Description = "FERRY_BRIDGE_CORE_PART_DESC",
    Category = BUILDING_PART_TYPE.CORE,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_BRIDGE",
        StartPart = "FERRY_BRIDGE_START_PART",
        EndPart = "FERRY_BRIDGE_END_PART",
        FillerList = {
            "FERRY_BRIDGE_CENTER_PART"
        },
    },
    BuildingZone = {
        ZoneEntryList = {}
    },
    BuildingFunction = "BUILDING_FUNCTION_FERRY_BRIDGE"
})

ferryBridge:registerAsset({
    DataType = "BUILDING_PART",
    Id = "FERRY_BRIDGE_RAFT_PART",
    Name = "FERRY_BRIDGE_RAFT_PART_NAME",
    Category = BUILDING_PART_TYPE.DECORATION,
    IsShowInUi = true,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
        CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_RAFT_PART"
    }
})

--[[------------------------------- UNLOCKABLES -------------------------------]]--

ferryBridge:overrideAsset({
    Id = "UNLOCKABLE_COMMON_BRIDGE_WOODEN",
    ActionList = {
        Action = "APPEND",
        {
            DataType = "GAME_ACTION_UNLOCK_BUILDING_LIST",
            BuildingProgressData = {
                AssetBuildingList = {
                    "FERRY_BRIDGE"
                }
            }
        }
    }
})

--[[------------------------- JOBS & BUILDING FUNCTIONS -----------------------]]--

ferryBridge:registerAsset({
    DataType = "BUILDING_FUNCTION_BRIDGE",
    Id = "BUILDING_FUNCTION_FERRY_BRIDGE"
})

--[[----------------------------- BEHAVIOUR TREES -----------------------------]]--
