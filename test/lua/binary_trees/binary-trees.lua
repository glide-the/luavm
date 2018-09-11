-- The Computer Language Benchmarks Game
-- https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
-- contributed by Mike Pall
-- *reset*
local function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
local function BottomUpTree(depth)
    if depth > 0 then
        depth = depth - 1
        local left, right = BottomUpTree(depth), BottomUpTree(depth)
        return { left, right }
    else
        return { }
    end
end

local function ItemCheck(tree)
    if tree[1] then
        return 1 + ItemCheck(tree[1]) + ItemCheck(tree[2])
    else
        return 1
    end
end

local N = tonumber(arg and arg[1]) or 0
print(string.format("N--%d",N))
local mindepth = 4
local maxdepth = mindepth + 2
if maxdepth < N then maxdepth = N end
print(string.format("maxdepth--%d",maxdepth))
do
    local stretchdepth = maxdepth + 1
    local stretchtree = BottomUpTree(stretchdepth)
    print_r(stretchtree)
    io.write(string.format("tree伸展的长度 %d\t check: %d\n",
            stretchdepth, ItemCheck(stretchtree)))
end

local longlivedtree = BottomUpTree(maxdepth)
--print_r(longlivedtree)
for depth=mindepth,maxdepth,2 do
    local iterations = 2 ^ (maxdepth - depth + mindepth)
    local check = 0
    for i=1,iterations do
        check = check + ItemCheck(BottomUpTree(depth))
    end
    print(string.format("%d\t tree的深度 %d\t check: %d\n",
            iterations, depth, check))
end

print(string.format("tree的长度%d\t check: %d\n",
        maxdepth, ItemCheck(longlivedtree)))