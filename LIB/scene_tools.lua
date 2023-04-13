-------------------------------------------------------------------------
---	Model scene tools (VERSION: 0.81) ... by lMonk
---	Helper functions for adding new TkSceneNodeData nodes and properties
---	!! Requires lua_2_exml.lua !!
-------------------------------------------------------------------------

--	Returns a keyed table of TkSceneNodeData sections, using the Name property as keys,
--	* Use to enable direct access to nodes in a table generated with ToLua
function SceneNames(node, keys)
	keys = keys or {}
	if node.META[2] == 'TkSceneNodeData.xml' then
		keys[node.Name] = node
	end
	for k, scn in pairs(node.Children or {}) do
		if k ~= 'META' then SceneNames(scn, keys) end
	end
	return keys
end

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

---	returns a jenkins hash from a string
function JenkinsHash(input)
    local hash = 0
    local charTable = {string.byte(input:upper(), 1, #input)}

    for i = 1, #input do
        hash = (hash + charTable[i]) & 0xffffffff
        hash = (hash + (hash << 10)) & 0xffffffff
        hash = (hash ~ (hash >> 6)) & 0xffffffff
    end
    hash = (hash + (hash << 3)) & 0xffffffff
    hash = (hash ~ (hash >> 11)) & 0xffffffff
    hash = (hash + (hash << 15)) & 0xffffffff

    return tostring(hash)
end

--	Builds a light TkSceneNodeData section.
--	receives a table with the following (optional) variables
--		name= 'n9',	fov= 360,
--		i=	30000,	f= 'q',		fr=	2,
--		r=	1,		g=	1,		b=	1,
--		c=	'7E450A' (color as hex - overwrites rgb)
--		tx=	0,		ty=	0,		tz=	0,
--		rx=	0,		ry=	0,		rz=	0,
--		sx=	1,		sy=	1,		sz=	1
function ScLight(light)
	-- c = color as hex string. overwrites rgb if present.
	if light.c then
		light.r = Hex2Prc(light.c:sub(1, 2))
		light.g = Hex2Prc(light.c:sub(3, 4))
		light.b = Hex2Prc(light.c:sub(5, 6))
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
function AddNewLight(l)  return ToExml(ScLight(l)) end
