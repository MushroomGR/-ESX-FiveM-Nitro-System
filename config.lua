Config = {}
Config.mechanicjob  = false -- turn this to true if you want only mechanics to be able to install nitro to cars inside ls customs and with the mechanic item you put bellow.If you keen this false everyone will be able to install nitro to owned cars but only on spots you put on zones.
Config.mechanicitem = 'blowpipe'
Config.Zones = {
				{
				title = "Example Spot",                                                                                                                                                            
				mapBlipId = 315,                                                            
				mapBlipColor = 61,                                                           
				spot = {x= 817.52, y = -2920.29, z= 5.21},
				radius = 25,
				},
								{
				title = "Example Spot 2",                                                                                                                                                            
				mapBlipId = 315,                                                            
				mapBlipColor = 61,                                                           
				spot = {x= 220.99 , y = -851.99 , z= 29.51},
				radius = 25,
				},
				}
Config.UseoxMYSQL = true -- change this to false if you are using the old mysql-async plugin
