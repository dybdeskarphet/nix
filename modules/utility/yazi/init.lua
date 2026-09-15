-- matugen colors {{{
local colors = require("matugen").palette
-- }}}

-- relative-motions {{{
require("relative-motions"):setup({
	show_numbers = "relative_absolute",
	show_motion = false,
	line_numbers_styles = {
		hovered = ui.Style():bold():fg(colors.primary):reverse(true),
		normal = ui.Style():fg(colors.source_color),
	},
})
-- }}}

-- Folder-specific rules {{{
ps.sub("ind-sort", function(opt)
	local cwd = cx.active.current.cwd
	if cwd:ends_with("dl") then
		opt.by, opt.reverse, opt.dir_first = "mtime", true, false
	elseif cwd:ends_with("cam") then
		opt.by, opt.reverse, opt.dir_first = "mtime", true, false
	else
		opt.by, opt.reverse, opt.dir_first = "natural", false, true
	end
	return opt
end)
-- }}}

-- Add file owner and group to Status bar {{{
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg(colors.primary),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg(colors.primary),
		" ",
	})
end, 500, Status.RIGHT)
-- }}}

-- Symlink {{{
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return "  " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
-- }}}

-- vim: fdm=marker fdl=0
