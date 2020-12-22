require"class"

Queue = class(function(q)
    q:clear()
  end)

function Queue.push(self, value)
  local nw = self.nw + 1
  self.nw = nw
  self.write_stack[nw] = value
end

function Queue.pop(self)
  if self.nr == 0 then
    while self.nw > 0 do
      self.nr = self.nr + 1
      self.read_stack[self.nr] = self.write_stack[self.nw]
      self.nw = self.nw - 1
    end
  end
  if self.nr == 0 then
    error("q is empty")
  end
  local ret = self.read_stack[self.nr]
  self.read_stack[self.nr] = nil
  self.nr = self.nr - 1
  return ret
end

function Queue.len(self)
  return self.nr + self.nw
end

function Queue.clear(self)
  self.write_stack = {}
  self.read_stack = {}
  self.nw = 0
  self.nr = 0
end

function Queue:dump()
  local ret = {}
  local nret = 0
  for i=self.nr,1,-1 do
    nret = nret + 1
    ret[nret] = self.read_stack[i]
  end
  for i=1,self.nw do
    nret = nret + 1
    ret[nret] = self.write_stack[i]
  end
  return ret
end