-- simple switch case for lua
type func = (...any)-> any?

return function(v: any, cases: {[any]: func, none: func?}, ...)
	local option = cases[v] or cases.none
	if option then
		return option(...)
	end
end