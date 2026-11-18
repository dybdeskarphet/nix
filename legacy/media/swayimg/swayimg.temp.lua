local M = {}

M.palette = {
<* for name, value in colors *>
	{{ name }} = "{{ value.default.hex }}",
<* endfor *>
}

return M
