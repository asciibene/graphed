-- Simple functions for graphed

function printul(s)
    nc.setunderline(true)
    print(s)
    nc.setunderline(false)
end

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

function showmesg(msg)
    nc.gotoxy(1,1)
    print(msg)
    nc.wait()
end

function at(s,p)
    return string.sub(s,p,p)
end

function mkpointer(pn)
    local p
    p={}
    p.x=5
    p.y=5
    p.glyph="X"
    return p
end

function dispmesg(m)
    for i=1,150 do
        nc.gotoxy(1,1)
        print(m)
    end
end
