----------------------------------------------------------------------
dofile('E:/MODZ_stuff/NoMansSky/AMUMss_Scripts/~LIB/scene_tools.lua')
----------------------------------------------------------------------

--	Returns a light TkSceneNodeData section.
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
