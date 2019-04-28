function mode.menu.start()
    main = true
    cursor_x = 36
    cursor_y = {50, 65, 80}
    levels = {"blablabla", "hihihi", "prout"}
    pos = 1
end

function mode.menu.update()
    local max = main and #cursor_y or #levels
    pos += ((btnp(2) and (pos > 1) and -1) or (btnp(3) and (pos < max) and 1 or 0))
    cursor_x = main and 36 or 61

    if pos == 1 and (btnp(4) or btnp(1)) and main then
        main = false
    elseif main == false and btnp(4) then
        state = "test"
    elseif main == false and (btnp(5) or btnp(0)) then
        pos = 1
        main = true
    end
end

function mode.menu.draw()
    cls(3)
    draw_menu_ui()
    csprint("ld44", 15, 9, 11)
    cosprint("play", 5, cursor_y[1], 6, (pos == 1 and main and 9 or 11))
    cosprint("help", 5, cursor_y[2], 6, (pos == 2 and main and 9 or 11))
    cosprint("scores", 5, cursor_y[3], 6, (pos == 3 and main and 9 or 11))
    draw_menu_play()
    draw_menu_help()
    draw_menu_debug()
end

function draw_menu_ui()
    palt(0, false)
    palt(15, true)
    map(0, 48, 0, 0, 16, 16)
    palt()
    spr(42, cursor_x, cursor_y[pos] - 2)
end

function draw_menu_play()
    if main and pos == 1 or (not main) then
        cosprint("levels", 70, 35, 6, 9)
        for i = 1, #levels do
            cosprint(levels[i], 75, 35 + 15*i, 6, pos == i and not main and 9 or 11)
        end
    end
end

function draw_menu_help()
    if main and pos==2 then
        cosprint("controls", 70, 35, 6, 9)
        cosprint("truc to truc", 70, cursor_y[1], 6, 11)
    end
end

function draw_menu_debug()

end
