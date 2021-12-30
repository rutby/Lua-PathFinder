-- ========================================================= 测试地图数据 1:可移动格子 0: 空格(不可移动) 4: 阻挡
local map = {
  -- 1,   2,   3,   4,   5,   6,   7,   8    9,  10,  11,  12,  13,  14,  15,  16,  17,  18,  19
    {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {1}, {1}, {1}, {4}, {4}, {1}, {1}, {1}, {1}, {4}, {0},-- 1
    {0}, {0}, {0}, {0}, {0}, {0}, {4}, {1}, {1}, {1}, {4}, {4}, {4}, {1}, {1}, {1}, {1}, {1}, {1},-- 2
    {0}, {0}, {0}, {0}, {1}, {1}, {4}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1},-- 3
    {1}, {0}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {4}, {4}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {4},-- 4
    {1}, {4}, {4}, {1}, {1}, {1}, {4}, {4}, {4}, {4}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {4},-- 5
    {1}, {1}, {1}, {1}, {1}, {1}, {1}, {4}, {4}, {4}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1},-- 6
    {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {4}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1},-- 7
    {0}, {1}, {1}, {1}, {1}, {1}, {1}, {4}, {4}, {1}, {1}, {1}, {1}, {4}, {1}, {1}, {1}, {1}, {1},-- 8
    {0}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {4}, {4}, {4}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1},-- 9
    {0}, {4}, {1}, {1}, {1}, {1}, {1}, {4}, {4}, {1}, {1}, {1}, {1}, {1}, {1}, {4}, {1}, {1}, {4},-- 10
    {0}, {0}, {0}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {4}, {1}, {4}, {1}, {0}, {0}, {0}, {0},-- 11
    {0}, {0}, {0}, {0}, {0}, {1}, {1}, {4}, {4}, {4}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, {0},-- 12
}
local nRow = 12
local nCol = 19

local function decorate_map()
    for row = 1, nRow do 
        for col = 1, nCol do 
            local index = (row - 1) * nCol + col
            local tag = map[index][1]
            map[index] = {
                col = col,
                row = row,
                tag = tag,
                id = index,
                select = false,
            }
        end
    end
end
decorate_map()

-- =========================================================

local M = {
    nRow = nRow,
    nCol = nCol,
    map = map,
}

function M.dump(tag, path)
    print(tag)
    
    local selected = {}
    for _, v in ipairs(path or {}) do 
        selected[v] = true
    end
    
    for row = nRow, 1, -1 do 
        local line = ''
        for col = 1, nCol do 
            local index = (row - 1) * nCol + col
            if selected[map[index].id] then 
                line = line .. '-' .. ' '
            else
                local tag = map[index].tag
                local display = tag == 4 and 'x' or tag
                line = line .. tostring(display) .. ' '
            end
        end
        print(line)
    end
    
    if not path then 
        for row = nRow, 1, -1 do 
            local line = ''
            for col = 1, nCol do 
                local index = (row - 1) * nCol + col
                local id = map[index].id
                if map[index].tag == 1 then 
                    if id < 10 then 
                        id = '00' .. tostring(id)
                    elseif id < 100 then 
                        id = '0' .. tostring(id)
                    end
                    line = line .. tostring(id) .. ' '
                else
                    line = line .. ' x ' .. ' '
                end
            end
            print(line)
        end
    end
end

function M.pos2index(row, col) 
    return (row - 1) * nCol + col
end

return M