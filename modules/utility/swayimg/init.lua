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

-- General Configuration
swayimg.mode = "viewer"
swayimg.antialiasing = true
swayimg.decoration = true
swayimg.overlay = false
swayimg.exif_orientation = true
swayimg.dnd_button = "MouseRight"

-- Format specific settings
swayimg.format_conf = {
	raw = {
		enable = true,
		camera_wb = true,
	},
	ttf = {
		enable = true,
		text = "The quick brown fox jumps over the lazy dog 0123456789",
		color = c_on_surface,
		background = c_bg,
	},
	video = {
		enable = true,
		size = 300,
		columns = 3,
		rows = 3,
		padding = 5,
		label = c_primary,
	},
}

--------------------------------------------------------------------------------
-- Image List Configuration (nsxiv-like directory scanning)
--------------------------------------------------------------------------------
swayimg.imagelist.order = "numeric"
swayimg.imagelist.reverse = false
swayimg.imagelist.recursive = false
swayimg.imagelist.adjacent = true -- Automatically include sibling images in directory
swayimg.imagelist.fsmon = true -- Watch for file additions/deletions

--------------------------------------------------------------------------------
-- Text Overlay Layer (Hidden by default, toggled via keybinding)
--------------------------------------------------------------------------------
swayimg.text.visible = false -- Start with clean view (no info displayed)
swayimg.text.font = "monospace"
swayimg.text.size = 18
swayimg.text.spacing = 3
swayimg.text.padding = 12
swayimg.text.color = c_on_surface
swayimg.text.background = c_surface_lowest_trans
swayimg.text.shadow = 0x00000000
swayimg.text.timeout = 0
swayimg.text.status_timeout = 3

--------------------------------------------------------------------------------
-- Image Viewer Mode
--------------------------------------------------------------------------------
swayimg.viewer.default_scale = "optimal" -- Fit to window if larger, 100% if smaller
swayimg.viewer.default_position = "center"
swayimg.viewer.drag_button = "MouseLeft"
swayimg.viewer.autocenter = true
swayimg.viewer.loop = true
swayimg.viewer.preload = 2
swayimg.viewer.history = 5
swayimg.viewer.mark_color = c_primary
swayimg.viewer.pinch_factor = 1.0

-- Detailed text info scheme (shown when toggled with 'i' or 't')
swayimg.viewer.text = {
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

swayimg.viewer.set_window_background(c_bg)
swayimg.viewer.set_image_chessboard(20, c_surface, c_surface_container)

-- Helper for panning
local pan_step = 20 -- Smaller step for slow, precise panning
local function pan(dx, dy)
	local pos = swayimg.viewer.get_position()
	swayimg.viewer.set_abs_position(pos.x + dx, pos.y + dy)
end

-- Keybindings (Viewer Mode)
-- Image Navigation
swayimg.viewer.on_key({ "n", "space", "next", "Page_Down" }, function()
	swayimg.viewer.open("next")
end)

swayimg.viewer.on_key({ "p", "BackSpace", "prior", "Page_Up" }, function()
	swayimg.viewer.open("prev")
end)

swayimg.viewer.on_key({ "g", "Home" }, function()
	swayimg.viewer.open("first")
end)

swayimg.viewer.on_key({ "Shift+g", "End" }, function()
	swayimg.viewer.open("last")
end)

swayimg.viewer.on_key({ "bracketright", "braceright" }, function()
	swayimg.viewer.open("next_dir")
end)

swayimg.viewer.on_key({ "bracketleft", "braceleft" }, function()
	swayimg.viewer.open("prev_dir")
end)

-- Animation / multi-frame navigation
swayimg.viewer.on_key({ "Shift+next", "period" }, function()
	swayimg.viewer.frame = swayimg.viewer.frame + 1
end)

swayimg.viewer.on_key({ "Shift+prior", "comma" }, function()
	local frame = swayimg.viewer.frame
	if frame > 0 then
		swayimg.viewer.frame = frame - 1
	end
end)

-- Slow Panning (h, j, k, l and Arrow keys)
swayimg.viewer.on_key({ "h", "Left" }, function()
	pan(pan_step, 0)
end)
swayimg.viewer.on_key({ "l", "Right" }, function()
	pan(-pan_step, 0)
end)
swayimg.viewer.on_key({ "k", "Up" }, function()
	pan(0, pan_step)
end)
swayimg.viewer.on_key({ "j", "Down" }, function()
	pan(0, -pan_step)
end)

-- Snapping to edges (Ctrl + h, j, k, l)
swayimg.viewer.on_key("Ctrl+h", function()
	swayimg.viewer.set_fix_position("leftcenter")
end)
swayimg.viewer.on_key("Ctrl+l", function()
	swayimg.viewer.set_fix_position("rightcenter")
end)
swayimg.viewer.on_key("Ctrl+k", function()
	swayimg.viewer.set_fix_position("topcenter")
end)
swayimg.viewer.on_key("Ctrl+j", function()
	swayimg.viewer.set_fix_position("bottomcenter")
end)

-- Zooming & Scaling
swayimg.viewer.on_key({ "plus", "equal" }, function()
	swayimg.viewer.scale = swayimg.viewer.scale * 1.15
end)

swayimg.viewer.on_key({ "minus", "underscore" }, function()
	swayimg.viewer.scale = swayimg.viewer.scale / 1.15
end)

swayimg.viewer.on_key("w", function()
	swayimg.viewer.set_fix_scale("fit")
end)

swayimg.viewer.on_key("Shift+w", function()
	swayimg.viewer.set_fix_scale("width")
end)

swayimg.viewer.on_key("e", function()
	swayimg.viewer.set_fix_scale("height")
end)

swayimg.viewer.on_key({ "1", "z" }, function()
	swayimg.viewer.set_fix_scale("real")
end)

swayimg.viewer.on_key({ "0" }, function()
	swayimg.viewer.reset()
end)

-- Rotation & Flipping
swayimg.viewer.on_key({ "less", "bracketleft", "Ctrl+r" }, function()
	swayimg.viewer.rotate(270)
end)

swayimg.viewer.on_key({ "greater", "bracketright", "r" }, function()
	swayimg.viewer.rotate(90)
end)

swayimg.viewer.on_key("Shift+r", function()
	swayimg.viewer.rotate(180)
end)

swayimg.viewer.on_key({ "bar", "Shift+backslash" }, function()
	swayimg.viewer.flip_horizontal()
end)

swayimg.viewer.on_key({ "Shift+underscore", "Shift+minus" }, function()
	swayimg.viewer.flip_vertical()
end)

-- Information Overlay Toggle (nsxiv uses 'i')
swayimg.viewer.on_key({ "i", "t" }, function()
	swayimg.text.visible = not swayimg.text.visible
end)

-- Modes & Window
swayimg.viewer.on_key({ "Return" }, function()
	swayimg.mode = "gallery"
end)

swayimg.viewer.on_key("s", function()
	swayimg.mode = "slideshow"
end)

swayimg.viewer.on_key({ "f", "F11" }, function()
	swayimg.fullscreen = not swayimg.fullscreen
end)

swayimg.viewer.on_key("a", function()
	swayimg.antialiasing = not swayimg.antialiasing
end)

swayimg.viewer.on_key({ "m", "Insert" }, function()
	swayimg.viewer.mark_image()
end)

swayimg.viewer.on_key({ "d", "Delete", "x" }, function()
	local img = swayimg.viewer.get_image()
	if img then
		swayimg.imagelist.remove(img.path)
	end
end)

swayimg.viewer.on_key({ "Ctrl+r" }, function()
	swayimg.viewer.reload()
end)

swayimg.viewer.on_key({ "q", "Escape" }, function()
	swayimg.exit()
end)

-- Mouse Bindings (Viewer)
swayimg.viewer.on_mouse("ScrollUp", function()
	pan(0, pan_step)
end)
swayimg.viewer.on_mouse("ScrollDown", function()
	pan(0, -pan_step)
end)
swayimg.viewer.on_mouse("ScrollLeft", function()
	pan(-pan_step, 0)
end)
swayimg.viewer.on_mouse("ScrollRight", function()
	pan(pan_step, 0)
end)

swayimg.viewer.on_mouse("Ctrl+ScrollUp", function()
	local mouse = swayimg.get_mouse_pos()
	local scale = swayimg.viewer.scale
	swayimg.viewer.set_abs_scale(scale * 1.15, mouse.x, mouse.y)
end)
swayimg.viewer.on_mouse("Ctrl+ScrollDown", function()
	local mouse = swayimg.get_mouse_pos()
	local scale = swayimg.viewer.scale
	swayimg.viewer.set_abs_scale(scale / 1.15, mouse.x, mouse.y)
end)

--------------------------------------------------------------------------------
-- Gallery Mode (Thumbnail Grid)
--------------------------------------------------------------------------------
swayimg.gallery.thumb_size = 200
swayimg.gallery.aspect = "fill"
swayimg.gallery.padding_size = 6
swayimg.gallery.border_size = 3
swayimg.gallery.selected_scale = 1.06
swayimg.gallery.hover = true
swayimg.gallery.cache = 120
swayimg.gallery.preload = false
swayimg.gallery.embedded_thumb = true
swayimg.gallery.pstore = false

swayimg.gallery.window_color = c_bg
swayimg.gallery.unselected_color = c_surface_container
swayimg.gallery.selected_color = c_surface_container_high
swayimg.gallery.border_color = c_primary
swayimg.gallery.mark_color = c_tertiary

swayimg.gallery.text = {
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
swayimg.gallery.on_key({ "h", "Left" }, function()
	swayimg.gallery.select("left")
end)

swayimg.gallery.on_key({ "j", "Down" }, function()
	swayimg.gallery.select("down")
end)

swayimg.gallery.on_key({ "k", "Up" }, function()
	swayimg.gallery.select("up")
end)

swayimg.gallery.on_key({ "l", "Right" }, function()
	swayimg.gallery.select("right")
end)

swayimg.gallery.on_key({ "g", "Home" }, function()
	swayimg.gallery.select("first")
end)

swayimg.gallery.on_key({ "Shift+g", "End" }, function()
	swayimg.gallery.select("last")
end)

swayimg.gallery.on_key({ "Ctrl+f", "next", "Page_Down" }, function()
	swayimg.gallery.select("pgdown")
end)

swayimg.gallery.on_key({ "Ctrl+b", "prior", "Page_Up" }, function()
	swayimg.gallery.select("pgup")
end)

-- Open selected image in viewer
swayimg.gallery.on_key({ "Return", "space" }, function()
	swayimg.mode = "viewer"
end)

-- Thumbnail resize
swayimg.gallery.on_key({ "plus", "equal" }, function()
	swayimg.gallery.thumb_size = swayimg.gallery.thumb_size + 20
end)

swayimg.gallery.on_key({ "minus", "underscore" }, function()
	if swayimg.gallery.thumb_size > 40 then
		swayimg.gallery.thumb_size = swayimg.gallery.thumb_size - 20
	end
end)

swayimg.gallery.on_key("0", function()
	swayimg.gallery.thumb_size = 200
end)

-- Controls & Modes
swayimg.gallery.on_key({ "i", "t" }, function()
	swayimg.text.visible = not swayimg.text.visible
end)

swayimg.gallery.on_key("s", function()
	swayimg.mode = "slideshow"
end)

swayimg.gallery.on_key({ "f", "F11" }, function()
	swayimg.fullscreen = not swayimg.fullscreen
end)

swayimg.gallery.on_key("a", function()
	swayimg.antialiasing = not swayimg.antialiasing
end)

swayimg.gallery.on_key({ "m", "Insert" }, function()
	swayimg.gallery.mark_image()
end)

swayimg.gallery.on_key({ "d", "Delete", "x" }, function()
	local img = swayimg.gallery.get_image()
	if img then
		swayimg.imagelist.remove(img.path)
	end
end)

swayimg.gallery.on_key({ "r", "Ctrl+r" }, function()
	swayimg.gallery.reload()
end)

swayimg.gallery.on_key({ "q", "Escape" }, function()
	swayimg.exit()
end)

-- Mouse Bindings (Gallery)
swayimg.gallery.on_mouse("ScrollUp", function()
	swayimg.gallery.select("up")
end)
swayimg.gallery.on_mouse("ScrollDown", function()
	swayimg.gallery.select("down")
end)
swayimg.gallery.on_mouse("ScrollLeft", function()
	swayimg.gallery.select("left")
end)
swayimg.gallery.on_mouse("ScrollRight", function()
	swayimg.gallery.select("right")
end)

swayimg.gallery.on_mouse("Ctrl+ScrollUp", function()
	swayimg.gallery.thumb_size = swayimg.gallery.thumb_size + 20
end)
swayimg.gallery.on_mouse("Ctrl+ScrollDown", function()
	if swayimg.gallery.thumb_size > 40 then
		swayimg.gallery.thumb_size = swayimg.gallery.thumb_size - 20
	end
end)

-- Slideshow Mode
swayimg.slideshow.timeout = 5
swayimg.slideshow.default_scale = "optimal"
swayimg.slideshow.history = 0
swayimg.slideshow.text = { topleft = { "{name}", "{list.index} / {list.total}" } }
swayimg.slideshow.set_window_background(c_bg)

swayimg.slideshow.on_key({ "s", "q", "Escape" }, function()
	swayimg.mode = "viewer"
end)

swayimg.slideshow.on_key({ "Return" }, function()
	swayimg.mode = "gallery"
end)

swayimg.slideshow.on_key({ "j", "Right", "next", "space" }, function()
	swayimg.slideshow.open("next")
end)

swayimg.slideshow.on_key({ "k", "Left", "prior", "BackSpace" }, function()
	swayimg.slideshow.open("prev")
end)

swayimg.slideshow.on_key({ "i", "t" }, function()
	swayimg.text.visible = not swayimg.text.visible
end)

swayimg.slideshow.on_key({ "f", "F11" }, function()
	swayimg.fullscreen = not swayimg.fullscreen
end)
