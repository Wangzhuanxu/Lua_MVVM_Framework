local list = class("list")

function list:ctor()
	self:clear()
end

function list:clear()
	self.length = 0
	self._next = self --next node
	self._prev = self --tail node
end

function list:push(value)
	local node = {value = value}
	return self:pushnode(node)
end

function list:pushnode(node)
	self._prev._next = node
	node._next = self
	node._prev = self._prev
	self._prev = node
	self.length = self.length + 1
	node.removed = false
	return node
end

function list:pop()
	local _prev = self._prev
	self:remove(_prev)
	return _prev.value
end

function list:remove(node)
	if not node or node.removed then return end
	if self.length == 0 then return end
	node.removed = true
	local _prev = node._prev
	local _next = node._next
	_next._prev = _prev
	_prev._next = _next
	self.length = self.length-1
end

function list:next(iter)
	local _next = iter._next
	if _next ~= self then
		return _next,_next.value
	end
end

function list:prev(iter)
	local _prev = iter._prev
	if _prev ~= self then
		return _prev, _prev.value
	end
end

function list:unshift(v)
	local node = {value = v, _prev = 0, _next = 0, removed = false}

	self._next._prev = node
	node._prev = self
	node._next = self._next
	self._next = node

	self.length = self.length + 1
	return node
end

function list:shift()
	local _next = self._next
	self:remove(_next)
	return _next.value
end

function list:find(v, iter)
	iter = iter or self

	repeat
		if v == iter.value then
			return iter
		else
			iter = iter._next
		end		
	until iter == self

	return nil
end

function list:erase(v)
	local iter = self:find(v)

	if iter then
		self:remove(iter)		
	end
end

function list:insert(v, iter)	
	if not iter then
		return self:push(v)
	end

	local node = {value = v, _next = 0, _prev = 0, removed = false}

	if iter._next then
		iter._next._prev = node
		node._next = iter._next
	else
		self.last = node
	end

	node._prev = iter
	iter._next = node
	self.length = self.length + 1
	return node
end

function list:head()
	return self._next.value
end

function list:tail()
	return self._prev.value
end

ilist = function (_list)
	return list.next,_list,_list
end

rilist = function(_list)
	return list.prev, _list, _list
end
return list