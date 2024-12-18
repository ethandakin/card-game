local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")

local Cards = require(ServerStorage.Cards)

local Main = {}
Main.__index = Main

local function sort(t)
    local c = table.clone(t)

    table.sort(c, function(a, b)
        if a.value == b.value then
            return a.suit > b.suit
        else
            return a.value > b.value
        end
    end)

    return c

end

local function shuffle(t)
    local c = table.clone(t)

    for i = #c, 2, -1 do
        local j = math.random(i)
        c[i], c[j] = c[j], c[i]
    end

    return c
end

function Main.new()
    local self = {
        id = HttpService:GenerateGUID(false),
        connections = {},
        
        deck = setmetatable({}, {
            __newindex = function(t, k, v) 
                local model = ServerStorage.model:Clone()
                model.CFrame = workspace.DeckSpawn.CFrame * CFrame.new(Vector3.new(0, -0.003 * k, 0)) * CFrame.Angles(0, math.rad(math.random(-1, 1)), 0)
                model.Name = tostring(k)
                model.Parent = workspace.Deck
                

                workspace.Display.Counter.SurfaceGui.TextLabel.Text = #t + 1 .. "/" .. #t + 1
                rawset(t, k, v)
            end

        }),
        
        dealt = {},
        hand = {},
        models = {},

        chips = 0,
        multiplier = 0,

        hands = 0,
        discards = 0,
    }

    return setmetatable(self, Main)
end

function Main:Initialize()
    for s = 1, 4 do
        for i = 1, 13 do
            local info = table.clone(Cards[i])
            info.index = i + ((s - 1) * 13)
            info.hand_index = 0
            info.suit = s
            self.deck[#self.deck + 1] = info
        end
    end

    -- shuffle deck
    self.deck = shuffle(self.deck)


    -- pull hand cards
    for i = 1, 8 do
        local card = table.remove(self.deck, #self.deck);

        table.insert(self.dealt, card)
    end

    self.dealt = sort(self.dealt)

    for i, v in pairs(sort(self.dealt)) do
        local card = ServerStorage.model:Clone()
        card.CFrame = ServerStorage.Location:FindFirstChild(i).CFrame
        card.Front.ImageLabel.Image = require(ServerStorage.Textures)[v.suit][v.value]
        card.Parent = workspace.Cards
        card.Name = i
        table.insert(self.models, card)
    end



    -- select triggers


    --[[
    for i, v in pairs(self.models) do
        v.ClickDetector.MouseClick:Connect(function()
            local card = self.dealt[i]

            if table.find(self.hand, card) then
                table.remove(self.hand, table.find(self.hand, card))
                -- 
                
                v.CFrame = v.CFrame * CFrame.new(0.05, 0, 0)
            else
                if #self.hand >= 5 then
                    return
                end

                card.hand_index = i

                table.insert(self.hand, card)
                v.CFrame = v.CFrame * CFrame.new(-0.05, 0, 0)
            end
        end)
    end
]]








end


return Main.new()