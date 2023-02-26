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
