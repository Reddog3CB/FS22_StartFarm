
startFarmScreen = {}

local startFarmScreen_mt = Class(startFarmScreen, ScreenElement)
--local startFarmScreen_mt = Class(startFarmScreen, TabbedMenu)

startFarmScreen.CONTROLS = {

		TITLE = "title",
		FARM_ID = "farm_id",
		FARM_HEADER = "farmHeader",
		MONEY = "money",
		DESCRIPTION = "description",
		BUTTON = "buttonOK",
		PIC1 = "pic1",
		PIC2 = "pic2",
		YARD = "yardSize",
		FARM_SIZE = "farmSize",
		TOTAL = "totalSize"
	}



function startFarmScreen:new()
	
	local self = ScreenElement.new(nil, startFarmScreen_mt)

	self:registerControls(startFarmScreen.CONTROLS)

	return self
end

function startFarmScreen:onOpen()
	startFarmScreen:superClass().onOpen(self)

		
		local farmIDs = {}
		for i=1, #RDM_StartFarm.startFarms do
			table.insert(farmIDs, tostring(i))
		end
		
		self.farm_id:setTexts(farmIDs)
		
		self.farm_id:setState(1, true)

end

function startFarmScreen:onSelectFarm()


	local selection = self.farm_id:getState()
	RDM_StartFarm.pickedFarm = selection
	RDM_StartFarm:setStartFarmSelection()
	g_gui:showGui("")
end

function startFarmScreen:onClose()
	startFarmScreen:superClass().onClose(self)
end

function startFarmScreen:onFarmSelectChange()
	
	local selection = self.farm_id:getState()

	
	local moneyValue = RDM_StartFarm.startFarms[selection].money
	local descriptionValue = "$l10n_"..RDM_StartFarm.startFarms[selection].description
	descriptionValue = startFarmScreen:getText(descriptionValue)
	local headerValue = RDM_StartFarm.startFarms[selection].header
	headerValue= startFarmScreen:getText(headerValue)

	
	local pica = RDM_StartFarm.MapModDir..RDM_StartFarm.startFarms[selection].imageA
	local picb = RDM_StartFarm.MapModDir..RDM_StartFarm.startFarms[selection].imageB

	if not fileExists(pica) then
		pica = RDM_StartFarm.ModDir.."placeholder.dds"
		
	end
	if not fileExists(picb) then
		picb = RDM_StartFarm.ModDir.."placeholder.dds"
		
	end
	
	local yardValue = 0
	local sizeValue = 0
	local totalValue = 0
	
	yardValue = string.format("%.2f ",startFarmScreen:getSize(selection, "yard"))
	sizeValue = string.format("%.2f ",startFarmScreen:getSize(selection, "farm"))
	local v = startFarmScreen:getValue(selection, "yard")
	yardValue = yardValue.." / "..tostring(v)
	totalValue = v
	v = startFarmScreen:getValue(selection, "farm")
	totalValue = totalValue + v	
	sizeValue = sizeValue.." / "..tostring(v)
	
	self.yardSize:setText(yardValue)
	self.farmSize:setText(sizeValue)
	self.totalSize:setText(totalValue)
	
	
	self.pic1:setImageFilename(pica)
	self.pic2:setImageFilename(picb)
	self.money:setText(moneyValue)
	self.description:setText(descriptionValue)
	self.farmHeader:setText(headerValue)	
	

end

function startFarmScreen:getSize(farmID, selector)
	local size = 0
	local farmlands = {}
	if selector=="yard" then
		table.insert(farmlands,RDM_StartFarm.startFarms[farmID].farmlands[1])
	else
	  for k,v in pairs(RDM_StartFarm.startFarms[farmID].farmlands) do
		if k>1 then
			table.insert(farmlands,v)
		end
	  end
	end

	for k, v in ipairs(farmlands) do
		local farmland = g_farmlandManager:getFarmlandById(v)
		size = size + farmland.areaInHa
	end
	return size
end

function startFarmScreen:getValue(farmID, selector)
	local value = 0

	local farmlands = {}
	if selector=="yard" then
		table.insert(farmlands,RDM_StartFarm.startFarms[farmID].farmlands[1])
	else
	  for k,v in pairs(RDM_StartFarm.startFarms[farmID].farmlands) do
		if k>1 then
			table.insert(farmlands,v)
		end
	  end
	end

	for k, v in ipairs(farmlands) do
		local farmland = g_farmlandManager:getFarmlandById(v)
		value = value + farmland.price
	end
	return value
end

function startFarmScreen:getText(textName)
	if textName ~= nil then
		local text = ""
		if textName:sub(1, 6) == "$l10n_" then
			local subText = textName:sub(7)
			if g_i18n:hasText(subText, RDM_StartFarm.MapMod) then
				text = g_i18n:getText(subText,RDM_StartFarm.MapMod)
			end
		elseif g_i18n:hasText(textName,RDM_StartFarm.MapMod) then
			text = g_i18n:getText(textName,RDM_StartFarm.MapMod)
		end

		if text ~= "" then

			return text
		end


		-- If all fail's and there is no 'backup' we need to provide the default warning so texts are entered correctly by modders. 
		return g_i18n:getText(textName)
	end

	return ""
end