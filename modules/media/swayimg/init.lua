local s = swayimg
local viewer = s.viewer
local gallery = s.gallery
local slideshow = s.slideshow
local imagelist = s.imagelist
local text = s.text

--------------------------------------------------------------------------------
-- Color & Palette Setup
--------------------------------------------------------------------------------
local function hex_to_argb(hex, alpha)
	if not hex then
		return 0xffffffff
	end
	hex = tostring(hex):gsub("#", ""):gsub("%s+", "")
	if #hex == 6 then
		local a = alpha or 0xff
		return tonumber(string.format("%02x%s", a, hex), 16)
	elseif #hex == 8 then
		return tonumber(hex, 16)
	end
	return 0xffffffff
end

local config_dir = os.getenv("HOME") .. "/.config/swayimg"
local has_colors, colors_mod = pcall(dofile, config_dir .. "/colors.lua")
local palette = (has_colors and colors_mod and colors_mod.palette)
	or {
		background = "#18120b",
		surface = "#18120b",
		surface_container = "#251f17",
		surface_container_high = "#2f2921",
		surface_container_lowest = "#120d07",
		surface_dim = "#18120b",
		primary = "#f3bd6e",
		secondary = "#ddc2a1",
		tertiary = "#b7cea2",
		on_surface = "#ede0d4",
		on_surface_variant = "#d3c4b4",
		outline = "#9b8f80",
	}

local c_bg = hex_to_argb(palette.background or "#000000", 0xff)
local c_surface = hex_to_argb(palette.surface or "#18120b", 0xff)
local c_surface_container = hex_to_argb(palette.surface_container or "#251f17", 0xff)
local c_surface_container_high = hex_to_argb(palette.surface_container_high or "#2f2921", 0xff)
local c_surface_lowest_trans = hex_to_argb(palette.surface_container_lowest or palette.background or "#000000", 0xd0)
local c_primary = hex_to_argb(palette.primary or "#f3bd6e", 0xff)
local c_secondary = hex_to_argb(palette.secondary or "#ddc2a1", 0xff)
local c_tertiary = hex_to_argb(palette.tertiary or "#b7cea2", 0xff)
local c_on_surface = hex_to_argb(palette.on_surface or "#ede0d4", 0xff)
local c_outline = hex_to_argb(palette.outline or "#9b8f80", 0xff)

--------------------------------------------------------------------------------
-- General Configuration
--------------------------------------------------------------------------------
s.mode = "viewer"
s.antialiasing = true
s.decoration = true
s.overlay = false
s.exif_orientation = true
s.dnd_button = "MouseRight"

-- Format specific settings
s.format_conf = {
	raw = {
		enable = true,
		camera_wb = true,
	},
}

--------------------------------------------------------------------------------
-- Image List Configuration (nsxiv-like directory scanning)
--------------------------------------------------------------------------------
imagelist.order = "numeric"
imagelist.reverse = false
imagelist.recursive = false
imagelist.adjacent = true -- Automatically include sibling images in directory
imagelist.fsmon = true -- Watch for file additions/deletions

--------------------------------------------------------------------------------
-- Text Overlay Layer (Hidden by default, toggled via keybinding)
--------------------------------------------------------------------------------
text.visible = false -- Start with clean view (no info displayed)
text.font = "monospace"
text.size = 18
text.spacing = 3
text.padding = 12
text.color = c_on_surface
text.background = c_surface_lowest_trans
text.shadow = 0x00000000
text.timeout = 0
text.status_timeout = 3

--------------------------------------------------------------------------------
-- Image Viewer Mode
--------------------------------------------------------------------------------
viewer.default_scale = "optimal" -- Fit to window if larger, 100% if smaller
viewer.default_position = "center"
viewer.drag_button = "MouseLeft"
viewer.autocenter = true
viewer.loop = true
viewer.preload = 2
viewer.history = 5
viewer.mark_color = c_primary
viewer.pinch_factor = 1.0

-- Detailed text info scheme (shown when toggled with 'i' or 't')
viewer.text = {
	topleft = {
		"File:\t{name}",
		"Format:\t{format}",
		"Size:\t{sizehr}",
		"Modified:\t{time}",
		"Path:\t{path}",
		"EXIF Date:\t{meta.Exif.Photo.DateTimeOriginal}",
		"Camera:\t{meta.Exif.Image.Model}",
	},
	topright = {
		"Image:\t{list.index} / {list.total}",
		"Frame:\t{frame.index} / {frame.total}",
		"Dimensions:\t{frame.width}x{frame.height}",
	},
	bottomleft = {
		"Scale:\t{scale}",
	},
}

viewer.set_window_background(c_bg)
viewer.set_image_chessboard(20, c_surface, c_surface_container)

-- Helper for panning
local pan_step = 20 -- Smaller step for slow, precise panning
local function pan(dx, dy)
	local pos = viewer.get_position()
	viewer.set_abs_position(pos.x + dx, pos.y + dy)
end

-- Keybindings (Viewer Mode)
-- Image Navigation
viewer.on_key({ "n", "space", "next", "Page_Down" }, function()
	viewer.open("next")
end)

viewer.on_key({ "p", "BackSpace", "prior", "Page_Up" }, function()
	viewer.open("prev")
end)

viewer.on_key({ "g", "Home" }, function()
	viewer.open("first")
end)

viewer.on_key({ "Shift+g", "End" }, function()
	viewer.open("last")
end)

viewer.on_key({ "bracketright", "braceright" }, function()
	viewer.open("next_dir")
end)

viewer.on_key({ "bracketleft", "braceleft" }, function()
	viewer.open("prev_dir")
end)

-- Animation / multi-frame navigation
viewer.on_key({ "Shift+next", "period" }, function()
	viewer.frame = viewer.frame + 1
end)

viewer.on_key({ "Shift+prior", "comma" }, function()
	local frame = viewer.frame
	if frame > 0 then
		viewer.frame = frame - 1
	end
end)

-- Slow Panning (h, j, k, l and Arrow keys)
viewer.on_key({ "h", "Left" }, function()
	pan(pan_step, 0)
end)
viewer.on_key({ "l", "Right" }, function()
	pan(-pan_step, 0)
end)
viewer.on_key({ "k", "Up" }, function()
	pan(0, pan_step)
end)
viewer.on_key({ "j", "Down" }, function()
	pan(0, -pan_step)
end)

-- Snapping to edges (Ctrl + h, j, k, l)
viewer.on_key("Ctrl+h", function()
	viewer.set_fix_position("leftcenter")
end)
viewer.on_key("Ctrl+l", function()
	viewer.set_fix_position("rightcenter")
end)
viewer.on_key("Ctrl+k", function()
	viewer.set_fix_position("topcenter")
end)
viewer.on_key("Ctrl+j", function()
	viewer.set_fix_position("bottomcenter")
end)

-- Zooming & Scaling
viewer.on_key({ "plus", "equal" }, function()
	viewer.scale = viewer.scale * 1.15
end)

viewer.on_key({ "minus", "underscore" }, function()
	viewer.scale = viewer.scale / 1.15
end)

viewer.on_key("w", function()
	viewer.set_fix_scale("fit")
end)

viewer.on_key("Shift+w", function()
	viewer.set_fix_scale("width")
end)

viewer.on_key("e", function()
	viewer.set_fix_scale("height")
end)

viewer.on_key({ "1", "z" }, function()
	viewer.set_fix_scale("real")
end)

viewer.on_key({ "0" }, function()
	viewer.reset()
end)

-- Rotation & Flipping
viewer.on_key({ "less", "bracketleft", "Ctrl+r" }, function()
	viewer.rotate(270)
end)

viewer.on_key({ "greater", "bracketright", "r" }, function()
	viewer.rotate(90)
end)

viewer.on_key("Shift+r", function()
	viewer.rotate(180)
end)

viewer.on_key({ "bar", "Shift+backslash" }, function()
	viewer.flip_horizontal()
end)

viewer.on_key({ "Shift+underscore", "Shift+minus" }, function()
	viewer.flip_vertical()
end)

-- Information Overlay Toggle (nsxiv uses 'i')
viewer.on_key({ "i", "t" }, function()
	text.visible = not text.visible
end)

-- Modes & Window
viewer.on_key({ "Return" }, function()
	s.mode = "gallery"
end)

viewer.on_key("s", function()
	s.mode = "slideshow"
end)

viewer.on_key({ "f", "F11" }, function()
	s.fullscreen = not s.fullscreen
end)

viewer.on_key("a", function()
	s.antialiasing = not s.antialiasing
end)

viewer.on_key({ "m", "Insert" }, function()
	viewer.mark_image()
end)

viewer.on_key({ "d", "Delete", "x" }, function()
	local img = viewer.get_image()
	if img then
		imagelist.remove(img.path)
	end
end)

viewer.on_key({ "Ctrl+r" }, function()
	viewer.reload()
end)

viewer.on_key({ "q", "Escape" }, function()
	s.exit()
end)

-- Mouse Bindings (Viewer)
viewer.on_mouse("ScrollUp", function()
	pan(0, pan_step)
end)
viewer.on_mouse("ScrollDown", function()
	pan(0, -pan_step)
end)
viewer.on_mouse("ScrollLeft", function()
	pan(-pan_step, 0)
end)
viewer.on_mouse("ScrollRight", function()
	pan(pan_step, 0)
end)

viewer.on_mouse("Ctrl+ScrollUp", function()
	local mouse = s.get_mouse_pos()
	local scale = viewer.scale
	viewer.set_abs_scale(scale * 1.15, mouse.x, mouse.y)
end)
viewer.on_mouse("Ctrl+ScrollDown", function()
	local mouse = s.get_mouse_pos()
	local scale = viewer.scale
	viewer.set_abs_scale(scale / 1.15, mouse.x, mouse.y)
end)

--------------------------------------------------------------------------------
-- Gallery Mode (Thumbnail Grid)
--------------------------------------------------------------------------------
gallery.thumb_size = 200
gallery.aspect = "fill"
gallery.padding_size = 6
gallery.border_size = 3
gallery.selected_scale = 1.06
gallery.hover = true
gallery.cache = 120
gallery.preload = false
gallery.embedded_thumb = true
gallery.pstore = false

gallery.window_color = c_bg
gallery.unselected_color = c_surface_container
gallery.selected_color = c_surface_container_high
gallery.border_color = c_primary
gallery.mark_color = c_tertiary

gallery.text = {
	topleft = {
		"File:\t{name}",
		"Size:\t{sizehr}",
	},
	topright = {
		"{list.index} / {list.total}",
	},
}

-- Keybindings (Gallery Mode)
-- Vim Navigation
gallery.on_key({ "h", "Left" }, function()
	gallery.select("left")
end)

gallery.on_key({ "j", "Down" }, function()
	gallery.select("down")
end)

gallery.on_key({ "k", "Up" }, function()
	gallery.select("up")
end)

gallery.on_key({ "l", "Right" }, function()
	gallery.select("right")
end)

gallery.on_key({ "g", "Home" }, function()
	gallery.select("first")
end)

gallery.on_key({ "Shift+g", "End" }, function()
	gallery.select("last")
end)

gallery.on_key({ "Ctrl+f", "next", "Page_Down" }, function()
	gallery.select("pgdown")
end)

gallery.on_key({ "Ctrl+b", "prior", "Page_Up" }, function()
	gallery.select("pgup")
end)

-- Open selected image in viewer
gallery.on_key({ "Return", "space" }, function()
	s.mode = "viewer"
end)

-- Thumbnail resize
gallery.on_key({ "plus", "equal" }, function()
	gallery.thumb_size = gallery.thumb_size + 20
end)

gallery.on_key({ "minus", "underscore" }, function()
	if gallery.thumb_size > 40 then
		gallery.thumb_size = gallery.thumb_size - 20
	end
end)

gallery.on_key("0", function()
	gallery.thumb_size = 200
end)

-- Controls & Modes
gallery.on_key({ "i", "t" }, function()
	text.visible = not text.visible
end)

gallery.on_key("s", function()
	s.mode = "slideshow"
end)

gallery.on_key({ "f", "F11" }, function()
	s.fullscreen = not s.fullscreen
end)

gallery.on_key("a", function()
	s.antialiasing = not s.antialiasing
end)

gallery.on_key({ "m", "Insert" }, function()
	gallery.mark_image()
end)

gallery.on_key({ "d", "Delete", "x" }, function()
	local img = gallery.get_image()
	if img then
		imagelist.remove(img.path)
	end
end)

gallery.on_key({ "r", "Ctrl+r" }, function()
	gallery.reload()
end)

gallery.on_key({ "q", "Escape" }, function()
	s.exit()
end)

-- Mouse Bindings (Gallery)
gallery.on_mouse("ScrollUp", function()
	gallery.select("up")
end)
gallery.on_mouse("ScrollDown", function()
	gallery.select("down")
end)
gallery.on_mouse("ScrollLeft", function()
	gallery.select("left")
end)
gallery.on_mouse("ScrollRight", function()
	gallery.select("right")
end)

gallery.on_mouse("Ctrl+ScrollUp", function()
	gallery.thumb_size = gallery.thumb_size + 20
end)
gallery.on_mouse("Ctrl+ScrollDown", function()
	if gallery.thumb_size > 40 then
		gallery.thumb_size = gallery.thumb_size - 20
	end
end)

--------------------------------------------------------------------------------
-- Slideshow Mode
--------------------------------------------------------------------------------
slideshow.timeout = 5
slideshow.default_scale = "optimal"
slideshow.history = 0
slideshow.text = {
	topleft = {
		"{name}",
		"{list.index} / {list.total}",
	},
}
slideshow.set_window_background(c_bg)

slideshow.on_key({ "s", "q", "Escape" }, function()
	s.mode = "viewer"
end)

slideshow.on_key({ "Return" }, function()
	s.mode = "gallery"
end)

slideshow.on_key({ "j", "Right", "next", "space" }, function()
	slideshow.open("next")
end)

slideshow.on_key({ "k", "Left", "prior", "BackSpace" }, function()
	slideshow.open("prev")
end)

slideshow.on_key({ "i", "t" }, function()
	text.visible = not text.visible
end)

slideshow.on_key({ "f", "F11" }, function()
	s.fullscreen = not s.fullscreen
end)
