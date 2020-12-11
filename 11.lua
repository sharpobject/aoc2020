require"stridx"
require"util"

local xs = {}
local n = 0

for x in io.lines() do
  n = n + 1
  xs[n] = procat("L"..x.."L")
end
xs[0] = string.rep("L", #xs[1])
xs[n+1] = string.rep("L", #xs[1])

local dxs = {-1,-1,-1, 0, 1, 1, 1, 0}
local dys = {-1, 0, 1, 1, 1, 0,-1,-1}

local function gogo(xs, keepgoing, nadj_to_unoccupy)
  local changed = true
  while changed do
    changed = false
    local nxs = deepcpy(xs)
    for i=1,n do
      for j=2,#xs[1]-1 do
        local nadj = 0
        for k=1,8 do
          local nx = i+dxs[k]
          local ny = j+dys[k]
          if keepgoing then
            while xs[nx][ny] == "." do
              nx = nx + dxs[k]
              ny = ny + dys[k]
            end
          end
          if xs[nx][ny] == "#" then
            nadj = nadj + 1
          end
        end
        if xs[i][j] == "L" and nadj == 0 then
          changed = true
          nxs[i][j] = "#"
        elseif xs[i][j] == "#" and nadj >= nadj_to_unoccupy then
          changed = true
          nxs[i][j] = "L"
        end
      end
    end
    xs = nxs
  end
  local ret = 0
  for i=1,n do
    for j=1,#xs[1] do
      if xs[i][j] == "#" then
        ret = ret + 1
      end
    end
  end
  print(ret)
end

gogo(deepcpy(xs), false, 4)
gogo(deepcpy(xs), true, 5)