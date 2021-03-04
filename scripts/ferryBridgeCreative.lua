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

ferryBridge:override({
    Id = "MATERIAL_TRANSPARENT_FERRY_BRIDGE_CREATIVE",
    HasAlphaTest = true
})

--[[---------------------------- CUSTOM COMPONENTS ----------------------------]]--

ferryBridge:registerPrefabComponent("models/ferryBridgeCreative.fbx/Prefab/StartPart/Door", { DataType = "COMP_BUILDING_PART", FeedbackComponentListToActivate = { { "PREFAB_FERRY_BRIDGE_CREATIVE_START_PART", "COMP_FERRY" } } })
ferryBridge:registerPrefabComponent("models/ferryBridgeCreative.fbx/Prefab/StartPart/Door", { DataType = "COMP_FERRY", Enabled = true })

--[[--------------------- ASSET PROCESSOR & NODE HANDLING ---------------------]]--
--[[--------------------------- COMPONENT ASSIGNMENT --------------------------]]--
--[[-------------------------------- COLLIDERS --------------------------------]]--

ferryBridge:registerAssetProcessor("models/ferryBridgeCreative.fbx", { DataType = "BUILDING_ASSET_PROCESSOR" })

ferryBridge:registerPrefabComponent("models/ferryBridgeCreative.fbx/Prefab/StartPart/Door", { DataType = "COMP_GROUNDED" })
ferryBridge:registerPrefabComponent("models/ferryBridgeCreative.fbx/Prefab/EndPart/Door.001", { DataType = "COMP_GROUNDED" })


ferryBridge:configurePrefabFlagList("models/ferryBridgeCreative.fbx/Prefab/StartPart", { "BRIDGE" })
ferryBridge:configurePrefabFlagList("models/ferryBridgeCreative.fbx/Prefab/CenterPart", { "BRIDGE" })
ferryBridge:configurePrefabFlagList("models/ferryBridgeCreative.fbx/Prefab/EndPart", { "BRIDGE" })

--[[------------------------ BUILDINGS & BUILDING PARTS -----------------------]]--

ferryBridge:register({
	DataType = "BUILDING",
	Id = "FERRY_BRIDGE_CREATIVE",
	Name = "FERRY_BRIDGE_CREATIVE_NAME",
	Description = "FERRY_BRIDGE_CREATIVE_DESC",
	BuildingType = "MONUMENT",
	AssetCoreBuildingPart = "FERRY_BRIDGE_CREATIVE_CORE_PART",
	IsDestructible = true,
	IsEditable = true,
	IsClearTrees = true
})

ferryBridge:register({
	DataType = "BUILDING_PART",
	Id = "FERRY_BRIDGE_CREATIVE_START_PART",
    Name = "FERRY_BRIDGE_CREATIVE_START_PART_NAME",
	IsShowInUi = false,
	ConstructorData = {
		DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
		CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_CREATIVE_START_PART"
	},
    BuildingZone = {
		ZoneEntryList = {
			{
				--Polygon = polygon.createRectangle({ 8, 14 }, { 0, 0 }),
				--Type = { DEFAULT = true, GRASS_CLEAR = true }
			}
		}
	},
})

ferryBridge:register({
	DataType = "BUILDING_PART",
	Id = "FERRY_BRIDGE_CREATIVE_CENTER_PART",
	IsShowInUi = false,
	ConstructorData = {
		DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
		CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_CREATIVE_CENTER_PART"
	},
    BuildingZone = {
		ZoneEntryList = {
			{
				--Polygon = polygon.createRectangle({ 2, 6 }),
				--Type = { DEFAULT = true }
			}
		}
	},
})

ferryBridge:register({
	DataType = "BUILDING_PART",
	Id = "FERRY_BRIDGE_CREATIVE_END_PART",
    Name = "FERRY_BRIDGE_CREATIVE_END_PART_NAME",
	IsShowInUi = false,
	ConstructorData = {
		DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
		CoreObjectPrefab = "PREFAB_FERRY_BRIDGE_CREATIVE_END_PART"
	},
    BuildingZone = {
		ZoneEntryList = {
			{
				--Polygon = polygon.createRectangle({ 8, 14 }, { 0, 0 }),
				--Type = { DEFAULT = true, GRASS_CLEAR = true }
			}
		}
	},
})

ferryBridge:register({
	DataType = "BUILDING_PART",
	Id = "FERRY_BRIDGE_CREATIVE_CORE_PART",
	Name = "FERRY_BRIDGE_CREATIVE_CORE_PART_NAME",
	Description = "FERRY_BRIDGE_CREATIVE_CORE_PART_DESC",
	ConstructorData = {
		DataType = "BUILDING_CONSTRUCTOR_BRIDGE",
		StartPart = "FERRY_BRIDGE_CREATIVE_START_PART",
		EndPart = "FERRY_BRIDGE_CREATIVE_END_PART",
		FillerList = {
			"FERRY_BRIDGE_CREATIVE_CENTER_PART"
		},
	},
	BuildingZone = {
		ZoneEntryList = {}
	},
	BuildingFunction = "FUNCTION_BRIDGE_ID"
})


--[[------------------------- JOBS & BUILDING FUNCTIONS -----------------------]]--

--[[----------------------------- BEHAVIOUR TREES -----------------------------]]--
