local input = require("input")
local astar = require('algorithm.astar')

-- =========================================================
local get_neighbour_nodes = function(node) 
    local nodes = {}
    local nCol = input.nCol
    local nRow = input.nRow
    local pos2index = input.pos2index
    local map = input.map
    
    if node.row - 1 >= 1 then
        table.insert(nodes, map[pos2index(node.row - 1, node.col)])
    end
    
    if node.row + 1 <= nRow then
        table.insert(nodes, map[pos2index(node.row + 1, node.col)])
    end
    
    if node.col - 1 >= 1 then
        table.insert(nodes, map[pos2index(node.row, node.col - 1)])
    end
    
    if node.col + 1 <= nCol then
        table.insert(nodes, map[pos2index(node.row, node.col + 1)])
    end
    
    local validNodes = {}
    for k, v in ipairs(nodes) do 
        if v.tag == 1 then 
            table.insert(validNodes, v)
        end
    end
    return validNodes
end

local get_cost = function(pos, bpos, epos)
    local g = math.abs(pos.row - bpos.row) + math.abs(pos.col - bpos.col)
    local h = math.abs(pos.row - epos.row) + math.abs(pos.col - epos.col)
    return g + h
end

local main = function()
    input.dump('::map::')
    
    local path = astar():run(input.map[58], input.map[124], get_neighbour_nodes, get_cost)
    input.dump('::path::', path)
end

-- ========================================================= 
main()