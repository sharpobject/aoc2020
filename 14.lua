require"stridx"
require"util"

local mem, mem2, mask = {}, {}, {}

local function set(addr, to_float, val, bit)
  if bit == 0 then
    mem2[addr] = val
  else
    if to_float & bit ~= 0 then
      set(addr ~ bit, to_float, val, bit >> 1)
    end
    set(addr, to_float, val, bit >> 1)
  end
end

for x in io.lines() do
  if x[2] == "a" then
    mask["1"] = 0
    mask["0"] = 0
    mask.X = 0
    local bit = 1<<35
    for i=8,43 do
      mask[x[i]] = mask[x[i]] | bit
      bit = bit >> 1
    end
  else
    x = x:sub(5):gsub("%]",""):gsub("%=",""):split(" ")
    mem[x[1]] = (x[2] & ~mask["0"]) | mask["1"]
    set(x[1]|mask["1"], mask.X, x[2]|0, 1<<35)
  end
end

for _,t in ipairs{mem, mem2} do
  local ret = 0
  for k,v in pairs(t) do
    ret = ret + v
  end
  print(ret)
end