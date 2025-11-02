if soul_update {
    soulx = __determine_soul_x(selection[0], selection[1])
    souly = __determine_soul_y(selection[0], selection[1])
    
    soul_update = false
}

soulx_display = lerp(soulx_display, soulx, .2)
souly_display = lerp(souly_display, souly, .2)