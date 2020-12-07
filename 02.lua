require"stridx"

local function is_valid(min,max,chr,pass)
  min = tonumber(min)
  max = tonumber(max)
  local n = 0
  for i=1,#pass do
    if pass[i] == chr then
      n = n + 1
    end
  end
  if min <= n and n <= max then
    return 1
  end
  return 0
end

local function is_valid2(min,max,chr,pass)
  min = tonumber(min)
  max = tonumber(max)
  local n = 0
  if (pass[min] == chr) ~= (pass[max] == chr) then return 1 end
  return 0
end


local a,n = {},0

local ret = 0
local ret2 = 0
for x in io.lines() do
  x = x:gsub('%-', ' '):gsub('%:', '')
  ret = ret + is_valid(unpack(x:split(" ")))
  ret2 = ret2 + is_valid2(unpack(x:split(" ")))
end

print(ret)
print(ret2)