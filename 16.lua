require"stridx"
require"util"

local rules = {}
local dep_rules = {}
local x = io.read("*l")
while x ~= "" do
  rules[#rules+1] = map(tonumber,
      x:gsub(".*: ",""):gsub("%-"," "):gsub("or ",""):split(" "))
  if x:sub(1,9) == "departure" then
    dep_rules[#rules] = true
  end
  x = io.read("*l")
end

io.read("*l")
local my_ticket = map(tonumber, io.read("*l"):split(","))

local tickets = {}
io.read("*l")
io.read("*l")
x = io.read("*l")
while x do
  tickets[#tickets+1] = map(tonumber, x:split(","))
  x = io.read("*l")
end

local valid = {}
local ret = 0
for i,t in ipairs(tickets) do
  valid[i] = true
  for _,v in ipairs(t) do
    local ok = false
    for _,r in ipairs(rules) do
      if (v >= r[1] and v <= r[2]) or (v >= r[3] and v <= r[4]) then
        ok = true
      end
    end
    if not ok then
      ret = ret + v
      valid[i] = false
    end
  end
end
print(ret)

-- for each RULE, a list of FIELD INDICES that it can match
local rule_to_fields = {}
for i,r in ipairs(rules) do
  local fields = {}
  for j=1,#rules do
    local ok = true
    for k,t in ipairs(tickets) do
      if valid[k] then
        local v = t[j]
        ok = ok and ((v >= r[1] and v <= r[2]) or (v >= r[3] and v <= r[4]))
      end
    end
    if ok then
      fields[#fields+1] = j
    end
  end
  rule_to_fields[i] = fields
end

local cm, visited = {}, {}

local function find_match(where)
  if where == nil then
    return true
  end
  for i=1,#rule_to_fields[where] do
    local match = rule_to_fields[where][i]
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

for i=1,#rules do
  visited = {}
  find_match(i)
end

ret = 1
for i,v in ipairs(my_ticket) do
  local ridx = cm[i]
  if dep_rules[ridx] then
    ret = ret * v
  end
end
print(ret)


