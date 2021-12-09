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
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/StartPart/DoorBlack", { DataType = "COMP_GROUNDED" })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/StartPart/DoorRaft", { DataType = "COMP_GROUNDED", GroundToWater = true })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/StartPart/DoorRaftBlack", { DataType = "COMP_GROUNDED", GroundToWater = true })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/EndPart/Door.001", { DataType = "COMP_GROUNDED" })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/EndPart/DoorBlack.001", { DataType = "COMP_GROUNDED" })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/EndPart/DoorRaft.001", { DataType = "COMP_GROUNDED", GroundToWater = true })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/EndPart/DoorRaftBlack.001", { DataType = "COMP_GROUNDED", GroundToWater = true })

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
    BuildingType = "TRANSPORTATION",
    AssetCoreBuildingPart = "FERRY_BRIDGE_CORE_PART",
    BuildingPartSetList = {
        {
            Name = "FERRY_BRIDGE_RAFT_CATEGORY",
            BuildingPartList = { "FERRY_BRIDGE_RAFT_PART" }
        }
    },
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
    },
    BuildingZone = {
        ZoneEntryList = {
            {
                --Polygon = polygon.createRectangle({ 2, 6 }),
                --Type = { DEFAULT = true }
            }
        }
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
    BuildingFunction = "FUNCTION_BRIDGE_ID"
})

ferryBridge:registerAsset({
    DataType = "BUILDING_PART",
    Id = "FERRY_BRIDGE_RAFT_PART",
    Name = "FERRY_BRIDGE_RAFT_PART_NAME",
    IsShowInUi = true,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
        CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_RAFT_PART"
    },
    BuildingZone = {
        ZoneEntryList = {}
    },
})

--[[------------------------- JOBS & BUILDING FUNCTIONS -----------------------]]--

ferryBridge:registerAsset({
    DataType = "BUILDING_FUNCTION_BRIDGE",
    Id = "FUNCTION_BRIDGE_ID"
})

--[[----------------------------- BEHAVIOUR TREES -----------------------------]]--
