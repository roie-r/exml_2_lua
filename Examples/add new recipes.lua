--------------------------------------
dofile('LIB/lua_2_exml.lua')
--------------------------------------

local new_recipes = {
	{
	---	make lots of sand from ferrite
		id		= 'RECIPE_MORESAND',
		name	= 'UI_SANDWORD_DIET7',
		make	= 40,
		cook	= 'False',
		{'SAND1',			6,	I_.SBT,	true}, -- result!
		{'LAND1',			1,	I_.SBT},
		{'LAND1',			1,	I_.SBT}
	},{
	---	Spawning Sac - bioship inventory
		id   	= 'RECIPE_BIOCARGO',
		name	= 'RECIPE_ASTEROID_MIX',
		make	= 4,
		cook	= 'False',
		{'ALIEN_INV_TOKEN', 1,	I_.PRD,	true}, -- result!
		{'FIENDCORE', 		2,	I_.PRD},
		{'SPACEGUNK2', 		40,	I_.SBT},
		{'ROBOT1', 			80,	I_.SBT}
	},{
	---	taint mag ferrite for more taint
		id		= 'RECIPE_TAINT3',
		name	= 'RECIPE_ASTEROID2',
		make	= 40,
		cook	= 'False',
		{'AF_METAL',		3,	I_.SBT,	true}, -- result!
		{'AF_METAL',		1,	I_.SBT},
		{'LAND3',			3,	I_.SBT}
	}
}

local function AddNewRecipes()
	local function addIngredient(x)
		return {
			META	= {x[4] and 'Result' or 'value', 'GcRefinerRecipeElement.xml'},
			Id		= x[1],
			Amount	= x[2],
			Type	= {
				META			= {'Type', 'GcInventoryType.xml'},
				InventoryType	= x[3]
			}
		}
	end
	local function BuildRecipe(rec)
		local T = {META = {'name', 'Ingredients'}}
		for i=2, #rec do
			T[#T+1] = addIngredient(rec[i])
		end
		return {
			META		= {'value', 'GcRefinerRecipe.xml'},
			Id			= rec.id,
			RecipeType	= rec.name,
			RecipeName	= rec.name,
			TimeToMake	= rec.make,
			Cooking		= rec.cook,
			Result		= addIngredient(rec[1]),
			Ingredients	= T
		}
	end
	local T = {}
	for _,r in ipairs(new_recipes) do
		T[#T+1] = BuildRecipe(r)
	end
	return ToExml(T)
end

NMS_MOD_DEFINITION_CONTAINER = {
	MOD_FILENAME 		= '_L2E_EXAMPLE add new recipes.pak',
	MOD_AUTHOR			= 'lMonk',
	NMS_VERSION			= '4.13',
	MODIFICATIONS 		= {{
	MBIN_CHANGE_TABLE	= {
	{
		MBIN_FILE_SOURCE	= 'METADATA/REALITY/TABLES/NMS_REALITY_GCRECIPETABLE.MBIN',
		EXML_CHANGE_TABLE	= {
			{
				PRECEDING_KEY_WORDS = 'Table',
				ADD 				= AddNewRecipes()
			}
		}
	}
}}}}
