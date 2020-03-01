# dungeoneq
Dungeon EQ - Private server


server is found at https://discord.gg/AuccmkP


## Self notes

# Instances Management

spawn2 is full of spawn data, search by zone field (shortname), you'll see version

#instance create 235 1 5400
watch response from echo, it'll say instance id, e.g. 1234
#instance add 1234 Player
#zoneinstance 1234 805 -123 -95

make mobs aggro
UPDATE npc_types SET npc_faction_id=623, aggroradius = 70 WHERE id >= 703000 AND id <= 703999;

# Debugging/Logging Tips
#logs set gmsay 20 3



# component spells:
SELECT spells_new.id, spells_new.NAME, components1, items.name, classes1, classes2, classes3, classes4, classes5, classes6, classes7, classes8, classes9, classes10, classes11, classes12, classes13, classes14, classes15, classes16 FROM spells_new INNER JOIN items ON items.id = spells_new.components1 WHERE (components1 > 0) AND (classes1 != 255 OR classes2 != 255 OR classes3 != 255 OR classes4 != 255 OR classes5 != 255 OR classes6 != 255 OR classes7 != 255 OR classes8 != 255 OR classes9 != 255 OR classes10 != 255 OR classes11 != 255 OR classes12 != 255 OR classes13 != 255 OR classes14 != 255 OR classes15 != 255 OR classes16 != 255);
UPDATE spells_new SET components1 = 0 WHERE components1 = 13011;
