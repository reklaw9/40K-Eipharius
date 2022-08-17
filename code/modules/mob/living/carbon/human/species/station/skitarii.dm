/datum/species/human/skitarii
	name = "Skitarii"
	name_plural = "Skitarii"
	blurb = "The Mechanicus' loyal soldiers."
	total_health = 400 //made to be recovered even if they get severely injured
	min_age = 18
	max_age = 80
	icobase = 'icons/mob/human_races/r_human.dmi'
	deform = 'icons/mob/human_races/r_def_human.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'
	pixel_offset_y = -4
	strength = STR_HIGH
	radiation_mod = 0.2
	species_flags = SPECIES_FLAG_NO_PAIN|SPECIES_FLAG_NO_POISON
	slowdown = -0.30
	inherent_verbs = list(
	/mob/living/carbon/human/skitarii/proc/giveskitstats,
		)
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch
		)

/mob/living/carbon/human
	var/new_skitarii = SPECIES_SKITARII

/mob/living/carbon/human/skitarii
	gender = MALE

/datum/species/human/skitarii/handle_post_spawn(var/mob/living/carbon/human/H)
	H.age = rand(min_age,max_age)//Random age doesn't quite matter I suppose
	if(H.f_style)//BALD
		H.f_style = "Shaved"
	if(H.h_style)//SHAVED
		H.h_style = "Bald"
	to_chat(H, "<big><span class='warning'>You are a servant of the Adeptus Mechanicus! Don't forget it!</span></big>")
	H.update_eyes()	//hacky fix, i don't care and i'll never ever care
	return ..()

/mob/living/carbon/human/proc/isSkitarii()//Used to tell if someone is a skit boy, can be used for possible jobs later down the line, stole from children
	if(species?.name == "Skitarii")
		return 1
	else
		return 0

/mob/living/carbon/human/skitarii/Initialize()
	. = ..()
	fully_replace_character_name(random_skitarii_name(src.gender))
	warfare_faction = IMPERIUM
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/job/skitarii)
	outfit.equip(src)
	offer_mob()
	hand = 0//Make sure one of their hands is active.
	isburied = 1

/mob/living/carbon/human/skitarii/proc/question(var/client/C) //asks the questions
	if(!C)
		return FALSE
	var/response = alert(C, "A Skitarii unit has been manufactured and needs a player. Are you interested?", "Skitarii", "Yes", "No",)
	if(!C || ckey)
		return FALSE
	if(response == "Yes")
		transfer_personality(C)
		src.warfare_faction = IMPERIUM
		return TRUE
	return FALSE

/mob/living/carbon/human/skitarii/proc/transfer_personality(var/client/candidate) //puts the guy in the place

	if(!candidate)
		return

	src.mind = candidate.mob.mind
	src.ckey = candidate.ckey
	if(src.mind)
		src.mind.assigned_role = "syndicate"

/mob/living/carbon/human/skitarii/proc/skitariiclasses()
	set name = "Remember your modifications"
	set category = "Mechanicus"
	set desc = "Alright lad, choose one of these."

	if(src.stat == DEAD)
		to_chat(src, "<span class='notice'>WHY ARE YOU DEAD IF YOU HAVENT EVEN SET YOUR FUCKING SKILLS?!</span>")
		return

	src.verbs -= /mob/living/carbon/human/skitarii/proc/skitariiclasses

	var/castes = input("Select a functionality","Functionality Selection") as null|anything in list("Fire Warrior", "Water Caste Merchant", "Earth Caste Mechanic", "Kroot Hunter")
	switch(castes)
		if("Skitarii Ranger")
			equip_to_slot_or_del(new /obj/item/clothing/under/rank/skitarii, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hooded/skitarii, slot_head)
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/skitshoes, slot_shoes)
			equip_to_slot_or_del(new /obj/item/gun/energy/pulse/pulserifle, slot_r_hand)
			equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat/combat/warfare, slot_gloves)
			equip_to_slot_or_del(new /obj/item/cell/pulserifle, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/cell/pulserifle, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/gun/energy/pulse/pulsepistol, slot_in_backpack)


			visible_message("[name] finally updates their software after a long wait.")
			src.add_stats(rand(10,12),rand(14,18),rand(12,15),10) //gives stats str, end, int, dex
			src.add_skills(rand(4,9),rand(8,13),rand(0,3),0,0) //skills such as melee, ranged, med, eng and surg
			src.update_eyes() //should fix grey vision
			src.warfare_language_shit(TAU) //secondary language
			src.name = "Shas [name]"
			src.real_name = "Shas [real_name]"
			client?.color = null
			src.verbs -= /mob/living/carbon/human/tau/proc/tauclasses //removes verb at the end so they can't spam it for whatever reason



			var/obj/item/card/id/ring/tau/W = new

			W.icon_state = "tau"
			W.assignment = "Fire Warrior"
			W.registered_name = real_name
			W.update_label()
			equip_to_slot_or_del(W, slot_wear_id)

		if("Water Caste Merchant")
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/gun/energy/pulse/pulsepistol, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/cell/pulserifle, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones2/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/stack/thrones3/twenty, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/clothing/head/tautrader, slot_head)
			equip_to_slot_or_del(new /obj/item/clothing/suit/watercaste, slot_wear_suit)

			visible_message("[name] finally updates their software after a long wait.")
			src.add_stats(rand(6,8),rand(10,12),rand(12,13),15) //gives stats str, end, int, dex
			src.add_skills(rand(3,6),rand(3,6),rand(0,3),3,3) //skills such as melee, ranged, med, eng and surg
			src.update_eyes() //should fix grey vision
			src.warfare_language_shit(TAU) //secondary language
			src.name = "Por [name]"
			src.real_name = "Por [real_name]"
			client?.color = null
			src.verbs -= /mob/living/carbon/human/tau/proc/tauclasses //removes verb at the end so they can't spam it for whatever reason



			var/obj/item/card/id/ring/tau/W = new

			W.icon_state = "tau"
			W.assignment = "Water Caste Merchant"
			W.registered_name = real_name
			W.update_label()
			equip_to_slot_or_del(W, slot_wear_id)

		if("Earth Caste Mechanic")
			equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots, slot_shoes)
			equip_to_slot_or_del(new /obj/item/gun/energy/pulse/pulsepistol, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/clothing/suit/earthcaste, slot_wear_suit)
			equip_to_slot_or_del(new /obj/item/storage/belt/utility/full, slot_in_backpack)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/welding/superior, slot_glasses)

			visible_message("[name] finally updates their software after a long wait.")
			src.add_stats(rand(7,9),rand(11,13),rand(13,16),12) //gives stats str, end, int, dex
			src.add_skills(rand(3,6),rand(3,6),rand(5,8),6,6) //skills such as melee, ranged, med, eng and surg
			src.update_eyes() //should fix grey vision
			src.warfare_language_shit(TAU) //secondary language
			src.name = "Fio'La [name]"
			src.real_name = "Fio'La [real_name]"
			client?.color = null
			src.verbs -= /mob/living/carbon/human/tau/proc/tauclasses //removes verb at the end so they can't spam it for whatever reason



			var/obj/item/card/id/ring/tau/W = new

			W.icon_state = "tau"
			W.assignment = "Earth Caste Mechanic"
			W.registered_name = real_name
			W.update_label()
			equip_to_slot_or_del(W, slot_wear_id)
