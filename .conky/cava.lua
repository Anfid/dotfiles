require("cairo")

local handle = io.popen("xrandr | perl -n -e '/ connected\\D*(\\d+)x\\d+\\+0\\+0/ && print $1'")
local screen_width = handle:read("*a")
handle:close()

local cava_max = 1000
local zero_size = 2

function conky_cava()
    if conky_window==nil then return end

    local size = conky_window.height

    local cava_list = {}
    local cava_fifo = io.open("/tmp/cava")
    if cava_fifo then
        local cava_string = cava_fifo:read()

        io.close(cava_fifo)

        if cava_string then
            for match in cava_string:gmatch("[^;]+") do
                table.insert(cava_list, match * (size - zero_size) / cava_max)
            end
        end
    end

    local cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )
    local cr = cairo_create(cs)

    for i, val in ipairs(cava_list) do
        --settings
        local rect  = {}
        rect.w = (screen_width - 10) / 50 - 5
        rect.h = -val - zero_size
        rect.x = (i - 1) * (rect.w + 5) + 5
        rect.y = size

        --draw it
        cairo_set_source_rgba(cr, 1, 1, 1, 0.5)
        cairo_set_line_width(cr, 0)
        cairo_rectangle(cr, rect.x, rect.y, rect.w, rect.h)
        cairo_fill_preserve(cr)
        cairo_stroke(cr)
    end

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
