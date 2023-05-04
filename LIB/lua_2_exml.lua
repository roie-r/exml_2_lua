-------------------------------------------------------------------------
---	LUA 2 EXML (VERSION: 0.82) ... by lMonk
---	A tool for converting exml to an equivalent lua table and back again
---	(with added color helper functions)
-------------------------------------------------------------------------

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
	-- remove the extra table added by ToLua
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
		-- if a name (n) is present then use 2-property tags
		META= {n or 'value', 'Colour.xml'},
		R	= t[1] or 1,
		G	= t[2] or 1,
		B	= t[3] or 1,
		A	= t[4] or 1
	}
end

--	InventoryType Enum
I_={ PRD='Product', SBT='Substance', TCH='Technology' }
