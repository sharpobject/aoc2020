require"stridx"
require"util"

local dxs =  {  1,    1,    0,  -1,   -1,    0}
local dys =  {  0,   -1,   -1,   0,    1,    1}
local dirs = {"e", "se", "sw", "w", "nw", "ne"}
for i=1,#dirs do
  dxs[dirs[i]] = dxs[i]
  dys[dirs[i]] = dys[i]
end

local tiles = {}
for s in io.lines() do
  local x,y = 0,0
  local idx = 1
  while idx <= #s do
    for _,dir in ipairs(dirs) do
      if s:sub(idx, idx+#dir-1) == dir then
        x = x + dxs[dir]
        y = y + dys[dir]
        idx = idx + #dir
        break
      end
    end
  end
  tiles[x] = tiles[x] or {}
  tiles[x][y] = not tiles[x][y]
end

local function prt()
  local ret = 0
  for _,t in pairs(tiles) do
    for y,v in pairs(t) do
      if v then
        ret = ret + 1
      else
        t[y] = nil
      end
    end
  end
  print(ret)
end

prt()
for i=1,100 do
  local counts = {}
  for x,t in pairs(tiles) do
    for y,v in pairs(t) do
      assert(v)
      for j=1,6 do
        local nx, ny = x+dxs[j], y+dys[j]
        counts[nx] = counts[nx] or {}
        counts[nx][ny] = (counts[nx][ny] or 0) + 1
      end
    end
  end
  local nt = {}
  for x,t in pairs(counts) do
    for y,v in pairs(t) do
      if v == 2 or (v == 1 and tiles[x] and tiles[x][y]) then
        nt[x] = nt[x] or {}
        nt[x][y] = true
      end
    end
  end
  tiles = nt
end
prt()
