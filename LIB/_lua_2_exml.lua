-------------------------------------------------------------------------------
---	LUA 2 EXML (VERSION: 0.86.01) ... by lMonk
---	A tool for converting exml to an equivalent lua table and back again.
---	Helper functions for color class, vector class and string arrays
---	* This script should be in [AMUMSS folder]\ModScript\ModHelperScripts\LIB
-------------------------------------------------------------------------------

--	Generate an EXML-tagged text from a lua table representation of exml class
--	@param class: a lua2exml formatted table
function ToExml(class)
	--	replace a boolean with its text equivalent (ignore otherwise)
	--	@param b: any value
	local function bool(b)
		return (type(b) == 'boolean') and ((b == true) and 'true' or 'false') or b
	end
	local function exml_r(tlua)
		local exml = {}
		function exml:add(t)
			for _,v in ipairs(t) do self[#self+1] = v end
		end
		for key, cls in pairs(tlua) do
			if key ~= 'meta' then
				exml[#exml+1] = '<Property '
				if type(cls) == 'table' and cls.meta then
					-- add and recurs for an inner table
					if cls.meta.att == 'name' or cls.meta.att == 'value' then
						exml:add({cls.meta.att, '="', cls.meta.val})
					else
						exml:add({'name="', cls.meta.att, '" value="', cls.meta.val})
						if cls.meta.inx then
							exml:add({'" index="', cls.meta.inx})
						end
						if cls.meta.lnk then
							exml:add({'" linked="', cls.meta.lnk})
						end
					end
					exml:add({'">', exml_r(cls), '</Property>'})
				else
					-- add a regular property
					if type(cls) == 'table' then
						key, cls = next(cls)
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
	-------------------------------------------------------------------------
	-- check the table level structure and meta placement
	-- add parent table for the recursion and handle multiple tables
	if type(class) ~= 'table' then return nil end
	local klen=0; for _ in pairs(class) do klen=klen+1 end

	if klen == 1 and class[1].meta then
		return exml_r(class)
	elseif class.meta and klen > 1 then
		return exml_r( {class} )
	-- concatenate unrelated (instead of nested) exml sections
	elseif type(class[1]) == 'table' and klen > 1 then
		local T = {}
		for _, tb in pairs(class) do
			T[#T+1] = exml_r((tb.meta and klen > 1) and {tb} or tb)
		end
		return table.concat(T)
	end
	return nil
end

--	Adds the xml header and data template
--	Uses the contained template meta if found (instead of the received variable)
--	@param data: a lua2exml formatted table
--	@param template: an nms file template string
function FileWrapping(data, template)
	local wrapper = '<?xml version="1.0" encoding="utf-8"?><Data template="%s">%s</Data>'
	if type(data) == 'string' then
		return string.format(wrapper, template, data)
	end
	-- remove the extra table added by ToLua
	if data.template then data = data.template end
	-- table loaded from file
	if data.meta.att == 'template' then
		-- strip mock template
		local txt_data = ToExml(data):sub(#data.meta.val + 36, -12)
		return string.format(wrapper, data.meta.val, txt_data)
	else
		return string.format(wrapper, template, ToExml(data))
	end
end

--	Translates a 0xFF hex section from a longer string to 0-1.0 percentage
--	@param hex: hex string (case insensitive [A-z0-9])
--	@param i: the hex pair's index
function Hex2Percent(hex, i)
	return math.floor(tonumber(hex:sub(i * 2 - 1, i * 2), 16) / 255 * 1000) / 1000
end

--	Returns a Colour class
--	@param T: ARGB color in percentage values or hex format.
--	  Either {1.0, 0.5, 0.4, 0.3} or {<a=1.0> <,r=0.5> <,g=0.4> <,b=0.3>} or 'FFA0B1C2'
--	@param color_name: class name
function ColorData(C, color_name)
	local argb = {}
	if type(C) == 'string' then
		for i=#C > 6 and 1 or 2, #C/2 do
			argb[i] = Hex2Percent(C, i)
		end
	elseif C == 0 then
		argb = {1, -1, -1, -1} -- 'real' black
	else
		argb = C or {}
	end
	return {
		meta= {att='name', val=color_name},
		{A	= (argb[1] or argb.a) or 1},
		{R	= (argb[2] or argb.r) or 1},
		{G	= (argb[3] or argb.g) or 1},
		{B	= (argb[4] or argb.b) or 1}
	}
end

--	Builds an amumss VCT table from a hex color string
--	@param h: hex color string in ARGB or RGB format (default is white)
--	(not really the place for this one, but it's convenient)
function Hex2VCT(h)
	local argb = {{'A', 1}, {'R', -1}, {'G', -1}, {'B', -1}}
	if h == 0 then return argb end -- 'real' black
	for i=#h > 6 and 1 or 2, #h/2 do
		argb[i][2] = Hex2Percent(h, i)
	end
	return argb
end

--	Returns a Vector 2, 3 or 4f class, depending on number of values
--	@param T: xy<z<t>> vector
--	  Either {1.0, 0.5 <,0.4, <,2>>} or {x=1.0, y=0.5 <,z=0.4 <,t=2>>}
--	@param vector_name: class name
function VectorData(T, vector_name)
	if not T then return nil end
	return {
		-- if a name is present then use 2-property tags
		meta= {att='name', val=vector_name},
		{X	= T[1] or T.x},
		{Y	= T[2] or T.y},
		{Z	= (T[3] or T.z) or nil},
		{W	= (T[4] or T.w) or nil}
	}
end

--	Returns a 'name' type array of strings
--	@param t: an ordered (non-keyed) table of strings
--	@param s_arr_name: class name
function StringArray(t, s_arr_name)
	if not t then return nil end
	local T = { meta = {att='name', val=s_arr_name} }
	for _,s in ipairs(t) do
		T[#T+1] = { [s_arr_name] = s }
	end
	return T
end

--	Determine if received is a single or multi-item
--	then process items through the received function
--	@param items: table of item properties or a non-keyed table of items (keys are ignored)
--	@param acton: the function to process the items in the table
function ProcessOnenAll(items, acton)
	-- first key = 1 means multiple entries
	if next(items) == 1 then
		local T = {}
		for _,e in ipairs(items) do
			T[#T+1] = acton(e)
		end
		return T
	end
	return acton(items)
end
