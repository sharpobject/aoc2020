require"stridx"
require"util"

local idxs, steps, rets = {0,0,0,0,0},{1,3,5,7,.5},{0,0,0,0,0}
for x in io.lines() do
  for i=1,5 do
    local idx = idxs[i]
    if idx % 1 == 0 and x[idx % #x + 1] == "#" then
      rets[i] = rets[i] + 1
    end
    idxs[i] = idxs[i] + steps[i]
  end
end

print(rets[2])
print(reduce(function(a,b) return a*b end, rets))