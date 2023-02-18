--------------------------------------------------------------------------------
---	Convert EXML to an equivalent lua table and back again to exml text
---	helper functions and ENUMs...
--------------------------------------------------------------------------------

--	replace a boolean with its text (ignore otherwise)
function bool(b)
	return (type(b) == 'boolean') and ((b == true) and 'True' or 'False') or b
end

--	Generate an EXML-tagged text from a lua table representation of exml class
function ToExml(class)
	local function len2(t)
	--	get the count of ALL objects in a table (non-recursive)
		i=0; for _ in pairs(t) do i=i+1 end ; return i
	end
	local function exml_r(tlua)
		local exml = {}
		function exml:add(t)
			for _,v in ipairs(t) do self[#self+1] = v end
		end
		for key, cls in pairs(tlua) do
			if key ~= 'META' then
				exml[#exml+1] = '<Property '
				if type(cls) == 'table' and cls.META then
					local att, val = cls['META'][1], cls['META'][2]
					-- add and recurs for an inner table
					if att == 'name' or att == 'value' then
						exml:add({att, '="', val, '">'})
					else
						exml:add({'name="', att, '" value="', val, '">'})
					end
					exml:add({exml_r(cls), '</Property>'})
				else
					-- add normal property
					if type(cls) == 'table' then
						-- because you can't read an unknown key directly
						for k,v in pairs(cls) do key = k; cls = v end
					end
					if key == 'name' or key == 'value' then
						exml:add({key, '="', bool(cls), '"/>'})
					else
						exml:add({'name="', key, '" value="', bool(cls), '"/>'})
					end
				end
			end
		end
		return table.concat(exml)
	end

	-- check the table level structure and meta placement
	-- add the needed layer for the recursion and handle multiple tables
	local klen = len2(class)
	if klen == 1 and class[1].META then
		return exml_r(class)
	elseif class.META and klen > 1 then
		return exml_r( {class} )
	-- concatenate unrelated exml sections, instead of nested inside each other
	elseif type(class[1]) == 'table' and klen > 1 then
		local T = {}
		for _, tb in pairs(class) do
			T[#T+1] = exml_r((tb.META and klen > 1) and {tb} or tb)
		end
		return table.concat(T)
	end
end

--	Adds the xml header and data template
--	Uses the contained template META if found (instead of the received variable)
function FileWrapping(data, template)
	local wrapper = [[<?xml version="1.0" encoding="utf-8"?><Data template="%s">%s</Data>]]
	if type(data) == 'string' then
		return string.format(wrapper, template, data)
	end
	-- remove the extra table added by ToLua (FIX THIS!)
	if data.template then data = data.template end
	-- table loaded from file
	if data.META[1] == 'template' then
		-- strip mock template
		txt_data = ToExml(data):sub(#data.META[2] + 36, -12)
		return string.format(wrapper, data.META[2], txt_data)
	else
		return string.format(wrapper, template, ToExml(data))
	end
end

--	Remove the EXML header and data template if found
--	The template is re-added as a property
local function UnWrap(data)
	if data:sub(1, 5) == '<?xml' then
		local template = data:match('<Data template="([%w_]+)">')
		return '<Property name="template" value="'..template..'">\n'..
				data:sub(data:find('<Property'), -8)..'</Property>'
	else
		return data
	end
end

--	Returns a table representation of EXML sections
--	When parsing a full file, the header is stripped and a mock template is added
--	Rquires complete EXML sections in the nomral format ...
--	 Each property in a separate line with no blank lines or comments
function ToLua(exml)
	local function eval(val)
		if val == 'True' then
			return true
		elseif val == 'False' then
			return false
		else
			return val
		end
	end
	local tag1	= [[<Property ([%w_]+)="(.+)"[ ]?([/]?)>]]
	local tag2	= [[<Property name="([%w_]+)" value="(.*)"[ ]?([/]?)>]]
	local tlua, st_node, st_array = {}, {}, {false}
	local parent= tlua
	local node	= nil
	--	array=true when processing an ordered (name) section
	local array	= false
	for line in UnWrap(exml):gmatch('([^\n]+)') do -- parse lines
		if line:match('Property') then -- properties only
			_,eql = line:gsub('=', '')
			if eql > 0 then
				-- choose tag by the count of [=] in a line
				local att, val, close = line:match(eql > 1 and tag2 or tag1)
				if close == '' then
					array = att == 'name'
					-- open new property table
					table.insert(st_node, parent)
					node = {META = {att , val}}

					 -- look up if parent is an array
					if st_array[#st_array] or att == 'value' then
						parent[#parent+1] = node
					elseif att == 'name' then
						parent[val] = node
					else
						parent[att] = node
					end
					table.insert(st_array, att == 'name')
					parent = node
				else
					-- add property to parent table
					if att == 'value' or array then
						node[#node+1] = {[att] = eval(val)}
					-- regular property (skips stubs)
					elseif att ~= 'name' then
						node[att] = eval(val)
					end
				end
			else
				-- go back to parent node
				parent = table.remove(st_node)
				table.remove(st_array)
				node = parent
			end
		end
	end
	return tlua
end

--	Converts EXML to a pretty-printed, ready-to-work, lua table script
--	When parsing a full file, the header is stripped and a mock template is added
--	Rquires complete EXML sections in the nomral format ...
--	 Each property in a separate line with no blank lines or comments
function PrintExmlAsLua(exml, indent, com)
	local function eval(val)
		if #val == 0 then
			return 'nil'
		elseif val == 'True' or val == 'False' then
			return val:lower()
		elseif tonumber(val) and #val < 18 and not val:match('^0x') then
			return val
		else
			return '[['..val..']]'
		end
	end
	local tag1	= [[<Property ([%w_]+)="(.+)"[ ]?([/]?)>]]
	local tag2	= [[<Property name="([%w_]+)" value="(.*)"[ ]?([/]?)>]]
	indent		= indent or '\t'
	com			= com or [[']]
	local lvl	= 0
	local tlua	= {'exml_source'}
	function tlua:add(t)
		for _,v in ipairs(t) do self[#self+1] = v end
	end
	--	array=true when processing an ordered (name) section
	local array	= false
	local st_array = {false}
	for line in UnWrap(exml):gmatch('([^\n]+)') do -- parse lines
		if line:match('Property') then -- properties only
			_,eql = line:gsub('=', '')
			if eql > 0 then
				-- choose tag by the count of [=] in a line
				local att, val, close = line:match(eql > 1 and tag2 or tag1)
				if close == '' then
					-- opening a new table
					array = att == 'name'
					-- look up if parent is an array
					if st_array[#st_array] or att == 'value' then
						tlua:add({indent:rep(lvl), '{\n'})
					else
						tlua:add({indent:rep(lvl), (att == 'name' and val or att), ' = ', '{\n'})
					end
					table.insert(st_array, att == 'name')
					lvl = lvl + 1
					tlua:add({indent:rep(lvl), 'META = {', com, att, com, ',', com, val, com, '},\n'})
				else
					-- value property or properties in an array
					if att == 'value' or array then
						tlua:add({indent:rep(lvl), '{', att, ' = ', com, val, com, '},\n'})
					-- regular property (skips stubs)
					elseif att ~= 'name' then
						tlua:add({indent:rep(lvl), att, ' = ', eval(val), ',\n'})
					end
				end
			else
				-- closing the table
				lvl = lvl - 1
				tlua:add({indent:rep(lvl), '},\n'})
				table.remove(st_array)
			end
		end
	end
	-- start & end trims
	tlua[3] = #tlua[3] > 2 and '' or ' = {\n'
	tlua[#tlua] = '}'
	return table.concat(tlua)
end

function Hex2Prc(h)
	-- translates a 0xFF hex string to 0-1.0 percentage
	-- math.floor(X / 255 * 1000) / 1000 == X * 0.00392
	return tonumber(h, 16) * 0.00392
end

function ColorFromHex(hex)
	local rgb = {{'R', 1}, {'G', 1}, {'B', 1}, {'A', 1}}
	for i=1, (#hex/2) do
		rgb[i][2] = Hex2Prc(hex:sub(i*2-1, i*2))
	end
	return rgb
end

--	return a color table from 3-4 number table or hex
--	n=class name, c=hex color (overwrites the rgb)
function ColorData(t, n)
	t = t  or {}
	if t.c then
		for i=1, (#t.c/2) do
			t[i] = Hex2Prc(t.c:sub(i*2-1, i*2))
		end
	end
	return {
		-- if a name (n) is present then use 2-property tag
		META= {n or 'value', 'Colour.xml'},
		R	= t[1] or 1,
		G	= t[2] or 1,
		B	= t[3] or 1,
		A	= t[4] or 1
	}
end

--	InventoryType Enum
I_={ PRD='Product', SBT='Substance', TCH='Technology' }

--	just let me clutter up my code in peace
NMS_MOD_DEFINITION_CONTAINER = {
	AMUMSS_SUPPRESS_MSG = 'MULTIPLE_STATEMENTS,UNDEFINED_VARIABLE,UNUSED_VARIABLE'
}
