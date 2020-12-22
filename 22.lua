require"stridx"
require"util"
require"queue"
require"stack"

local p1, p2 = Queue(), Queue()
for x in io.lines() do
  if x == "" then
    p1, p2 = p2, p1
  elseif tonumber(x) then
    p2:push(tonumber(x))
  end
end

local winner = {}

local function rcombat(p1, p2)
  local seen = {}
  while p1:len() > 0 and p2:len() > 0 do
    local s1, s2 = table.concat(p1:dump(),","), table.concat(p2:dump(),",")
    local state = s1..";"..s2
    --print(state)
    if seen[state] then
      return p1
    end
    seen[state] = true
    local c1, c2 = p1:pop(), p2:pop()
    local winner = p2
    if p1:len() >= c1 and p2:len() >= c2 then
      local stuff1, stuff2 = p1:dump(), p2:dump()
      local np1, np2 = Queue(), Queue()
      for i=1,c1 do
        np1:push(stuff1[i])
      end
      for i=1,c2 do
        np2:push(stuff2[i])
      end
      local subwinner = rcombat(np1, np2)
      if subwinner == np1 then
        winner = p1
      end
    elseif c1 > c2 then
      winner = p1
    end
    if winner == p1 then
      p1:push(c1)
      p1:push(c2)
    else
      p2:push(c2)
      p2:push(c1)
    end
  end
  if p1:len() > 0 then
    return p1
  end
  return p2
end

local rp1, rp2 = deepcpy(p1), deepcpy(p2)

while p2:len() > 0 and p1:len() > 0 do
  local c1, c2 = p1:pop(), p2:pop()
  if c1 > c2 then
    p1:push(c1)
    p1:push(c2)
  else
    p2:push(c2)
    p2:push(c1)
  end
end

if p2:len() > 0 then
  p2, p1 = p1, p2
end

local mul = p1:len()
local ret = 0
while p1:len() > 0 do
  ret = ret + p1:pop() * mul
  mul = mul - 1
end
print(ret)

p1 = rcombat(rp1, rp2)
local mul = p1:len()
local ret = 0
while p1:len() > 0 do
  ret = ret + p1:pop() * mul
  mul = mul - 1
end
print(ret)
