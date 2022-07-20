--[[-------------------------------------------------------------------------
Read me first!
---------------------------------------------------------------------------]]
--[[
	Its important to test your slot machines to make sure they fit with your economy.
	Settings the chance to high can and will ruin it if you dont have it configured properly.

	To save slots you simple type !saveslots, to remove them just remove them from the map and do !saveslots again.

	If you have any questions please open a support ticket and i'll answer as soona I see it

	Thanks for purchasing, enjoy your slots :)

	The WORKSHOP link is here : http://steamcommunity.com/sharedfiles/filedetails/?id=1174019751

	These commands disable or enable the screen (client side)
	bdor_disable_screens
	bdor_enable_screens
]]

--Just leave this here, you dont need to change it
BDON_CONFIG = {}

--This is the base bet amount. Change this how you please, the winnings scale with it (except for jackpot)
BDON_CONFIG.bet = 500 

--This is the minimum the jackpot can be (its random)
BDON_CONFIG.minJackpot = 500000
 
--This is the maximum the jackpot can be (its random between min-max)
BDON_CONFIG.maxJackpot = 1000000

--This is the chance that the next double is either a double or nothing. the highter the number the higher the chance (% between 0 and 100)
BDON_CONFIG.doubleChance = 40 --(50 is recommened, but if you think there winning jackpot to much then lower this number, or raise it its your server :)

--This is a list of usergroups that can save/edit the machines (!saveslots)
BDON_CONFIG.AdminRanks = {
	"superadmin",
	"admin",
	"owner",
	"any other ranks you want, add them here"
}

--If the sounds are too loud, you can change this. It is between 0 and 1
BDON_CONFIG.Volume = 1

--You can change money Method
	--DRP = DarkRP Money System
	--PS1 = PointShop1 Money
	--PS2 = PointShop2 Money
	--PPS2 = Premium PointShop2 Money
	--CSM = Custom Money System (Use all override functions in bottom of this file)
	--FREE = No Money (Just for fun)

BDON_CONFIG.Curreny = "PS2"

--You can change this to anything, or thing. This gets added before any money amount is shown
BDON_CONFIG.CurrenyPrefixBefore = ""
BDON_CONFIG.CurrenyPrefixAfter = "PTS"

--[[-------------------------------------------------------------------------
Custom Money Method
---------------------------------------------------------------------------]]

BDON_CONFIG.custom = {}

BDON_CONFIG.custom.addMoney = function(ply, amount)
	
end

BDON_CONFIG.custom.canAfford = function(ply, amount)
	return true
end

BDON_CONFIG.custom.takeMoney = function(ply, amount)
	
end




--[[-------------------------------------------------------------------------
Money Method (!! DON'T CHANGE THIS !!)
---------------------------------------------------------------------------]]

BDON_CONFIG.addMoney = function(ply, amount)
	local c = BDON_CONFIG.Curreny
	if(c == "DRP") then
		ply:addMoney(amount)
	elseif(c == "PS1") then
		ply:PS_GivePoints(amount)
	elseif(c == "PS2") then
		ply:PS2_AddStandardPoints(amount)
	elseif(c == "PPS2") then
		ply:PS2_AddPremiumPoints(amount)
	elseif(c == "CSM") then
		BDON_CONFIG.custom.addMoney(ply,amount)
	end
end

BDON_CONFIG.canAfford = function(ply, amount)
	local c = BDON_CONFIG.Curreny
	if(c == "DRP") then
		return ply:canAfford(amount)
	elseif(c == "PS1") then
		return ply:PS_HasPoints(amount)
	elseif(c == "PS2") then
		return ply.PS2_Wallet.points - amount >= 0
	elseif(c == "PPS2") then
		return ply.PS2_Wallet.premiumPoints - amount >= 0
	elseif(c == "CSM") then
		return BDON_CONFIG.custom.canAfford(ply,amount)
	end
	return true
end

BDON_CONFIG.takeMoney = function(ply, amount)
	local c = BDON_CONFIG.Curreny
	if(c == "DRP") then
		ply:addMoney(amount * -1)
	elseif(c == "PS1") then
		ply:PS_TakePoints(amount)
	elseif(c == "PS2") then
		ply:PS2_AddStandardPoints(-amount)
	elseif(c == "PPS2") then
		ply:PS2_AddPremiumPoints(-amount)
	elseif(c == "CSM") then
		BDON_CONFIG.custom.takeMoney(ply,amount)
	end
end

BDON_CONFIG.showMoney = function(amount)

	local f = amount
	while true do   
	   	f, k = string.gsub(f, "^(-?%d+)(%d%d%d)", '%1,%2')
	   	if (k==0) then
			break 
		end
	end

	if(BDON_CONFIG.Curreny == "FREE") then f = "0" end

	return string.format("%s%s%s",BDON_CONFIG.CurrenyPrefixBefore,f,BDON_CONFIG.CurrenyPrefixAfter)
end


