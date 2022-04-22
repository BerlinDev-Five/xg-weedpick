Config = {}

Config.Locale = 'en'

Config.Delays = {
	WeedProcessing = 1000 * 2
}

Config.Pricesell = 750

Config.MinPiecesWed = 1

Config.DrugDealerItems = {
	empty_weed_bag = 91
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 

Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	WeedField = {coords = vector3(278.5, 4383.7, 47.06), name = 'blip_weedfield', color = 25, sprite = 496, radius = 100.0},
	WeedProcessing = {coords = vector3(2328.66, 2572.17, 46.90), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	DrugDealer = {coords = vector3(-1164.92, -1566.67, 3.45), name = 'blip_drugdealer', color = 6, sprite = 378, radius = 25.0},
}

Config.Locations = {
    ["weed"] = {
        [1] = vector4(278.5, 4383.7, 47.06, 266.8),
    },
}	