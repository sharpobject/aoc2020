require"stridx"
require"util"
local re = require"rex_pcre"

local inss, alss = {}, {}
for x in io.lines() do
  ins, als = unpack(x:gsub("% %(", "("):gsub("%(contains% ", "(")
              :gsub("%,",""):gsub("%)",""):split("("))
  inss[#inss+1] = ins:split(" ")
  alss[#alss+1] = als:split(" ")
end

local function intersect(a,b)
  if b == nil then
    return a
  end
  for k,v in pairs(b) do
    if not a[k] then
      b[k] = nil
    end
  end
  return b
end

local al_to_ins = {}
for i,als in ipairs(alss) do
  for _,al in ipairs(als) do
    local this_set = {}
    for _,ing in ipairs(inss[i]) do
      this_set[ing] = true
    end
    al_to_ins[al] = intersect(this_set, al_to_ins[al])
  end
end

local guilty_ins = {}
for _,ins in pairs(al_to_ins) do
  for ing,_ in pairs(ins) do
    guilty_ins[ing] = true
    guilty_ins[#guilty_ins+1] = ing
  end
end

local ret = 0
for _,ins in pairs(inss) do
  for _,ing in pairs(ins) do
    if not guilty_ins[ing] then
      ret = ret + 1
    end
  end
end
print(ret)

local cm, visited = {}, {}
local function find_match(where)
  if where == nil then
    return true
  end
  for match,_ in pairs(al_to_ins[where]) do
    if not visited[match] then
      visited[match] = true
      if find_match(cm[match]) then
        cm[match] = where
        return true
      end
    end
  end
  return false
end

for al,_ in pairs(al_to_ins) do
  visited = {}
  find_match(al)
end

local ret2 = {}
for k,v in pairs(cm) do
  ret2[#ret2+1] = {k,v}
end
table.sort(ret2, function(x,y)
  return x[2] < y[2]
end)
print(table.concat(map(function(x) return x[1] end, ret2), ","))
