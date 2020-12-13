require"stridx"
require"util"

local xs = {}
local n = 0

local st = tonumber(io.read("*l"))
local ls = io.read("*l"):split(",")
local xs = {}
local n = 0
for i=1,#ls do
  n = n + 1
  if ls[i] ~= "x" then
    xs[n] = tonumber(ls[i])
  end
end

local function gcd(a,b)
  if b == 0 then return a end
  return gcd(b, a%b)
end
local function lcm(a,b)
  return a*(b/gcd(a,b))
end

local best_bus = 0
local best_wait_time = 1e99
local ts = 0
local step = 1
for i,bus in pairs(xs) do
  local this_wait_time = (bus - (st % bus)) % bus
  if this_wait_time < best_wait_time then
    best_wait_time = this_wait_time
    best_bus = bus
  end
  local modulus = (bus*1000-(i-1)) % bus
  while ts % bus ~= modulus do
    ts = ts + step
  end
  step = lcm(step, bus)
end

print(best_bus*best_wait_time)
print(("%d"):format(ts))