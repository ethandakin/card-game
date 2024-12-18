local Card = {}
Card.__index = Card

local Textures = require(game:GetService("ServerStorage").Textures)

local cards = {
    "Ace",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Jack",
    "Queen",
    "King"
}

local new_values = {
    ["Ace"] = 11,
    ["Two"] = 2,
    ["Three"] = 3,
    ["Four"] = 4,
    ["Five"] = 5,
    ["Six"] = 6,
    ["Seven"] = 7,
    ["Eight"] = 8,
    ["Nine"] = 9,
    ["Ten"] = 10,
    ["Jack"] = 10,
    ["Queen"] = 10,
    ["King"] = 10
}



local suits = {
    "Clubs", 
    "Diamonds", 
    "Hearts", 
    "Spades",
}

function Card.new(suit, value, pos)
    print(value)
    local self = {
        suit = suits[suit],
        suit_value = suit,
        card = cards[value],
        pos = pos,
        value = value,
        chip_value = new_values[cards[value]],
        texture = Textures[suits[suit]][value]
    }

    return setmetatable(self, Card)
end

function Card:spawn(position) 
    self.model = game.ServerStorage.model:Clone()
    self.model.Parent = workspace.Cards
    self.model.CFrame = position
    self.model.Front.ImageLabel.Image = self.texture
end

return Card