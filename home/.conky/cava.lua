require("cairo")

local handle = io.popen("xrandr | perl -n -e '/ connected\\D*(\\d+)x\\d+\\+0\\+0/ && print $1'")
local screen_width = handle:read("*a")
handle:close()

local cava_max = 1000
local zero_size = 2

_G.cava_global_val = {}
local cava_val = {}

-- set posix non-blocking parser, else use default io parser
local parser = {}
do
local success, result = pcall(require, "posix")
if success then
    parser.posix = result
    function parser:read()
        local cava_fifo = assert(
            self.posix.open("/tmp/cava", self.posix.O_RDONLY + self.posix.O_NONBLOCK),
            "Could not open /tmp/cava")

        -- Buffer has to be big enough to read all accumulated output asap. This will prevent slow updating cava
        -- from displaying outdated values
        local bufsize = 4096
        local cava_string = self.posix.read(cava_fifo, bufsize)
        self.posix.close(cava_fifo)

        local cava_val = {}
        for match in cava_string:match("[^\n]+"):gmatch("[^;]+") do
            table.insert(cava_val, match)
        end

        -- Assert prevents blinking. Sometimes because of simultaneous access to fifo incomplete string may be received.
        -- This way it may freeze a little sometimes, but it won't blink
        assert(#cava_val == 50, "Expected length of the table is 50. Actual result: " .. tostring(#cava_val))

        return cava_val
    end
else
    print(result)
    function parser:read()
        local cava_fifo = assert(io.open("/tmp/cava"), "Could not open /tmp/cava")
        local cava_string = cava_fifo:read()
        io.close(cava_fifo)

        local cava_val = {}
        for match in cava_string:gmatch("[^;]+") do
            table.insert(cava_val, match)
        end

        -- Assert prevents blinking. Sometimes because of simultaneous access to fifo incomplete string may be received.
        -- This way it may freeze a little sometimes, but it won't blink
        assert(#cava_val == 50, "Expected length of the table is 50. Actual result: " .. tostring(#cava_val))

        return cava_val
    end
end
end

-- capture cairo variables to prevent regular global namespace indexing
local cairo = {
    xlib_surface_create = _G.cairo_xlib_surface_create,
    create              = _G.cairo_create,
    set_source_rgba     = _G.cairo_set_source_rgba,
    set_line_width      = _G.cairo_set_line_width,
    rectangle           = _G.cairo_rectangle,
    fill_preserve       = _G.cairo_fill_preserve,
    stroke              = _G.cairo_stroke,
    destroy             = _G.cairo_destroy,
    surface_destroy     = _G.cairo_surface_destroy,
}

local function round(x) return x + 0.5 - (x + 0.5) % 1 end

local function update_global_val()
    local success, result = pcall(parser.read, parser)

    if success then
        _G.cava_global_val = result
    else
        print(result)
    end
end

function _G.conky_cava()
    local conky_window = _G.conky_window
    if conky_window==nil then return end

    local size = conky_window.height

    update_global_val()

    local cava_global_val = _G.cava_global_val

    -- Adjust values to fit into the desired size
    local cava_val_fit = {}
    local cava_changed = false
    for i = 1, #cava_global_val do
        cava_val_fit[i] = round(cava_global_val[i] * (size - zero_size) / cava_max)
        if cava_val[i] ~= cava_val_fit[i] then
            cava_changed = true
        end
    end

    -- It is a good idea to prevent redraw, if no value is changed, however conky clears previously drawn surface on the
    -- next iteration
    --if not cava_changed then return end

    cava_val = cava_val_fit

    local cs = cairo.xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )
    local cr = cairo.create(cs)

    for i, val in ipairs(cava_val) do
        --settings
        local rect  = {}
        rect.w = (screen_width - 10) / 50 - 5
        rect.h = -val - zero_size
        rect.x = (i - 1) * (rect.w + 5) + 5
        rect.y = size

        --draw it
        cairo.set_source_rgba(cr, 1, 1, 1, 0.5)
        cairo.set_line_width(cr, 0)
        cairo.rectangle(cr, rect.x, rect.y, rect.w, rect.h)
        cairo.fill_preserve(cr)
        cairo.stroke(cr)
    end

    cairo.destroy(cr)
    cairo.surface_destroy(cs)
end
