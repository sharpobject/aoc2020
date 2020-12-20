require"stridx"
require"util"
require"queue"

local ids = {}
local tiles = {}
local sides = {}
local id, tile = 0, {}
for x in io.lines() do
  if x == "" then
    tiles[#tiles+1] = tile
    ids[#ids+1] = id
    tile = {}
  elseif x[1] == "T" then
    id = tonumber(x:gsub("%:",""):split(" ")[2])
  else
    tile[#tile+1] = x
  end
end

for i,t in ipairs(tiles) do
  local stuff = {}
  stuff[1] = t[1]
  stuff[2] = t[#t]
  local a,b = "",""
  for i=1,#t do
    a = a..t[i][1]
    b = b..t[i][#t]
  end
  stuff[3] = a
  stuff[4] = b
  for i=5,8 do
    stuff[i] = stuff[i-4]:reverse()
  end
  sides[i] = stuff
end

-- get b's offset relative to a
local function offset(a,b)
  if a[1] == b[#b] then
    return -1,0
  end
  if a[#a] == b[1] then
    return 1,0
  end
  local ok = true
  for i=1,#a do
    ok = ok and a[i][1] == b[i][#b]
  end
  if ok then
    return 0,-1
  end
  ok = true
  for i=1,#a do
    ok = ok and a[i][#a] == b[i][1]
  end
  if ok then
    return 0,1
  end
end

local function match(a,b)
  if a == b then return 0 end
  for i=1,8 do
    for j=1,8 do
      if a[i] == b[j] then
        return 1
      end
    end
  end
  return 0
end

local matches = {}
local ret = 1
for i,a in ipairs(sides) do
  matches[i] = 0
  for j,b in ipairs(sides) do
    matches[i] = matches[i] + match(a,b)
  end
  if matches[i] == 2 then
    ret = ret * ids[i]
  end
end
print(ret)

local q = Queue()
local xs,ys,tiling = {}, {}, {}
q:push({1,1,1})
while q:len() > 0 do
  local i,x,y = unpack(q:pop())
  if not xs[i] then
    xs[i] = x
    ys[i] = y
    tiling[x] = tiling[x] or {}
    tiling[x][y] = i
    for j,b in ipairs(tiles) do
      if match(sides[i],sides[j]) > 0 then
        local t = tiles[j]
        local dx,dy
        for qq=1,2 do
          for qqq=1,4 do
            dx, dy = offset(tiles[i], t)
            if dx then goto done end
            local new_stuff = {}
            for ii=1,#t do
              local s = ""
              for jj=1,#t do
                s = s..t[jj][ii]
              end
              new_stuff[ii] = s:reverse()
            end
            for ii=1,#t do
              t[ii] = new_stuff[ii]
            end
          end
          for qqq=1,#t do
            t[qqq] = t[qqq]:reverse()
          end
        end
        ::done::
        q:push({j, x+dx, y+dy})
      end
    end
  end
end

local strs = {}

for x,stuff in spairs(tiling) do
  local these_strs = {}
  for y,idx in spairs(stuff) do
    local t = tiles[idx]
    for i=1,#t do
      t[i] = t[i]:sub(2,#t-1)
    end
    table.remove(t,#t)
    table.remove(t,1)
    for i=1,#t do
      these_strs[i] = (these_strs[i] or "")..t[i]
    end
  end
  for i=1,#these_strs do
    strs[#strs+1] = these_strs[i]
  end
end

local npounds = 0
for i=1,#strs do
  for j=1,#strs[i] do
    if strs[i][j] == "#" then
      npounds = npounds + 1
    end
  end
end

local nessie = {
"                  # ",
"#    ##    ##    ###",
" #  #  #  #  #  #   ",
}
local nlen = #nessie[1]

local ret2 = 0
for qq=1,2 do
  for qqq=1,4 do
    local visited = {}
    local this_count = 0
    for i=1,#strs-2 do
      for j=1,#strs[1]-nlen+1 do
        for ii = 1,3 do
          for jj = 1,nlen do
            if nessie[ii][jj] == "#" and strs[i+ii-1][j+jj-1] ~= "#" then
              goto no_sighting
            end
          end
        end
        for ii = 1,3 do
          for jj = 1,nlen do
            if nessie[ii][jj] == "#" then
              visited[i+ii-1] = visited[i+ii-1] or {}
              if not visited[i+ii-1][j+jj-1] then
                visited[i+ii-1][j+jj-1] = true
                this_count = this_count + 1
              end
            end
          end
        end
        ::no_sighting::
      end
    end
    ret2 = math.max(ret2, this_count)

    local new_stuff = {}
    for ii=1,#strs do
      local s = ""
      for jj=1,#strs do
        s = s..strs[jj][ii]
      end
      new_stuff[ii] = s:reverse()
    end
    for ii=1,#strs do
      strs[ii] = new_stuff[ii]
    end
  end
  for qqq=1,#strs do
    strs[qqq] = strs[qqq]:reverse()
  end
end

print(npounds - ret2)


















