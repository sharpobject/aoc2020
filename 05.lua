require"stridx"
require"util"

local x = io.read("*l")
ret = -99
local seats = {}
while x do
  local myrow = 0
  local rowstep = 64
  for i=1,7 do
    if x[i] == "B" then
      myrow = myrow + rowstep
    end
    rowstep = rowstep / 2
  end
  local colstep = 4
  local mycol = 0
  for i=8,10 do
    if x[i] == "R" then
      mycol = mycol + colstep
    end
    colstep = colstep / 2
  end
  local id = myrow * 8 + mycol
  seats[id] = true
  ret = math.max(ret, id)
  x = io.read("*l")
end

print(ret)

for i=0,99999 do
  if seats[i-1] and seats[i+1] and not seats[i] then
    print(i)
  end
end