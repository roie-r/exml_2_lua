----------------------------------------------------------------------
dofile('LIB/lua_2_exml.lua')
dofile('LIB/table_entry.lua')
----------------------------------------------------------------------

NMS_MOD_DEFINITION_CONTAINER = {
	MOD_FILENAME 		= '_TEST L2E add new tech.pak',
	MOD_AUTHOR			= 'lMonk',
	NMS_VERSION			= '4.38',
	MODIFICATIONS 		= {{
	MBIN_CHANGE_TABLE	= {
	{
		MBIN_FILE_SOURCE	= 'METADATA/REALITY/TABLES/NMS_REALITY_GCTECHNOLOGYTABLE.MBIN',
		EXML_CHANGE_TABLE	= {
			{
				PRECEDING_KEY_WORDS	= 'Table',
				ADD					= ToExml(TechnologyEntry({
					id				= 'BODYSHIELD',
					name			= 'BODYSHIELD_NAME',
					namelower		= 'BODYSHIELD_NAME_L',
					subtitle		= 'BODYSHIELD_SUB',
					description		= 'BODYSHIELD_DESC',
					icon			= 'TEXTURES/UI/FRONTEND/ICONS/TECHNOLOGY/RENDER.SHIELD.RED2.DDS',
					color			= {c='095c77ff'},
					chargeable		= true,
					chargeamount	= 400,
					chargetype		= 'Catalyst',
					chargeby		= {'POWERCELL', 'CATALYST2', 'CATALYST1'},
					primaryitem		= true,
					category		= 'Suit',
					rarity			= 'Always',
					value			= 5,
					requirements	= {
						{id='POWERCELL', n=1, tp='Product'}
					},
					basestat		= 'Suit_Armour_Shield',
					statbonuses		= {
						{st='Suit_Armour_Shield',			bn=1,	lv=1},
						{st='Suit_Armour_Shield_Strength',	bn=24,	lv=1},
						{st='Suit_Armour_Health',			bn=60,	lv=20}
					},
					fragmentcost	= 980
				}))
			}
		}
	}
}}}}
