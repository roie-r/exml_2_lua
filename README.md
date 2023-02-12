# EXML 2 LUA
A system for converting EXML - a No Mans Sky data set - to a lua table and back.
The tool handles full files or specific sections. It can load the data to memory directly or write the data as a ready-to-use script to a text file.
## Exml-as-lua table format
Every section in its own table, and the section has a META table describing its attributes. The first item in a meta table is `name`, `value`, or the named attribute. A string looks like this:
```lua
{
    META  = {"value", "NMSString0x20.xml"},
    Value = [[my text string]]
}
```
A named colour class looks like this:
```lua
{
    META = {"LinkColour", "Colour.xml"},
    R    = 1,
    G    = 1,
    B    = 1,
    A    = 1
}
```
Technology/product requirement, which contains a table for inventory type, looks like this:
```lua
{
    META   = {"value", "GcTechnologyRequirement.xml"},
    ID     = "MICROCHIP",
    Amount = 2,
    Type   = {
        META = {"Type", "GcInventoryType.xml"},
        InventoryType = "Product"
    }
}
```
Using this format allows to describe any EXML data.
## Editing full EXML files
While this tool is meant as an extension for AMUMSS, it can be used to edit an re-write a full EXML file:
```lua
function ReadExml(path)
    local f = io.open(path, 'r')
    local t = ToLua(f:read('*a'))
    f:close()
    return t
end

function WriteExml(t, path)
    local f = io.open(path, 'w')
    f:write(FileWrapping(t))
    f:close()
end

src1 = './METADATA/REALITY/TABLES/NMS_REALITY_GCTECHNOLOGYTABLE.EXML'

gc_tech = ReadExml(src1)

local all_tech = gc_tech.template.Table
local tid = {}
--    map IDs to be used as table keys
for i, tch in ipairs(all_tech) do tid[tch.ID] = i end

all_tech[tid.UT_TOX].ChargeAmount = 1200
for _,sb in ipairs(all_tech[tid.SHIPGUN1].StatBonuses) do
    if sb.Stat.StatsType:find('Range') then
        sb.Bonus = sb.Bonus + 500
    end
end
table.remove(all_tech, tid.MECH_GUN)

WriteExml(gc_tech, src1)
```
