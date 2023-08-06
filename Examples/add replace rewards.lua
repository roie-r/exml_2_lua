-----------------------------------------------------------------------
dofile('LIB/lua_2_exml.lua')
dofile('LIB/reward_entry.lua')
-----------------------------------------------------------------------
mod_desc = [[
  Replacing and adding new rewards:
  - freighter defense reward (requires changes in AlienPuzzle)
  - crashed freighter containers
  - salvaged glass (sentinel loot)
  - pirate ships battle loot
  - jetpack boost bonuses
]]---------------------------------------------------------------------

local new_rewards = {
	{
	---	add new ship ---
		id			= 'MY_1ST_SHIP',
		choice		= C_.ALL,
		rewardlist	= {
			{
				f			= R_Ship,
				c			= 100,
				name		= 'Scrap Bucket',
				filename	= 'MODELS/COMMON/SPACECRAFT/SHUTTLE/SHUTTLE_PROC.SCENE.MBIN',
				seed		= '0x1015EED',
				slots		= 42,
				class		= 'A',
				shiptype	= 'Shuttle',
				inventory	= {
					{id='HYPERDRIVE',	amount=true},
					{id='LAUNCHER',		amount=true},
					{id='SHIPSHIELD',	amount=true},
					{id='SHIPJUMP1',	amount=true},
					{id='SHIPGUN1'}
				}
			},
			{id=U_.HG,	n=100,	x=160,	c=100,	f=R_Money}
		}
	},
	{
	---	add new multitool ---
		id			= 'MY_1ST_TOOL',
		choice		= C_.ALL,
		rewardlist	= {
			{
				f			= R_Multitool,
				c			= 100,
				name		= 'Royale With Cheese',
				filename	= 'MODELS/COMMON/WEAPONS/MULTITOOL/ROYALMULTITOOL.SCENE.MBIN',
				seed		= '0x1015EED',
				slots		= 24,
				class		= 'A',
				weapontype	= 'Royal',
				inventory	= {
					{id='LASER',	amount=true},
					{id='BOLT'},
					{id='SCAN1'},
					{id='SCANBINOC1'}
				}
			},
			{id=U_.HG,	n=100,	x=160,	c=100,	f=R_Money}
		}
	},
	{
	---	sentinel salvaged glass shard ---
		id			= 'DE_SENT_LOOT',
		choice		= C_.ONE,
		replacement	= true,
		rewardlist	= {
			--id					Min		Max		%		function
			{id='CHART_HIVE',				x=1,	c=2,	f=R_Product},
			{id='U_SENTGUN',				x=1,	c=30,	f=R_Product},
			{id='U_SENTSUIT',				x=1,	c=30,	f=R_Product},
			{id='COMPUTER',     	n=1,	x=2,	c=6,	f=R_Product},
			{id='ANTIMATTER',   	n=1,	x=2,	c=6,	f=R_Product},
			{id='MAGNET',       	n=1,	x=2,	c=6,	f=R_Product},
			{id='HYDRALIC',     	n=1,	x=2,	c=6,	f=R_Product},
			{id='MIRROR',       	n=1,	x=2,	c=6,	f=R_Product},
			{id='BIO',          	n=1,	x=2,	c=6,	f=R_Product},
			{id='MECH_PROD',    	n=1,	x=2,	c=6,	f=R_Product},
			{id='WALKER_PROD',  	n=1,	x=2,	c=6,	f=R_Product},
			{id='ALLOY1',    				x=1,	c=4,	f=R_Product},
			{id='ALLOY2',    				x=1,	c=4,	f=R_Product},
			{id='ALLOY3',    				x=1,	c=4,	f=R_Product},
			{id='ALLOY4',    				x=1,	c=4,	f=R_Product},
			{id='ALLOY5',    				x=1,	c=4,	f=R_Product},
			{id='ALLOY6',    				x=1,	c=4,	f=R_Product},
			{id='ALLOY7',    				x=1,	c=1,	f=R_Product},
			{id='ALLOY8',    				x=1,	c=1,	f=R_Product},
			{id=U_.HG,				n=100,	x=160,	c=10,	f=R_Money}
		}
	},
	{
	---	crashed freighter containers ---
		id			= 'CRASHCONT_M',
		choice		= C_.ONE,
		replacement	= true,
		rewardlist	= {
			{id=U_.UT,	n=25000,	x=75000,	c=50,	f=R_Money},
			{
				f=R_MultiItem,
				c=45,
				{id='LAUNCHFUEL',		n=1, 	t=M_.PRD},
				{id='BP_SALVAGE',		n=3, 	t=M_.PRD},
				{pid=P_.DTC, 			q=2,	t=M_.PRP},
			},
			{
				f=R_MultiItem,
				c=45,
				{id='ANTIMATTER',		n=2, 	t=M_.PRD},
				{id='AM_HOUSING',		n=2, 	t=M_.PRD},
				{id='TECHFRAG',			n=230, 	t=M_.SBT},
			},
			{
				f=R_MultiItem,
				c=35,
				{id='FRIG_TOKEN',		n=1, 	t=M_.PRD},
				{id='TIMEMILK',			n=94, 	t=M_.SBT},
			},
			{
				f=R_MultiItem,
				c=35,
				{id='WEAP_INV_TOKEN',	n=1, 	t=M_.PRD},
				{id='AF_METAL',			n=117, 	t=M_.SBT},
			},
			{id=U_.UT,	n=150000,	x=260000,	c=20,	f=R_Money},
			{
				f=R_MultiItem,
				{id='FARMPROD1',		n=1, 	t=M_.PRD},	-- Acid
				{id='WORMDUST',			n=105, 	t=M_.SBT},
				c=25,
			},
			{
				f=R_MultiItem,
				c=25,
				{id='FARMPROD5',		n=1, 	t=M_.PRD},	-- Poly Fibre
				{id='TIMEDUST',			n=94, 	t=M_.SBT},
			},
			{
				f=R_MultiItem,
				c=25,
				{id='SALVAGE_TECH8',	n=1, 	t=M_.PRD},	-- Subatomic Regulators
				{id='SPECIAL_POOP',		n=203, 	t=M_.SBT},
			},
			{
				f=R_MultiItem,
				c=25,
				{id='SALVAGE_TECH7',	n=1, 	t=M_.PRD},	-- Recycled Circuitry
				{id='TIMEMILK',			n=91, 	t=M_.SBT},
			},
			{
				f=R_MultiItem,
				c=2,
				{id='FREI_INV_TOKEN',	n=2, 	t=M_.PRD},	-- freighter inv
				{id='ROBOT1',			n=303, 	t=M_.SBT},
			},

			-- freighter hyper
			{
				f=R_MultiItem,
				c=5,
				{pid=P_.FRH, 		q=0,	t=M_.PRP},
				{id='CASING',		n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=2,
				{pid=P_.FRH, 		q=1,	t=M_.PRP},
				{id='COMPOUND6',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRH, 		q=2,	t=M_.PRP},
				{id='PRODFUEL2',	n=1, 	t=M_.PRD},
			},
			{
				c=1,
				{pid=P_.FRH, 		q=3,	t=M_.PRP},
				{id='ILLEGAL_PROD6',n=1, 	t=M_.PRD},
				f=R_MultiItem,
			},
			-- freighter fuel
			{
				f=R_MultiItem,
				c=5,
				{pid=P_.FRF, 		q=0,	t=M_.PRP},
				{id='NANOTUBES',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=2,
				{pid=P_.FRF, 		q=1,	t=M_.PRP},
				{id='COMPOUND5',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRF, 		q=2,	t=M_.PRP},
				{id='REPAIRKIT',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRF, 		q=3,	t=M_.PRP},
				{id='ILLEGAL_PROD5',n=1, 	t=M_.PRD},
			},
			-- freighter trade
			{
				f=R_MultiItem,
				c=5,
				{pid=P_.FRT, 		q=0,	t=M_.PRP},
				{id='JELLY',		n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=2,
				{pid=P_.FRT, 		q=1,	t=M_.PRP},
				{id='COMPOUND4',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRT, 		q=2,	t=M_.PRP},
				{id='BIO',			n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRT, 		q=3,	t=M_.PRP},
				{id='ILLEGAL_PROD4',n=1, 	t=M_.PRD},
			},
			-- freighter combat
			{
				f=R_MultiItem,
				c=5,
				{pid=P_.FRC, 		q=0,	t=M_.PRP},
				{id='POWERCELL',	n=187, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=2,
				{pid=P_.FRC, 		q=1,	t=M_.PRP},
				{id='COMPOUND3',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRC, 		q=2,	t=M_.PRP},
				{id='MIRROR',		n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRC, 		q=3,	t=M_.PRP},
				{id='ILLEGAL_PROD3',n=1, 	t=M_.PRD},
			},
			-- freighter mining
			{
				f=R_MultiItem,
				c=5,
				{pid=P_.FRM, 		q=0,	t=M_.PRP},
				{id='CATA_CRAFT',	n=187, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=2,
				{pid=P_.FRM, 		q=1,	t=M_.PRP},
				{id='COMPOUND2',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRM, 		q=2,	t=M_.PRP},
				{id='MICROCHIP',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRM, 		q=3,	t=M_.PRP},
				{id='ILLEGAL_PROD2',n=1, 	t=M_.PRD},
			},
			-- freighter explore
			{
				f=R_MultiItem,
				c=5,
				{pid=P_.FRE, 		q=0,	t=M_.PRP},
				{id='CARBON_SEAL',	n=187, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=2,
				{pid=P_.FRE, 		q=1,	t=M_.PRP},
				{id='COMPOUND1',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRE, 		q=2,	t=M_.PRP},
				{id='TRA_ENERGY5',	n=1, 	t=M_.PRD},
			},
			{
				f=R_MultiItem,
				c=1,
				{pid=P_.FRE, 		q=3,	t=M_.PRP},
				{id='ILLEGAL_PROD1',n=1, 	t=M_.PRD},
			}
		}
	},
	{
	---	explorer freighter defense battle ---
		id			= 'FREIGHTERSAVE_E',
		choice		= C_.ALL,
		rewardlist	= {
			{
				--id				Amount	type
				{id='HYPERFUEL1',	n=1, 	t=M_.PRD},	-- Hyperdrive fuel
				{id='SCRAP_TECH',	n=1, 	t=M_.PRD},
				{id='FREI_INV_TOKEN',n=1, 	t=M_.PRD},	-- freighter inv slot
				{id='ASTEROID3',	n=169, 	t=M_.SBT},	-- Platinum
				{pid=P_.SPB,		q=1,	t=M_.PRP},	-- Space Bones Procedural
				c=100,
				f=R_MultiItem
			},
			{id=U_.HG, n=50, x=60, c=100, f=R_Money},
		}
	},
	{
	---	trader freighter defense battle ---
		id			= 'FREIGHTERSAVE_T',
		choice		= C_.ALL,
		rewardlist	= {
			{
				--id				Amount	type
				{id='HYPERFUEL1',	n=1, 	t=M_.PRD},
				{id='GEODE_RARE',	n=1, 	t=M_.PRD},
				{id='FREI_INV_TOKEN',n=1, 	t=M_.PRD},
				{id='ASTEROID1',	n=523, 	t=M_.SBT},	-- silver
				{pid=P_.SLV,		q=1,	t=M_.PRP},	-- Salvage Procedural
				c=100,
				f=R_MultiItem
			},
			{id=U_.UT, n=35100, x=50200, c=100, f=R_Money},
		}
	},
	{
	---	warior freighter defense battle ---
		id			= 'FREIGHTERSAVE_W',
		choice		= C_.ALL,
		rewardlist	= {
			{
				--id				Amount	type
				{id='HYPERFUEL1',	n=1, 	t=M_.PRD},
				{id='SCRAP_WEAP',	n=1, 	t=M_.PRD},
				{id='FREI_INV_TOKEN',n=1, 	t=M_.PRD},
				{id='ASTEROID2',	n=387, 	t=M_.SBT},	-- gold
				{pid=P_.DTC,		q=1,	t=M_.PRP},
				c=100,
				f=R_MultiItem
			},
			{id=U_.NN, n=190, x=270, c=100, f=R_Money},
		}
	},
	{
	---	pirate attack loot - easy level ---
		id			= 'PIRATELOOT_EASY',
		choice		= C_.ONE_S,
		rewardlist	= {
			--id					Min		Max		%		function
			{id='SHIPCHARGE',				x=1,	c=80,	f=R_Product},
			{id='TRA_ALLOY1',		n=1,	x=2,	c=40,	f=R_Product},
			{id='TRA_ENERGY1',		n=1,	x=2,	c=40,	f=R_Product},
			{id='TRA_EXOTICS1',		n=1,	x=2,	c=40,	f=R_Product},
			{id='ILLEGAL_PROD3',	n=1,	x=2,	c=40,	f=R_Product},
			{id=P_.DBI,				r=R_.C,			c=30,	f=R_Procedural},
			{id=P_.DTC,				r=R_.C,			c=30,	f=R_Procedural},
			{id=U_.UT,				n=18000,x=30000,c=80,	f=R_Money}
		}
	},
	{
	---	pirate attack loot - normal level ---
		id			= 'PIRATELOOT',
		choice 		= C_.ONE_S,
		zeroseed 	= true,
		replacement	= true,
		rewardlist	= {
			--id					Min		Max		%		function
			{id='SHIPCHARGE',		n=1,	x=2,	c=80,	f=R_Product},
			{id='SCRAP_GOODS',				x=1,	c=90,	f=R_Product},
			{id='SCRAP_TECH',				x=1,	c=90,	f=R_Product},
			{id='SCRAP_WEAP',				x=1,	c=90,	f=R_Product},
			{id='TRA_ALLOY3',		n=1,	x=3,	c=40,	f=R_Product},
			{id='TRA_ENERGY3',		n=1,	x=3,	c=40,	f=R_Product},
			{id='TRA_COMPONENT3',	n=1,	x=3,	c=40,	f=R_Product},
			{id='TRA_MINERALS3',	n=1,	x=3,	c=40,	f=R_Product},
			{id='ILLEGAL_PROD4',	n=1,	x=2,	c=30,	f=R_Product},
			{id='AF_METAL',			n=100,	x=130,	c=30,	f=R_Substance},
			{id=P_.DBI,				o=true,	r=R_.U,	c=30,	f=R_Procedural},
			{id=P_.DTC,				o=true,	r=R_.U,	c=30,	f=R_Procedural},
			{id=U_.NN,				n=100,	x=250,	c=100,	f=R_Money}
		}
	},
	{
	---	 pirate attack loot - hard level ---
		id			= 'PIRATELOOT_HARD',
		choice		= C_.ONE_S,
		zeroseed	= true,
		rewardlist	= {
			--id					Min		Max		%		function
			{id='SHIPCHARGE',		n=1,	x=3,	c=80,	f=R_Product},
			{id='WATER2',			n=260,	x=360,	c=40,	f=R_Substance},
			{id='EX_GREEN',			n=150,	x=250,	c=40,	f=R_Substance},
			{id='EX_BLUE',			n=120,	x=220,	c=40,	f=R_Substance},
			{id='AF_METAL',			n=110,	x=180,	c=40,	f=R_Substance},
			{id='SCRAP_GOODS',				x=1,	c=40,	f=R_Product},
			{id='SCRAP_TECH',				x=1,	c=40,	f=R_Product},
			{id='SCRAP_WEAP',				x=1,	c=40,	f=R_Product},
			{id='TRA_ENERGY4',		n=1,	x=3,	c=50,	f=R_Product},
			{id='TRA_ALLOY4',		n=1,	x=3,	c=50,	f=R_Product},
			{id='TRA_EXOTICS4',		n=1,	x=3,	c=50,	f=R_Product},
			{id='TRA_TECH4',		n=1,	x=3,	c=50,	f=R_Product},
			{id='ILLEGAL_PROD5',	n=1,	x=2,	c=30,	f=R_Product},
			{id='GEODE_RARE',				x=1,	c=20,	f=R_Product},
			{id=P_.DBI,				o=true,	r=R_.U,	c=20,	f=R_Procedural},
			{id=P_.DTC,				o=true,	r=R_.U,	c=20,	f=R_Procedural},
			{id=U_.NN,				n=300,	x=400,	c=100,	f=R_Money}
		}
	},
	{
	---	 pirate attack loot - building raid ---
		id			= 'RAIDLOOT',
		choice		= C_.ONE_S,
		rewardlist	= {
			--id					Min		Max		%		function
			{id='SHIPCHARGE',				x=1,	c=80,	f=R_Product},
			{id='SCRAP_GOODS',				x=1,	c=40,	f=R_Product},
			{id='SCRAP_TECH',				x=1,	c=40,	f=R_Product},
			{id='ILLEGAL_PROD2',	n=1,	x=4,	c=30,	f=R_Product},
			{id='WATER2',			n=260,	x=280,	c=30,	f=R_Substance},
			{id='GEODE_RARE',				x=1,	c=20,	f=R_Product},
			{id=P_.DBI,				o=true,	r=R_.U,	c=20,	f=R_Procedural},
			{id=P_.DTC,				o=true,	r=R_.U,	c=20,	f=R_Procedural},
			{id=U_.UT,				n=25000,x=35000,c=80,	f=R_Money}
		}
	},
	{
	---	jetpack boost from tech plant ---
		id			= 'JETPACK_BOOST',
		choice		= C_.ALL,
		replacement	= true,
		rewardlist	= {
			{id='jetboost',		t=5,	b=1.25,	c=100,	f=R_Jetboost}
		}
	},
	{
	---	health + shield + stamina + hazard + jetboost = balatant cheat! ---
		id			= 'HEALTH_MAJOR',
		choice		= C_.ALL_S,
		rewardlist	= {
			{id='health',		n=3,	x=5,	c=100,	f=R_Health},
			{id='shield',		n=70,	x=100,	c=100,	f=R_Shield},
			{id='hazard',		z=80,			c=100,	f=R_Hazard},
			{id='stamina',		t=6,			c=100,	f=R_Stamina},
			{id='jetboost',		t=4,	b=1.2,	c=100,	f=R_Jetboost}
		}
	},
	{
	---	test reward ---
		id			= 'TEST_99',
		unused		= true,
		choice		= C_.ONE,
		rewardlist	= {
			-- id					details			%		function
			{id='no_sentinels',		t=20,			c=90,	f=R_NoSentinels},
			{id='flyby',			t=5,			c=95,	f=R_FlyBy},
			{id='wanted_level',		w=0,			c=50,	f=R_Wanted},
			{id='ROGUE_HAZBOX',				x=1,	c=10,	f=R_Product},
			{id='UT_SHIPLAS',				x=1,	c=10,	f=R_Product},
			{id=P_.FOS,				r=R_.R,			c=10,	f=R_Procedural},
			{id=P_.SPH,				r=R_.U,			c=10,	f=R_Procedural},
			{id='SCRAP_WEAP',				x=1,	c=10,	f=R_Product},
			{id='STEALTH',			s=true,			c=10,	f=R_Technology},
			{id='ACCESS1',			s=true,			c=10,	f=R_ProductRecipe},
			{id={'ALLOY7','ALLOY8'},n=2,	x=5,	c=2,	f=R_ProductSysList},
			{id={'ALLOY4','ALLOY5'},				c=2,	f=R_ProductAllList},
			{id=U_.NN,				n=101,	x=202,	c=100,	f=R_Money}
		}
	}
}

-- loop through the rewards list and return the generated exml
local function AddNewRewardsToChangeTable()
	local T = {}
	T[1] = {
		FSKWG	= {},
		REMOVE	= 'Section'
	}
	local rewards = {}
	for _,rwd in ipairs(new_rewards) do
		-- collect exisitng rewards to be removed in FSKWG
		if not rwd.unused then
			if rwd.replacement then
				T[1].FSKWG[#T[1].FSKWG+1] = {'Id', rwd.id}
			end
			rewards[#rewards+1] = R_RewardTableEntry(rwd)
		end
	end
	-- remove FSKWG if none added
	if #T[1].FSKWG <= 0 then T[1] = nil end

	T[#T+1] = {
		PRECEDING_KEY_WORDS	= 'GenericTable',
		ADD					= ToExml(rewards)
	}
	return T
end

NMS_MOD_DEFINITION_CONTAINER = {
	MOD_FILENAME 		= '_TEST L2E add replace rewards.pak',
	MOD_AUTHOR			= 'lMonk',
	NMS_VERSION			= '4.38',
	MOD_DESCRIPTION		= mod_desc,
	MODIFICATIONS 		= {{
	MBIN_CHANGE_TABLE	= {
	{
		MBIN_FILE_SOURCE	= 'METADATA/REALITY/TABLES/REWARDTABLE.MBIN',
		EXML_CHANGE_TABLE	= AddNewRewardsToChangeTable()
	}
}}}}
