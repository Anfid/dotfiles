require("cairo")

local rings_table = {
    --[[
        * name        - type of the stat to display.
                        See https://github.com/brndnmtthws/conky/wiki/Configuration-Variables for various possible
                        options
        * arg         - argument to the stat type, see link above
        * max         - maximum value of the ring
        * bg_color    - color of the base ring
        * bg_alpha    - alpha value of the base ring
        * fg_color    - color of the indicator part of the ring
        * fg_alpha    - alpha value of the indicator part of the ring
        * x           - x coordinate of the ring centre
        * y           - y coordinate of the ring centre
        * radius      - radius of the ring
        * thickness   - thickness of the ring, centred around the radius
        * start_angle - start angle of the ring, in degrees, clockwise from top. Value can be either positive or
                        negative
        * end_angle   - end angle of the ring, in degrees, clockwise from top. Value can be either positive or negative,
                        but must be larger than start_angle.
    ]]--
    {
        name='time',
        arg='%S',
        max=60,
        bg_color=0xffffff,
        bg_alpha=0.1,
        fg_color=0xffffff,
        fg_alpha=0.6,
        x=160, y=155,
        radius=65,
        thickness=4,
        start_angle=0,
        end_angle=360
    },
    {
        name='cpu',
        arg='cpu1',
        max=100,
        bg_color=0xffffff,
        bg_alpha=0.2,
        fg_color=0xffffff,
        fg_alpha=0.5,
        x=160, y=155,
        radius=75,
        thickness=5,
        start_angle=93,
        end_angle=208
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_color=0xffffff,
        bg_alpha=0.2,
        fg_color=0xffffff,
        fg_alpha=0.5,
        x=160, y=155,
        radius=81,
        thickness=5,
        start_angle=93,
        end_angle=208
    },
    {
        name='cpu',
        arg='cpu3',
        max=100,
        bg_color=0xffffff,
        bg_alpha=0.2,
        fg_color=0xffffff,
        fg_alpha=0.5,
        x=160, y=155,
        radius=87,
        thickness=5,
        start_angle=93,
        end_angle=208
    },
    {
        name='cpu',
        arg='cpu4',
        max=100,
        bg_color=0xffffff,
        bg_alpha=0.2,
        fg_color=0xffffff,
        fg_alpha=0.5,
        x=160, y=155,
        radius=93,
        thickness=5,
        start_angle=93,
        end_angle=208
    },
    {
        name='memperc',
        arg='',
        max=100,
        bg_color=0xffffff,
        bg_alpha=0.2,
        fg_color=0xffffff,
        fg_alpha=0.5,
        x=160, y=155,
        radius=84,
        thickness=22.5,
        start_angle=212,
        end_angle=329
    },
    {
        name='battery_percent',
        arg='BAT1',
        max=100,
        bg_color=0xffffff,
        bg_alpha=0.2,
        fg_color=0xffffff,
        fg_alpha=0.5,
        x=160, y=155,
        radius=84,
        thickness=22.5,
        start_angle=-27,
        end_angle=88
    },
    {
        name='cpu', -- dummy (used for arc)
        arg='',
        max=1,
        bg_color=0xd5dcde,
        bg_alpha=0.7,
        fg_color=0xd5dcde,
        fg_alpha=0,
        x=162, y=155,
        radius=118,
        thickness=2,
        start_angle=75,
        end_angle=105
    },
    {
        name='cpu', -- dummy (used for arc)
        arg='',
        max=1,
        bg_color=0xffffff,
        bg_alpha=0.7,
        fg_color=0xffffff,
        fg_alpha=0,
        x=266, y=155,
        radius=308,
        thickness=2,
        start_angle=84,
        end_angle=96
    },
    {
        name='fs_used_perc',
        arg='/',
        max=100,
        bg_color=0xffffff,
        bg_alpha=0.2,
        fg_color=0xffffff,
        fg_alpha=0.5,
        x=160, y=155,
        radius=105,
        thickness=5,
        start_angle=-120,
        end_angle=-1.5
    },
    {
        name='fs_used_perc',
        arg='/home',
        max=100,
        bg_color=0xffffff,
        bg_alpha=0.2,
        fg_color=0xffffff,
        fg_alpha=0.5,
        x=160, y=155,
        radius=105,
        thickness=5,
        start_angle=1.5,
        end_angle=120
    },
}

local clock = {
    x = 160,
    y = 155,
    r = 65,
    color = 0xffaa11,
    alpha = 0.4,
    seconds = false,
}

local function rgb_to_r_g_b(color, alpha)
    return ((color / 0x10000) % 0x100) / 255., ((color / 0x100) % 0x100) / 255., (color % 0x100) / 255., alpha
end

local function draw_ring(cr, t, pt)
    local x, y   = pt['x'], pt['y']
    local r, w   = pt['radius'], pt['thickness']
    local sa, ea = pt['start_angle'], pt['end_angle']
    local bgc, bga = pt['bg_color'], pt['bg_alpha']
    local fgc, fga = pt['fg_color'], pt['fg_alpha']

    local angle_0 = sa * (2 * math.pi / 360) - math.pi / 2
    local angle_f = ea * (2 * math.pi / 360) - math.pi / 2
    local t_arc = t * (angle_f - angle_0)

    -- Draw background ring

    cairo_arc(cr, x, y, r, angle_0, angle_f)
    cairo_set_source_rgba(cr, rgb_to_r_g_b(bgc, bga))
    cairo_set_line_width(cr, w)
    cairo_stroke(cr)

    -- Draw indicator ring

    cairo_arc(cr, x, y, r, angle_0, angle_0+t_arc)
    cairo_set_source_rgba(cr, rgb_to_r_g_b(fgc, fga))
    cairo_stroke(cr)
end

local function draw_clock_hands(cr, x, y)
    local secs  = os.date("%S")
    local mins  = os.date("%M")
    local hours = os.date("%I")

    local secs_arc  = (2 * math.pi / 60) * secs
    local mins_arc  = (2 * math.pi / 60) * mins + secs_arc / 60
    local hours_arc = (2 * math.pi / 12) * hours + mins_arc / 12

    -- Draw hour hand

    local xh = x + 0.7 * clock.r * math.sin(hours_arc)
    local yh = y - 0.7 * clock.r * math.cos(hours_arc)
    cairo_move_to(cr, x, y)
    cairo_line_to(cr, xh, yh)

    cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
    cairo_set_line_width(cr, 5)
    cairo_set_source_rgba(cr, rgb_to_r_g_b(clock.color, clock.alpha))
    cairo_stroke(cr)

    -- Draw minute hand

    local xm = x + clock.r * math.sin(mins_arc)
    local ym = y - clock.r * math.cos(mins_arc)
    cairo_move_to(cr, x, y)
    cairo_line_to(cr, xm, ym)

    cairo_set_line_width(cr, 3)
    cairo_stroke(cr)

    -- Draw seconds hand

    if clock.seconds then
        local xs = x + clock_r * math.sin(secs_arc)
        local ys = y - clock.r * math.cos(secs_arc)
        cairo_move_to(cr, x, y)
        cairo_line_to(cr, xs, ys)

        cairo_set_line_width(cr, 1)
        cairo_stroke(cr)
    end
end

local function setup_rings(cr, rings)
    for _, ring in pairs(rings) do
        local command = string.format('${%s %s}', ring['name'], ring['arg'])
        local value = tonumber(conky_parse(command))

        if value == nil then
            value = 0
        end

        local perc = value / ring['max']
        if perc > 1 then perc = 1 end

        draw_ring(cr, perc, ring)
    end
end

function conky_rings()
    local updates = tonumber(conky_parse('${updates}'))

    if conky_window == nil or updates <= 5 then
        return
    end

    local cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )
    local cr = cairo_create(cs)

    setup_rings(cr, rings_table)
    draw_clock_hands(cr, clock.x, clock.y)

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
