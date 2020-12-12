require"stridx"
require"util"

local dxs = {-1, 0, 1, 0}
local dys = { 0,-1, 0, 1}
local facing = 1
local dir_to_facing = {E=1,S=2,W=3,N=4}

local x1,y1 = 0,0
local x,y = -10,1
local rx, ry = 0,0

for l in io.lines() do
  local dir, amt = l[1], tonumber(l:sub(2))
  if dir_to_facing[dir] then
    x = x + dxs[dir_to_facing[dir]] * amt
    y = y + dys[dir_to_facing[dir]] * amt
    x1 = x1 + dxs[dir_to_facing[dir]] * amt
    y1 = y1 + dys[dir_to_facing[dir]] * amt
  elseif dir == "F" then
    x1 = x1 + dxs[facing] * amt
    y1 = y1 + dys[facing] * amt
    rx = rx + x * amt
    ry = ry + y * amt
  else
    amt = amt / 90
    if dir == "L" then
      amt = -amt
    end
    amt = (amt + 400) % 4
    for i=1,amt do
      x, y = -y, x
      facing = facing % 4 + 1
    end
  end
end
print(math.abs(x1) + math.abs(y1))
print(math.abs(rx) + math.abs(ry))
