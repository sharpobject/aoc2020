require"stridx"
require"util"
require"queue"

local p = {}

for x in io.lines() do
  local tokens = x:split(" ")
  local op = tokens[1]
  local operand = tonumber(tokens[2]:sub(2))
  if tokens[2][1] == "-" then
    operand = -operand
  end
  p[#p+1] = {op, operand}
end

local visited = {}

local function try()
  local pc = 1
  local acc = 0
  while pc and p[pc] and not visited[pc] do
    visited[pc] = true
    local op, operand = p[pc][1], p[pc][2]
    if op == "acc" then
      acc = acc + operand
    end
    if op == "jmp" then
      pc = pc + operand
    else
      pc = pc + 1
    end
    if op == "win" then
      return acc
    end
  end
  return acc
end

print(try())

local back_edges = {}
local r_back_edges = {}
local tr = {jmp="nop",nop="jmp"}
for i=1,#p do
  local op, operand = p[i][1], p[i][2]
  if tr[op] then
    local nxt = i + operand
    local r_nxt = i + 1
    if op == "nop" then
      nxt, r_nxt = r_nxt, nxt
    end
    back_edges[nxt] = back_edges[nxt] or {}
    back_edges[nxt][i] = true
    r_back_edges[r_nxt] = r_back_edges[r_nxt] or {}
    r_back_edges[r_nxt][i] = true
  else
    local nxt = i + 1
    back_edges[nxt] = back_edges[nxt] or {}
    back_edges[nxt][i] = true
  end
end

local prev_visited = visited
visited = {}
local back_visited = {}
local q = Queue()
p[#p+1] = {"win", "yolo"}
q:push(#p)
while true do
  local pc = q:pop()
  if not back_visited[pc] then
    back_visited[pc] = true
    for prev in pairs(r_back_edges[pc] or {}) do
      if prev_visited[prev] then
        p[prev][1] = tr[p[prev][1]]
        print(try())
        return
      end
    end
    for prev in pairs(back_edges[pc] or {}) do
      q:push(prev)
    end
  end
end