# FS22_StartFarm

Pick your start farm allows map makers to create customisable and tailored starting presets for players, with individual starting funds depending on economic difficulty.

#### Set up

You must create an xml file in EITHER;
the YOURMOD/maps folder
the YOURMOD/maps/xml folder

An example xml for a single farm.
```xml
<?xml version="1.0" encoding="utf-8" standalone="no" ?>
<RDM_StartFarm>	
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
</RDM_StartFarm>	     
```
#### XML TAGS
##### header
This is the title/name of the farm and should be relatively short - "Manthorpe Farm" or "Pig farming". Ideally this should be done through a language entry in either modDesc or a separate $l10n file

##### description
This is a more narrative description of the starting location and conditions and can be much more verbose than the header.Ideally this should be done through a language entry in either modDesc or a separate $l10n file

##### image1 & image2
This is the path to an image within your mod. Pics should be dds format, and square ^2 but the actual size of the frame is 512 x 512px. I have used an ingame view and a map view to show the land to be owned and it's location but you can use any image you wish.

##### money1, money2 & money3
Money 1 is for easy difficulty, 2 normal and 3 hard. You may use a negative, in which case the player will start with a negative balance, NOT with a loan.

##### farmlands
This tag must enclose any number of "farmland" tags, each farmland tag should be the farmland id's relating to the land. Any placeables on those lands should be set with the xml "boughtWithFarmland=true" property in their xml to enable ownership to be assigned.

##### vehicles
This is a file path to a vehicles xml within your mod. The vehicles xml should be in the savegame vehicles.xml format (an easy way to set your vehicles up is to load the game with EDC, buy as many vehicles as you need and place them, save and use that as the base for the individual farm saves.

##### items
This is a file path to a placeables xml within your mod. This should be used when you want a starting farm to have placeables that otherwise would not be on the map. For example I have used it to give farm silos to lands on Elmcreek that do not have them normally.
