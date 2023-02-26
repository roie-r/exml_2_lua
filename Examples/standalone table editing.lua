-----------------------------------------------------------------------------------------
dofile('C:/TEMP/LIB/table_entry.lua')
--[[-------------------------------------------------------------------------------------
  While this tool is meant as an extension for AMUMSS, it really can be used to edit
  and re-write a full EXML file by itself.
  Here's a simple example of using ToLua & ToExml (called from inside FileWrapping)
  as a stand-alone EXML editor (just the editing itself - it's not a full modding tool).
]]---------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------
src1 = 'C:/TEMP/UNPACKED/METADATA/REALITY/TABLES/NMS_REALITY_GCTECHNOLOGYTABLE.EXML'
gc_tech = ReadExml(src1)

local all_tech = gc_tech.template.Table
local tid = {}
--	map IDs to be used as table keys
for i, tch in ipairs(all_tech) do tid[tch.ID] = i end

all_tech[tid.UT_TOX].ChargeAmount = 1200
for _,sb in ipairs(all_tech[tid.SHIPGUN1].StatBonuses) do
	if sb.Stat.StatsType:find('Range') then
		sb.Bonus = sb.Bonus + 500
	end
end
table.remove(all_tech, tid.MECH_GUN)

WriteExml(gc_tech, 'C:/TEMP/gc_tech.exml')
-----------------------------------------------------------------------------------------
src2 = 'C:/TEMP/UNPACKED/METADATA/REALITY/TABLES/NMS_REALITY_GCPRODUCTTABLE.EXML'
gc_prod = ReadExml(src2)

local all_prod = gc_prod.template.Table
local pid = {}
--	map IDs to be used as table keys
for i, prd in ipairs(all_prod) do pid[prd.ID] = i end

for _,prd in ipairs(all_prod) do
	prd.StackMultiplier = prd.StackMultiplier * 10
end
all_prod[pid.MICROCHIP].Requirements[2].Amount = 2

WriteExml(gc_prod, 'C:/TEMP/gc_prod.exml')
-----------------------------------------------------------------------------------------
print('...done')
