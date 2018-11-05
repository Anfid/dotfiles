require("cairo")

local handle = io.popen("xrandr | perl -n -e '/ connected\\D*(\\d+)x\\d+\\+0\\+0/ && print $1'")
local screen_width = handle:read("*a")
handle:close()

function conky_cava()
    if conky_window==nil then return end

    local cava_fifo = assert(io.open("/tmp/cava"))
    local cava_string = cava_fifo:read()
    local cava_list = {}

    for match in cava_string:gmatch("[^;]+") do
        table.insert(cava_list, match)
    end

    local cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )
    local cr = cairo_create(cs)

    for i = 1, #cava_list do
        --settings
        local rect  = {}
        rect.width  = (screen_width - 10) / 50 - 5
        rect.height = -cava_list[i] - 2
        rect.x      = (i - 1) * (rect.width + 5) + 5
        rect.y      = 35

        --draw it
        cairo_set_source_rgba(cr, 1, 1, 1, 0.5)
        cairo_set_line_width(cr, 0)
        cairo_rectangle(cr, rect.x, rect.y, rect.width, rect.height)
        cairo_fill_preserve(cr)
        cairo_stroke(cr)
    end

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
