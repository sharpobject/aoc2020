require"class"

Queue = class(function(q)
    q:clear()
  end)

function Queue.push(self, value)
  local nw = self.nw + 1
  self.nw = nw
  self.write_q[nw] = value
end

function Queue.pop(self)
  if self.r == self.nr then
    self.nr = self.nw
    self.r = 0
    self.nw = 0
    self.read_q, self.write_q = self.write_q, self.read_q
  end
  if self.r == self.nr then
    error("q is empty")
  end
  self.r = self.r + 1
  local ret = self.read_q[self.r]
  self.read_q[self.r] = nil
  return ret
end

function Queue.len(self)
  return self.nr + self.nw - self.r
end

function Queue.clear(self)
  self.read_q = {}
  self.write_q = {}
  self.nw = 0
  self.nr = 0
  self.r = 0
end

function Queue:dump()
  local ret = {}
  local nret = 0
  for i=self.r+1,self.nr do
    nret = nret + 1
    ret[nret] = self.read_q[i]
  end
  for i=1,self.nw do
    nret = nret + 1
    ret[nret] = self.write_q[i]
  end
  return ret
end