local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")

local Deck = require(ServerStorage.Deck)

local Game = {}
Game.__index = Game

function Game.new() 
    local self = {
        id = HttpService:GenerateGUID(false),
        connections = {}
    }

    setmetatable(self, Game)

    return self
end

function Game:Start()        
    self.deck = Deck.new()
    self.deck:Shuffle()


    self.deck:Deal()

    local hands = 4
    local discards = 3
    local scoreToBeat = 300
    local currentScore = 0

    game.Workspace.cardcounter.SurfaceGui.TextLabel.Text = #self.deck.cards .. "/52"

    local selected = {}

    for i, v in pairs(self.deck.removed) do
        v.model.ClickDetector.MouseClick:Connect(function() 
            if table.find(selected, v) then
                table.remove(selected, table.find(selected, v))
                v.model.Highlight.Enabled = false
            else
                if #selected >= 5 then
                    return
                end

                table.insert(selected, v)
                v.model.Highlight.Enabled = true
            end
        end)
    end

    self.connections["yes"] = game.Workspace.yes.ClickDetector.MouseClick:Connect(function() 
        if #selected == 0 then
            return
        end

        -- calculate SCORE 

        local chips = 0
        local mult = 0

        local rank, hand = Deck:getRank(selected)

        local Rankings = require(game.ServerStorage.Rankings)
        chips = Rankings[rank].chips
        mult = Rankings[rank].coefficient

        game.Workspace.hand.SurfaceGui.TextLabel.Text = rank

        print(hand)

        for i, v in pairs(hand) do
            chips += v.chip_value
        end

        game.Workspace.chips.SurfaceGui.TextLabel.Text = chips
        game.Workspace.mult.SurfaceGui.TextLabel.Text = mult

        local score = chips * mult

        game.Workspace.score.SurfaceGui.score.Text = score
        
        currentScore += score

    end)

    self.connections["no"] = game.Workspace.no.ClickDetector.MouseClick:Connect(function() 
        if #selected == 0 then
            return
        end

        self.deck = nil
        selected = {}
        self:cleanUp()
        self:Start()
    end)
end

function Game:cleanUp() 
    for i, v in pairs(game.Workspace.Cards:GetChildren()) do
        v:Destroy()
    end

    for i, v in pairs(self.connections) do
        v:Disconnect()  

    end

end

return Game.new()