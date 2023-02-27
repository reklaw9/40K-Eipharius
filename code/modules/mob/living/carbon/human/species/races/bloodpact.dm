/datum/species/bloodpact
	name = SPECIES_BLOODPACT
	name_plural = "Bloodpact"
	secondary_langs = list(LANGUAGE_DARKTONGUE)
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	icobase = 'icons/mob/human_races/r_human.dmi'
	deform = 'icons/mob/human_races/r_def_human.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'
	min_age = 16
	max_age = 200
	gluttonous = GLUT_ITEM_NORMAL
	total_health = 200
	mob_size = MOB_MEDIUM
	strength = STR_HIGH
	sexybits_location = BP_GROIN

	inherent_verbs = list(
	/mob/living/carbon/human/Bloodpact/proc/givebloodstats,
	/mob/living/carbon/human/proc/bludforbludguy, // KILL, MAIM, BURN!
	/mob/living/carbon/human/proc/letriverflow,
	/mob/living/carbon/human/proc/moving,
	/mob/living/carbon/human/proc/overthere,
	/mob/living/carbon/human/proc/praynslay,
	/mob/living/carbon/human/proc/chaaaaaarge,
	/mob/living/carbon/human/proc/chopdem,
	/mob/living/carbon/human/proc/bringdeath,
	/mob/living/carbon/human/proc/advance,
	/mob/living/carbon/human/proc/aaaaaa,
	/*/mob/living/carbon/human/proc/draw_rune */ // doesnt work rn because only khorne cultists can draw runes and they technically are not khorne. and if they were, it would use pilgrim khorne slots
		)

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite
		)


/datum/species/bloodpact/handle_post_spawn(var/mob/living/carbon/human/H)
	H.age = rand(20,180)//Random age for kiddos.
	to_chat(H, "<big><span class='warning'>You are veterans of the Bloodpact sent to Eipharius to enact the Anarch's will, find and co-ordinate with the local followers of the ruinous powers and plot an uprising to rival old Horus himself. Do not waste your lives, instead spend the lives of your followers whom you recruit from the planet.</span></big>")
	H.update_eyes()	//hacky fix, i don't care and i'll never ever care
	return ..()
/mob/living/carbon/human
	var/new_bloodpact = SPECIES_BLOODPACT

/mob/living/carbon/human/Bloodpact
	gender = MALE

/mob/living/carbon/human/Bloodpact/proc/givebloodstats()
	set name = "Embrace your Chaotic Blessings"
	set category = "Ruinous Powers"
	set desc = "Gives bloodpact stats since I can't seem to do it any other way in this clown world."

	if(src.stat == DEAD)
		to_chat(src, "<span class='notice'>You can't do this when dead.</span>")
		return

	visible_message("[name] Embraces their blessings from The God of Blood, the Skull taker, the soul eater: Khorne. Skulls for his throne shall come.")
	src.add_stats(rand(17,22),rand(17,22),rand(14,17),rand(14,16))
	src.add_skills(rand(11,14),rand(11,14),rand(2,5),5,4) //skills such as melee, ranged, med, eng and surg
	src.adjustStaminaLoss(-INFINITY)
	src.update_eyes() //should fix grey vision
	src.warfare_language_shit(LANGUAGE_DARKTONGUE) //secondary language // doesnt work currently
	src.verbs -= /mob/living/carbon/human/Bloodpact/proc/givebloodstats //removes verb at the end so they can't spam it for whatever reason
	client?.color = null


/mob/living/carbon/human/Bloodpact/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, new_bloodpact)
/mob/living/carbon/human/Bloodpact/Initialize()
	. = ..()
	fully_replace_character_name(random_chaos_name(src.gender))
	faction = "Khorne"
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/job/bloodpact)
	outfit.equip(src)

