/* Briefing
 * The briefing can be defined by calling FHQ_TT_addBriefing.
 * The array is built like this.
 * The first element should be a filter (side, group, faction, or a piece of script). All units matching the 
 * filter will see the briefing
 * This is followed by pairs of strings, a head line, and an actual text.
 * Briefings are added in the order in which they appear for any unit that matches
 * the last filter.
 */
[
	{true}, 
		["Mission",
			"<marker name='perditus_start'>Perditus</marker> and <marker name='derelictus_start'>Derelictus</marker> will destroy the <marker name='obj1'>Bluking</marker> and <marker name='obj2'>Vrana</marker> teams' go-karts, and eliminate the <marker name='obj3'>reporters</marker> and the <marker name='obj4'>Redstone team manager</marker> before disappearing <marker name='obj5'>west</marker>."],
			
		["Situation",
			"January 3rd 2025: the annual go-kart world championship event has taken place on Altis today. The drivers' quarters and service point is located in the abandoned town of Oreokastro and the drivers have been taken on a tour of the nearby castle ruins. PMC Versus local high command (callsign 'Corona') has tasked two Versus teams (callsigns '<marker name='perditus_start'>Perditus</marker>' and '<marker name='derelictus_start'>Derelictus</marker>') to sneak into Oreokastro while the drivers are away and make sure this is the last go-kart event in Altian history.<br/><br/>Perditus and Derelictus are to destroy the go-karts before the distribution of prizes later this afternoon. Corona has designated the <marker name='obj1'>Bluking</marker> and <marker name='obj2'>Vrana</marker> teams' go-karts as targets, as well as the <marker name='obj4'>Redstone team's manager</marker>. Corona also wants the Versus operators to try and eliminate at least two of the press <marker name='obj3'>reporters</marker> residing in the chapel. This will surely attract world wide media coverage on the volatile nature of Altis' current status.<br/><br/>As always, time is of the essence. While the AAF forces have taken responsibility of securing the event, the local AAF troops in Oreocastro are spread thin as half of the forces are guarding Oreocastro and the other half the drivers at the ruins. The AAF helicopters are already transporting an additional security detail from the Gulf and Corona estimates around 10 minutes before they arrive."],

		["Enemy",
			"The AAF have positioned approximately 10-20 foot mobiles with standard military equipment in Oreokastro. PMC Versus operators are again at disadvantage since the high quality equipment hidden in southern Altis has not been recovered yet. On the other hand, Corona has managed to repair the offroad vehicles. Versus operators are to use the offroads' fire power to quickly overwhelm the AAF forces in Oreokastro, and - if need be - ambush the AAF QRF before quickly disappearing west of the AO.<br/><br/>Corona has learned that the AAF QRF approaching from the Gulf consists of two to three helicopters. According to the AAF standard OP, one of these helicopters is a troop transport supported by one to two gunships.<br/><br/>Corona also suspects that the AAF forces guarding the go-kart drivers at the ruins will most likely fortify their positions and protect the drivers rather than investigating the sounds of a firefight."],

		["Callsigns",
			"Corona: local high command operating at FOB Aurum.<br/>Perditus: surgical element, based at FOB Cuprum.<br/>Derelictus: supporting element, based at FOB Ferrum."],
            
        ["Additional",
			"PMC Versus uses FHQ Task Tracker to provide operators with briefings and tasks."]
    
] call FHQ_TT_addBriefing;

[
	{true},                                                         // Filter
    	["task1",										// Task name
         "Destroy the two Bluking team <marker name='obj1'>go-karts</marker>.",				       // Task text in briefing
         "Destroy Bluking karts.",							// Task title in briefing
         "courier"										// Waypoint text

        ],
        ["task2",										// Task name
         "Destroy the two Vrana team <marker name='obj2'>go-karts</marker>.",				       // Task text in briefing
         "Destroy Vrana karts.",							// Task title in briefing
         "commander"											// Waypoint text

        ],
		["task3",										// Task name
         "Eliminate the two <marker name='obj3'>reporters</marker> resting near the chapel.",				       // Task text in briefing
         "Eliminate the reporters.",							// Task title in briefing
         "ammo trucks"											// Waypoint text
        ],
        ["task4",										// Task name
         "Eliminate the Redstone team <marker name='obj4'>manager</marker>.",				       // Task text in briefing
         "Eliminate the manager.",							// Task title in briefing
         "ammo trucks"											// Waypoint text
        ],
        ["task5",										// Task name
         "Leave the AO to the <marker name='obj5'>west</marker>.",				       // Task text in briefing
         "Disappear.",							// Task title in briefing
         "ammo trucks"											// Waypoint text
        ]

] call FHQ_TT_addTasks;