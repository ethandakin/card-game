--!strict
local HttpService: HttpService = game:GetService("HttpService")
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players: Players = game:GetService("Players")

local Remote: RemoteEvent = ReplicatedStorage.Remote

local Main = {}
Main.__index = Main

type Card = {
    value: number,
    rank: number,
    suit: number
}

export type Main = typeof(setmetatable({} :: {
    id: string,
    connections: {RBXScriptConnection},
    deck: {Card},
    dealt: {Card},
    hand: {Card},
    chips: number,
    multiplier: number,
    hands: number,
    discards: number,
    player: Player?

}, Main))

function Main.new(): Main
    return setmetatable({
        id = HttpService:GenerateGUID(false),
        connections = {},
        
        deck = {},
        dealt = {},
        hand = {},

        chips = 0,
        multiplier = 0,

        hands = 0,
        discards = 0
    }, Main)
end

function Main.Initialize(self: Main)
    -- get player
    self.player = Players.PlayerAdded:Wait()



    -- create deck
    for suit: number = 1, 4 do
        for rank: number = 2, 14 do
            table.insert(self.deck, {
                rank = rank,
                value = if rank == 14 then 11 else math.clamp(rank, 1, 10),
                suit = suit
            })
        end
    end

    -- shuffle deck
    self:Shuffle()
    -- draw hand


    while task.wait(3) do
        self:Draw(1)
    end

    -- send hand to client

    print(self)

    -- hook up events from client :)


    
end

function Main.Shuffle(self: Main)
    for i = #self.deck, 2, -1 do
        local j = math.random(i)
        self.deck[i], self.deck[j] = self.deck[j], self.deck[i]
    end
end

function Main.Draw(self: Main, n: number)
    if not self.player then
        return
    end

    for i: number = 1, n do
        if #self.deck <= 0 then
            return
        end

        local card: Card = self.deck[#self.deck]
        self.deck[#self.deck] = nil
        self.hand[#self.hand + 1] = card

        -- fire to client
        Remote:FireClient(self.player, "Effect", "Draw", card)
    end
end



return Main.new()