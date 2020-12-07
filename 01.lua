local a,n = {},0

for x in io.lines() do
  n = n+1
  a[n] = tonumber(x)
end

local entries = {}
for _,x in ipairs(a) do
  local opp = 2020 - x
  if entries[opp] then
    print(x * opp)
  end
  entries[x] = true
end

for i=1,n do
  local x = a[i]
  for j=i+1,n do
    local y = a[j]
    local z = 2020 - x - y
    if entries[z] then
      print(x*y*z)
    end
  end
end