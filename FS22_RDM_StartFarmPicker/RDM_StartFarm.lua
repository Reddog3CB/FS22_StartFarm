--[[
Pick your starting farm from map enabled xml

Author:     Reddog
Version:    1.0.0
Modified:   2023-02-9

Changelog:

]]


RDM_StartFarm = Mod:init()
RDM_StartFarm.HasRun = false
RDM_StartFarm.startFarms = {}
RDM_StartFarm.ModDir = g_currentModDirectory
RDM_StartFarm.difficulty = 0
RDM_StartFarm.pickedFarm = 0
RDM_StartFarm.UpdateTime = 0
RDM_StartFarm.ShowGUI = true
RDM_StartFarm.MapMod = ""
RDM_StartFarm.MapModDir = ""
RDM_StartFarm.CanRun = true


function RDM_StartFarm:beforeStartMission()
	RDM_StartFarm:checkStartFarmSaveFile()

	RDM_StartFarm.MapMod = g_currentMission.missionInfo.customEnvironment

	if g_currentMission.missionInfo.mapXMLFilename == "$data/maps/mapUS/map.xml" then
		RDM_StartFarm.MapModDir = RDM_StartFarm.ModDir.."elmcreek/"
		
	else
	
		RDM_StartFarm.MapModDir = g_currentMission.missionInfo.baseDirectory.."maps/"
	end
		
	RDM_StartFarm.difficulty = g_currentMission.missionInfo.economicDifficulty
	if RDM_StartFarm.HasRun then

	else

		RDM_StartFarm:readStartFarmXML()

	end
	
end

function RDM_StartFarm:readStartFarmXML()
	local fileFound = false
	local xmlPath = RDM_StartFarm.MapModDir .. "startingFarms.xml"

	if not fileExists(xmlPath) then
		xmlPath = RDM_StartFarm.MapModDir .. "xml/startingFarms.xml"
		if fileExists(xmlPath) then
			fileFound = true
		end
	else
		fileFound = true
	end

	if fileFound then
		local xmlFile = loadXMLFile("startingFarms", xmlPath)


		if hasXMLProperty(xmlFile, "RDM_StartFarm") then                
			local i = 0
			while true do
				local key = string.format("RDM_StartFarm.farm(%d)", i)
				if not hasXMLProperty(xmlFile, key) then
					break
				end

		local fmoney = 0 
		if RDM_StartFarm.difficulty ==1 then 
			fmoney = getXMLInt(xmlFile, key .. ".money1")
		elseif RDM_StartFarm.difficulty == 2 then
			fmoney = getXMLInt(xmlFile, key .. ".money2")
		else
			fmoney = getXMLInt(xmlFile, key .. ".money3")
		end

				local farm = {
					header = Utils.getNoNil(getXMLString(xmlFile, key .. "#header"), string.format("Header %s", i+1)),
					description = Utils.getNoNil(getXMLString(xmlFile, key .. "#description"), string.format("Description %s", i+1)),
					imageA = getXMLString(xmlFile, key .. "#image1"),
					imageB =getXMLString(xmlFile, key .. "#image2"),
					xmlItems =getXMLString(xmlFile, key .. ".items"),
					xmlVehicles =getXMLString(xmlFile, key .. ".vehicles"),
					money = fmoney,
				}

				farm.farmlands = {}
				local j = 0
				while true do
					local key2 = string.format("%s.farmlands.farmland(%d)", key, j)    
					if not hasXMLProperty(xmlFile, key2) then
						break
					end    
					table.insert(farm.farmlands, getXMLInt(xmlFile, key2))
					j = j + 1
				end           

				table.insert(RDM_StartFarm.startFarms, farm)                
				i = i + 1
			end
		else
			Log:error("XML File has not got the correct tags in it")
			RDM_StartFarm.CanRun=false
		end
	else
		Log:error("No XML file can be found")
		RDM_StartFarm.CanRun=false
	end
end

function RDM_StartFarm:checkStartFarmSaveFile()

	if g_currentMission.missionInfo.savegameDirectory ==nil then
		
	else
		RDM_StartFarm.HasRun = true
		RDM_StartFarm.CanRun=false
	end

end

function RDM_StartFarm:setStartFarmSelection()

	RDM_StartFarm:resetDefaultStart()

	if RDM_StartFarm.pickedFarm >0 then
		
		local farm = RDM_StartFarm.startFarms[RDM_StartFarm.pickedFarm]
		local farmlands = farm.farmlands
		local money = farm.money
		local existingMoney = g_currentMission:getMoney(1)
		g_currentMission:addMoney(existingMoney*-1, 1, MoneyType.TRANSFER, true)
		g_currentMission:addMoney(money, 1, MoneyType.TRANSFER, true)
		for _,farmlandId in pairs(farmlands) do
			g_farmlandManager:setLandOwnership(farmlandId, 1)
		end
		RDM_StartFarm:loadVehicles(RDM_StartFarm.pickedFarm)
		RDM_StartFarm:loadPlaceables(RDM_StartFarm.pickedFarm)
	else
		Log:error("Something's gone wrong!")
	end
end

function RDM_StartFarm:openGUI()
	if RDM_StartFarm.CanRun then
		source(RDM_StartFarm.ModDir .. 'gui/startFarmScreen.lua')
		g_startFarmScreen = startFarmScreen.new(nil, nil, g_messageCenter, g_i18n, g_inputBinding)
		g_gui:loadGui(RDM_StartFarm.ModDir .. 'xml/startFarmGUI.xml', 'StartFarmScreen', g_startFarmScreen)

		g_uiDebugEnabled = true

		g_gui:showGui('StartFarmScreen')
	end

end

function RDM_StartFarm:update(dt)

	if not g_gui:getIsGuiVisible() and RDM_StartFarm.CanRun and RDM_StartFarm.ShowGUI then
			RDM_StartFarm.ShowGUI = false
			RDM_StartFarm:openGUI()
	end

end

function RDM_StartFarm:loadVehicles(farmID)

	if RDM_StartFarm.startFarms[farmID].xmlVehicles~=nil then

	local xmlFilename = RDM_StartFarm.MapModDir .. RDM_StartFarm.startFarms[farmID].xmlVehicles

		if fileExists(xmlFilename) then
			
			local xmlFile = XMLFile.load("VehiclesXML", xmlFilename, Vehicle.xmlSchemaSavegame)
			VehicleLoadingUtil.loadVehiclesFromSavegame(xmlFilename, false, g_currentMission.missionInfo, g_currentMission.missionDynamicInfo, RDM_StartFarm.loadVehiclesFinished, nil, nil)
		else
			Log:error("Vehicle File cannot be found")
		end
	end
end

function RDM_StartFarm:loadVehiclesFinished()
	
end

function RDM_StartFarm:resetDefaultStart()

	local farmlands = g_farmlandManager:getOwnedFarmlandIdsByFarmId(1)
		for _,farmlandId in pairs(farmlands) do
			g_farmlandManager:setLandOwnership(farmlandId, FarmlandManager.NO_OWNER_FARM_ID)
		end	
	
	for i=#g_currentMission.vehicles,1,-1  do
		
		local vehicle = g_currentMission.vehicles[i]
		local rootvehicle = vehicle:getRootVehicle()
		if rootvehicle~=nil then
			if rootvehicle:getFullName():find("Locomotive") then
			
			else
				g_currentMission:removeVehicle(vehicle)
			end
		end		
	end
end

function RDM_StartFarm:loadPlaceables(farmID)

	if RDM_StartFarm.startFarms[farmID].xmlItems~=nil then

	local xmlFilename = RDM_StartFarm.MapModDir .. RDM_StartFarm.startFarms[farmID].xmlItems

		if fileExists(xmlFilename) then
			

			g_currentMission.placeableSystem:load(xmlFilename,xmlFilename, g_currentMission.missionInfo, g_currentMission.missionDynamicInfo, nil, nil, nil)

		else
			Log:error("Placeable File cannot be found")
		end
	end
end
