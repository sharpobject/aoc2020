require"class"

Stack = class(function(s)
    s:clear()
  end)

function Stack.push(self, value)
  local n = self.n + 1
  self.n = n
  self.stack[n] = value
end

function Stack.pop(self)
  if self.n == 0 then
    error("stack is empty")
  end
  local ret = self.stack[self.n]
  self.stack[self.n] = nil
  self.n = self.n - 1
  return ret
end

function Stack.len(self)
  return self.n
end

function Stack.clear(self)
  self.stack = {}
  self.n = 0
end
