local HttpService = game:GetService("HttpService")

local Main = {}
Main.__index = Main

function Main.new()
    local self = {
        id = HttpService:GenerateGUID(false),
        connections = {},
        
        deck = {},
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

    local curve = Instance.new("FloatCurve")

    local keys = {
        FloatCurveKey.new(0.0, -1.0, Enum.KeyInterpolationMode.Linear),
        FloatCurveKey.new(1.0, 1.0, Enum.KeyInterpolationMode.Linear)
    }

    curve:SetKeys(keys)
    print(curve:GetValueAtTime(0.5))

    curve:SetKeys(keys)
        for i = 0, 51 do
        table.insert(self.deck, math.floor(i / 13) + 1 .. " " .. tostring(i + 1))
    end

    print(self)

end


return Main.new()