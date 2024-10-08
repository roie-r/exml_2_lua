# EXML 2 LUA
A tool for converting EXML files - the No Man's Sky game data file format, generated by [MBINCompiler](https://github.com/monkeyman192/MBINCompiler "MBINCompiler") - to a lua table and back.
The tool handles full files or specific sections. It can load the data to memory directly or write it to a text file as a ready-to-use lua script.
## Exml-as-lua table format
Every section in its own table, and each section has a META table describing its attributes. The first item in a meta table is `name`, `value`, or the named attribute.
Using these rules, the following describes a string class section:
```lua
{
    META  = {"value", "NMSString0x20.xml"},
    Value = [[my text string]]
}
```
A colour class:
```lua
{
    META = {"LinkColour", "Colour.xml"},
    R    = 1,
    G    = 1,
    B    = 1,
    A    = 1
}
```
Technology/product requirement, containing a sub-section for inventory type, class:
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
This format can describe any EXML data.
