require"stridx"
require"util"

local x = map(function(x) return x-1 end,procat(io.read("*l")))

local function removenext(node)
  local ret = node.n
  node.n = ret.n
  return ret
end

local function insertnext(node, to_insert)
  local oldnext = node.n
  to_insert.n = oldnext
  node.n = to_insert
end

local function solve(x, n, nturns)
  x = deepcpy(x)
  for i=#x+1,n do
    x[i] = i-1
  end
  local nodes = {}
  for i=1,n do
    x[i] = {v=x[i]}
    nodes[x[i].v] = x[i]
  end
  for i=1,n do
    x[i].n = x[i%n+1]
  end
  local curr = x[1]
  for i=1,nturns do
    local a,b,c
    a = removenext(curr)
    b = removenext(curr)
    c = removenext(curr)
    local dst = (curr.v-1)%n
    while a.v==dst or b.v==dst or c.v==dst do
      dst = (dst-1)%n
    end
    dst = nodes[dst]
    insertnext(dst, c)
    insertnext(dst, b)
    insertnext(dst, a)
    curr = curr.n
  end
  return nodes[0]
end

local curr = solve(x, 9, 100)
local ret = ""
for i=1,8 do
  curr = curr.n
  ret = ret..(curr.v+1)
end
print(ret)
curr = solve(x, 1000000, 10000000)
print((curr.n.v + 1) * (curr.n.n.v + 1))
