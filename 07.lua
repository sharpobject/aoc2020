require"stridx"
require"util"
require"queue"

local x = io.read("*l")

local out_edges = {}
local p2_edges = {}

while x do
  local tokens = x:split(" ")
  local src = tokens[1].." "..tokens[2]
  for idx=6,#tokens,4 do
    local dst = tokens[idx].." "..tokens[idx+1]
    p2_edges[src] = p2_edges[src] or {}
    p2_edges[src][dst] = tonumber(tokens[idx-1])
    out_edges[dst] = out_edges[dst] or {}
    out_edges[dst][src] = true
  end
  x = io.read("*l")
end

local visited = {}
local q = Queue()
q:push("shiny gold")
local ret = -1

while q:len() > 0 do
  local node = q:pop()
  if not visited[node] then
    ret = ret + 1
    visited[node] = true
    for nxt in pairs(out_edges[node] or {}) do
      q:push(nxt)
    end
  end
end
print(ret)

ret = -1
q:push({"shiny gold", 1})
while q:len() > 0 do
  local node, cnt = unpack(q:pop())
  ret = ret + cnt
  for nxt, mul in pairs(p2_edges[node]) do
    q:push({nxt, cnt*mul})
  end
end
print(ret)