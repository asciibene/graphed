-- Paint in your terminal
nc = require("nocurses")
dofile("simplefuncs.lua")
-- Misc nc funcs ============================
COLORS={"BLACK","RED","GREEN","YELLOW","BLUE","MAGENTA","CYAN","WHITE"}
MSIZE_X=32 -- Map
MSIZE_Y=24 ---- size
PL_GLYPH="@"
VER=0.10
-- -------------- START FUNC -----------
function start()
    nc.setcurshape("BAR") 
    nc.clrscr()
    -- Make X functions
    map=mkmat()
    mapcolors=mkmat()
    p=mkpointer()
    nc.clrscr()
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
    print("X:"..p.x.." | ".." Y:"..p.y.."   ")
    if mesg_string~=nil then
        nc.gotoxy(1,1)
        print(mesg_string)
        mesg_string=nil
    end
end

function drawmap_fg() -- Draw map foreground    
    nc.setfontcolor("RED")
    nc.gotoxy(p.x,p.y)
    print(p.glyph)
    nc.setfontcolor("WHITE")
end
-- end drawmap--> main func ---------VVVVVVVVV
function main()
    printul("Graphed -- 'Graphical Editor' --")
    printcol("http://asciibene.tx0.org/","YELLOW")
    printcol("version "..VER,"CYAN")
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
    elseif k=="j" and p.y<MSIZE_Y then
        movep(0,1) 
    elseif k=="k" and p.y>1 then
        movep(0,-1) 
    elseif k=="l" and p.x<MSIZE_X then
        movep(1,0)
    elseif k=="H" and p.x>3 then
        movep(-3,0)  
    elseif k=="J" and p.y<MSIZE_Y-3 then
        movep(0,3) 
    elseif k=="K" and p.y>3 then
        movep(0,-3) 
    elseif k=="L" and p.x<MSIZE_X-3 then
        movep(3,0) 
    elseif k=="q" then
        exitbool=true
    elseif k=="t" then
        mesg_string="This is a test"
    elseif k=="c" then
        changep()
    elseif k=="." then 
        map[p.x][p.y]=p.glyph
    elseif k=="x" then
        map[p.x][p.y]=" "
    elseif k=="w" then
        write()
    elseif k=="?" then
        help()
    elseif k=="o" then
        -- TODO OPTIONS -----
    elseif k=="s" then
        changesize()
        
    else         
        return 0
    end

end

function loadf(fn)
    local tbl
    fp=io.open(fn,"r")
    ftxt={}
    i=1
    for i=1,MSIZE_Y do
         ftxt[i]=io.read("l")
    end

    -- XXX This func is garbage XXX
        -- initialze table
    for ix=1,MSIZE_X do
        for iy=1,MSIZE_Y do
            tbl[ix]={}
            tbl[ix][iy]=0
        end
    end
    -- Read file
    for ix=1,MSIZE_X do
        for iy=1,MSIZE_Y do
                 
        end
    end
    return tbl
end

function help()
    nc.clrscr()
    nc.setfontcolor("BLUE")
    printul("graphed commands")
    print("c -> change current glyph")
    print(". -> place current glyph on screen")
    print("x -> delete glyph under cursor")
    -- TODO
    nc.setfontcolor("RED")
    print("Press enter...")
    nc.wait()
    nc.setfontcolor("WHITE")
end

function changesize()
    nc.clrscr()
    print("Enter y size(lines)")
    yin=io.read("l")
    print("Enter y size(lines)")
    xin=io.read("l")
    
    MSIZE_X=tonumber(xin)
    MSIZE_Y=tonumber(yin)

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
    mesg_string="Wrote to file : "..fn
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

-- -------------------------------------------
-- To write a ephemeral message that gets erased after any input (unlike 'press enter') messages then set 'mesg_string' to any value
-- ------------------------------------------
start()
