-------------------------------------------------------------------------------
---	Model scene tools (VERSION: 0.85.6) ... by lMonk
---	Helper function for adding new TkSceneNodeData nodes and properties
---	* Requires _lua_2_exml.lua !
---	* This script should be in [AMUMSS folder]\ModScript\ModHelperScripts\LIB
-------------------------------------------------------------------------------

--	Build a single -or list of TkSceneNodeData classes
--	@param props: a keyed table for scene class properties.
--	{
--	  name	= scene node name (NameHash is calculated automatically)
--	  stype	= scene node type
--	  form	= [optional] Transform data. a list of 9 ordered values or keyed values,
--			  but NOT a combination of the two!
--	  pxlud = [optional] PlatformExclusion
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
			Name 				= props.name,
			NameHash			= jenkinsHash(props.name),
			Type				= props.stype,
			PlatformExclusion	= props.pxlud or nil
		}
		--	add TkTransformData class
		props.form = props.form or {}
		T.Form = {
			meta	= {'Transform', 'TkTransformData.xml'},
			TransX	= (props.form.tx or props.form[1]) or nil,
			TransY	= (props.form.ty or props.form[2]) or nil,
			TransZ	= (props.form.tz or props.form[3]) or nil,
			RotX	= (props.form.rx or props.form[4]) or nil,
			RotY	= (props.form.ry or props.form[5]) or nil,
			RotZ	= (props.form.rz or props.form[6]) or nil,
			ScaleX	= (props.form.sx or props.form[7]) or 1,
			ScaleY	= (props.form.sy or props.form[8]) or 1,
			ScaleZ	= (props.form.sz or props.form[9]) or 1
		}
		--	if present, add attributes list
		if props.attr then
			-- add accompanying attribute to scenegraph
			if props.attr.SCENEGRAPH then
				props.attr.EMBEDGEOMETRY = 'TRUE'
			end
			T.Attr = { meta = {'name', 'Attributes'} }
			for nm, val in pairs(props.attr) do
				T.Attr[#T.Attr+1] = {
					meta	= {'value', 'TkSceneNodeAttributeData.xml'},
					Name	= nm,
					Value	= val
				}
			end
		end
		if props.child then
		--	add children list if found
			local k,_ = next(props.child)
			cnd = ScNode(props.child)
			T.Child	= k == 1 and cnd or {cnd}
			T.Child.meta = {'name', 'Children'}
		end
		return T
	end
	-----------------------------------------------------------------
	local k,_ = next(nodes)
	if k == 1 then
	-- k=1 means the first of a list of unrelated, non-nested, nodes
		local T = {}
		for _,nd in ipairs(nodes) do
				T[#T+1] = sceneNode(nd)
		end
		return T
	end
	return sceneNode(nodes)
end

--	Wrapper function. Accepts lua scene nodes and Returns an exml string.
function AddSceneNodes(nodes)
	return ToExml(ScNode(nodes))
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
--	  mt=	MATERIALS/LIGHT.MATERIAL.MBIN
function ScLight(lights)
	local function lightNode(light)
		if light.c then
			for i, col in ipairs({'r', 'g', 'b'}) do
				--  skip the alpha if present
				light[col] = Hex2Percent(light.c, #light.c > 6 and i+1 or i)
			end
		end
		return {
			name	= light.name or 'n9',
			stype	= 'LIGHT',
			form	= light,
			attr	= {
				FOV			= light.fov or 360,
				FALLOFF		= (light.f and light.f:sub(1,1) == 'l') and 'linear' or 'quadratic',
				FALLOFF_RATE= light.fr or 2,
				INTENSITY	= light.i  or 30000,
				COL_R		= light.r  or 1,
				COL_G		= light.g  or 1,
				COL_B		= light.b  or 1,
				VOLUMETRIC	= light.v  or nil,
				COOKIE_IDX	= -1,
				MATERIAL	= light.mt or 'MATERIALS/LIGHT.MATERIAL.MBIN'
			}
		}
	end
	-----------------------------------------------------------------
	if lights then
		local k,_ = next(lights)
		if k == 1 then
		-- k=1 means the first of a list of tables
			local T = {}
			for _,l in pairs(lights) do
				T[#T+1] = lightNode(l)
			end
			return ScNode(T)
		end
	end
	return ScNode(lightNode(lights))
end

--	Wrapper function. Accepts lua light nodes and Returns an exml string.
function AddLightNodes(lights)
	return ToExml(ScLight(lights))
end