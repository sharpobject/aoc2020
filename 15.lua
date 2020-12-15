require"stridx"
require"util"

local xs = {[0]=""}
local num_to_t = {}
local n = 0

for _,x in ipairs(map(tonumber, io.read("*l"):split(","))) do
  n = n + 1
  xs[n] = x
  num_to_t[xs[n-1]] = n-1
end

while n < 30000000 do
  n = n + 1
  local prev = xs[n-1]
  if num_to_t[prev] then
    xs[n] = n - 1 - num_to_t[prev]
  else
    xs[n] = 0
  end
  num_to_t[xs[n-1]] = n-1
end

print(xs[2020])
print(xs[30000000])