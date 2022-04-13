-- Paint in your terminal
nc = require("nocurses")
dofile("simplefuncs.lua")
-- Misc nc funcs ============================

COLORS={"BLACK","RED","GREEN","YELLOW","BLUE","MAGENTA","CYAN","WHITE"}
MSIZE_X=32 -- Map
MSIZE_Y=24 ---- size
PL_GLYPH="@"
VER=0.08
-- MAKE Map matrix ------------- 
-- -------------- START FUNC -----------
function start()
    nc.setcurshape("BAR") 
    nc.clrscr()
    -- Make X functions
    map=mkmat()
    mapcolors=mkmat()
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
    print("X:"..p.x.." | ".." Y:"..p.y.."    ")
end

function drawmap_fg() -- Draw map foreground    
    nc.setfontcolor("RED")
    nc.gotoxy(p.x,p.y)
    print(p.glyph)
    nc.setfontcolor("WHITE")
end
----------- main func -----
function main()
    printul("Graphed")
    print("version "..VER)
    while exitbool~=true do
        if await_cmd()~=0  then
            drawmap()
            drawmap_fg()
        end         
    end
    nc.clrscr()
    printul("Goodbye...")
end



-- END OF MAKE FUNCS ========== MAKE =====
function await_cmd()
    local k
    k=string.char(nc.getch())
    if k=="h" and p.x>1 then
        movep(-1,0) 
    elseif k=="j" and p.y<=MSIZE_Y then
        movep(0,1) 
    elseif k=="k" and p.y>1 then
        movep(0,-1) 
    elseif k=="l" and p.x<MSIZE_X then
        movep(1,0) 
    elseif k=="q" then
        exitbool=true
    elseif k=="t" then
        showmesg("This is a test")
    elseif k=="g" then
        changep()
    elseif k=="." then 
        map[p.x][p.y]=p.glyph
    elseif k=="x" then
        map[p.x][p.y]=" "
    elseif k=="w" then
        write()
    elseif k=="?" then
        help()
    else         
        return 0
    end

end
-- TODO make load func TODO

function help()
    nc.clrscr()
    nc.setfontcolor("BLUE")
    printul("graphed commands")
    print("g -> change current glyph")
    print(". -> place current glyph on screen")
    print("x -> delete glyph under cursor")
    -- TODO
    nc.setfontcolor("RED")
    print("Press enter...")
    nc.wait()
    nc.setfontcolor("WHITE")
end

function write()
    nc.clrscr()
    print("Enter Filename")
    fn=io.read("l")
    fp=io.open(fn,"w+")
    for i=1,MSIZE_Y do
        for ii=1,MSIZE_X do
        cc=map[ii][i]
        fp:write(cc)
        end
        fp:write("\n")
    end
    fp:close()
    nc.clrscr()
    showmesg("wrote to file:'"..fn.."'. Press enter")
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

-- ------------------------------------------
start()
