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

ferryBridge:override({
    Id = "MATERIAL_TRANSPARENT",
    HasAlphaTest = true
})

--[[---------------------------- CUSTOM COMPONENTS ----------------------------]]--

local COMP_FERRY = {
	TypeName = "COMP_FERRY",
	ParentType = "COMPONENT",
	Properties = {
        { Name = "SavedRaftList", Type = "list<string>", Default = nil, Flags = { "SAVE_GAME" } }
    }
}

function COMP_FERRY:create()
    self.agentIdList = {}
    self.raftIdList = {}
    self.posStart = nil
    self.posEnd = nil
    self.waterDistance = 0
    self.totalDistance = 0
    self.bridgeY = 0
end

function COMP_FERRY:raycast(pos)
    local raycastResultWater = {}
    local raycastResultTerrain = {}
    local FromPosition = { pos[1], pos[2]+100, pos[3] }
    local ToPosition = { pos[1], pos[2]-100, pos[3] }
    local flagWater = bit.bor(bit.lshift(1, OBJECT_FLAG.WATER:toNumber()))
    local flagTerrain = bit.bor(bit.lshift(1, OBJECT_FLAG.TERRAIN:toNumber()))
    
    self:getLevel():rayCast(FromPosition, ToPosition, raycastResultWater, flagWater)
    self:getLevel():rayCast(FromPosition, ToPosition, raycastResultTerrain, flagTerrain)
    
    --ferryBridge:log("Water Raycast: " .. tostring(raycastResultWater.Position))
    --ferryBridge:log("Terrain Raycast: " .. tostring(raycastResultTerrain.Position))
    --ferryBridge:log("Raycast Bool: " .. tostring(raycastResultWater.Position.y > raycastResultTerrain.Position.y))
    
    if raycastResultWater.Position.y > raycastResultTerrain.Position.y then
        return true, raycastResultWater.Position.y
    else
        return false, raycastResultWater.Position.y
    end
end

function COMP_FERRY:init()
    local building = self:getOwner():getParent():getParent():getParent():getComponent("COMP_BUILDING")
    local parts = building:getBuildingPartList()
    local pos1 = nil
    local pos2 = nil
    for i=1,#parts do
        if parts[i]:getOwner().Name == "BridgeCorePart" then
            parts[i]:getOwner():forEachChildRecursive(
                function(child)
                    if child.Name == "Door" then
                        pos1 = child:getGlobalPosition()
                    end
                end
            )
            --ferryBridge:log("pos1: " .. tostring(pos1))
        elseif parts[i]:getOwner().Name == "EndPart" then
            parts[i]:getOwner():forEachChildRecursive(
                function(child)
                    if child.Name == "Door.001" then
                        pos2 = child:getGlobalPosition()
                    end
                end
            )
            --ferryBridge:log("pos2: " .. tostring(pos2))
        end
    end
    --a = (pos2.y - pos1.y) / (pos2.x - pos1.x)
    --b = pos1.y - a*pos1.x
    local posNew = { 0, 0, 0 }
    --ferryBridge:log(tostring(posNew))
    local waterFound = false
    for i=0,1,0.01 do
        --ferryBridge:log("i: " .. i)
        posNew[1] = (1-i)*pos1.x + i*pos2.x
        posNew[2] = (1-i)*pos1.y + i*pos2.y
        posNew[3] = (1-i)*pos1.z + i*pos2.z
        --ferryBridge:log("posNew: " .. tostring(posNew))
        local waterCheck, yVal = self:raycast(posNew)
        --ferryBridge:log("waterCheck: " .. tostring(waterCheck))
        if waterFound == false then
            --ferryBridge:log("if waterFound false")
            if waterCheck == true then
                --ferryBridge:log("if waterCheck true")
                --ferryBridge:log(tostring(posNew))
                self.posStart = { posNew[1], yVal, posNew[3] }
                waterFound = true
            end
        else
            --ferryBridge:log("if waterFound true")
            if waterCheck == false then
                --ferryBridge:log("if waterCheck false")
                --ferryBridge:log(tostring(posNew))
                self.posEnd = { posNew[1], yVal, posNew[3] }
                break
            end
        end
    end
    --ferryBridge:log("posStart: " .. tostring(self.posStart))
    --ferryBridge:log("posEnd: " .. tostring(self.posEnd))
    if self.posStart ~= nil and self.posEnd ~= nil then
        self.totalDistance = math.sqrt( (pos1.x - pos2.x)^2 + (pos1.y - pos2.y)^2 + (pos1.z - pos2.z)^2 )
        self.waterDistance = 1.05 * math.sqrt( (self.posStart[1] - self.posEnd[1])^2 + (self.posStart[2] - self.posEnd[2])^2 + (self.posStart[3] - self.posEnd[3])^2 )
        --ferryBridge:log("Water distance: " .. tostring(self.waterDistance))
        self.bridgeY = math.min(self.posStart[2], self.posEnd[2])
        for i, entry in pairs(self.SavedRaftList) do
            local splitEntry = {}
            for j in string.gmatch(entry, "([^,]+)") do
               table.insert(splitEntry, j)
            end
            local raft = self:getLevel():find(splitEntry[1])
            if raft ~= nil then
                local raftPos = raft:getGlobalPosition()
                local raftDistance1 = math.sqrt( (self.posEnd[1] - raftPos.x)^2 + (self.posEnd[2] - raftPos.y)^2 + (self.posEnd[3] - raftPos.z)^2 )
                local raftDistance2 = math.sqrt( (self.posStart[1] - raftPos.x)^2 + (self.posStart[2] - raftPos.y)^2 + (self.posStart[3] - raftPos.z)^2 )
                --ferryBridge:log("raftDistance: " .. tostring(raftDistance1+raftDistance2) .. " waterDistance " .. self.waterDistance)
                if raftDistance1 + raftDistance2 <= self.totalDistance then
                    --ferryBridge:log("Deleting Raft: " .. splitEntry[1])
                    --raft:destroy()
                    --self.SavedRaftList[i] = nil
                    self:addToRaftIdList({ splitEntry[1], splitEntry[2] })
                end
            end
        end
    end
end

function COMP_FERRY:addToAgentIdList(entry)
    table.insert(self.agentIdList, entry)
    --ferryBridge:log("addToAgentIdList: " .. entry)
end

function COMP_FERRY:removeFromAgentIdList(entry)
    for i, id in ipairs(self.agentIdList) do
        if id == entry then
            table.remove(self.agentIdList, i)
            --ferryBridge:log("removeFromList: " .. entry)
            break
        end
    end
    --ferryBridge:log("addToAgentIdList: " .. entry)
end

function COMP_FERRY:addToRaftIdList(entry)
    table.insert(self.raftIdList, entry)
    --ferryBridge:log("addToRaftIdList: " .. tostring(entry))
end

function COMP_FERRY:addToSavedRaftList(entry)
    table.insert(self.SavedRaftList, entry)
    --ferryBridge:log("addToRaftIdList: " .. tostring(entry))
end

function COMP_FERRY:removeFromSavedRaftList(entry)
    --ferryBridge:log(tostring(self.SavedRaftList))
    --ferryBridge:log("Removing Raft Entry: " .. tostring(entry[1]))
    for i, idPair in ipairs(self.SavedRaftList) do
        --ferryBridge:log("Comparison Entry: " .. tostring(idPair))
        --ferryBridge:log("Comparison Boolean: " .. tostring(idPair == entry))
        if idPair == entry then
            table.remove(self.SavedRaftList, i)
            --ferryBridge:log("removeFromList: " .. entry)
            --ferryBridge:log(tostring(self.SavedRaftList))
            break
        end
    end
    --ferryBridge:log("addToAgentIdList: " .. entry)
end

--[[
function COMP_FERRY:rotateVector(v, q)
    q = quaternion.conjugate(q)
    local u = { q.x, q.y, q.z }
    local s = q.w
    
    -- 2.0f * dot(u, v) * u
    local dotUV = 2*(u[1]*v[1] + u[2]*v[2] + u[3]*v[3])
    local term1 = { dotUV*u[1], dotUV*u[2], dotUV*u[3] }
    
    -- (s*s - dot(u, u)) * v
    local dotUU = s*s - (u[1]*u[1] + u[2]*u[2] + u[3]*u[3])
    local term2 = { dotUU*v[1], dotUU*v[2], dotUU*v[3] }
    
    -- 2.0f * s * cross(u, v)
    local crossUV = { u[2]*v[3] - u[3]*v[2], u[3]*v[1] - u[1]*v[3], u[1]*v[2] - u[2]*v[1] } 
    local term3 = { 2*s*crossUV[1], 2*s*crossUV[2], 2*s*crossUV[3] } 
    
    local rotatedVector = { term1[1] + term2[1] + term3[1], term1[2] + term2[2] + term3[2], term1[3] + term2[3] + term3[3] }
    
    return rotatedVector
end
]]--

function COMP_FERRY:update()
    --ferryBridge:log(tostring(self.SavedRaftList))
    if self.posStart ~= nil and self.posEnd ~= nil then
        self:getLevel():getComponentManager("COMP_AGENT"):getAllComponent():forEach(
            function(agent)
                local agentPos = agent:getOwner():getGlobalPosition()
                local distance1 = math.sqrt( (self.posStart[1] - agentPos.x)^2 + (self.posStart[2] - agentPos.y)^2 + (self.posStart[3] - agentPos.z)^2 )
                local distance2 = math.sqrt( (self.posEnd[1] - agentPos.x)^2 + (self.posEnd[2] - agentPos.y)^2 + (self.posEnd[3] - agentPos.z)^2 )
                --ferryBridge:log(agent:getOwner().Name .. " distances " .. tostring(distance1 + distance2) .. " waterDistance " .. tostring(self.waterDistance))
                if distance1 + distance2 <= self.waterDistance then
                    local villager = agent:getOwner():getComponent("COMP_VILLAGER")
                    if villager ~= nil then
                        agent:setAnimation("MARKET_TENDER")
                    end
                    local idFound = false
                    local agentId = agent:getOwner():getId()
                    for _, entry in ipairs(self.agentIdList) do
                        if entry == agentId then
                            idFound = true
                            break
                        end
                    end
                    if idFound == false then
                        --ferryBridge:log("Id not found")
                        --ferryBridge:log("Distance1: " .. distance1)
                        --ferryBridge:log("Distance2: " .. distance2)
                        if distance1 < 2 or distance2 < 2 then
                            self:addToAgentIdList(agentId)
                            local orientation = agent:getOwner():getGlobalOrientation()
                            local raft = self:getLevel():createObject("PREFAB_FERRY_BRIDGE_RAFT_PART", { agentPos.x, self.bridgeY, agentPos.z }, orientation)
                            self:addToRaftIdList({ raft:getId(), agentId })
                            self:addToSavedRaftList(tostring(raft:getId()) .. "," .. tostring(agentId))
                        end
                    end
                else
                    local agentId = agent:getOwner():getId()
                    self:removeFromAgentIdList(agentId)
                end
            end
        )
        
        local dt = self:getLevel():getDeltaTime()
        if dt ~= 0 then
            for i, entry in pairs(self.raftIdList) do
                local raft = self:getLevel():find(entry[1])
                if raft ~= nil then
                    local raftPos = raft:getGlobalPosition()
                    local agent = self:getLevel():find(entry[2])
                    local agentPos = agent:getGlobalPosition()
                    
                    local newRaftPos = { agentPos.x, raftPos.y, agentPos.z }
                    raft:setGlobalPosition(newRaftPos)
                    raft:setGlobalOrientation(agent:getGlobalOrientation())
                    
                    local raftDistance1 = math.sqrt( (self.posEnd[1] - raftPos.x)^2 + (self.posEnd[2] - raftPos.y)^2 + (self.posEnd[3] - raftPos.z)^2 )
                    local raftDistance2 = math.sqrt( (self.posStart[1] - raftPos.x)^2 + (self.posStart[2] - raftPos.y)^2 + (self.posStart[3] - raftPos.z)^2 )
                    
                    if raftDistance1 > self.waterDistance or raftDistance2 > self.waterDistance then
                        --ferryBridge:log("Destroying Raft: " .. tostring(entry[1]))
                        --ferryBridge:log("Before Destroy: " .. tostring(self.raftIdList))
                        raft:destroy()
                        --ferryBridge:log("After Destroy: " .. tostring(self.raftIdList))
                        self:removeFromSavedRaftList(self.raftIdList[i][1] .. "," .. self.raftIdList[i][2])
                        self.raftIdList[i] = nil
                        --ferryBridge:log("After Nil: " .. tostring(self.raftIdList))
                    end
                else
                    self:removeFromSavedRaftList(self.raftIdList[i][1] .. "," .. self.raftIdList[i][2])
                    self.raftIdList[i] = nil
                end
            end
        end
    end
end

function COMP_FERRY:onDestroy(_isClearingLevel)
    if self.posStart ~= nil and self.posEnd ~= nil then
        for i, entry in pairs(self.SavedRaftList) do
            local splitEntry = {}
            for j in string.gmatch(entry, "([^,]+)") do
               table.insert(splitEntry, j)
            end
            local raft = self:getLevel():find(splitEntry[1])
            if raft ~= nil then
                local raftPos = raft:getGlobalPosition()
                local raftDistance1 = math.sqrt( (self.posEnd[1] - raftPos.x)^2 + (self.posEnd[2] - raftPos.y)^2 + (self.posEnd[3] - raftPos.z)^2 )
                local raftDistance2 = math.sqrt( (self.posStart[1] - raftPos.x)^2 + (self.posStart[2] - raftPos.y)^2 + (self.posStart[3] - raftPos.z)^2 )
                --ferryBridge:log("raftDistance: " .. tostring(raftDistance1+raftDistance2) .. " waterDistance " .. self.waterDistance)
                if raftDistance1 + raftDistance2 <= self.totalDistance then
                    --ferryBridge:log("Deleting Raft: " .. splitEntry[1])
                    raft:destroy()
                    self.SavedRaftList[i] = nil
                end
            end
        end
    end
end

ferryBridge:registerClass(COMP_FERRY)

ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/StartPart/Cube", { DataType = "COMP_BUILDING_PART", FeedbackComponentListToActivate = { { "PREFAB_FERRY_BRIDGE_START_PART", "COMP_FERRY" } } })
ferryBridge:registerPrefabComponent("models/ferryBridge.fbx/Prefab/StartPart/Cube", { DataType = "COMP_FERRY", Enabled = true })

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

--[[------------------------ BUILDINGS & BUILDING PARTS -----------------------]]--

ferryBridge:register({
	DataType = "BUILDING",
	Id = "FERRY_BRIDGE",
	Name = "FERRY_BRIDGE_NAME",
	Description = "FERRY_BRIDGE_DESC",
	BuildingType = "MONUMENT",
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

ferryBridge:register({
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

ferryBridge:register({
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

ferryBridge:register({
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

ferryBridge:register({
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

ferryBridge:register({
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

ferryBridge:register({
	DataType = "BUILDING_FUNCTION_BRIDGE",
	Id = "FUNCTION_BRIDGE_ID"
})

--[[----------------------------- BEHAVIOUR TREES -----------------------------]]--
