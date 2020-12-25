local xs = {io.read("*l")+0, io.read("*l")+0}
local x = xs[2]
local value = 7
local n = 0
while value ~= x do
  value = (value * 7) % 20201227
  n = n + 1
end

local ret = xs[1]
local subj = xs[1]
for i=1,n do
  ret = (ret * subj) % 20201227
end
print(ret)