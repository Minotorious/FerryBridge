--[[---------------------------------------------------------------------------\
| ||\\    //||       /|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ |
| || \\  // ||  (o_ / |                  SUPPLEMENTARY FILE                  | |
| ||  \\//  ||  //\/  |                         ----                         | |
| ||   \/   ||  V_/_  |            FERRY BRIDGE CREATIVE VARIANT             | |
| ||        ||        |‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗/ |
\---------------------------------------------------------------------------]]--

local ferryBridge = ...

--[[--------------------------- PREFABS & MATERIALS ---------------------------]]--

ferryBridge:registerAssetId("models/ferryBridgeCreative.fbx/Prefab/StartPart", "PREFAB_FERRY_BRIDGE_CREATIVE_START_PART")
ferryBridge:registerAssetId("models/ferryBridgeCreative.fbx/Prefab/CenterPart", "PREFAB_FERRY_BRIDGE_CREATIVE_CENTER_PART")
ferryBridge:registerAssetId("models/ferryBridgeCreative.fbx/Prefab/EndPart", "PREFAB_FERRY_BRIDGE_CREATIVE_END_PART")

ferryBridge:registerAssetId("models/ferryBridgeCreative.fbx/Materials/Material.Transparent", "MATERIAL_TRANSPARENT_FERRY_BRIDGE_CREATIVE")

ferryBridge:overrideAsset({
    Id = "MATERIAL_TRANSPARENT_FERRY_BRIDGE_CREATIVE",
    HasAlphaTest = true
})

--[[---------------------------- CUSTOM COMPONENTS ----------------------------]]--

--[[--------------------- ASSET PROCESSOR & NODE HANDLING ---------------------]]--
--[[--------------------------- COMPONENT ASSIGNMENT --------------------------]]--
--[[-------------------------------- COLLIDERS --------------------------------]]--

ferryBridge:registerAssetProcessor("models/ferryBridgeCreative.fbx", { DataType = "BUILDING_ASSET_PROCESSOR" })

ferryBridge:registerPrefabComponent("models/ferryBridgeCreative.fbx/Prefab/StartPart/Door", { DataType = "COMP_GROUNDED" })
ferryBridge:registerPrefabComponent("models/ferryBridgeCreative.fbx/Prefab/EndPart/Door.001", { DataType = "COMP_GROUNDED" })

ferryBridge:configurePrefabFlagList("models/ferryBridgeCreative.fbx/Prefab/StartPart", { "BRIDGE" })
ferryBridge:configurePrefabFlagList("models/ferryBridgeCreative.fbx/Prefab/CenterPart", { "BRIDGE" })
ferryBridge:configurePrefabFlagList("models/ferryBridgeCreative.fbx/Prefab/EndPart", { "BRIDGE" })

ferryBridge:registerPrefabComponent("models/ferryBridgeCreative.fbx/Prefab/StartPart/Door", { DataType = "COMP_FERRY_BRIDGE", Enabled = true })

--[[------------------------ BUILDINGS & BUILDING PARTS -----------------------]]--

ferryBridge:registerAsset({
    DataType = "BUILDING",
    Id = "FERRY_BRIDGE_CREATIVE",
    Name = "FERRY_BRIDGE_CREATIVE_NAME",
    Description = "FERRY_BRIDGE_CREATIVE_DESC",
    BuildingType = BUILDING_TYPE.TRANSPORTATION,
    AssetCoreBuildingPart = "FERRY_BRIDGE_CREATIVE_CORE_PART",
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
    Id = "FERRY_BRIDGE_CREATIVE_START_PART",
    Name = "FERRY_BRIDGE_CREATIVE_START_PART_NAME",
    IsShowInUi = false,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
        CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_CREATIVE_START_PART"
    }
})

ferryBridge:registerAsset({
    DataType = "BUILDING_PART",
    Id = "FERRY_BRIDGE_CREATIVE_CENTER_PART",
    IsShowInUi = false,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
        CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_CREATIVE_CENTER_PART"
    }
})

ferryBridge:registerAsset({
    DataType = "BUILDING_PART",
    Id = "FERRY_BRIDGE_CREATIVE_END_PART",
    Name = "FERRY_BRIDGE_CREATIVE_END_PART_NAME",
    IsShowInUi = false,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
        CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_CREATIVE_END_PART"
    }
})

ferryBridge:registerAsset({
    DataType = "BUILDING_PART",
    Id = "FERRY_BRIDGE_CREATIVE_CORE_PART",
    Name = "FERRY_BRIDGE_CREATIVE_CORE_PART_NAME",
    Description = "FERRY_BRIDGE_CREATIVE_CORE_PART_DESC",
    Category = BUILDING_PART_TYPE.CORE,
    ConstructorData = {
        DataType = "BUILDING_CONSTRUCTOR_BRIDGE",
        StartPart = "FERRY_BRIDGE_CREATIVE_START_PART",
        EndPart = "FERRY_BRIDGE_CREATIVE_END_PART",
        FillerList = {
            "FERRY_BRIDGE_CREATIVE_CENTER_PART"
        },
    },
    BuildingFunction = "BUILDING_FUNCTION_FERRY_BRIDGE"
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
                    "FERRY_BRIDGE_CREATIVE"
                }
            }
        }
    }
})

--[[------------------------- JOBS & BUILDING FUNCTIONS -----------------------]]--

--[[----------------------------- BEHAVIOUR TREES -----------------------------]]--
