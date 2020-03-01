sub EVENT_SAY {
    if ($zoneid != 386) {
        if ($text eq "exit") {
            DungeonFinish();
            quest::movepc(386, 0, 0, 10, 0);
            return;
        }
        plugin::Whisper("you have completed the dungeon");
        plugin::Whisper("[" . quest::saylink("exit", 1, "exit") . "]");
        return;
    }
    if ($client->GetClientVersion() != 7) {
        plugin::Whisper("unfortunately, to play on this server, you must be using the Rain of Fear game client.");
        return;
    }

    #if (!$client->GetGM()) {
    #    quest::popup("Work In Progress", "This is a work in progress server. <a href=\"https://discord.gg/AuccmkP\">Join our Discord link</a> to keep up to date on latest progress, and give input to the creation process of this server!<br><br>Dungeon EQ is a Roguelike Everquest Hardcore Experience.<br>Start off as a naked level 1, battle dungeons to improve in skill<br> Gain randomized loot with potential at legendary items<br>Every run through the dungeon is entirely unique");
    #    return;
    #}

    my $state = quest::get_data($client->CharacterID() . "-state");

    if ($state eq "") {
        quest::popup("Work In Progress", "This is a work in progress server. <a href=\"https://discord.gg/AuccmkP\">Join our Discord link</a> to keep up to date on latest progress, and give input to the creation process of this server!<br><br>Dungeon EQ is a Roguelike Everquest Hardcore Experience.<br>Start off as a naked level 1, battle dungeons to improve in skill<br> Gain randomized loot with potential at legendary items<br>Every run through the dungeon is entirely unique");
    }

    if ($state eq "INSIDE_DUNGEON") {
        quest::popup("Work In Progress", "This is a work in progress server. <a href=\"https://discord.gg/AuccmkP\">Join our Discord link</a> to keep up to date on latest progress, and give input to the creation process of this server!<br><br>Dungeon EQ is a Roguelike Everquest Hardcore Experience.<br>Start off as a naked level 1, battle dungeons to improve in skill<br> Gain randomized loot with potential at legendary items<br>Every run through the dungeon is entirely unique");
    }

    if ($state eq "") {
        quest::set_data($client->CharacterID(). "-state", "START_NEW");
        $state = "START_NEW";
        DungeonGenerate();
        #TODO: Strip all gear.
        #TODO: Reset AA's, reset level, and skills
        DungeonResetCharacter();
    }

    if ($state eq "FINISHED_DUNGEON") {
        DungeonNameGenerate();
    }



    my $count = quest::get_data($client->CharacterID() . "-dialog-count");
    for (my $i = 1; $i <= $count; $i++) {
        if ($text ne "option $i") {
            next;
        }

        $res = DungeonChoose($i);
        if ($res) {
            DungeonGenerate();
        }
        last;
    }



    if ($state eq "NEXT_DUNGEON") {
        if (!DungeonInstanceCheck()) {
            return;
        }
        quest::set_data($client->CharacterID() . "-dialog-count", 1);
        quest::set_data($client->CharacterID() . "-dialog-header", "dungeon is ready to enter");
        quest::set_data($client->CharacterID() . "-dialog-option-1-text", "enter");
        quest::set_data($client->CharacterID() . "-dialog-option-1-effect", "enter");
    }

    # display dialog
    $count = quest::get_data($client->CharacterID() . "-dialog-count");
    plugin::Whisper(quest::get_data($client->CharacterID() . "-dialog-header"));
    for (my $i = 1; $i <= $count; $i++) {
        plugin::Whisper("[" . quest::saylink("option $i", 1, "option $i") . "] " .quest::get_data($client->CharacterID() . "-dialog-option-" . $i . "-text"));
    }
}


# DungeonGenerate() # Generate the next step of a dungeon.
sub DungeonGenerate {
    $client = plugin::val('$client');
    $class = plugin::val('$class');
    $state = quest::get_data($client->CharacterID(). "-state");

    DungeonResetChoices();
    # Start a new run
    if ($state eq "START_NEW") {
        quest::set_data($client->CharacterID() . "-state", "PREP");
        quest::set_data($client->CharacterID() . "-dialog-count", 3);
        quest::set_data($client->CharacterID() . "-dialog-header", "choose your path:");

        quest::set_data($client->CharacterID() . "-dialog-option-1-text", "enemies have half health on next dungeon");
        quest::set_data($client->CharacterID() . "-dialog-option-1-effect", "enemy50nextdungeon");
        quest::set_data($client->CharacterID() . "-dialog-option-1-result", "enemies will have half health on next dungeon");

        @classes = ("Warrior", "Shadowknight", "Rogue", "Necromancer", "Wizard", "Magician", "Enchanter");
        $itemid = 6305; #screaming mace
        foreach my $c (@classes) {
            if ($c ne $class) {
                next;
            }
            #dragoon dirk
            $itemid = 13942;
            last;
        }

        quest::set_data($client->CharacterID() . "-dialog-option-2-text", "gain reward: " . quest::varlink($itemid));
        quest::set_data($client->CharacterID() . "-dialog-option-2-effect", "summon" . $itemid);

        $itemid = 2341; #foreman's tunic
        quest::set_data($client->CharacterID() . "-dialog-option-3-text", "gain reward: " . quest::varlink($itemid));
        quest::set_data($client->CharacterID() . "-dialog-option-3-effect", "summon" . $itemid);

        quest::set_data($client->CharacterID() . "-dialog-option-4-text", "skip");
        quest::set_data($client->CharacterID() . "-dialog-option-4-effect", "skip");
        quest::set_data($client->CharacterID() . "-dialog-option-4-result", "you skipped all choices");
        return;
    }

    if ($state eq "PREP") {
        DungeonNameGenerate();
        return;
    }

    if ($state eq "NEXT_DUNGEON") {
        # state is handled after entering
        if (!DungeonInstanceCheck()) {
            quest::set_data($client->CharacterID() . "-dialog-count", 0);
            quest::set_data($client->CharacterID() . "-dialog-header", "your next dungeon is still being prepared");
            return;
        }
        quest::set_data($client->CharacterID() . "-dialog-count", 1);
        quest::set_data($client->CharacterID() . "-dialog-header", "dungeon is ready to enter");
        quest::set_data($client->CharacterID() . "-dialog-option-1-text", "enter");
        quest::set_data($client->CharacterID() . "-dialog-option-1-effect", "enter");

        return;
    }

    if ($state eq "ENTERING_DUNGEON") {
        # state is handled after entering
        if (!DungeonInstanceCheck()) {
            quest::set_data($client->CharacterID() . "-dialog-count", 0);
            quest::set_data($client->CharacterID() . "-dialog-header", "your next dungeon is still being prepared");
            return;
        }
        quest::set_data($client->CharacterID() . "-dialog-count", 1);
        quest::set_data($client->CharacterID() . "-dialog-header", "try to enter the dungeon again?");
        quest::set_data($client->CharacterID() . "-dialog-option-1-text", "enter");
        quest::set_data($client->CharacterID() . "-dialog-option-1-effect", "enter");
        return;
    }

    if ($state eq "INSIDE_DUNGEON") {
        DungeonNameGenerate();
        return;
    }


    plugin::Whisper("unhandled state for dungeon generation: " . $state);

    return;
}


sub DungeonFinish {
    $client = plugin::val('$client');
    $instance = quest::get_data($client->CharacterID() . "-dungeon-instance-id");
    if ($instance eq "") {
        return;
    }
    # quest::DestroyInstance($instance);
    quest::UpdateInstanceTimer($instance, 1);
    quest::RemoveFromInstance($instance);
    $client->Message(15, "You have finished the dungeon. (" . $instance . ")");
}


# DungeonResetChoices() clears the dialog of previous choices
sub DungeonResetChoices {
    $client = plugin::val('$client');
    quest::set_data($client->CharacterID() . "-dialog-count", 0);
    quest::set_data($client->CharacterID() . "-dialog-header", "");
    foreach my $i (1 .. 4) {
        quest::set_data($client->CharacterID() . "-dialog-option-" . $i . "-text", "");
        quest::set_data($client->CharacterID() . "-dialog-option-" . $i ."-effect", "");
        quest::set_data($client->CharacterID() . "-dialog-option-" . $i . "-result", "");
    }
}


# DungeonChoose(int choice) bool # Choose a dialog option, triggering it's effect
sub DungeonChoose {
    $choice = shift;
    $client = plugin::val('$client');

    if ($client->GetGM()) { plugin::Whisper("trying choice " . $choice); }
    my $effect = quest::get_data($client->CharacterID() . "-dialog-option-" . $choice . "-effect");
    my $result = quest::get_data($client->CharacterID() . "-dialog-option-" . $choice . "-result");

    if ($effect eq "") {
        plugin::Whisper("invalid choice. Try another.");
        return 0;
    }

    if ($effect eq "enemy50nextdungeon") {
        plugin::Whisper($result);
        return 1;
    }

    if (index($effect, "summon") == 0) {
        my $id = substr $effect, 6;
        plugin::Whisper("obtained: ". quest::varlink($id));
        quest::summonitem($id);
        return 1;
    }

    if ($effect eq "skip") {
        plugin::Whisper($result);
        return 1;
    }

    if ($effect eq "giveup") {
        $client->SetPVP(0);
        my $deaths = quest::get_data($client->CharacterID() . "-deaths");
        if ($deaths eq "") {
            $deaths = 0;
        }
        $deaths = int($deaths);
        $deaths++;
        quest::set_data($client->CharacterID() . "-deaths", $deaths);
        plugin::Whisper("you have now failed " . $deaths . " times");
        return 1;
    }

    if (index($effect, "dungeon") == 0) {
        my @zoneInfo = split('-', $effect);
        my $zoneName = $zoneInfo[1];
        my $version = $zoneInfo[2];
        my $taskid = $zoneInfo[3];

        if ($client->GetGM()) { plugin::Whisper("creating instance " . $zoneName . " " . $version . " taskid: " . $taskid); }

        DungeonCreate($zoneName, $version, $taskid);
        return 1;
    }

    if ($effect eq "reset") {
        DungeonResetCharacter();
        quest::set_data($client->CharacterID() . "-state", "START_NEW");
        return 1;
    }

    if ($effect eq "enter") {
        plugin::Whisper("good luck on your dungeon!");


        $client->Heal();
        my $instance = quest::get_data($client->CharacterID() . "-dungeon-instance-id");
        my $x = quest::get_data($client->CharacterID() . "-dungeon-instance-x");
        my $y = quest::get_data($client->CharacterID() . "-dungeon-instance-y");
        my $z = quest::get_data($client->CharacterID() . "-dungeon-instance-z");
        $zoneName = quest::get_data($client->CharacterID() . "-dungeon-instance-zonename");
        my $zoneID = quest::GetZoneID($zoneName);

        quest::set_data($client->CharacterID() . "-state", "ENTERING_DUNGEON");

        quest::MovePCInstance($zoneID, $instance, $x, $y, $z, 0);
        return 1;
    }

    plugin::Whisper($effect . " is not yet implemented. Please choose another option.");

    return 0;
}


# DungeonCreate($zoneName, $version)
sub DungeonCreate {
    $zoneName = shift;
    $version = shift;
    $taskid = shift;
    $client = plugin::val('$client');

    # zone, version, duration
    $instance = quest::CreateInstance($zoneName, $version, 5400);
    quest::AssignToInstanceByCharID($instance, $client->CharacterID());
    quest::set_data($client->CharacterID() . "-dungeon-instance-id", $instance);
    quest::set_data($client->CharacterID() . "-dungeon-instance-zonename", $zoneName);
    quest::set_data($client->CharacterID() . "-dungeon-instance-version", $version);
    quest::set_data($client->CharacterID() . "-dungeon-ready", time()+6);
    quest::set_data("instance-" . $instance . "-level", $client->GetLevel());
    $x = 0;
    $y = 0;
    $z = 0;
    if ($zoneName eq "mira") {
        $x = 43.81;
        $y = 36.30;
        $z = 3.63;
    }

    if ($zoneName eq "hateplaneb") {
        $x = -393;
        $y = 665.80;
        $z = 3;
    }

    if ($zoneName eq "taka") {
        $x = -91.53;
        $y = 462.66;
        $z = 3.13;
    }


    if ($zoneName eq "gyrospireb") {
        $x = -5.90;
        $y = -826.33;
        $z = 3.13;
    }

    if ($zoneName eq "ruja") {
        $x = 805;
        $y = -123;
        $z = -95;
    }
    if ($zoneName eq "stillmoonb") {
        $x = 171.13;
        $y = 1135.21;
        $z = 43.06;
    }
    if ($zoneName eq "rujd") {
        $x = -322;
        $y = 1254;
        $z = -96;
    }
    if ($zoneName eq "sncrematory") {
        $x = 436.94;
        $y = -1131.84;
        $z = -33.87;
    }
    if ($zoneName eq "snpool") {
        $x = 119.71;
        $y = -10.15;
        $z = -19.87;
    }
    if ($zoneName eq "solteris") {
        $x = -130.86;
        $y = 84.44;
        $z = -38.04;
    }
    if ($zoneName eq "ssratemple") {
        $x = 249.90;
        $y = 312.81;
        $z = -4.86;
    }
    if ($zoneName eq "suncrest") {
        $x = -2708.89;
        $y = -1503.10;
        $z = 308.64;
    }

    if ($zoneName eq "toskirakk") {
        $x = 2080.31;
        $y = -382.94;
        $z = 68.16;
    }

    if ($zoneName eq "veksar") {
        $x = 295.99;
        $y = -48.27;
        $z = -13.87;
    }

    if ($zoneName eq "thulelibrary") {
        $x = -157.15;
        $y = 76.17;
        $z = 92.02;
    }

    if ($zoneName eq "somnium") {
        $x = 189.48;
        $y = -3.72;
        $z = -24.74;
    }

    if ($zoneName eq "windsong") {
        $x = -1217.98;
        $y = -118.50;
        $z = 6.35;
    }


    if ($zoneName eq "riftseekers") {
        $x = 15.84;
        $y = 251.14;
        $z = -229.53;
    }


    if ($zoneName eq "rujf") {
        $x = -290;
        $y = -571;
        $z = -460;
    }

    if ($zoneName eq "felwithea") {
        $x = -292.22;
        $y = -117.25;
        $z = 3.13;
    }



    if ($zoneName eq "rujg") {
        $x = 292.63;
        $y = -1195.06;
        $z = 128.38;
    }

    if ($zoneName eq "ruji") {
        $x = 833;
        $y = -1871;
        $z = -222;
    }

    if ($zoneName eq "rujj") {
        $x = 750;
        $y = -134;
        $z = 26;
    }

    if ($zoneName eq "skyshrine") {
        $x = 2464.35;
        $y = 2300.50;
        $z = -161.81;
    }

    if ($zoneName eq "guka") {
        $x = 93.55;
        $y = -848.44;
        $z = 1.13;
    }

    if ($zoneName eq "soldungc") {
        $x = 605.90;
        $y = 155.05;
        $z = -16.87;
    }

    if ($zoneName eq "breedinggrounds") {
        $x = -181.38;
        $y = 113.96;
        $z = -47.27;
    }

    if ($zoneName eq "foundation") {
        $x = 1152.99;
        $y = -1005.85;
        $z = -209.09;
    }


    if ($zoneName eq "housegarden") {
        $x = -1279;
        $y = -399.70;
        $z = -101.81;
    }

    quest::set_data($client->CharacterID() . "-dungeon-instance-x", $x);
    quest::set_data($client->CharacterID() . "-dungeon-instance-y", $y);
    quest::set_data($client->CharacterID() . "-dungeon-instance-z", $z);
    quest::set_data($client->CharacterID() . "-dungeon-instance-taskid", $taskid);
    quest::assigntask($taskid);
}


# DungeonInstanceCheck() bool # Check if a dungeon is ready to enter
sub DungeonInstanceCheck {
    $client = plugin::val('$client');

    $time = quest::get_data($client->CharacterID() . "-dungeon-ready");
    if (int(time()) < int($time)) {
        plugin::Whisper("your dungeon is being prepared. Please wait " . (int($time) - int(time())) . " seconds [" . quest::saylink("retry", 1, "retry") . "]");
        return 0;
    }

    $version = quest::get_data($client->CharacterID() . "-dungeon-instance-version");
    $zoneName = quest::get_data($client->CharacterID() . "-dungeon-instance-zonename");

    $instance = quest::GetInstanceIDByCharID($zoneName, $version, $client->CharacterID());
    if ($instance == 0) {
        plugin::Whisper("hmm.. no dungeon found! Did you not enter your dungeon fast enough? [" . quest::saylink("option 1", 1, "give up") . "], or /ooc Shin! Dungeon poof!");

        quest::set_data($client->CharacterID() . "-state", "INSIDE_DUNGEON");
        quest::set_data($client->CharacterID() . "-dialog-count", 1);
        quest::set_data($client->CharacterID() . "-dialog-header", "you have failed your dungeon.");
        quest::set_data($client->CharacterID() . "-dialog-option-1-text", "give up");
        quest::set_data($client->CharacterID() . "-dialog-option-1-effect", "giveup");
        quest::set_data($client->CharacterID() . "-dialog-option-1-result", "you admit defeat, but continue your journey");
        quest::set_data($client->CharacterID() . "-dialog-option-2-text", "start over - reset character back to level 1");
        quest::set_data($client->CharacterID() . "-dialog-option-2-effect", "reset");
        quest::set_data($client->CharacterID() . "-dialog-option-2-result", "resetting you to level 1");

        return 0;
    }

    return 1;
}



sub DungeonResetCharacter {
    $client = plugin::val('$client');
    $class = plugin::val('$class');

    plugin::Whisper("resetting you, this will take a moment...");

    quest::unscribespells();
    $client->UnmemSpellAll(1);
    quest::untraindiscs();
    quest::setallskill(0);
    $client->ResetAA();
    $client->ResetTrade();
    $client->SetPVP(0);
    quest::set_data($client->CharacterID() . "-deaths", "");

    foreach my $taskid (290 .. 294) {
        $client->FailTask($taskid);
    }

    $client->SetAlternateCurrencyValue(40903, 0);

    $instance = quest::get_data($client->CharacterID() . "-dungeon-instance-id");
    if ($instance ne "") {
        quest::UpdateInstanceTimer($instance, 1);
        quest::RemoveFromInstance($instance);
    }

    foreach my $slotid (0 .. 2550) {
        if ($client->GetItemIDAt($slotid) > 0) {
            $client->DeleteItemInInventory($slotid, 0, 1);
        }
    }

    DungeonSetCharacter(1);

    #rusty mace 6011
    #rusty dagger 7007
    $weaponID = 6011;
    if ($class eq "Rogue" || $class eq "Necromancer" || $class eq "Wizard" || $class eq "Mage" || $class eq "Enchanter") {
        $weaponID = 7007;
    }
    $client->SummonItem(6011, 1, 0, 0, 0, 0, 0, 0, 13);
}


# DungeonNameGenerate() creates next dungeon choices
sub DungeonNameGenerate {
    $client = plugin::val('$client');


    $client->Heal();

    my %pool;
    my $poolTotal = 0;
    my $roll = 0;


    #last entry should not have pooltotal added
    #$poolTotal += 100;


    $attempts = quest::ChooseRandom(2..5);
    quest::set_data($client->CharacterID() . "-state", "NEXT_DUNGEON");
    quest::set_data($client->CharacterID() . "-dialog-count", $attempts);
    quest::set_data($client->CharacterID() . "-dialog-header", "choose your path:");
    foreach my $taskid (290 .. 293) {
        $client->FailTask($taskid);
    }
    if ($client->GetGM()) {
        $client->Message(0, "trying $attempts at rolls");
    }
    foreach my $i (1..$attempts) {
        #"thulelibrary"
        # "riftseekers"
        #suncrest
        #rujg, ruji, rujj
        #"gyrospireb"
        $path = quest::ChooseRandom("ruja","mira","taka","guka","breedinggrounds","felwithea","skyshrine","soldungc","hateplaneb","rujd","rujf","sncrematory","snpool","solteris","ssratemple","suncrest","toskirakk","stillmoonb","veksar","housegarden","foundation", "somnium", "windsong");

        if ($client->GetGM()) {
            $client->Message(15, "chose " . $path);
        }
        $text = "take the path";


        $killCount = 0;
        if ($client->GetLevel() < 10) {
            $taskid = 290;
        } elsif ($client->GetLevel() < 20) {
            $taskid = quest::ChooseRandom(290, 291);
        } elsif ($client->GetLevel() < 30) {
            $taskid = quest::ChooseRandom(290, 291, 292);
        } else {
            $taskid = quest::ChooseRandom(290, 291, 292, 293);
        }
        if ($taskid == 290) {
            $killCount = 5;
        } elsif ($taskid == 291) {
            $killCount = 10;
        } elsif ($taskid == 292) {
            $killCount = 15;
        } elsif ($taskid == 293) {
            $killCount = 20;
        }

        if ($path eq "gryospireb") {
            $adj = quest::ChooseRandom("clockwork", "gyro", "spire", "bez");
            $version = 0;
        }

        if ($path eq "breedinggrounds") {
            $adj = quest::ChooseRandom("chetari", "dracoliche", "fire dragon", "breeding");
            $version = 0;
        }

        if ($path eq "ruja") {
            $adj = quest::ChooseRandom("long", "dark", "narrow", "underground");
            $version = 1;
        }

        if ($path eq "guka") {
            $adj = quest::ChooseRandom("slimy", "froglok", "evil eye", "living");
            $version = 2;
        }

        if ($path eq "mira") {
            $adj = quest::ChooseRandom("frozen", "cold", "frosted", "velium");
            $version = 2;
        }

        if ($path eq "taka") {
            $adj = quest::ChooseRandom("sandy", "earthy", "buried", "elemental");
            $version = 2;
        }

        if ($path eq "soldungc") {
            $adj = quest::ChooseRandom("webbed", "lava-filled", "Nagafen", "fire");
            $version = 0;
        }

        if ($path eq "felwithea") {
            $adj = quest::ChooseRandom("elven", "high", "good", "white");
            $version = 0;
        }

        if ($path eq "rujd") {
            $adj = quest::ChooseRandom("unknown", "dug", "restless", "lowest");
            $version = 2;
        }

        if ($path eq "skyshrine") {
            $adj = quest::ChooseRandom("sky", "dragonic", "Yelinak", "ice golem");
            $version = 0;
        }

        if ($path eq "hateplaneb") {
            $adj = quest::ChooseRandom("evil", "hated", "Innoruuk", "vampiric");
            $version = 0;
        }

        if ($path eq "rujf") {
            $adj = quest::ChooseRandom("muscovite", "primordial", "darksome", "unfounded");
            $version = 2;
        }

        if ($path eq "rujg") {
            $adj = quest::ChooseRandom("wooden", "orcish", "hollow", "horrid");
            $version = 50;
        }

        if ($path eq "ruji") {
            $adj = quest::ChooseRandom("brown", "dirty", "muddy", "goblin");
            $version = 0;
        }

        if ($path eq "rujj") {
            $adj = quest::ChooseRandom("hot", "quiet", "deep", "yellow");
            $version = 2;
        }


        if ($path eq "housegarden") {
            $adj = quest::ChooseRandom("overgrown", "green", "mossy", "buzzing");
            $version = 0;
        }

        if ($path eq "foundation") {
            $adj = quest::ChooseRandom("rocky", "dwarven", "beetle", "giant");
            $version = 0;
        }

        if ($path eq "stillmoonb") {
            $adj = quest::ChooseRandom("trail", "spider", "winding", "eerie");
            $version = 0;
        }

        if ($path eq "sncrematory") {
            $adj = quest::ChooseRandom("sewer", "underground", "green", "gross");
            $version = 0;
        }

        if ($path eq "snpool") {
            $adj = quest::ChooseRandom("liquid", "grimy", "diseased", "infested");
            $version = 0;
        }

        if ($path eq "solteris") {
            $adj = quest::ChooseRandom("fiery", "red", "enflamed", "godly");
            $version = 0;
        }

        if ($path eq "ssratemple") {
            $adj = quest::ChooseRandom("snake", "airless", "mysterious", "grey");
            $version = 0;
        }

        if ($path eq "suncrest") {
            $adj = quest::ChooseRandom("airy", "windy", "blue", "wandering");
            $version = 0;
        }

        if ($path eq "toskirakk") {
            $adj = quest::ChooseRandom("slaver", "ogre", "rough", "gold");
            $version = 0;
        }

        if ($path eq "veksar") {
            $adj = quest::ChooseRandom("rocky", "scary", "evil", "watery");
            $version = 0;
        }


        if ($path eq "thulelibrary") {
            $adj = quest::ChooseRandom("studious", "sheen", "free", "critical");
            $version = 0;
        }

        if ($path eq "somnium") {
            $adj = quest::ChooseRandom("glittering", "mysterious", "enigmatic", "insane");
            $version = 0;
        }

        if ($path eq "windsong") {
            $adj = quest::ChooseRandom("airy", "windy", "blue", "wandering");
            $version = 0;
        }

        if ($path eq "riftseekers") {
            $adj = quest::ChooseRandom("devil", "icy", "split", "crystallized");
            $version = 0;
        }

        $text = "slay $killCount enemies on the the $adj path";
        quest::set_data($client->CharacterID() . "-dialog-option-" . $i . "-text", $text);
        quest::set_data($client->CharacterID() . "-dialog-option-" . $i . "-effect", "dungeon-" . $path . "-" . $version . "-" . $taskid);
        quest::set_data($client->CharacterID() . "-dialog-option-" . $i . "-result", "preparing dungeon, please wait a moment as it manifests");
    }
}



# DungeonSetCharacter(level) # Sets a character to provided level, scribing all spells and skills available
sub DungeonSetCharacter {
    $level = shift;
    $client = plugin::val('$client');
    quest::level($level);

    # set all available skills to maximum for race/class at current level
    foreach my $skill (0 .. 77) {
        # continue the foreach loop using the next skill ID if the client cannot use the skill ID
        next unless $client->CanHaveSkill($skill);
        # create a scalar variable to store the maximum skill Value for the Skill ID
        my $maxSkill = $client->MaxSkill($skill, $client->GetClass(), $level);
        # continue the foreach loop using the next Skill ID if the client has a higher skill Value for the Skill ID
        next unless $maxSkill > $client->GetRawSkill($skill);
        # set the Skill ID to the maximum Value that the client is allowed
        $client->SetSkill($skill, $maxSkill);
    }

    quest::traindiscs($level, $level-1);
    quest::scribespells($level, $level-1);
}