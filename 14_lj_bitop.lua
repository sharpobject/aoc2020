require"stridx"
require"util"
local bit = require"bit"
local band, bor, bxor = bit.band, bit.bor, bit.bxor
local bnot, lshift, rshift = bit.bnot, bit.lshift, bit.rshift

local mem, mem2, mask1, mask2 = {}, {}, {}, {}

local int_max = 2^31

local function set(addr1, addr2, float1, float2, val, bit1, bit2)
  if bit1 ~= 0 then
    if band(float1, bit1) ~= 0 then
      set(bxor(addr1, bit1), addr2, float1, float2, val, rshift(bit1, 1), bit2)
    end
    set(addr1, addr2, float1, float2, val, rshift(bit1, 1), bit2)
  elseif bit2 ~= 0 then
    if band(float2, bit2) ~= 0 then
      set(addr1, bxor(bit2, addr2), float1, float2, val, bit1, rshift(bit2, 1))
    end
    set(addr1, addr2, float1, float2, val, bit1, rshift(bit2, 1))
  else
    --print(addr1 * int_max + addr2, val)
    mem2[addr1 * int_max + addr2] = val
  end
end


for x in io.lines() do
  if x[2] == "a" then
    mask1["1"] = 0
    mask1["0"] = 0
    mask1.X = 0
    mask2["1"] = 0
    mask2["0"] = 0
    mask2.X = 0
    local bit = lshift(1, 4)
    for i=8,12 do
      mask1[x[i]] = bor(mask1[x[i]], bit)
      bit = rshift(bit, 1)
    end
    bit = lshift(1, 30)
    for i=13,43 do
      mask2[x[i]] = bor(mask2[x[i]], bit)
      bit = rshift(bit, 1)
    end
  else
    x = map(tonumber,x:sub(5):gsub("%]",""):gsub("%=",""):split(" "))
    local addr_lo = x[1] % int_max
    local addr_hi = (x[1] - addr_lo) / int_max
    local val_lo = x[2] % int_max
    local val_hi = (x[2] - val_lo) / int_max
    --print(x[1], bor(band(val_hi, bnot(mask1["0"])), mask1["1"]) * int_max +
    --            bor(band(val_lo, bnot(mask2["0"])), mask2["1"]))
    mem[x[1]] = bor(band(val_hi, bnot(mask1["0"])), mask1["1"]) * int_max +
                bor(band(val_lo, bnot(mask2["0"])), mask2["1"])
    set(bor(addr_hi, mask1["1"]), bor(addr_lo, mask2["1"]),
        mask1.X, mask2.X, x[2], lshift(1,4), lshift(1,30))
  end
end

for _,t in ipairs{mem, mem2} do
  local ret = 0
  for k,v in pairs(t) do
    ret = ret + v
  end
  print(ret)
end