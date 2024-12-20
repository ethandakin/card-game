local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Player = {}
Player.__index = Player

function Player.new()
    local self = {
        connections = {},
        hand = {},
        models = {},
    }

    return setmetatable(self, Player)
end

function Player:Initialize()
    self.connections["RemoteEvent"] = ReplicatedStorage.Remote.OnClientEvent:Connect(function(type: string, ...)
        if type == "Effect" then
            local args = {...}
            
            if args[1] == "Draw" then
                self:AddCard(args[2])
            end



        end
    end)
end

function Player:AddCard(card) 
    local model = ReplicatedStorage.Card:Clone()
    model.Parent = workspace.Hand
    table.insert(self.hand, card)
    table.insert(self.models, model)

    local width = model.Size.Z
    local maxWidth = workspace.HandPart.Size.Z

    print(width, maxWidth)

    

end

function Player:Cleanup() 
    for _, connection: RBXScriptConnection in pairs(self.connections) do
        connection:Disconnect()
    end
end

return Player.new()