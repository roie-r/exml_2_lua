----------------------------------------------------------------------
dofile('E:/MODZ_stuff/NoMansSky/AMUMss_Scripts/~LIB/table_entry.lua')
----------------------------------------------------------------------

NMS_MOD_DEFINITION_CONTAINER = {
	MOD_FILENAME 		= '_TEST L2E add new basepart.pak',
	MOD_AUTHOR			= 'lMonk',
	NMS_VERSION			= '4.14',
	MODIFICATIONS 		= {{
	MBIN_CHANGE_TABLE	= {
	{
		MBIN_FILE_SOURCE	= 'METADATA/REALITY/TABLES/BASEBUILDINGOBJECTSTABLE.MBIN',
		EXML_CHANGE_TABLE	= {
			{
				PRECEDING_KEY_WORDS	= 'Objects',
				ADD					= ToExml(BaseBuildObjectEntry({
					id				= 'BUILDLIGHT9',
					placementscene	= 'MODELS/PLANETS/BIOMES/COMMON/BUILDINGS/PARTS/BUILDABLEPARTS/DECORATION/STANDINGLIGHT2_PLACEMENT.SCENE.MBIN',
					decorationtype	= 'Normal',
					isplaceable		= true,
					isdecoration	= true,
					onplanetbase 	= true,
					onfreighter		= true,
					onplanet		= false,
					groups			= {{'DECORATION', 'DECOLIGHTS'}},
					canpickup		= false,
					editsterrain	= false,
					issealed		= false,
					linknetwork		= 'Power',
					networksubgroup	= 3,
					networkmask		= 1469,
					rate			= -1
				}))
			}
		}
	},
	{
		MBIN_FILE_SOURCE	= 'METADATA/REALITY/TABLES/BASEBUILDINGPARTSTABLE.MBIN',
		EXML_CHANGE_TABLE	= {
			{
				PRECEDING_KEY_WORDS	= 'Parts',
				ADD					= ToExml(BaseBuildPartEntry({
					id			= '_BUILDLIGHT9',
					stylemodels	= {{
						'MODELS/PLANETS/BIOMES/COMMON/BUILDINGS/PARTS/BUILDABLEPARTS/DECORATION/STANDINGLIGHT2.SCENE.MBIN',
						'MODELS/PLANETS/BIOMES/COMMON/BUILDINGS/PARTS/BUILDABLEPARTS/DECORATION/STANDINGLIGHT2_LOD.SCENE.MBIN'
					}}
				}))
			}
		}
	}
}}}}
