-------------------------------------------------------------------------------
---	Model scene tools (VERSION: 0.82.1) ... by lMonk
---	Helper functions for adding new TkSceneNodeData nodes and properties
---	* Requires lua_2_exml.lua !
---	* This should be placed at [AMUMSS folder]\ModScript\ModHelperScripts\LIB
-------------------------------------------------------------------------------

--	T (optional) is a table for scene class properties >> attributes, transform and children
function ScNode(name, stype, T)
	T = T or {}
	T.META 		= {'value', 'TkSceneNodeData.xml'}
	T.Name 		= name
	T.NameHash	= JenkinsHash(name)
	T.Type 		= stype
	return T
end

--	accepts either a list of 9 values or keyed values (but NOT a combination of the two)
function ScTransform(t)
	t = t or {}
	return {
		META	= {'Transform', 'TkTransformData.xml'},
		TransX	= (t.tx or t[1]) or 0,
		TransY	= (t.ty or t[2]) or 0,
		TransZ	= (t.tz or t[3]) or 0,
		RotX	= (t.rx or t[4]) or 0,
		RotY	= (t.ry or t[5]) or 0,
		RotZ	= (t.rz or t[6]) or 0,
		ScaleX	= (t.sx or t[7]) or 1,
		ScaleY	= (t.sy or t[8]) or 1,
		ScaleZ	= (t.sz or t[9]) or 1
	}
end

--	accepts a list of {name, value} pairs
function ScAttributes(t)
	local T = {META = {'name', 'Attributes'}}
	for _,at in ipairs(t) do
		T[#T+1] = {
			META	= {'value', 'TkSceneNodeAttributeData.xml'},
			Name	= at[1],
			Value	= at[2]
		}
	end
	return T
end

function ScChildren(t)
	t.META = {'name', 'Children'}
	return t
end

--	returns a jenkins hash from a string (by lyravega)
function JenkinsHash(input)
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

--	Builds a light TkSceneNodeData section.
--	receives a table with the following (optional) parameters
--	  name= 'n9',	fov= 360,
--	  i=	30000,	f= 'q',		fr=	2,
--	  r=	1,		g=	1,		b=	1,
--	  c=	'7E450A' (color as hex - overwrites rgb)
--	  tx=	0,		ty=	0,		tz=	0,
--	  rx=	0,		ry=	0,		rz=	0,
--	  sx=	1,		sy=	1,		sz=	1
function ScLight(light)
	if light.c then
		for i, col in ipairs({'r', 'g', 'b'}) do
			--  skip the alpha if present
			light[col] = Hex2Percent(light.c, #light.c > 6 and i+1 or i)
		end
	end
	return ScNode(
		light.name or 'n9',
		'LIGHT',
		{
			ScTransform(light),
			ScAttributes({
				{'FOV',		 	light.fov or 360},
				{'FALLOFF',	 	(light.f and light.f:sub(1,1) == 'l') and 'linear' or 'quadratic'},
				{'FALLOFF_RATE',light.fr or 2},
				{'INTENSITY',	light.i  or 30000},
				{'COL_R',		light.r  or 1},
				{'COL_G',		light.g  or 1},
				{'COL_B',		light.b  or 1},
				{'VOLUMETRIC',	0},
				{'COOKIE_IDX',	-1},
				{'MATERIAL',	'MATERIALS/LIGHT.MATERIAL.MBIN'}
			})
		}
	)
end
--	wrapper: returns the exml text of ScLight
function AddNewLight(l)
	return ToExml(ScLight(l))
end
