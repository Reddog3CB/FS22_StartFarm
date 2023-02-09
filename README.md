# FS22_StartFarm

Pick your start farm allows map makers to create customisable and tailored starting presets for players, with individual starting funds depending on economic difficulty.

Set up

You must create an xml file in EITHER;
the YOURMOD/maps folder
the YOURMOD/maps/xml folder

This xml must have the following structure:

<?xml version="1.0" encoding="utf-8" standalone="no" ?>
<RDM_StartFarm>	
        <farm header="FenEdge_startfarm_1_header" description="FenEdge_startfarm_1_description" image1="startFarm/pic1a.dds" image2="startFarm/pic1b.dds">
            <items>xml/Map_items1.xml</items>
            <vehicles>startFarm/vehicles1.xml</vehicles>
            <money1>1000000</money1>
            <money2>500000</money2>
            <money3>200000</money3>
        </farm>
        <farm header="FenEdge_startfarm_2_header" description="FenEdge_startfarm_2_description" image1="startFarm/pic2a.dds" image2="startFarm/pic2b.dds">
            <items>xml/Map_items1.xml</items>
            <vehicles>startFarm/vehicles2.xml</vehicles>
            <money1>200000</money1>
            <money2>100000</money2>
            <money3>5000</money3>
            <farmlands>
                <farmland>254</farmland>
                <farmland>2</farmland>
                <farmland>1</farmland>
            </farmlands>
        </farm>

Headers and Descriptions should be done via $l10n_ to work correctly

Money 1 is Easy difficulty, 2 normal and 3 hard.

Farmlands are the farmland id's relating to the land. Any placeables on those lands should be set with the xml "boughtWithFarmland=true" property in their xml.

Vehicles xml should be in the savegame vehicles.xml format (an easy way to set your vehicles up is to load the game with EDC, buy as many vehicles as you need and place them, save and use that as the base for the individual farm saves.
