--[[
	TitanGarrisonResources: A simple Display of current Garrison Resources value as a percent
	Author: Blakenfeder
	
	Based on addon "Titan Panel [Honor Points]" by subwired.
--]]

-- Default translations (enUS)
local L = {}
L["buttonLabel"] = "Resources: "
L["tooltipTitle"] = "Garrison Resources"
L["tooltipDescription"] = "Earn resources to build-up and\rexpand your garrison."
L["tooltipCountLabel"] = "Total Maximum: "

local menutext = "Titan|cffff8800 "..L["tooltipTitle"].."|r"
local ID = "GR"
local elap, currencyCount = 0, 0.0
local currencyMaximum

-- Main button frame and addon base
local f = CreateFrame("Button", "TitanPanelGRButton", CreateFrame("Frame", nil, UIParent), "TitanPanelComboTemplate")
f:SetFrameStrata("FULLSCREEN")
f:SetScript("OnEvent", function(this, event, ...) this[event](this, ...) end)
f:RegisterEvent("ADDON_LOADED")


function f:ADDON_LOADED(a1)
--print ("a1 = " .. a1)
	if a1 ~= "TitanGarrisonResources" then -- needs to be the name of the folder that the addon is in
	return 
	end
	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
	
	-- Set different translations if needed
	if GetLocale() == "esMX" then
		L["buttonLabel"] = "Recursos: "
		L["tooltipTitle"] = "Recursos de la fortaleza"
		L["tooltipDescription"] = "Gana recursos para reforzar y expandir\rtu fortaleza."
		L["tooltipCountLabel"] = "Máximo total: "
	end

	local name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, unknown
	local i = 0
	local CurrencyIndex = 0
	local myicon = "Interface\\Icons\\inv_garrison_resource.blp"
	local mycheck = "Interface\\Icons\\Inv_Garrison_Resource"

	self.registry = {
		id = ID,
		menuText = menutext,
		buttonTextFunction = "TitanPanelGRButton_GetButtonText",
		tooltipTitle = L["tooltipTitle"],
		tooltipTextFunction = "TitanPanelGRButton_GetTooltipText",
		frequency = 2,
		icon = myicon,
		iconWidth = 16,
		category = "Information",
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = false,

		},
	}
	self:SetScript("OnUpdate", function(this, a1)
		elap = elap + a1
		if elap < 1 then return end

		for i = 1, GetCurrencyListSize(), 1 do
			
			name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, unknown = GetCurrencyListInfo(i)
			
			if string.lower(tostring(icon)) == string.lower(mycheck) then
				CurrencyIndex = i
			end
			
		end
		
		name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, unknown = GetCurrencyListInfo(CurrencyIndex)

		 currencyCount = count
		currencyMaximum = maximum
		
		TitanPanelButton_UpdateButton(ID)
		elap = 0
	end)
		
	--TitanPanelButton_OnLoad(self)
end



----------------------------------------------
function TitanPanelGRButton_GetButtonText()
----------------------------------------------
	local currencyCountText
	if not currencyCount then
		currencyCountText = TitanUtils_GetHighlightText("??")
	else	
		currencyCountText = TitanUtils_GetHighlightText(string.format("%.0f", currencyCount) .."")
	end
	return L["buttonLabel"], currencyCountText
end

-----------------------------------------------
function TitanPanelGRButton_GetTooltipText()
-----------------------------------------------

return L["tooltipDescription"].."\r                                                                     \r"..L["tooltipCountLabel"]..TitanUtils_GetHighlightText(currencyCount.."/"..currencyMaximum)

end

local temp = {}
local function UIDDM_Add(text, func, checked, keepShown)
	temp.text, temp.func, temp.checked, temp.keepShownOnClick = text, func, checked, keepShown
	UIDropDownMenu_AddButton(temp)
end
----------------------------------------------------
function TitanPanelRightClickMenu_PrepareGRMenu()
----------------------------------------------------
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[ID].menuText)
	
	TitanPanelRightClickMenu_AddToggleIcon(ID)
	TitanPanelRightClickMenu_AddToggleLabelText(ID)
	TitanPanelRightClickMenu_AddSpacer()
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, ID, TITAN_PANEL_MENU_FUNC_HIDE)
end