--[[---------------------------------------------------------------------------\
| ||\\    //||       /|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ |
| || \\  // ||  (o_ / |                  SUPPLEMENTARY FILE                  | |
| ||  \\//  ||  //\/  |                         ----                         | |
| ||   \/   ||  V_/_  |                  COMP FERRY BRIDGE                   | |
| ||        ||        |‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗/ |
\---------------------------------------------------------------------------]]--

local ferryBridge = ...

--[[---------------------------- CUSTOM COMPONENTS ----------------------------]]--

local COMP_FERRY_BRIDGE = {
    TypeName = "COMP_FERRY_BRIDGE",
    ParentType = "COMPONENT",
    Properties = {
        { Name = "ActiveAgents", Type = "list<GAME_OBJECT>", Default = {}, Flags = { "SAVE_GAME" } }
    }
}

function COMP_FERRY_BRIDGE:create()
    self.posStart = nil
    self.posEnd = nil
    self.waterDistance = 0
    self.bridgeY = 0
end

function COMP_FERRY_BRIDGE:raycast(pos)
    local raycastResultWater = {}
    local raycastResultTerrain = {}
    local fromPosition = { pos[1], pos[2]+100, pos[3] }
    local toPosition = { pos[1], pos[2]-100, pos[3] }
    local flagWater = bit.bor(bit.lshift(1, OBJECT_FLAG.WATER:toNumber()))
    local flagTerrain = bit.bor(bit.lshift(1, OBJECT_FLAG.TERRAIN:toNumber()))

    self:getLevel():rayCast(fromPosition, toPosition, raycastResultWater, flagWater)
    self:getLevel():rayCast(fromPosition, toPosition, raycastResultTerrain, flagTerrain)

    if raycastResultWater.Position.y > raycastResultTerrain.Position.y then
        return true, raycastResultWater.Position.y
    else
        return false, raycastResultWater.Position.y
    end
end

function COMP_FERRY_BRIDGE:onEnabled()
    local building = self:getOwner():findFirstObjectWithComponentUp("COMP_BUILDING")
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
        elseif parts[i]:getOwner().Name == "EndPart" then
            parts[i]:getOwner():forEachChildRecursive(
                function(child)
                    if child.Name == "Door.001" then
                        pos2 = child:getGlobalPosition()
                    end
                end
            )

        end
    end

    local posNew = { 0, 0, 0 }
    local waterFound = false
    for i=0,1,0.01 do
        posNew[1] = (1-i)*pos1.x + i*pos2.x
        posNew[2] = (1-i)*pos1.y + i*pos2.y
        posNew[3] = (1-i)*pos1.z + i*pos2.z

        local waterCheck, yVal = self:raycast(posNew)
        if waterFound == false then
            if waterCheck == true then
                self.posStart = { posNew[1], yVal, posNew[3] }
                waterFound = true
            end
        else
            if waterCheck == false then
                self.posEnd = { posNew[1], yVal, posNew[3] }
                break
            end
        end
    end

    if self.posStart ~= nil and self.posEnd ~= nil then
        self.waterDistance = 1.05 * math.sqrt( (self.posStart[1] - self.posEnd[1])^2 + (self.posStart[2] - self.posEnd[2])^2 + (self.posStart[3] - self.posEnd[3])^2 )
    end
end

function COMP_FERRY_BRIDGE:addToActiveAgentsList(agent)
    table.insert(self.ActiveAgents, agent)
end

function COMP_FERRY_BRIDGE:update()
    if self.posStart ~= nil and self.posEnd ~= nil then
        self:getLevel():getComponentManager("COMP_AGENT"):getAllComponent():forEach(
            function(agent)
                local agentPos = agent:getOwner():getGlobalPosition()
                local distance1 = math.sqrt( (self.posStart[1] - agentPos.x)^2 + (self.posStart[2] - agentPos.y)^2 + (self.posStart[3] - agentPos.z)^2 )
                local distance2 = math.sqrt( (self.posEnd[1] - agentPos.x)^2 + (self.posEnd[2] - agentPos.y)^2 + (self.posEnd[3] - agentPos.z)^2 )

                if distance1 + distance2 <= self.waterDistance then
                    local villager = agent:getOwner():getComponent("COMP_VILLAGER")
                    if villager ~= nil then
                        agent:setAnimation("MARKET_TENDER")
                    end
                    local found = false
                    for _, entry in pairs(self.ActiveAgents) do
                        if entry == agent:getOwner() then
                            found = true
                            break
                        end
                    end

                    if found == false then
                        if distance1 < 2 or distance2 < 2 then
                            local orientation = agent:getOwner():getGlobalOrientation()
                            local raft = self:getLevel():createObject("PREFAB_FERRY_BRIDGE_RAFT_PART", { agentPos.x, self.bridgeY, agentPos.z }, orientation)
                            raft:setParent(agent:getOwner(), true)
                            self:addToActiveAgentsList(agent:getOwner())
                        end
                    end
                end
            end
        )

        for i, entry in pairs(self.ActiveAgents) do
            if entry ~= nil and entry:is("GAME_OBJECT") then
                local agentPos = entry:getGlobalPosition()

                local raftDistance1 = math.sqrt( (self.posEnd[1] - agentPos.x)^2 + (self.posEnd[2] - agentPos.y)^2 + (self.posEnd[3] - agentPos.z)^2 )
                local raftDistance2 = math.sqrt( (self.posStart[1] - agentPos.x)^2 + (self.posStart[2] - agentPos.y)^2 + (self.posStart[3] - agentPos.z)^2 )

                if raftDistance1 > self.waterDistance or raftDistance2 > self.waterDistance then
                    entry:forEachChild(
                        function(child)
                            if child.Name == "RaftPart" then
                                child:destroy()
                                self.ActiveAgents[i] = nil
                            end
                        end
                    )
                end
            end
        end
    end
end

function COMP_FERRY_BRIDGE:onFinalize(isClearingLevel)
    if not isClearingLevel then
        for i, entry in pairs(self.ActiveAgents) do
            if entry ~= nil and entry:is("GAME_OBJECT") then
                entry:forEachChild(
                    function(child)
                        if child.Name == "RaftPart" then
                            child:destroy()
                            self.ActiveAgents[i] = nil
                        end
                    end
                )
            end
        end
    end
end

ferryBridge:registerClass(COMP_FERRY_BRIDGE)