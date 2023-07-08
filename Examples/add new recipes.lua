---------------------------------------------------------------------
dofile('LIB/lua_2_exml.lua')
---------------------------------------------------------------------
mod_desc = [[
  Add new recipes
]]-------------------------------------------------------------------

local new_recipes = {
	{--	make lots of sand from ferrite
		id		= 'RECIPE_MORESAND',
		name	= 'UI_SANDWORD_DIET7',
		make	= 40,
		cook	= 'False',
		{id='SAND1',			n=6,	tp=I_.SBT,	res=true}, -- result!
		{id='LAND1',			n=1,	tp=I_.SBT},
		{id='LAND1',			n=1,	tp=I_.SBT}
	},
	{--	Spawning Sac - bioship inventory
		id   	= 'RECIPE_BIOCARGO',
		name	= 'RECIPE_ASTEROID_MIX',
		make	= 4,
		cook	= 'False',
		{id='ALIEN_INV_TOKEN',	n=1,	tp=I_.PRD,	res=true}, -- result!
		{id='FIENDCORE', 		n=2,	tp=I_.PRD},
		{id='SPACEGUNK2', 		n=40,	tp=I_.SBT},
		{id='ROBOT1', 			n=80,	tp=I_.SBT}
	},
	{--	taint mag ferrite for more taint
		id		= 'RECIPE_TAINT3',
		name	= 'RECIPE_ASTEROID2',
		make	= 40,
		cook	= 'False',
		{id='AF_METAL',			n=3,	tp=I_.SBT,	res=true}, -- result!
		{id='AF_METAL',			n=1,	tp=I_.SBT},
		{id='LAND3',			n=3,	tp=I_.SBT}
	},
}

local function AddNewRecipes()
	local function addIngredient(x)
		return {
			META	= {x.res and 'Result' or 'value', 'GcRefinerRecipeElement.xml'},
			Id		= x.id,
			Amount	= x.n,
			Type	= {
				META			= {'Type', 'GcInventoryType.xml'},
				InventoryType	= x.tp
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
	MOD_FILENAME 		= '__TABLE RECIPE.pak',
	MOD_AUTHOR			= 'lMonk',
	NMS_VERSION			= '4.36.2',
	MOD_DESCRIPTION		= mod_desc,
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
