require"stridx"
require"util"

local mem = {}
local mem2 = {}
local to_and   = 0xffffffffffff
local to_or    = 0x000000000000
local to_float = 0x000000000000

local function set(addr, to_float, val, bit)
  if bit == 0 then
    mem2[addr] = val
    return
  end
  if to_float & bit ~= 0 then
    set(addr ~ bit, to_float, val, bit >> 1)
  end
  set(addr, to_float, val, bit >> 1)
end

for x in io.lines() do
  if x[2] == "a" then
    to_and   = 0xffffffffffff
    to_or    = 0x000000000000
    to_float = 0x000000000000
    x = x:sub(8)
    local bit = 1<<35
    for i=1,36 do
      if x[i] == "1" then
        to_or = to_or | bit
      elseif x[i] == "0" then
        to_and = to_and & ~bit
      else
        to_float = to_float | bit
      end
      bit = bit >> 1
    end
  else
    x = x:sub(5):gsub("%]",""):gsub("%=",""):split(" ")
    mem[x[1]] = (x[2] & to_and) | to_or
    local addr = (x[1] | to_or) & ~to_float
    local val = tonumber(x[2])
    set(addr, to_float, val, 1<<35)
  end
end

local ret = 0
for k,v in pairs(mem) do
  ret = ret + v
end
print(ret)
ret = 0
for k,v in pairs(mem2) do
  ret = ret + v
end
print(ret)