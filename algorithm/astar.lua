--[[
    A*算法描述: 
    * 初始化open_set和close_set；
    * 将起点加入open_set中，并设置优先级为0（优先级最高）；
    * 如果open_set不为空，则从open_set中选取优先级最高的节点n：
        * 如果节点n为终点，则：
            * 从终点开始逐步追踪parent节点，一直达到起点；
            * 返回找到的结果路径，算法结束；
        * 如果节点n不是终点，则：
            * 将节点n从open_set中删除，并加入close_set中；
            * 遍历节点n所有的邻近节点：
                * 如果邻近节点m在close_set中，则：
                    * 跳过，选取下一个邻近节点
                * 如果邻近节点m也不在open_set中，则：
                    * 设置节点m的parent为节点n
                    * 计算节点m的优先级
                    * 将节点m加入open_set中
]]

local astar = class('astar')

function astar:run(bpos, epos, get_neighbour_nodes, heuristic_cost)
    self._open_list = {}
    self._close_list = {}
    self._heuristic_cost = heuristic_cost
    self._bpos = bpos
    self._epos = epos
    local path = {}
    local find = false
    
    self:join_open_list(bpos)
    
    while(#self._open_list > 0 and not find) do 
        local node_index = self:get_min_cost_index()
        local n = self._open_list[node_index]
        if n == epos then 
            local rpath = {}
            while(n.parent) do 
                table.insert(rpath, n.id)
                n = n.parent
            end
            
            for k = #rpath, 1, -1 do 
                table.insert(path, rpath[k])
            end
            find = true
        else
            local node_to_close = table.remove(self._open_list, node_index)
            node_to_close.in_close = true
            table.insert(self._close_list, node_to_close)
            
            local nodes = get_neighbour_nodes(n)
            for k, v in ipairs(nodes) do 
                if not v.in_close and not v.in_open then 
                    v.parent = n
                    self:join_open_list(v)
                end
            end
        end
    end
    
    self:clear_properties(self._open_list)
    self:clear_properties(self._close_list)
    
    return path
end

function astar:clone(tb)
    local result = {}
    for k, v in pairs(tb) do 
        table.insert(result, v)
    end
    return result
end

function astar:join_open_list(node)
    node.h = self._heuristic_cost(node, self._epos)
    node.g = (node.parent and node.parent.g + self._heuristic_cost(node, node.parent)) or 0
    node.in_open = true
    table.insert(self._open_list, node)
end

function astar:join_close_list(node)
    node.in_close = true
    table.insert(self._close_list, node)
end

function astar:clear_properties(tb)
    for k, v in ipairs(tb) do 
        v.parent = nil
        v.in_close = nil
        v.in_open = nil
        v.g = nil
        v.h = nil
    end
end

function astar:get_min_cost_index()
    local min_dis
    local min_index
    for k, v in ipairs(self._open_list) do 
        if min_dis == nil or (v.g + v.h) < min_dis then 
            min_dis = (v.g + v.h)
            min_index = k
        end
    end
    return min_index
end

return astar