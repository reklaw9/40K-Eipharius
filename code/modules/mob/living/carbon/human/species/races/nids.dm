//Normal Genestealer
/datum/species/xenos/tyranid/genestealer
	name = SPECIES_GENESTEALER
	name_plural = "Genestealers"
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	icobase = 'icons/mob/human_races/tyranids/r_tyranid.dmi'
	deform = 'icons/mob/human_races/tyranids/r_def_tyranid.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'
	language = LANGUAGE_TYRANID
	min_age = 1
	max_age = 300 //this fucker be old, but not too old, 'bout 6 generations worth of age.
	total_health = 400 //insanely high brain HP
	mob_size = MOB_LARGE //fat fuck
	strength = STR_VHIGH
	teeth_type = /obj/item/stack/teeth/human //til I get cool nid teeth
	sexybits_location = BP_HEAD
//	var/pain_power = 80 //useless verb for safekeeping, REMOVE NOPAIN if you want this to work
	inherent_verbs = list(
	/mob/living/carbon/human/genestealer/verb/convert,
	/mob/living/carbon/human/genestealer/proc/talon,
	/mob/living/carbon/human/genestealer/proc/makepool,
	/mob/living/carbon/human/genestealer/proc/gsheal,
	/mob/living/carbon/human/genestealer/proc/givestealerstats,
	 )
	slowdown = -1
	//genestealer unarmed attacks at end of file
	unarmed_types = list(
		/datum/unarmed_attack/rendingclaws,
		)
	has_fine_manipulation = 0 //can genestealers use weaponry, tools, medicine or guns? correct answer is yes, but DON'T give them that yet.
//	siemens_coefficient = 0 //first gen mfers be hackin everythin, no worries bro no worries
//	darksight = 20 //giving them night vision
	brute_mod = 0.7 // Hardened carapace.
	burn_mod = 2 // Hardened chitin carapace, easy to burn but insanely resistant to brute.
	species_flags = SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_EMBED | SPECIES_FLAG_NO_PAIN
//	appearance_flags = HAS_EYE_COLOR | HAS_SKIN_COLOR
	blood_color = "#8c0760" //purple ichor or so
	gibbed_anim = "gibbed-a"
	dusted_anim = "dust-a"
	
/datum/species/xenos/tyranid/handle_post_spawn(var/mob/living/carbon/human/H)
	H.age = rand(min_age,max_age)//Random age for nidders
	if(H.f_style)//Only newly infected cultists get beards
		H.f_style = "Shaved"
	to_chat(H, "<big><span class='warning'>THE DAY OF RECKONING HAS COME! I AWAKEN!(Select your class in genestealer tab)</span></big>")
	H.update_eyes()	//hacky fix, i don't care and i'll never ever care
	return ..()

/mob/living/carbon/human
	var/new_nid = SPECIES_TYRANID
	var/biomass = 100
	var/isconverting = 0
	var/dnastore = 0
	var/poolparty = 0

/mob/living/carbon/human/genestealer
	gender = MALE
	alien_talk_understand = 1

/datum/species/xenos/tyranid/genestealer/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, new_nid)
	
	
/datum/species/xenos/tyranid/Initialize()
	. = ..()
	fully_replace_character_name(random_nid_name(src.gender))
	warfare_faction = TYRANIDS
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/job/genestealer)
	outfit.equip(src)
	isburied = 1
	T.faction = "Tyranids"
	T.mind.special_role = "Tyranid"
	T.gsc = 1
	src.gsc = 1
	src.mind.special_role = "Tyranid"
	T.AddInfectionImages()
	src.AddInfectionImages()//likely redundant but sometimes they don't show so better to make it check twice on both parties.
	AddInfectionImages()
	thirst = INFINITY
	nutrition = INFINITY
	bladder = -INFINITY
	bowels = -INFINITY
	gsc = 1
	add_stats(rand(6,6),rand(14,16),rand(10,16),20)



	hand = 0//Make sure one of their hands is active.


//Begin abilities

/mob/living/carbon/human/genestealer/verb/convert()
	set name = "Genestealer Kiss"
	set desc = "You extend your tongue and pierce your victim with it."
	set category = "Tyranid"

	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, "<span class='warning'>We must be grabbing a creature in our active hand to convert them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting //this will be modified later as we add more rando species
	if(!istype(T))
		to_chat(src, "<span class='warning'>[T] is not compatible with our biology.</span>")
		return

	if(isconverting)
		to_chat(src, "<span class='warning'>We are already kissing [T]!</span>")
		return
	if(T.faction == "Tyranids")
		to_chat(src, "<span class='warning'>[T] is already implanted!</span>")
		return

	isconverting = 1

	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				to_chat(src, "<span class='notice'>This creature is suitable for the hive...</span>")
			if(2)
				to_chat(src, "<span class='notice'>[src] begins to open their jaw and extend their tongue</span>")
				src.visible_message("<span class='warning'>[src] opens their jaw and extends their tongue!</span>")
			if(3)
				to_chat(src, "<span class='notice'>[T] is impaled by your forked tongue</span>")
				src.visible_message("<span class='danger'>[src] impales [T] with their tongue.</span>")
				to_chat(T, "<span class='danger'>You feel a sharp stabbing pain!</span>")
				affecting.take_damage(1, 0, DAM_SHARP, "large organic needle")
				src.biomass -=10
				playsound(src, 'sound/effects/lecrunch.ogg', 50, 0, -1)

		if(!do_mob(src, T, 10))
			to_chat(src, "<span class='warning'>Our implantation of [T] has been interrupted!</span>")
			isconverting = 0
			return

	to_chat(src, "<span class='notice'>We have implanted [T]!</span>")
	to_chat(T, "<span class='danger'>You have been attacked by a genestealer and now feel incredibly confused and dizzy, you can't exactly remember what happened, you probably got out before they infected you, right? </span>")

	isconverting = 0

	T.faction = "Tyranids"
	T.mind.special_role = "Tyranid"
	T.gsc = 1
	src.gsc = 1
	src.mind.special_role = "Tyranid"
	T.AddInfectionImages()
	src.AddInfectionImages()//likely redundant but sometimes they don't show so better to make it check twice on both parties.
	T.add_language(LANGUAGE_TYRANID)
	src.dnastore++
	H.confused++
	H.drowsyness++
	T.adjustOxyLoss(-2)
	T.adjustBruteLoss(-1)
	T.adjustToxLoss(-1)
	T.adjustBrainLoss(-1)
	T.inject_blood(src, 500)
	return 1

/mob/living/carbon/human/genestealer/proc/ripperswarm() // ok
	set name = "Call on Ripper Swarm (20)"
	set desc = "Distract them!"
	set category = "Tyranid"

	if(src.biomass < 10)
		to_chat(src, "<font color='#800080'>You don't have enough biomass!</font>")
		return
	else
		new /mob/living/simple_animal/hostile/rippers(src.loc) //Rippers in the codex are 9 models per unit
		new /mob/living/simple_animal/hostile/rippers(src.loc)
		new /mob/living/simple_animal/hostile/rippers(src.loc)
		src.biomass -= 10
		visible_message("<span class='warning'>Numerous rippers burst from the ground and immediately begin to swarm!</span>")

/mob/living/carbon/human/genestealer/proc/neurotoxin(mob/target as mob in oview())
	set name = "Spit Neurotoxin (5)"
	set desc = "Spits neurotoxin at someone, paralyzing them for a short time if they are not wearing protective gear."
	set category = "Tyranid"

	if(src.biomass < 5)
		to_chat(src, "<font color='#800080'>You don't have enough biomass!</font>")
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "<font color='#800080'>You cannot spit neurotoxin in your current state.</font>")
		return

	visible_message("<span class='warning'>[src] spits neurotoxin at [target]!</span>", "<span class='alium'>You spit neurotoxin at [target].</span>")

	var/obj/item/projectile/energy/neurotoxin/A = new /obj/item/projectile/energy/neurotoxin(usr.loc)
	A.launch_projectile(target,get_organ_target())
	src.biomass -=5

/mob/living/carbon/human/genestealer/proc/makepool(mob/target as mob in oview())
	set name = "Create Spawning Pool"
	set desc = "Forms a spawning pool"
	set category = "Tyranid"

	if(src.poolparty >= 2)
		to_chat(src, "<font color='#800080'>You can't make any more pools!</font>")
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "<font color='#800080'>You cannot make a spawning pool in your current state.</font>")
		return

	new /obj/structure/spawningpool(src.loc)
	src.poolparty++
	src.mind.special_role = "Tyranid"
	src.gsc = 1
	src.AddInfectionImages()
/* //they don't have acid???
/mob/living/carbon/human/genestealer/proc/corrosive_acid(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Corrosive Acid (5)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Tyranid"

	if(!O in oview(1))
		to_chat(src, "<span class='alium'>[O] is too far away.</span>")
		return
	if(src.biomass < 5)
		to_chat(src, "<span class='alium'>We don't have enough biomass!</span>")
		return

	else
		new /obj/effect/acid(get_turf(O), O)
		visible_message("<span class='alium'><B>[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!</B></span>")
		src.biomass -=5
		return
*/

/mob/living/carbon/human/genestealer/proc/givestealerstats()
	set name = "Sync with the Hive Mind"
	set category = "Tyranid"
	set desc = "Stats and unfucks vision."

	if(src.stat == DEAD)
		to_chat(src, "<span class='notice'>You can't do this when dead.</span>")
		return

	visible_message("[name] listens intently to the will of the hive mind. Now is the time! The fleet is near! Communicate with your hive using ,h")
	src.AddInfectionImages()
	src.add_stats(rand(10,15),rand(17,18),rand(13,13),18) //gives stats str, end, int, dex
	src.add_skills(11,1,7,1,7)) //skills such as melee, ranged, med, eng and surg)
	src.adjustStaminaLoss(-INFINITY)
	src.update_eyes() //should fix grey vision
	src.set_trait(new/datum/trait/death_tolerant())
	client?.color = null
	src.health = 400 //brainhealth
	src.maxHealth = 400 //brainhealth
	src.warfare_language_shit(LANGUAGE_TYRANID)
	src.verbs -= /mob/living/carbon/human/genestealer/proc/givestealerstats //removes verb at the end so they can't spam it for whatever reason

/mob/living/carbon/human/genestealer/proc/gsheal()
	set name = "Repair Physiology (10)"
	set category = "Tyranid"
	set desc = "Heals"

	if(src.stat == DEAD)
		to_chat(src, "<span class='notice'>You can't do this when dead.</span>")
		return
	if(src.biomass < 5)
		to_chat(src, "<span class='alium'>We don't have enough biomass!</span>")
		return
	else
		visible_message("[src] expends some of his stored biomass correting wounds and damage to their organs.")
		adjustOxyLoss(-1)
		adjustToxLoss(-1)
		adjustBrainLoss(-1)
		src.radiation = 0
		src.bodytemperature = T36C
		src.eye_blurry = 0
		src.ear_deaf = 0
		src.ear_damage = 0
		src.inject_blood(src, 500)
		src.biomass -=10

/mob/living/carbon/human/genestealer/proc/talon()
	set name = "Prepare Nonlethal Blows(0)"		
	set category = "Tyranid"		
	set desc = "You ready your talons for a painful blow instead of a lethal one."		
	put_in_hands(new /obj/item/melee/baton/nidstun)		
	src.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)		
	return


/mob/living/carbon/human/genestealer/proc/injector()
	set name = "Prepare Bio Injector(5)"		
	set category = "Tyranid"		
	set desc = "Gives you a 5u chloral hydrate biological injector"	
	src.biomass -=5
	put_in_hands(new /obj/item/melee/baton/nidstun)		
	src.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)		
	return
	
	
//Begin nid items
/obj/item/reagent_containers/hypospray/autoinjector/tyranidchloralhydrate
	name = "Biological Injector"
	desc = "A poisonous concoction inside of a hollowed out chitin shell with a needle made out of bone, contains some sleepy sleepy drugs."
	icon = 'icons/obj/weapons/melee/misc.dmi'
	icon_state = "catachanfang"
	item_state = "catachanfang"
	color = "#292929"
	amount_per_transfer_from_this = 5
	volume = 5
	origin_tech = list(TECH_BIO = 8) //i don't know how you did it, but if you managed to, you deserve this
	starts_with = list(/datum/reagent/chloralhydrate = 5)
	
/obj/item/reagent_containers/hypospray/autoinjector/tyranidchloralhydrate/dropped() //since nodrop is fucked this will deal with it for now.
	..()
	spawn(1) if(src) qdel(src)

/obj/item/melee/baton/nidstun
	name = "Venomous Talon"
	desc = "This talon is prepared to strike nonlethal pincing attacks to try and slow a enemy down, possibly even knocking them out."
	icon = 'icons/obj/weapons/melee/misc.dmi'
	icon_state = "catachanfang"
	item_state = "catachanfang"
	color = "#292929"
	slot_flags = SLOT_BELT|SLOT_BACK|SLOT_S_STORE
	str_requirement = 10
	force = 5
	agonyforce = 90 //don't make this too high or it may kill people
	status = 1
	block_chance = 60
	sales_price = 0
	weapon_speed_delay = 5
	sharp = TRUE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_NO_BLOOD
	attack_verb = list("stabbed", "jabbed", "infested")
	armor_penetration = 90 //Genestealer magic.

/obj/item/melee/baton/nidstun/dropped() //since nodrop is fucked this will deal with it for now.
	..()
	spawn(1) if(src) qdel(src)
	
/obj/structure/spawningpool
	name = "spawning pool"
	desc = "A pulsating mass of writing blood and acid, its eager for biological contributions, maybe you should throw yourself into it-- wait who said that?"
	icon = 'icons/mob/human_races/tyranids/tyranids.dmi'
	icon_state = "reclaimer"
	anchored = 1
	density = 1
	layer = 4
	bound_height = 32
	bound_width = 32

/obj/structure/spawningpool/attack_hand(mob/living/carbon/human/genestealer/user as mob)
	if(user.dnastore < 1) //no DNA = nothing happens
		return
	else
		user.dnastore--
		user.biomass +=20
		to_chat(user, "<font color='#800080'>The Hive grows stronger with my contribution... </font>")
		return



/obj/structure/spawningpool/attackby(var/obj/item/O, var/mob/user)
	if((O.sharp) || istype(O, /obj/item/material/knife/butch) || istype(O, /obj/item/material/sword))//what items can cut down trees
		visible_message("<span='bnotice'[user] begins to cut apart \the [src]!</span>" )
		playsound(src, 'sound/weapons/pierce.ogg', 100, FALSE)
		if(do_after(user, 110, src))
			qdel(src)


//planned
/*

/datum/species/xenos/tyranids/Maelignaci
	name = SPECIES_GEN1TYRANID
	name_plural = "Tyranids"
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	icobase = 'icons/mob/human_races/tyranids/r_tyranid.dmi'
	deform = 'icons/mob/human_races/tyranids/r_def_tyranid.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'
	language = LANGUAGE_TYRANID
	min_age = 1
	max_age = 100
	gluttonous = GLUT_ITEM_NORMAL
	total_health = 250
	mob_size = MOB_MEDIUM
	strength = STR_HIGH
	teeth_type = /obj/item/stack/teeth/human //til I get cool nid teeth
	sexybits_location = BP_GROIN
	var/pain_power = 0
	inherent_verbs = list(
	/mob/living/carbon/human/genestealer/verb/convert,
	/mob/living/carbon/human/genestealer/proc/talon,
	/mob/living/carbon/human/genestealer/proc/makepool,
	/mob/living/carbon/human/genestealer/proc/corrosive_acid,
	/mob/living/carbon/human/genestealer/proc/gsheal,
	/mob/living/carbon/human/genestealer/proc/givestealerstats,

	 )
	slowdown = -0.5
	unarmed_types = list(
		/datum/unarmed_attack/rendingclaws,
		/datum/unarmed_attack/rendingclaws,
		)

	has_fine_manipulation = 1
	siemens_coefficient = 0
	gluttonous = GLUT_ANYTHING
	stomach_capacity = MOB_MEDIUM
	darksight = 16

	brute_mod = 0.9 // Hardened carapace.
	burn_mod = 2 // Hardened carapace.
*/




//Nid specific verbs
/datum/unarmed_attack/rendingclaws/genestealer 
	attack_verb = list("rends")
	attack_noun = list("claw")
	eye_attack_text = "blades"
	eye_attack_text_victim = "daggers"
	damage = 95
	sharp = 1
	edge = 1
	attack_sound = 'sound/effects/nidslash.ogg'


/datum/unarmed_attack/rendingclaws/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [organ]!</span>")
		return 0

	if(!target.lying)
		switch(zone)
			if(BP_HEAD, BP_MOUTH, BP_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(35 to 40)
						user.visible_message("<span class='danger'>[user] gouged [target] across \his cheek!</span>")
					if(41 to 49)
						user.visible_message(pick(
							80; "<span class='danger'>[user] [pick(attack_verb)] [target]'s head!</span>",
							20; "<span class='danger'>[user] struck [target] in the head[pick("",)]!</span>",
							50; "<span class='danger'>[user] slashed a claw against [target]'s head!</span>"
							))
					if(50 to 55)
						user.visible_message(pick(
							10; "<span class='danger'>[user] maims [target]'s face!</span>",
							90; "<span class='danger'>[user] smashed \his [pick(attack_noun)] into [target]'s [pick("[organ]", "face", "jaw")]!</span>"
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(35 to 40)	user.visible_message("<span class='danger'>[user] threw a glancing slash at [target]'s [organ]!</span>")
					if(41 to 49)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target]'s [organ]!</span>")
					if(50 to 55)	user.visible_message("<span class='danger'>[user] tears apart [target]'s [organ]!</span>")
	else
		user.visible_message("<span class='danger'>[user] [pick("slashed", "flailed a claw at", "scythed", "impaled their [pick(attack_noun)] into")] [target]'s [organ]!</span>") //why do we have a separate set of verbs for lying targets?
