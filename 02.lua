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

local function is_valid(min,max,chr,pass)
  min = tonumber(min)
  max = tonumber(max)
  local n = 0
  if (pass[min] == chr) ~= (pass[max] == chr) then return 1 end
  return 0
end


local a,n = {},0
local x = io.read("*l")

local ret = 0
while x do
  x = x:gsub('%-', ' '):gsub('%:', '')
  ret = ret + is_valid(unpack(x:split(" ")))
  x = io.read("*l")
end

print(ret)