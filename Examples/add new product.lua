--------------------------------------
dofile('C:/TEMP/LIB/table_entry.lua')
--------------------------------------

NMS_MOD_DEFINITION_CONTAINER = {
	MOD_FILENAME 		= '_L2E_EXAMPLE add new products.pak',
	MOD_AUTHOR			= 'lMonk',
	NMS_VERSION			= '4.10',
	MODIFICATIONS 		= {{
	MBIN_CHANGE_TABLE	= {
	{
		MBIN_FILE_SOURCE	= 'METADATA/REALITY/TABLES/NMS_REALITY_GCPRODUCTTABLE.MBIN',
		EXML_CHANGE_TABLE	= {
			{
				PRECEDING_KEY_WORDS	= 'Table',
				ADD					= ToExml({
					[1] = ProductEntry({
						id				= 'ULTRAPRODX40',
						name			= 'PRODX40_NAME',
						namelower		= 'PRODX40_NAME_L',
						subtitle		= 'CURIO4_SUBTITLE',
						description		= 'PRODX40_DESC',
						basevalue		= 624000000,
						color			= {c='ccccccff'},
						category		= 'Special',
						type			= 'Tradeable',
						rarity			= 'Rare',
						legality		= 'Legal',
						iscraftable		= true,
						requirements	= {
							{'ULTRAPROD1', 		20,	I_.PRD},
							{'ULTRAPROD2', 		20,	I_.PRD}
						},
						stackmultiplier	= 16,
						icon			= 'TEXTURES/UI/FRONTEND/ICONS/U4PRODUCTS/PRODUCT.CAPTUREDNANODE.DDS'
					}),
					[2] = ProductEntry({
						id				= 'SUPERFOOD',
						name			= 'SUPERFOOD_NAME',
						namelower		= 'SUPERFOOD_NAME_L',
						subtitle		= 'PROD_NIP_SUBTITLE',
						description		= 'SUPERFOOD_DESC',
						basevalue		= 2,
						color			= {c='1a273dff'},
						category		= 'Exotic',
						type			= 'Consumable',
						rarity			= 'Rare',
						legality		= 'Legal',
						consumable		= true,
						requirements	= {
							{'SENTINEL_LOOT',	2,	I_.PRD},
							{'FOOD_V_ROBOT',	2,	I_.PRD},
							{'STELLAR2',		50,	I_.SBT}
						},
						stackmultiplier	= 20,
						icon			= 'TEXTURES/UI/FRONTEND/ICONS/PRODUCTS/PRODUCT.GLOWPELLET.DDS'
					})
				})
			}
		}
	}
}}}}
