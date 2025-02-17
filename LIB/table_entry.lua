-------------------------------------------------------------------------------
---	Reality tables entries (VERSION: 0.86.0) ... by lMonk
---	Build full table entries, conversion-ready with ToExml; For technology,
--	 proc-tech, product, recipe, basebuild objects and basebuild parts.
---	* Not ALL properties of the tables' classes are included. Some properties
---	 who are unused/deprecated/can stay with a default value are omitted.
---	* Requires _lua_2_exml.lua !
---	* This script should be in [AMUMSS folder]\ModScript\ModHelperScripts\LIB
-------------------------------------------------------------------------------

IT_={--	InventoryType Enum
	SBT='Substance',	TCH='Technology',	PRD='Product'
}

--	build the requirements table for tech and products
--	receives a table of {id, amount, product/substance} items
function GetRequirements(r)
	if not r then return nil end
	local reqs = {meta = {att='name', val='Requirements'}}
	for _,req in ipairs(r) do
		reqs[#reqs+1] = {
			meta	= {att='Requirements', val='GcTechnologyRequirement'},
			ID		= req.id,
			Amount	= req.n,							--	i
			Type	= {
				meta	= {att='Type', val='GcInventoryType'},
				InventoryType = req.tp					--	Enum
			}
		}
	end
	return reqs
end

--	receives a table of {type, bonus, level} items
function TechStatBonus(tsb)
	return {
		meta	= {att='StatBonuses', val='GcStatsBonus'},
		Stat	= {
			meta		= {att='Stat', val='GcStatsTypes'},
			StatsType	= tsb.st					--	Enum
		},
		Bonus	= tsb.bn,							--	f
		Level	= tsb.lv or 0						--	i 0-4
	}
end

--	Build an entry for NMS_REALITY_GCTECHNOLOGYTABLE
--	sub lists (requirements and color) are entered in separate tables
function TechnologyEntry(items)
	local function techEntry(tech)
		return {
			meta			= {att='Table', val='GcTechnology'},
			ID				= tech.id,
			Group			= tech.group,									--	s
			Name			= tech.name,									--	s
			NameLower		= tech.namelower,								--	s
			Subtitle		= tech.subtitle,								--	s
			Description		= tech.description,								--	s
			Teach			= true,
			HintStart		= tech.hintstart,
			HintEnd			= tech.hintend,
			Icon			= {
				meta	= {att='Icon', val='TkTextureResource'},
				Filename	= tech.icon,									--	s
			},
			Colour			= ColorData(tech.color, 'Colour'),				--	rgb/hex
			Level			= 1,
			Chargeable		= tech.chargeable,								--	b
			ChargeAmount	= tech.chargeamount	or 100,						--	i
			ChargeType		= {
				meta	= {att='ChargeType', val='GcRealitySubstanceCategory'},
				SubstanceCategory = (tech.chargetype or 'Earth'),			--	E
			},
			ChargeBy		= StringArray(tech.chargeby, 'ChargeBy'),		--	Id
			ChargeMultiplier= tech.chargemultiply or 1,
			BuildFullyCharged= true,
			UsesAmmo		= tech.usesammo,								--	b
			AmmoId			= tech.ammoid,									--	Id
			PrimaryItem		= tech.primaryitem,								--	b
			Upgrade			= tech.upgrade,									--	b
			Core			= tech.core,									--	b
			Procedural		= tech.istemplate,								--	not a bug
			Category		= {
				meta	= {att='Category', val='GcTechnologyCategory'},
				TechnologyCategory = tech.category,							--	Enum
			},
			Rarity			= {
				meta	= {att='Rarity', val='GcTechnologyRarity'},
				TechnologyRarity = tech.rarity	or 'Normal',				--	Enum
			},
			Value			= tech.value		or 10,						--	i
			Requirements	= GetRequirements(tech.requirements),
			BaseStat		= {
				meta	= {att='BaseStat', val='GcStatsTypes'},
				StatsType	= tech.basestat,								--	Enum
			},
			StatBonuses		= (
				function()
					local stats = {meta = {att='name', val='StatBonuses'}}
					for _,tsb in ipairs(tech.statbonuses) do
						stats[#stats+1] = TechStatBonus(tsb)
					end
					return stats
				end
			)(),
			RequiredTech	= tech.requiredtech,							--	Id
			FocusLocator	= tech.focuslocator,							--	??
			UpgradeColour	= ColorData(tech.upgradecolor, 'UpgradeColour'),--	rgb/hex
			LinkColour		= ColorData(tech.linkcolor, 'LinkColour'),		--	rgb/hex
			BaseValue		= 1,
			RequiredRank	= tech.requiredrank	or 1,
			FragmentCost	= tech.fragmentcost	or 1,
			TechShopRarity	= {
				meta	= {att='TechShopRarity', val='GcTechnologyRarity'},
				TechnologyRarity = tech.rarity	or 'Normal',				--	E
			},
			WikiEnabled		= tech.wikienabled,								--	b
			IsTemplate		= tech.istemplate,								--	b
			ExclusivePrimaryStat = tech.exclusiveprimarystat				--	b
		}
	end
	return ProcessOnenAll(items, techEntry)
end

--	Build an entry for NMS_REALITY_GCPRODUCTTABLE
--	sub lists (requirements and color) are entered in separate tables
function ProductEntry(items)
	local function prodEntry(prod)
		return {
			meta	= {att='value', val='GcProductData'},
			ID			= prod.id,
			Name		= prod.name,									--	s
			NameLower	= prod.namelower,								--	s
			Subtitle	= prod.subtitle,								--	s
			Description	= prod.description,								--	s
			DebrisFile	= {
				meta	= {att='DebrisFile', val='TkModelResource'},
				Filename= 'MODELS/EFFECTS/DEBRIS/TERRAINDEBRIS/TERRAINDEBRIS4.SCENE.MBIN'
			},
			BaseValue	= prod.basevalue or 1,							--	i
			Icon		= {
				meta	= {att='Icon', val='TkTextureResource'},
				Filename= prod.icon										--	s
			},
			Colour		= ColorData(prod.color, 'Colour'),				--	rgb/hex
			Category	= {
				meta	= {att='Category', val='GcRealitySubstanceCategory'},
				SubstanceCategory	= prod.category	or 'Earth'			--	Enum
			},
			Type		= {
				meta	= {att='Type', val='GcProductCategory'},
				ProductCategory		= prod.type		or 'Component'		--	Enum
			},
			Rarity		= {
				meta	= {att='Rarity', val='GcRarity'},
				Rarity				= prod.rarity	or 'Common'			--	Enum
			},
			Legality	= {
				meta	= {att='Legality', val='GcLegality'},
				Legality			= prod.legality	or 'Legal'			--	Enum
			},
			Consumable				= prod.consumable,					--	b
			ChargeValue				= prod.chargevalue,					--	i
			StackMultiplier			= prod.stackmultiplier	or 1,
			DefaultCraftAmount		= prod.craftamount		or 1,
			CraftAmountStepSize		= prod.craftstep		or 1,
			CraftAmountMultiplier	= prod.crafmultiplier	or 1,
			Requirements			= GetRequirements(prod.requirements),
			Cost		= {
				meta	= {att='Cost', val='GcItemPriceModifiers'},
				SpaceStationMarkup	= prod.spacestationmarkup,
				LowPriceMod			= prod.lowpricemod		or -0.1,
				HighPriceMod		= prod.highpricemod		or 0.1,
				BuyBaseMarkup		= prod.buybasemarkup	or 0.2,
				BuyMarkupMod		= prod.buymarkupmod
			},
			RecipeCost				= prod.recipecost		or 1,
			SpecificChargeOnly		= prod.specificchargeonly,			--	b
			NormalisedValueOnWorld	= prod.normalisedvalueonworld,		--	f
			NormalisedValueOffWorld	= prod.normalisedvalueoffworld,		--	f
			TradeCategory= {
				meta	= {att='TradeCategory', val='GcTradeCategory'},
				TradeCategory	= prod.tradecategory or 'None'			--	Enum
			},
			WikiCategory				= prod.wikicategory or 'NotEnabled',
			IsCraftable					= prod.iscraftable,				--	b
			DeploysInto					= prod.deploysinto,				--	Id
			EconomyInfluenceMultiplier	= prod.economyinfluence,		--	i
			PinObjective				= prod.pinobjective,			--	s
			PinObjectiveTip				= prod.pinobjectivetip,			--	s
			CookingIngredient			= prod.cookingingredient,		--	b
			CookingValue				= prod.cookingvalue,			--	i
			GoodForSelling				= prod.goodforselling,			--	b
			EggModifierIngredient		= prod.eggmodifier,				--	b
			IsTechbox					= prod.istechbox,				--	b
			CanSendToOtherPlayers		= prod.sendtoplayer				--	b
		}
	end
	return ProcessOnenAll(items, prodEntry)
end

--	receives a table of {type, min, max, weightcurve, always} items
function ProcTechStatLevel(tsl)
	return {
		meta		= {att='value', val='GcProceduralTechnologyStatLevel'},
		Stat		= {
			meta = {att='Stat', val='GcStatsTypes'},
			StatsType = tsl.st,							--	Enum
		},
		ValueMin	= tsl.mn and tsl.mn or tsl.mx,		--	f
		ValueMax	= tsl.mx,							--	f
		WeightingCurve = {
			meta = {att='WeightingCurve', val='GcWeightingCurve'},
			WeightingCurve = tsl.wc or 'NoWeighting',	--	Enum
		},
		AlwaysChoose= tsl.ac							--	b
	}
end

--	Build an entry for NMS_REALITY_GCPROCEDURALTECHNOLOGYTABLE
function ProcTechEntry(items)
	local function proctechEntry(tech)
		return {
			meta	= {att='value', val='GcProceduralTechnologyData'},
			ID				= tech.id,
			Template		= tech.template,
			Name			= tech.name,
			NameLower		= tech.namelower,
			Group			= tech.namelower, -- not a bug
			Subtitle		= tech.subtitle,
			Description		= tech.description,
			Colour			= ColorData(tech.color, 'Colour'),			--	rgb/hex
			Quality			= tech.quality or 'Normal',					--	Enum
			Category		= {
				meta = {att='Category', val='GcProceduralTechnologyCategory'},
				ProceduralTechnologyCategory = tech.category,			--	Enum
			},
			NumStatsMin		= tech.numstatsmin,							--	i
			NumStatsMax		= tech.numstatsmax,							--	i
			WeightingCurve	= {
				meta = {att='WeightingCurve', val='GcWeightingCurve'},
				WeightingCurve = tech.weightingcurve or 'NoWeighting',	--	Enum
			},
			UpgradeColour	= ColorData(tech.upgradecolor, 'UpgradeColour'),
			StatLevels		= (
				function()
					local stats = {meta = {att='name', val='StatLevels'}}
					for _,sl in ipairs(tech.statlevels) do
						stats[#stats+1] = ProcTechStatLevel(sl)
					end
					return stats
				end
			)()
		}
	end
	return ProcessOnenAll(items, proctechEntry)
end

--	Build an entry for BASEBUILDINGOBJECTSTABLE
function BaseBuildObjectEntry(items)
	local function baseObjectEntry(bpart)
		return {
			meta = {att='value', val='GcBaseBuildingEntry'},
			ID							= bpart.id,
			Style						= {
				meta		= {att='Style', val='GcBaseBuildingPartStyle'},
				Style		= bpart.style or 'None'						--	Enum
			},
			PlacementScene				= {
				meta		= {att='PlacementScene', val='TkModelResource'},
				Filename	= bpart.placementscene
			},
			DecorationType				= {
				meta		= {att='DecorationType', val='GcBaseBuildingObjectDecorationTypes'},
				BaseBuildingDecorationType = bpart.decorationtype or 'Normal'--	Enum
			},
			IsPlaceable					= bpart.isplaceable,			--	b
			IsDecoration				= bpart.isdecoration,			--	b
			BuildableOnPlanetBase 		= bpart.onplanetbase,			--	b
			BuildableOnFreighter		= bpart.onfreighter,			--	b
			BuildableOnPlanet			= bpart.onplanet,				--	b
			BuildableUnderwater			= true,
			BuildableAboveWater			= true,
			CheckPlayerCollision		= false,
			CanRotate3D					= true,
			CanScale					= true,
			Groups						= (
				function()
					if not bpart.groups then return nil end
					local T = {meta = {att='name', val='Groups'}}
					for _,v in ipairs(bpart.groups) do
						T[#T+1] = {
							meta	= {att='value', val='GcBaseBuildingEntryGroup'},
							Group			= v.group,
							SubGroupName	= v.subname
						}
					end
					return T
				end
			)(),
			StorageContainerIndex 		= -1,							--	i
			CanChangeColour				= true,
			CanChangeMaterial			= true,
			CanPickUp					= bpart.canpickup,				--	b
			ShowInBuildMenu				= true,
			CompositePartObjectIDs		= StringArray(bpart.compositeparts, 'CompositePartObjectIDs'),
			FamilyIDs					= StringArray(bpart.familyids, 'FamilyIDs'),
			BuildEffectAccelerator		= 1,							--	i
			RemovesAttachedDecoration	= true,
			RemovesWhenUnsnapped		= false,
			EditsTerrain				= bpart.editsterrain,			--	b
			BaseTerrainEditShape		= 'Cube',						--	Enum
			MinimumDeleteDistance		= 1,							--	i
			IsSealed					= bpart.issealed,				--	b
			CloseMenuAfterBuild			= bpart.closemenuafterbuild,
			LinkGridData				= {
				meta = {att='LinkGridData', val='GcBaseLinkGridData'},
				Connection = {
					meta	= {att='Connection', val='GcBaseLinkGridConnectionData'},
					Network	= {
						meta = {att='Network', val='GcLinkNetworkTypes'},
						LinkNetworkType = bpart.linknetwork or 'Power'	--	Enum
					},
					NetworkSubGroup		= bpart.networksubgroup,		--	i
					NetworkMask			= bpart.networkmask,			--	i
					ConnectionDistance	= 0.1							--	f
				},
				Rate					= bpart.rate,					--	f
				Storage					= bpart.storage					--	i
			},
			ShowGhosts					= bpart.showghosts,				--	b
			GhostsCountOverride			= 0,
			SnappingDistanceOverride	= 0,
			RegionSpawnLOD				= 1
		}
	end
	return ProcessOnenAll(items, baseObjectEntry)
end

--	Build an entry for BASEBUILDINGPARTSTABLE
function BaseBuildPartEntry(items)
	local function basePartEntry(bpart)
		local T = {
			meta	= {att='value', val='GcBaseBuildingPart'},
			ID		= bpart.id,
			StyleModels = {meta = {att='name', val='StyleModels'}}
		}
		for _,src in ipairs(bpart.stylemodels) do
			T.StyleModels[#T.StyleModels+1] = {
				meta = {att='value', val='GcBaseBuildingPartStyleModel'},
				Style = {
					meta = {att='Style', val='GcBaseBuildingPartStyle'},
					Style = src.style or 'None',						--	Enum
				},
				Model = {
					meta = {att='Model', val='TkModelResource'},
					Filename = src.act,
				},
				Inactive = {
					meta = {att='Inactive', val='TkModelResource'},
					Filename = src.lod
				}
			}
		end
		return T
	end
	return ProcessOnenAll(items, basePartEntry)
end

--	Build an entry for NMS_REALITY_GCRECIPETABLE
function RefinerRecipeEntry(items)
	local function addIngredient(elem, result)
		return {
			meta	= {att=(result and 'Result' or 'value'), val='GcRefinerRecipeElement'},
			Id		= elem.id,
			Amount	= elem.n,										--	i
			Type	= {
				meta			= {att='Type', val='GcInventoryType'},
				InventoryType	= elem.tp							--	Enum
			}
		}
	end
	local function refinerecipeEntry(recipe)
		local igrds = {meta = {att='name', val='Ingredients'}}
		for _,elem in ipairs(recipe.ingredients) do
			igrds[#igrds+1] = addIngredient(elem)
		end
		return {
			meta	= {att='value', val='GcRefinerRecipe'},
			Id			= recipe.id,
			RecipeType	= recipe.name,									--	s
			RecipeName	= recipe.name,									--	s
			TimeToMake	= recipe.make,									--	i
			Cooking		= recipe.cook,									--	b
			Result		= addIngredient(recipe.result, true),
			Ingredients	= igrds
		}
	end
	return ProcessOnenAll(items, refinerecipeEntry)
end
