require"stridx"
require"util"
local bit = require"bit"
local band, bor, bxor = bit.band, bit.bor, bit.bxor
local bnot, lshift, rshift = bit.bnot, bit.lshift, bit.rshift

local mem, mem2, mask = {}, {}, {}

local function set(addr, to_float, val, bit)
  if bit == 0 then
    mem2[addr] = val
  else
    if band(to_float, bit) ~= 0 then
      set(bxor(addr, bit), to_float, val, rshift(bit, 1))
    end
    set(addr, to_float, val, rshift(bit, 1))
  end
end

for x in io.lines() do
  if x[2] == "a" then
    mask["1"] = 0
    mask["0"] = 0
    mask.X = 0
    local bit = lshift(1, 35)
    for i=8,43 do
      mask[x[i]] = bor(mask[x[i]], bit)
      bit = rshift(bit, 1)
    end
  else
    x = map(tonumber, x:sub(5):gsub("%]",""):gsub("%=",""):split(" "))
    mem[x[1]] = bor(band(x[2], bnot(mask["0"])), mask["1"])
    set(bor(x[1], mask["1"]), mask.X, x[2], lshift(1,35))
  end
end

for _,t in ipairs{mem, mem2} do
  local ret = 0
  for k,v in pairs(t) do
    ret = ret + v
  end
  print(ret)
end