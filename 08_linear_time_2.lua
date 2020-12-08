require"stridx"
require"util"
require"stack"

local p = {}

for x in io.lines() do
  local t = x:split(" ")
  p[#p+1] = {t[1], tonumber(t[2])}
end

local visited = {}
local s = Stack()
local n = 0
local pc = 1
local acc = 0

local function step()
  visited[pc] = true
  local op, operand = unpack(p[pc])
  if op == "acc" then
    acc = acc + operand
  elseif op == "jmp" then
    pc = pc + operand - 1
  end
  pc = pc + 1
end

local tr = {jmp="nop",nop="jmp"}
while p[pc] and not visited[pc] do
  if tr[p[pc][1]] then
    s:push({pc,acc})
  end
  step()
end
print(acc)

local winner = #p+1
while true do
  pc,acc = unpack(s:pop())
  p[pc][1] = tr[p[pc][1]]
  step()
  while p[pc] and not visited[pc] do
    step()
  end
  if pc == winner then
    print(acc)
    break
  end
end