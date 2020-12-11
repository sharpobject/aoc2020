require"stridx"
require"util"

local p = {}

for x in io.lines() do
  local t = x:split(" ")
  p[#p+1] = {t[1], tonumber(t[2])}
end

local visited = {}
local acc = 0

local function try()
  local visited = {}
  local acc = 0
  local pc = 1
  while pc and p[pc] and not visited[pc] do
    visited[pc] = true
    local op, operand = p[pc][1], p[pc][2]
    if op == "jmp" then
      pc = pc + operand
    else
      pc = pc + 1
    end
    if op == "acc" then
      acc = acc + operand
    end
    if op == "win" then
      return true, acc
    end
  end
  return false, acc
end

print(try())

p[#p+1] = {"win", "yolo"}

local tr = {nop="jmp",jmp="nop"}
for i=1,#p do
  local op = p[i][1]
  if tr[op] then
    p[i][1] = tr[op]
    local ok, ret = try()
    if ok then
      print(i,ret)
    end
    p[i][1] = op
  end
end







