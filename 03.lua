require"stridx"
require"util"

local x = io.read("*l")
local idxs, steps, rets = {0,0,0,0,0},{1,3,5,7,.5},{0,0,0,0,0}
while x do
  for i=1,5 do
    local idx = idxs[i]
    if idx % 1 == 0 and x[idx % #x + 1] == "#" then
      rets[i] = rets[i] + 1
    end
    idxs[i] = idxs[i] + steps[i]
  end
  x = io.read("*l")
end

print(rets[2])
print(reduce(function(a,b) return a*b end, rets))