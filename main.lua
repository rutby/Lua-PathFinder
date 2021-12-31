local input = require("input")
local astar = require('algorithm.astar')()

local is_in_boundary = function(row, col)
    local nCol = input.nCol
    local nRow = input.nRow
    return row >=1 and row <= nRow and col >= 1 and col <= nCol
end

-- ========================================================= 曼哈顿距离
local get_neighbour_nodes1 = function(node) 
    local nodes = {}
    local pos2index = input.pos2index
    local map = input.map

    local neighbour = {
        {node.row - 1, node.col},
        {node.row, node.col - 1},
        {node.row, node.col + 1},
        {node.row + 1, node.col},
    }
    
    for k, v in ipairs(neighbour) do 
        if is_in_boundary(v[1], v[2]) then 
            local node = map[pos2index(v[1], v[2])]
            if node.tag == 1 then 
                table.insert(nodes, node)
            end
        end
    end
    
    return nodes
end

local heuristic1 = function(bpos, epos)
    local dx = math.abs(bpos.col - epos.col)
    local dy = math.abs(bpos.row - epos.row)
    return dx + dy
end

local get_cost1 = function(pos, bpos, epos)
    local g = heuristic1(pos, bpos)
    local h = heuristic1(pos, epos)
    return g + h
end

-- ========================================================= 对角距离

local get_neighbour_nodes2 = function(node) 
    local nodes = {}
    local pos2index = input.pos2index
    local map = input.map
    
    local neighbour = {
        {node.row - 1, node.col - 1},
        {node.row - 1, node.col},
        {node.row - 1, node.col + 1},
        {node.row, node.col - 1},
        {node.row, node.col + 1},
        {node.row + 1, node.col - 1},
        {node.row + 1, node.col},
        {node.row + 1, node.col + 1},
    }
    
    for k, v in ipairs(neighbour) do 
        if is_in_boundary(v[1], v[2]) then 
            local node = map[pos2index(v[1], v[2])]
            if node.tag == 1 then 
                table.insert(nodes, node)
            end
        end
    end

    return nodes
end

local heuristic2 = function(bpos, epos)
    local dx = math.abs(bpos.col - epos.col)
    local dy = math.abs(bpos.row - epos.row)
    return (dx + dy) + (1.4142 - 2) * math.min(dx, dy)
end

-- ========================================================= 
local main = function()
    input.dump('::map::')
    local path = astar:run(input.map[58], input.map[124], get_neighbour_nodes1, heuristic1)
    -- local path = astar:run(input.map[58], input.map[124], get_neighbour_nodes2, heuristic2)
    input.dump('::path::', path)
end
main()