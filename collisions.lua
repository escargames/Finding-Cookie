
function bg_flag(x,y,flag)
    local bg = mget(x - game.region.x, y - game.region.y)
    return fget(bg, flag)
end

function fg_flag(x,y,flag)
    local fg = mget(x - game.region.x + 40, y - game.region.y)
    return fget(fg, flag)
end

function block_walk(x,y,w,h)
    if w or h then
        return block_walk(x-w/2,y-h/2) or block_walk(x+w/2,y-h/2)
            or block_walk(x-w/2,y+h/2) or block_walk(x+w/2,y+h/2)
    end
    return fg_flag(x,y, 0) -- foreground object
        or bg_flag(x,y, 4) -- water
end

function block_fly(x,y,w,h)
    if w or h then
        return block_fly(x-w/2,y-h/2) or block_fly(x+w/2,y-h/2)
            or block_fly(x-w/2,y+h/2) or block_fly(x+w/2,y+h/2)
    end
    return fg_flag(x,y, 0) -- foreground object
end

--
-- everything below this is deprecated
--

function wall_or_ladder(x,y)
    local m = mget(x/8,y/8)
    if fget(m,5) and world then
        local spike = world.spikes_lut[flr(x/8) + flr(y/8)/256]
        if spike and spike.solid >= g_solid_time then
            return true
        end
    end
    if ((x%8<4) and (y%8<4)) return fget(m,0)
    if ((x%8>=4) and (y%8<4)) return fget(m,1)
    if ((x%8<4) and (y%8>=4)) return fget(m,2)
    if ((x%8>=4) and (y%8>=4)) return fget(m,3)
    return true
end

function wall_or_ladder_area(x,y,w,h)
    return wall_or_ladder(x-w,y-h) or wall_or_ladder(x-1+w,y-h) or
           wall_or_ladder(x-w,y-1+h) or wall_or_ladder(x-1+w,y-1+h) or
           wall_or_ladder(x-w,y) or wall_or_ladder(x-1+w,y) or
           wall_or_ladder(x,y-1+h) or wall_or_ladder(x,y-h)
end

function trap(x,y)
    local m = mget(x/8, y/8)
    return fget(m, 5)
end

function ladder(x,y)
    local m = mget(x/8, y/8)
    return fget(m, 4) and wall_or_ladder(x,y)
end

function ladder_area_up(x,y,h)
    return ladder(x,y-h)
end

function ladder_area_down(x,y,h)
    return ladder(x,y-1+h)
end

function ladder_area(x,y,w,h)
    return ladder(x-w,y-h) or ladder(x-1+w,y-h) or
           ladder(x-w,y-1+h) or ladder(x-1+w,y-1+h)
end

function ladder_middle(e)
    local ladder_x = flr(e.x / 8) * 8
    if e.x < ladder_x + 4 then
        move_x(e, 1)
    elseif e.x > ladder_x + 4 then
        move_x(e, -1)
    end
end

