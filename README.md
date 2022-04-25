# xg-weedpick

* Latest QBCoreVersion Supported!

* qb-targed required!



# **!IMPORTANT**

* Make sure to add these in qb-core/client/functions.lua


(And this after Drawtext3d) 

```lua
QBCore.Functions.Draw2DText = function(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
```



(This at the Bottom)

```lua
QBCore.Functions.SpawnObject = function(model, coords, cb)
    local model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
        RequestModel(model)
        local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
        SetModelAsNoLongerNeeded(model)

        if cb then
            cb(obj)
        end
    end)
end
```
```lua
QBCore.Functions.SpawnLocalObject = function(model, coords, cb)
    local model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
        RequestModel(model)
        local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
        SetModelAsNoLongerNeeded(model)

        if cb then
            cb(obj)
        end
    end)
end
```
```lua
QBCore.Functions.DeleteObject = function(object)
    SetEntityAsMissionEntity(object, false, true)
    DeleteObject(object)
end
```

**!IMPORTANT**

* Paste this code in qb-target/init.lua 

* Config.BoxZones 

```lua
   ["weedpro"] = {
    name = 'weedpro',
	coords = vector3(2328.57, 2570.7, 46.68),
	length = 1.6,
	width = 1,
	heading = 60,
	debugPoly = false,
  minZ=43.08,
  maxZ=47.08,
          options = {
            {
                type = "client",
                event = "weed:process",
                icon = "fas fa-leaf",
                label = "Processing Weed",
            },
		},	
	distance = 2.5,	 
},
```

* Paste this code in qb-target/init.lua 

* Config.TargetModels

```lua
    ['weedpick'] = {
        models = `prop_weed_02`,
        options = {
            {
                type = "client",
                event = "weed:collect", 
                icon = "fas fa-cannabis",
                label = "Picking Weed",
                --price = 5,
            },
        },
        distance = 2.5
    },

    ["weedsell"] = {
        models = {
            "g_m_y_mexgang_01", 
        },
        options = {
            {
                type = "client",
                event = "weed:sell",
                icon = "fas fa-cannabis",
                label = "Sell WeedBag",
            },
        },
        distance = 2.5,
    },
```	

* Paste this code in qb-target/init.lua 

* Config.Peds

```lua
    { 
	model = `g_m_y_mexgang_01`, 
	coords = vector4(-1164.92, -1566.67, 3.45, 307.22),
	gender = 'male',
	freeze = true,
	invincible = true,
	blockevents = true,
},
```

Enjoy

**Any issue related this script contact me on my discord server
Join our Framework**
Discord: https://discord.gg/Nh8WscE6ck
