require"stridx"
require"util"

local xs = {}
local n = 0
local inv = nil

for x in io.lines() do
  n = n + 1
  x = 0+x
  xs[n] = x
  if n > 2 and not inv then
    local ok = false
    for i=n-2,n-1 do
      for j=i+1,n-1 do
        if xs[i] + xs[j] == x then
          ok = true
        end
      end
    end
    if not ok then
      print(x)
      inv = x
    end
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