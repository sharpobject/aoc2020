require"stridx"
require"util"

local xs = {0}
local n = 1
local maxx = 0

for x in io.lines() do
  n = n + 1
  x = 0+x
  xs[n] = x
  maxx = math.max(maxx, x)
end
n = n + 1
xs[n] = maxx + 3

table.sort(xs)

local diffs = {0,0,0}
for i=2,#xs do
  local diff = xs[i] - xs[i-1]
  diffs[diff] = diffs[diff] + 1
end
print(diffs[1] * diffs[3])

dp = {}
for i=1,n do dp[i] = 0 end
dp[1] = 1
for i=2,n do
  for j=i-3,i-1 do
    if xs[j] and xs[i] - xs[j] <= 3 then
      dp[i] = dp[i] + dp[j]
    end
  end
end
print(dp[n])