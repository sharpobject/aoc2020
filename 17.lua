require"stridx"
require"util"

local xs = {}
local n = 0

for x in io.lines() do
  n = n + 1
  xs[n] = {}
  for i=1,#x do
    if x[i] == "#" then
      xs[n][i] = true
    end
  end
end

local orig_xs = xs

for ndims = 2,10 do
  xs = orig_xs
  for i=3,ndims do
    xs = {xs}
  end

  local function traverse(curr, idxs, level, cb)
    if level > ndims then
      return cb(curr, idxs)
    end
    for k,v in pairs(curr) do
      idxs[level] = k
      if level == ndims then
        cb(curr, k, idxs)
      else
        traverse(v, idxs, level+1, cb)
      end
    end
  end

  local function foradj(curr, idxs, level, all_zero, cb)
    for i=-1,1 do
      local this_all_zero = all_zero and i==0
      local idx = idxs[level]+i
      if level == ndims then
        if not this_all_zero then
          cb(curr, idx)
        end
      else
        curr[idx] = curr[idx] or {}
        foradj(curr[idx], idxs, level+1, this_all_zero, cb)
      end
    end
  end

  local function deepget(xs, idxs)
    for i=1,ndims do
      if not xs then return nil end
      xs = xs[idxs[i]]
    end
    return xs
  end

  local nxs
  local idxs, idxs2 = {}
  for qqq=1,6 do
    nxs = {}
    traverse(xs, idxs, 1, function(_, _, idxs)
      foradj(nxs, idxs, 1, true, function(t,k)
        t[k] = (t[k] or 0) + 1
      end)
    end)

    traverse(nxs, idxs, 1, function(curr, k, idxs)
      if not ((deepget(xs, idxs) and curr[k] == 2) or curr[k] == 3) then
        curr[k] = nil
      end
    end)

    xs = nxs
    --[[local ret = 0
    local map = {}
    for i=1,40 do
      map[i] = {}
      for j=1,40 do
        map[i][j] = "."
      end
    end
    traverse(xs, idxs, 1, function(_,_,idxs)
      map[idxs[1]+20][idxs[2]+20] = "#"
      ret = ret + 1
    end)
    for i=1,40 do
      print(table.concat(map[i]))
    end
    print(ret)--]]
  end

  local ret = 0
  traverse(xs, idxs, 1, function() ret = ret + 1 end)
  print(ndims, ret)
end