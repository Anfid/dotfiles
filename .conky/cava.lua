require 'cairo'

handle = io.popen("xrandr | perl -n -e '/ connected\\D*(\\d+)x\\d+\\+0\\+0/ && print $1'")
screen_width = handle:read("*a")
handle:close()

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function conky_cava()
    if conky_window==nil then return end

    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
    local cr=cairo_create(cs)

    cava_fifo=assert(io.open("/tmp/cava"))
    cava_string=cava_fifo:read()
    local cava_list = {}
    for match in cava_string:gmatch("[^;]+") do
        table.insert(cava_list, match)
    end

    for i=1,#cava_list do
        --settings
        rec_width=(screen_width-10)/50 - 5
        rec_height=-cava_list[i]-2
        top_left_x=(i-1)*(rec_width+5)+5
        top_left_y=35
        --draw it
        cairo_set_source_rgba (cr,1,1,1,0.5)
        cairo_set_line_width (cr,0)
        cairo_rectangle (cr,top_left_x,top_left_y,rec_width,rec_height)
        cairo_fill_preserve (cr)
        cairo_stroke (cr)
    end
end
