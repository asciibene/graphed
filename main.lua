-- Paint in your terminal
nc = require("nocurses")

-- Misc nc funcs ============================
function printul(s)
    nc.setunderline(true)
    print(s)
    nc.setunderline(false)
end



------------------------------------
-- consts and vars


MSIZE_X=50 -- Map
MSIZE_Y=24 ---- size
PL_GLYPH="@"
VER=0.034
-- MAKE Map matrix ------------- 
function mkmat()
    local mt
    mt = {}          -- create the matrix
    for i=1,MSIZE_X do
      mt[i] = {}     -- create a new row
      for j=1,MSIZE_Y do
        mt[i][j] = " "
      end
    end
   return mt
end

function at(s,p)
    return string.sub(s,p,p)
end

-- -------------- START FUNC -----------
function start()
    nc.setcurshape("BLOCK") 
    nc.clrscr()
    -- Make X functions
    map=mkmat()
    p=mkpointer()
    
    -- Now main loop
    main()
end   
-- ----------------END START FUNC -------------

-- ====== DRAW MAP FUNC=========
function drawmap()
    for ix=1,MSIZE_X do
        for iy=1,MSIZE_Y do
            nc.gotoxy(ix,iy)
            print(map[ix][iy])
        end
    end
end

function drawmap_fg() -- Draw map foreground    
    nc.gotoxy(p.x,p.y)
    print(p.glyph)
end
----------- main func -----
function main()    
    while exitbool~=true do
        if see==false then
            drawmap()
            drawmap_fg()
            see=true
        end
        await_cmd()
    end
    exit()
end


function exit() -- Exits gracefully
    nc.clrscr()
    printul("Goodbye...")
    

end

function mkpointer(pn)
    local p
    p={}
    p.x=5
    p.y=5
    p.glyph="X"
    return p
end

-- END OF MAKE FUNCS ========== MAKE =====
function await_cmd()
    local k
    k=string.char(nc.getch())
    if k=="h" then
        movep(-1,0) 
    elseif k=="j" then
        movep(0,1) 
    elseif k=="k" then
        movep(0,-1) 
    elseif k=="l" then
        movep(1,0) 
    elseif k=="q" then
        exitbool=true
    elseif k=="t" then
        showmesg("This is a test")
        
    end
end

function movep(dx,dy)
   p.x=p.x+dx
   p.y=p.y+dy
   see=false
end

function showmesg(msg)
    nc.gotoxy(1,1)
    print(msg)
    nc.wait()
    see=false
end

-- ------------------------------------------
start()
