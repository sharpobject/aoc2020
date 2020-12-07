require"stridx"
require"util"

local ans = {}
local ret = 0
local ret2 = 0
local gs = 0

local function process()
  for k,v in pairs(ans) do
    if v == gs then
      ret2 = ret2+1
    end
  end
  ans = {}
  gs = 0
end

for x in io.lines() do
  if x == "" then
    process()
  else
    gs = gs + 1
  end
  for i=1,#x do
    local c = x[i]
    ans[c] = (ans[c] or 0) + 1
    if ans[c] == 1 then
      ret = ret + 1
    end
  end
end
process()

print(ret)
print(ret2)