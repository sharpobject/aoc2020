require"stridx"
require"util"

local xs = {{{}}}
local n = 0

for x in io.lines() do
  n = n + 1
  xs[1][1][n] = {}
  for i=1,#x do
    if x[i] == "#" then
      xs[1][1][n][i] = true
    end
  end
end

local dxs, dys, dzs, dws = {}, {}, {}, {}
for dy=-1,1 do
  for dz=-1,1 do
    for dw=-1,1 do
      if dy ~= 0 or dz ~= 0 or dw ~= 0 then
        dxs[#dxs+1] = 0
        dys[#dys+1] = dy
        dzs[#dzs+1] = dz
        dws[#dws+1] = dw
      end
    end
  end
end

local orig_xs = xs

for qq=1,2 do
  xs = orig_xs
  local nds = #dws
  for qqq=1,6 do
    nxs = {}
    for i,a in pairs(xs) do
      nxs[i] = nxs[i] or {}
      for j,b in pairs(a) do
        nxs[i][j] = nxs[i][j] or {}
        for k,c in pairs(b) do
          nxs[i][j][k] = nxs[i][j][k] or {}
          for l,_ in pairs(c) do
            nxs[i][j][k][l] = nxs[i][j][k][l] or 0
            for m=1,nds do
              local ni, nj, nk, nl = i+dxs[m], j+dys[m], k+dzs[m], l+dws[m]
              nxs[ni] = nxs[ni] or {}
              nxs[ni][nj] = nxs[ni][nj] or {}
              nxs[ni][nj][nk] = nxs[ni][nj][nk] or {}
              nxs[ni][nj][nk][nl] = (nxs[ni][nj][nk][nl] or 0) + 1
            end
          end
        end
      end
    end
    for i,a in pairs(nxs) do
      for j,b in pairs(a) do
        for k,c in pairs(b) do
          for l,v in pairs(c) do
            if xs[i] and xs[i][j] and xs[i][j][k] and xs[i][j][k][l] then
              if v == 2 or v == 3 then
                c[l] = true
              else
                c[l] = nil
              end
            else
              if v == 3 then
                c[l] = true
              else
                c[l] = nil
              end
            end
          end
        end
      end
    end
    xs = nxs
  end

  local ret = 0
  for i,a in pairs(nxs) do
    for j,b in pairs(a) do
      for k,c in pairs(b) do
        for k,c in pairs(c) do
          ret = ret + 1
        end
      end
    end
  end
  print(ret)

  dxs, dys, dzs, dws = {}, {}, {}, {}
  for dx=-1,1 do
    for dy=-1,1 do
      for dz=-1,1 do
        for dw=-1,1 do
          if dx ~= 0 or dy ~= 0 or dz ~= 0 or dw ~= 0 then
            dxs[#dxs+1] = dx
            dys[#dys+1] = dy
            dzs[#dzs+1] = dz
            dws[#dws+1] = dw
          end
        end
      end
    end
  end
end