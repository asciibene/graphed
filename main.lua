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
    nc.setcurshape("BAR") 
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
    -- XXX draw last info line XXX 
    nc.gotoxy(0,MSIZE_Y+1)
    print(p.x.." . "..p.y.."    ")
end

function drawmap_fg() -- Draw map foreground    
    nc.gotoxy(p.x,p.y)
    print(p.glyph)
end
----------- main func -----
function main()    
    while exitbool~=true do
        if await_cmd()~=0 then
            drawmap()
            drawmap_fg()
        end         
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
    elseif k=="c" then
        changep()
    elseif k=="." then 
        paint(p.x,p.y,p.glyph)
    elseif k=="x" then
        paint(p.x,p.y," ")
    elseif k=="o" then
        -- TODO Set color
    else         
        return 0
    end

end

function paint(px,py,pg)
    map[px][py]=pg
end

function movep(dx,dy)
   p.x=p.x+dx
   p.y=p.y+dy
end

function changep()
   local c
   showmesg("Press Enter and a new char:")
   while c==nil do
       c=string.char(nc.getch())
   end
   p.glyph=c
end

function showmesg(msg)
    nc.gotoxy(1,1)
    print(msg)
    nc.wait()
end

-- ------------------------------------------
start()
