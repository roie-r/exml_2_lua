-------------------------------------------------------------------------------
---	Model scene tools (VERSION: 0.84.1) ... by lMonk
---	Helper function for adding new TkSceneNodeData nodes and properties
---	* Requires _lua_2_exml.lua !
---	* This script should be in [AMUMSS folder]\ModScript\ModHelperScripts\LIB
-------------------------------------------------------------------------------

--	Build a single -or list of scene nodes
--	@param props: a keyed table for scene class properties.
--	{
--	  name	= scene node name (NameHash is calculated automatically)
--	  stype	= scene node type
--	  form	= [optional] Transform data. a list of 9 ordered values or keyed values,
--			  but NOT a combination of the two!
--	  attr	= [optional] Attributes table of {name, value} pairs
--	  child	= [optional] Children table for ScNode tables
--	}
function ScNode(nodes)
	--	returns a jenkins hash from a string (by lyravega)
	local function jenkinsHash(input)
		local hash = 0
		local t_chars = {string.byte(input:upper(), 1, #input)}

		for i = 1, #input do
			hash = (hash + t_chars[i]) & 0xffffffff
			hash = (hash + (hash << 10)) & 0xffffffff
			hash = (hash ~ (hash >> 6)) & 0xffffffff
		end
		hash = (hash + (hash << 3)) & 0xffffffff
		hash = (hash ~ (hash >> 11)) & 0xffffffff
		hash = (hash + (hash << 15)) & 0xffffffff
		return tostring(hash)
	end
	--	Build a TkSceneNodeData class
	local function sceneNode(props)
		local T	= {
			meta	= {'value', 'TkSceneNodeData.xml'},
			Name 		= props.name,
			NameHash	= jenkinsHash(props.name),
			Type		= props.stype
		}
		--	add TkTransformData class
		props.form = props.form or {}
		T.Form = {
			meta	= {'Transform', 'TkTransformData.xml'},
			TransX	= (props.form.tx or props.form[1]) or 0,
			TransY	= (props.form.ty or props.form[2]) or 0,
			TransZ	= (props.form.tz or props.form[3]) or 0,
			RotX	= (props.form.rx or props.form[4]) or 0,
			RotY	= (props.form.ry or props.form[5]) or 0,
			RotZ	= (props.form.rz or props.form[6]) or 0,
			ScaleX	= (props.form.sx or props.form[7]) or 1,
			ScaleY	= (props.form.sy or props.form[8]) or 1,
			ScaleZ	= (props.form.sz or props.form[9]) or 1
		}
		if props.attr then
		--	add attributes list if found
			T.Attr = { meta = {'name', 'Attributes'} }
			for _,at in ipairs(props.attr) do
				T.Attr[#T.Attr+1] = {
					meta	= {'value', 'TkSceneNodeAttributeData.xml'},
					Name	= at[1],
					Value	= at[2]
				}
			end
		end
		if props.child then
		--	add children list if found
			local tc = { meta = {'name', 'Children'} }
			for _,pc in ipairs(props.child) do tc[#tc+1] = pc end
			T[#T+1]	= tc
		end
		return T
	end
	-----------------------------------------------------------------
	local k,_ = next(nodes)
	if k == 1 then
	-- k=1 means the first of a list of unrelated, non-nested, nodes
		local T = {}
		for _,nd in pairs(nodes) do
				T[#T+1] = sceneNode(nd)
		end
		return T
	end
	return sceneNode(nodes)
end

--	Builds light TkSceneNodeData sections.
--	receives a table, or a table of tables, with the following (optional) parameters
--	  name= 'n9',	fov= 360,	v=	0,
--	  i=	30000,	f= 'q',		fr=	2,
--	  r=	1,		g=	1,		b=	1,
--	  c=	'7E450A' (color as hex - overwrites rgb)
--	  tx=	0,		ty=	0,		tz=	0,
--	  rx=	0,		ry=	0,		rz=	0,
--	  sx=	1,		sy=	1,		sz=	1
function ScLight(lights)
	local function lightNode(light)
		if light.c then
			for i, col in ipairs({'r', 'g', 'b'}) do
				--  skip the alpha if present
				light[col] = Hex2Percent(light.c, #light.c > 6 and i+1 or i)
			end
		end
		return ScNode({
			name	= light.name or 'n9',
			stype	= 'LIGHT',
			form	= light,
			attr	= {
				{'FOV',		 	light.fov or 360},
				{'FALLOFF',	 	(light.f and light.f:sub(1,1) == 'l') and 'linear' or 'quadratic'},
				{'FALLOFF_RATE',light.fr or 2},
				{'INTENSITY',	light.i  or 30000},
				{'COL_R',		light.r  or 1},
				{'COL_G',		light.g  or 1},
				{'COL_B',		light.b  or 1},
				{'VOLUMETRIC',	light.v  or 0},
				{'COOKIE_IDX',	-1},
				{'MATERIAL',	'MATERIALS/LIGHT.MATERIAL.MBIN'}
			}
		})
	end
	-----------------------------------------------------------------
	if lights then
		local k,_ = next(lights)
		if k == 1 then
		-- k=1 means the first of a list of tables
			local T = {}
			for _,lght in pairs(lights) do
				T[#T+1] = lightNode(lght)
			end
			return T
		end
	end
	return lightNode(lights)
end
