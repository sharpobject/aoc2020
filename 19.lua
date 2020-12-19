require"stridx"
require"util"
local re = require"rex_pcre"

local rules = {}
local x = io.read("*l")
while x ~= "" do
  local stuff = x:split(": ")
  stuff[#stuff+1] = "|"
  local ridx = tonumber(stuff[1])
  rules[ridx] = {}
  local subrules = {}
  for i=2,#stuff do
    local term = stuff[i]
    if term[1] == '"' then
      rules[ridx] = term[2]
      break
    elseif term == "|" then
      rules[ridx][#rules[ridx]+1] = subrules
      subrules = {}
    else
      subrules[#subrules+1] = tonumber(term)
    end
  end
  x = io.read("*l")
end

local function stringify(idx)
  if type(rules[idx]) == "string" then
    return rules[idx]
  end
  local t = {}
  for i=1,#rules[idx] do
    local subrule = rules[idx][i]
    for _,alternative in pairs(subrule) do
      t[#t+1] = "(?:"
      t[#t+1] = stringify(alternative)
      t[#t+1] = ")"
    end
    if i < #rules[idx] then
      t[#t+1] = "|"
    end
  end
  t = table.concat(t)
  rules[idx] = t
  return t
end

local old_rules = deepcpy(rules)

local rule = re.new("^(?:"..stringify(0)..")$")
-- new rule 0: match any number of 42, then 0 or 1 11, then a smaller number of 31
-- at least 2x 42 and 1x 31!
local rule42 = re.new("^(?:"..stringify(42)..")$")
local rule11 = re.new("^(?:"..stringify(11)..")?$")
local rule31 = re.new("^(?:"..stringify(31)..")$")

local dp42, dp31 = {}, {}
local function matches_42(s, lo, hi)
  if lo == hi then return 0 end
  if not dp42[lo] then dp42[lo] = {} end
  if dp42[lo][hi] then return dp42[lo][hi] end
  local best = -1e99
  for mid = lo, hi do
    if re.match(s:sub(lo, mid-1), rule42) then
      local rest = matches_42(s, mid, hi)
      if rest+1 > best then
        best = rest+1
      end
    end
  end
  dp42[lo][hi] = best
  return best
end

local function matches_31(s, lo, hi)
  if lo == hi then return 0 end
  if not dp31[lo] then dp31[lo] = {} end
  if dp31[lo][hi] then return dp31[lo][hi] end
  local best = 1e99
  for mid = lo, hi do
    if re.match(s:sub(lo, mid-1), rule31) then
      local rest = matches_31(s, mid, hi)
      if rest+1 < best then
        best = rest+1
      end
    end
  end
  dp31[lo][hi] = best
  return best
end

local function match(s)
  dp42, dp31 = {}, {}
  for i=1,#s+1 do
    for j=i,#s+1 do
      local a = matches_42(s,1,i)
      local ok = re.match(s:sub(i,j-1), rule11)
      local b = matches_31(s,j,#s+1)
      if ok and a > b and b > 0 then
        return true
      end
    end
  end
  return false
end

local ret = 0
local ret2 = 0
x = io.read("*l")
while x do
  if re.match(x, rule) then
    ret = ret + 1
  end
  if match(x) then
    ret2 = ret2 + 1
  end
  x = io.read("*l")
end
print(ret)
print(ret2)
