-------------------------------------------------------------------------
dofile('E:/MODZ_stuff/NoMansSky/AMUMss_Scripts/~LIB/lua_2_exml.lua')
-------------------------------------------------------------------------
--	Helper functions for adding new TkSceneNodeData nodes and properties
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

--	T (optional) is a table for scene class properties - attributes, transform and children
function ScNode(name, stype, T)
	T = T or {}
	T.META = {'value', 'TkSceneNodeData.xml'}
	T.Name = name
	T.Type = stype
	return T
end

--	accepts either a list of 9 values or keyed values (but NOT a combiantion of the two)
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
