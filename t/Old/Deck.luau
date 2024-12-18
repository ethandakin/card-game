local ServerStorage = game:GetService("ServerStorage")
local Card = require(ServerStorage.Card)

local Deck = {}
Deck.__index = Deck

function Deck.new()
    local self = {
        cards = {},
        removed = {},
        discarded = {}
    }

    for s = 1, 4 do
        for i = 1, 13 do
            table.insert(self.cards, Card.new(s, i, (13 * s - 1) + i))
        end
    end

    return setmetatable(self, Deck)
end

function Deck:Shuffle()
    for i = #self.cards, 2, -1 do
        local j = math.random(i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

local function sortHand(hand) 
    local t = table.clone(hand)

    table.sort(t, function(a, b)
        if a.value == b.value then
            return a.suit_value > b.suit_value
        else
            return a.value > b.value
        end
    end)

    return t
end


function Deck:Deal(n)
    n = n or 8
    
    for i = 1, n do
        local card = table.remove(self.cards, #self.cards);

        table.insert(self.removed, card)
    end

    local t = sortHand(self.removed)

    for i, v in pairs(t) do
        v:spawn(game.Workspace.cards:FindFirstChild(tostring(i)).CFrame * CFrame.new(Vector3.new(0, 0.1, 0)))
    end
end



-- gets just the values of a hand
local function getValues(hand)
    local t = {}

    for i, v in pairs(hand) do
        table.insert(t, v.value)
    end

    return t
end

-- gets the occurences of each card based on value
local function getCount(hand)
    local t = {}

    for _, v in pairs(hand) do
        if t[v] then
            t[v] += 1
        else
            t[v] = 1
        end
    end

    return t
end

-- returns the highest count card
local function getHighestCount(hand)
    local highest = 0

    for i, v in pairs(hand) do
        if v > highest then 
            highest = v 
        end
    end

    return highest
end

-- sorts the hand based on value and suit


-- compares a concatenated, sorted hand with the values 1, 10, 11, 12, 13 
local function isRoyal(hand)
    if #hand < 5 then
        return false
    end
    
    local t = getValues(sortHand(hand))

    if table.concat(t) == table.concat({1, 10, 11, 12, 13}) then
        return true
    else
        return false
    end
end

--  ensures entire hand is the same suit
local function isFlush(hand)
    if #hand < 5 then
        return false
    end

    for i = 2, #hand do
        if hand[i].suit ~= hand[1].suit then 
            return false 
        end
    end

    return true
end

local function isStraight(hand)
    if #hand < 5 then
        return false
    end

    local t = table.clone(hand)

    table.sort(t, function (a, b) return a.value < b.value end)

    local ace, thisValue, lastValue = false, false, false

    for i = 2, #t do
        thisValue, lastValue = t[i].value, t[i-1].value
        if lastValue == 1 then ace = i - 1 end
        if thisValue ~= lastValue + 1 then
            if ace then
                t[ace].value = 14
                return isStraight(t)
            else
                return false
            end
        end
    end
    return true
end

-- ensures entire hand is the same card value
local function isFive(hand)
    if #hand < 5 then
        return false
    end

    for i = 2, #hand do
        if hand[i].value ~= hand[1].value then
            return false
        end
    end

    return true
end

-- checks the first three cards are the same, then the last two are the same
local function isHouse(hand)
    if #hand < 5 then
        return false
    end

    local t = getValues(sortHand(hand))
    
    for i = 2, 3 do
        if t[i] ~= t[1] then 
            return false 
        end
    end

    for i = 4, 5 do
        if t[i] ~= t[4] then 
            return false 
        end
    end

    return true
end

-- checks if all the cards are a different suit (currently impossible)
local function isDiverse(hand) 
    if #hand < 5 then
        return false    
    end

    for i = 2, #hand do
        if hand[i].suit == hand[1].suit then
            return false
        end
    end

    return true
end


function Deck:getRank(hand)
    local five = isFive(hand)
    local house = isHouse(hand)
    local diverse = isDiverse(hand)

    
    local royal = isRoyal(hand)
    local flush = isFlush(hand)

    if five and flush then
        return "flush-five", hand
    end

    if flush and house then
        return "flush-house", hand
    end

    if five and diverse then
        return "five-of-a-kind", hand
    end

    if royal and flush then
        return "royal-flush", hand
    end

    local straight = isStraight(hand)
    
    if straight and flush then
        return "straight-flush", hand
    end

    local count = getCount(getValues(hand))
    local highest = getHighestCount(count)
    local sorted = sortHand(hand)

    local t = {}

    for i, v in pairs(sorted) do
        if not t[tostring(v.value)] then
            t[tostring(v.value)] = {}
        end

        table.insert(t[tostring(v.value)], v)
    end

    if highest == 4 then
        local h

        for i, v in pairs(t) do
            if #v == 4 then
                h = v
            end
        end

        return "four-of-a-kind", h
    end

    local threes, twos = 0, 0
    
    for _, v in pairs(count) do
        if v == 3 then threes += 1 end
        if v == 2 then twos += 1 end
    end

    if threes == 1 and twos == 1 then
        return "full-house", hand
    end

    if flush then
        return "flush", hand
    end

    if straight then
        return "straight", hand
    end

    if highest == 3 then
        local h

        for i, v in pairs(t) do
            if #v == 3 then
                h = v
            end
        end

        return "three-of-a-kind", h
    end

    if threes == 0 and twos == 2 then
        local h = {}

        for i, v in pairs(t) do
            if #v == 2 then
                for _, j in pairs(v) do
                    table.insert(h, j)
                end
            end
        end

        return "two-pair", h
    end

    if highest == 2 then
        local h

        for i, v in pairs(t) do
            if #v == 2 then
                h = v
            end
        end

        return "pair", h
    end

    return "high-card", {sorted[1]}
end

return Deck