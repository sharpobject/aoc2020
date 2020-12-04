require"stridx"
require"util"

local req_fields = {"byr","iyr","eyr","hgt","hcl","ecl","pid"}
local fields = {}
local ret = 0
local ret2 = 0
local ecl = arr_to_set{"amb","blu","brn","gry","grn","hzl","oth"}

local function extra()
  return fields.byr:match("^%d%d%d%d$") and
    tonumber(fields.byr) >= 1920 and
    tonumber(fields.byr) <= 2002 and
    fields.iyr:match("^%d%d%d%d$") and
    tonumber(fields.iyr) >= 2010 and
    tonumber(fields.iyr) <= 2020 and
    fields.eyr:match("^%d%d%d%d$") and
    tonumber(fields.eyr) >= 2020 and
    tonumber(fields.eyr) <= 2030 and
    ((fields.hgt:match("^%d%d%dcm$") and
      tonumber(fields.hgt:sub(1,3)) >= 150 and
      tonumber(fields.hgt:sub(1,3)) <= 193) or
    (fields.hgt:match("^%d%din$") and
      tonumber(fields.hgt:sub(1,2)) >= 59 and
      tonumber(fields.hgt:sub(1,2)) <= 76)
    ) and
    fields.hcl:match("^#[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]$") and
    ecl[fields.ecl] and
    fields.pid:match("^%d%d%d%d%d%d%d%d%d$")
end

local function handle()
  local ok = true
  for i=1,#req_fields do
    ok = ok and fields[req_fields[i]]
  end
  if ok then
    ret = ret + 1
    if extra() then
      ret2 = ret2 + 1
    end
  end
  fields = {}
end

local x = io.read("*l")
while x do
  if x == "" then
    handle()
  end
  for _,thing in ipairs(x:split(" ")) do
    local xs = thing:split(":")
    if xs[3] then xs[2] = xs[2]..":"..xs[3] end
    fields[xs[1]] = xs[2]
  end
  x = io.read("*l")
end
handle()

print(ret)
print(ret2)