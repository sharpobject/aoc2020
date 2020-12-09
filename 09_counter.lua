require"stridx"
require"util"

local xs = {}
local n = 0
local inv = nil
local c = setmetatable({}, {__index = function(t,k)t[k]=0 return 0 end})

for x in io.lines() do
  n = n + 1
  x = 0+x
  xs[n] = x
  c[x] = c[x] + 1
  if n > 25 and not inv then
    local ok = false
    for i=n-25,n-1 do
      if (xs[i] ~= x/2 and c[x-xs[i]] > 0) or c[x-xs[i]] > 1 then
        ok = true
      end
    end
    if not ok then
      print(x)
      inv = x
    end
    c[x-25] = c[x-25] - 1
  end
end

local lo = 1
local hi = 1
local sum = 0
while sum ~= inv do
  if sum < inv then
    sum = sum + xs[hi]
    hi = hi + 1
  else
    sum = sum - xs[lo]
    lo = lo + 1
  end
end

local minx, maxx = 1e99,-1e99
for i=lo,hi-1 do
  minx = math.min(xs[i],minx)
  maxx = math.max(xs[i],maxx)
end
print(minx+maxx)