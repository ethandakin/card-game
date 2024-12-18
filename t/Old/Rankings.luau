local Rankings = {
    ["High Card"] = {chips = 5, coefficient = 1},
    ["Pair"] = {chips = 10, coefficient = 2},
    ["Two Pair"] = {chips = 20, coefficient = 2},
    ["Three of a Kind"] = {chips = 30, coefficient = 3},
    ["Straight"] = {chips = 30, coefficient = 4},
    ["Flush"] = {chips = 35, coefficient = 4},
    ["Full House"] = {chips = 40, coefficient = 4},
    ["Four of a Kind"] = {chips = 60, coefficient = 7},
    ["Straight Flush"] = {chips = 100, coefficient = 8},
    ["Royal Flush"] = {chips = 111, coefficient = 11},
    ["Five of a Kind"] = {chips = 120, coefficient = 12},
    ["Flush House"] = {chips = 140, coefficient = 14},
    ["Flush Five"] = {chips = 160, coefficient = 16},
}

return Rankings