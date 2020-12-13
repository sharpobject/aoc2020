require"stridx"
require"util"
local bigint = require"bigint"

local xs = {}
local n = 0

local st = tonumber(io.read("*l"))
local ls = io.read("*l"):split(",")
local xs = {}
local n = 0
for i=1,#ls do
  if ls[i] ~= "x" then
    n = n + 1
    xs[n] = tonumber(ls[i])
  end
end

local best_bus = 0
local best_wait_time = 1e99
for i=1,n do
  local this_wait_time = (xs[i] - (st % xs[i])) % xs[i]
  if this_wait_time < best_wait_time then
    best_wait_time = this_wait_time
    best_bus = xs[i]
  end
end

print(best_bus*best_wait_time)

local function gcd(a,b)
  if tostring(b) == "0" then return a end
  return gcd(b, a%b)
end
local function lcm(a,b)
  return a*b/gcd(a,b)
end

local ts = bigint:new(0)
local step = bigint:new(1)
for i=1,#ls do
  if ls[i] ~= "x" then
    local bus = bigint:new(ls[i])
    local modulus = (bus*1000-(i-1)) % bus
    while tostring(ts % bus) ~= tostring(modulus) do
      ts = ts + step
    end
    step = lcm(step, bus)
  end
end
print(ts)