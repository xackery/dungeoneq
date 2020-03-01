sub EVENT_SPAWN {
    if ($zoneid == 386) {
        return;
    }
    if ($zoneid == 1) {
        return;
    }
    quest::settimer(1,1);
}

sub EVENT_TIMER {
    if ($timer == 1) {
        quest::stoptimer(1);
        $level = quest::get_data("instance-" . $instanceid . "-level");
        if (!$level) {
            return;
        }
        if ($npc->GetOwnerID()) {
            return;
        }
        if ($npc->GetRace() == 377) { #chest
            $npc->Depop();
            return;
        }
        if ($npc->GetNPCTypeID() == 672) { # a steadfast servant
            return;
        }
        if ($npc->GetRace() == 376) { #box
            $npc->Depop();
            return;
        }
        if ($npc->GetRace() == 381) { #weapon rack
            $npc->Depop();
            return;
        }
        if ($npc->GetRace() == 380) { #table
            $npc->Depop();
            return;
        }
        if ($npc->GetNPCTypeID() == 2000910) {
            return;
        }
        if ($npc->GetNPCTypeID() == 2000911) {
            return;
        }
        if ($npc->GetNPCTypeID() == 2000912) {
            return;
        }
        if (!$npc->IsTargetable()) {
            $npc->Depop();
            return;
        }
        if ($npc->IsTrap()) {
            $npc->Depop();
            return;
        }
        ScaleAll($npc, $level);
        $npc->Heal();
    }
}


sub EVENT_DEATH_COMPLETE {
    if ($zoneid == 386) {
        return;
    }

    $killer = $entity_list->GetMobByID($killer_id);
    
    if ($killer->IsPet()) {
        $killer_id = $killer->GetOwnerID();
        $killer = $entity_list->GetMobByID($killer_id);
        if (!$killer) {
            return;
        }
    }

    if (!$killer->IsClient()) {
        return;
    }


    my @cl = $entity_list->GetClientList();
    foreach my $c (@cl) {
        if (!$c) {
            next;
        }
        if (!$c->IsClient()) {
            next;
        }
        foreach my $taskid (290 .. 294) {        
            $c->UpdateTaskActivity($taskid, 0, 1);
        }
    }
}

sub ScaleAll {
    $npc = shift;
    $level = shift;
    if ($level > 100) {
        $level = 100;
    }

    if ($level < 1) {
        return;
    }
    if (!$npc) {
        return;
    }
    
    $originalLevel = $npc->GetLevel();

    #$npc->SetLevel($level);
    ScaleLevel($npc, $level);
    ScaleAccuracy($npc, $level);
    ScaleSlowMitigation($npc, $level);
    ScaleAttack($npc, $level);
    ScaleStrength($npc, $level);
    ScaleStamina($npc, $level);
    ScaleDexterity($npc, $level);
    ScaleAgility($npc, $level);
    ScaleIntelligence($npc, $level);
    ScaleWisdom($npc, $level);
    ScaleCharisma($npc, $level);
    ScaleMagicResist($npc, $level);
    ScaleColdResist($npc, $level);
    ScaleFireResist($npc, $level);
    ScalePoisonResist($npc, $level);
    ScaleDiseaseResist($npc, $level);
    ScaleCorruptionResist($npc, $level);
    ScalePhysicalResist($npc, $level);
    ScaleMinDamage($npc, $level);
    ScaleMaxDamage($npc, $level);
    ScaleHPRegenRate($npc, $level);
    ScaleAttackDelay($npc, $level);
    ScaleAttackSpeed($npc, $level);
    ScaleSpellScale($npc, $level);
    ScaleHealScale($npc, $level);
    ScaleSpecialAbilities($npc, $level);
    ScaleAvoidance($npc, $level);
    ScaleAC($npc, $level);
    ScaleHP($npc, $level);
    ScaleSpells($npc, $level, $originalLevel);
    ScaleSpellEffects($npc, $level, $originalLevel);
}


sub ScaleLevel {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    $npc->ModifyNPCStat("level", $level);
}


sub ScaleAC {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 8, 11, 14, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 52, 59, 65, 72, 78, 85, 91, 95, 99, 103, 107, 111, 115, 119, 123, 127, 135, 142, 150, 158, 166, 173, 181, 189, 196, 204, 208, 212, 217, 221, 225, 229, 233, 237, 241, 245, 249, 253, 257, 261, 266, 270, 274, 278, 282, 286, 290, 294, 299, 303, 307, 311, 315, 319, 324, 328, 332, 336, 340, 344, 348, 352, 356, 360, 364, 368, 372, 376, 380, 384, 388, 392, 396, 400, 404, 408, 420, 423, 444, 456, 468, 480, 492, 504, 516, 528);
    $npc->ModifyNPCStat("ac", $stats[$level]);
}

sub ScaleHP {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }

    @stats = (0, 11, 27, 43, 59, 75, 100, 125, 150, 175, 200, 234, 268, 302, 336, 381, 426, 471, 516, 561, 606, 651, 712, 800, 845, 895, 956, 1100, 1140, 1240, 1350, 1450, 1550, 1650, 1750, 1850, 1950, 2100, 2350, 2650, 2900, 3250, 3750, 4250, 5000, 5600, 6000, 6500, 7500, 8500, 10000, 11700, 13400, 15100, 16800, 18500, 20200, 21900, 23600, 25300, 27000, 28909, 30818, 32727, 34636, 36545, 38455, 40364, 42273, 44182, 46091, 48000, 49909, 51818, 53727, 55636, 75000, 90000, 113000, 130000, 140000, 240000, 340000, 440000, 445000, 450000, 455000, 460000, 465000, 470000, 475000, 800000, 900000, 1000000, 1100000, 1200000, 1300000, 1400000, 1500000, 1600000, 1700000);
    $hp = $stats[$level];
    
    $modifier = 1;

    if ($level >= 30) {
        $modifier = 0.8;
    }
    if ($level >= 40) {
        $modifier = 0.6;
    }
    if ($level >= 50) {
        $modifier = 0.4;
    }
    if ($level >= 55) {
        $modifier = 0.3;
    }
    if ($level >= 60) {
        $modifier = 0.2;
    }
    #if ($level >= 65) {
    #    $modifier = 0.16;
    #}
    #if ($level >= 70) {
    #    $modifier = 0.14;
    #}


    $hp *= $modifier;

    $npc->ModifyNPCStat("max_hp", $hp);
}

sub ScaleAccuracy {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 42, 44, 46, 48, 50, 50, 50, 50, 50, 50, 53, 56, 59, 62, 65, 68, 71, 74, 77, 80, 85, 91, 96, 102, 107, 113, 118, 124, 129, 135, 140, 143, 145, 148, 150, 160, 200, 250, 270, 300, 330, 500, 1050, 1055, 1060, 1065, 1070, 1075, 1080, 1085, 1090, 1095, 1100, 1105, 1110, 1115, 1120, 1125, 1130, 1135);
    $npc->ModifyNPCStat("accuracy", $stats[$level]);
}

sub ScaleSlowMitigation {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 20, 20, 20, 20, 20, 25, 25, 25, 25, 25, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30);
    $npc->ModifyNPCStat("slow_mitigation", $stats[$level]);
}

sub ScaleAttack {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 42, 44, 46, 48, 50, 50, 50, 50, 50, 50, 53, 56, 59, 62, 65, 68, 71, 74, 77, 80, 84, 87, 91, 95, 98, 102, 105, 109, 113, 116, 120, 128, 135, 143, 150, 160, 170, 180, 190, 200, 300, 400, 410, 420, 430, 440, 450, 460, 470, 480, 485, 490, 495, 500, 505, 510, 515, 520, 525, 530);
    $npc->ModifyNPCStat("atk", $stats[$level]);
}

sub ScaleStrength {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 85, 88, 91, 94, 97, 104, 110, 117, 123, 130, 137, 143, 150, 156, 163, 166, 169, 173, 176, 179, 182, 185, 188, 191, 194, 197, 200, 203, 206, 210, 213, 216, 219, 222, 225, 228, 231, 234, 237, 240, 244, 247, 250, 253, 256, 259, 262, 265, 268, 271, 274, 277, 280, 283, 286, 289, 292, 295, 298, 301, 304, 307, 310, 313, 316, 319, 322, 325, 328, 331, 334, 337, 340, 343, 346);
    $npc->ModifyNPCStat("str", $stats[$level]);
}

sub ScaleStamina {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 85, 88, 91, 94, 97, 104, 110, 117, 123, 130, 137, 143, 150, 156, 163, 166, 169, 173, 176, 179, 182, 185, 188, 191, 194, 197, 200, 203, 206, 210, 213, 216, 219, 222, 225, 228, 231, 234, 237, 240, 244, 247, 250, 253, 256, 259, 262, 265, 268, 271, 274, 277, 280, 283, 286, 289, 292, 295, 298, 301, 304, 307, 310, 313, 316, 319, 322, 325, 328, 331, 334, 337, 340, 343, 346);
    $npc->ModifyNPCStat("sta", $stats[$level]);
}

sub ScaleDexterity {
    $npc = shift;
    $level = shift;
    @stats = (0, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 85, 88, 91, 94, 97, 104, 110, 117, 123, 130, 137, 143, 150, 156, 163, 166, 169, 173, 176, 179, 182, 185, 188, 191, 194, 197, 200, 203, 206, 210, 213, 216, 219, 222, 225, 228, 231, 234, 237, 240, 244, 247, 250, 253, 256, 259, 262, 265, 268, 271, 274, 277, 280, 283, 286, 289, 292, 295, 298, 301, 304, 307, 310, 313, 316, 319, 322, 325, 328, 331, 334, 337, 340, 343, 346);
    $npc->ModifyNPCStat("dex", $stats[$level]);
}

sub ScaleAgility {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 85, 88, 91, 94, 97, 104, 110, 117, 123, 130, 137, 143, 150, 156, 163, 166, 169, 173, 176, 179, 182, 185, 188, 191, 194, 197, 200, 203, 206, 210, 213, 216, 219, 222, 225, 228, 231, 234, 237, 240, 244, 247, 250, 253, 256, 259, 262, 265, 268, 271, 274, 277, 280, 283, 286, 289, 292, 295, 298, 301, 304, 307, 310, 313, 316, 319, 322, 325, 328, 331, 334, 337, 340, 343, 346);
    $npc->ModifyNPCStat("agi", $stats[$level]);
}

sub ScaleIntelligence {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 85, 88, 91, 94, 97, 104, 110, 117, 123, 130, 137, 143, 150, 156, 163, 166, 169, 173, 176, 179, 182, 185, 188, 191, 194, 197, 200, 203, 206, 210, 213, 216, 219, 222, 225, 228, 231, 234, 237, 240, 244, 247, 250, 253, 256, 259, 262, 265, 268, 271, 274, 277, 280, 283, 286, 289, 292, 295, 298, 301, 304, 307, 310, 313, 316, 319, 322, 325, 328, 331, 334, 337, 340, 343, 346);
    $npc->ModifyNPCStat("int", $stats[$level]);
}

sub ScaleWisdom {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 85, 88, 91, 94, 97, 104, 110, 117, 123, 130, 137, 143, 150, 156, 163, 166, 169, 173, 176, 179, 182, 185, 188, 191, 194, 197, 200, 203, 206, 210, 213, 216, 219, 222, 225, 228, 231, 234, 237, 240, 244, 247, 250, 253, 256, 259, 262, 265, 268, 271, 274, 277, 280, 283, 286, 289, 292, 295, 298, 301, 304, 307, 310, 313, 316, 319, 322, 325, 328, 331, 334, 337, 340, 343, 346);
    $npc->ModifyNPCStat("wis", $stats[$level]);
}

sub ScaleCharisma {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 85, 88, 91, 94, 97, 104, 110, 117, 123, 130, 137, 143, 150, 156, 163, 166, 169, 173, 176, 179, 182, 185, 188, 191, 194, 197, 200, 203, 206, 210, 213, 216, 219, 222, 225, 228, 231, 234, 237, 240, 244, 247, 250, 253, 256, 259, 262, 265, 268, 271, 274, 277, 280, 283, 286, 289, 292, 295, 298, 301, 304, 307, 310, 313, 316, 319, 322, 325, 328, 331, 334, 337, 340, 343, 346);
    $npc->ModifyNPCStat("cha", $stats[$level]);
}

sub ScaleMagicResist {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    } 
    @stats = (0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 16, 17, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 24, 25, 25, 26, 26, 27, 27, 28, 28, 29, 29, 30, 30, 31, 31, 32, 32, 33, 33, 34, 34, 35, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 58, 61, 64, 67, 70, 73, 76, 79, 82, 85);
    $npc->ModifyNPCStat("mr", $stats[$level]);
}

sub ScaleColdResist {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 16, 17, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 24, 25, 25, 26, 26, 27, 27, 28, 28, 29, 29, 30, 30, 31, 31, 32, 32, 33, 33, 34, 34, 35, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 58, 61, 64, 67, 70, 73, 76, 79, 82, 85);
    $npc->ModifyNPCStat("cr", $stats[$level]);
}

sub ScaleFireResist {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 16, 17, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 24, 25, 25, 26, 26, 27, 27, 28, 28, 29, 29, 30, 30, 31, 31, 32, 32, 33, 33, 34, 34, 35, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 58, 61, 64, 67, 70, 73, 76, 79, 82, 85);
    $npc->ModifyNPCStat("fr", $stats[$level]);
}

sub ScalePoisonResist {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 16, 17, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 24, 25, 25, 26, 26, 27, 27, 28, 28, 29, 29, 30, 30, 31, 31, 32, 32, 33, 33, 34, 34, 35, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 58, 61, 64, 67, 70, 73, 76, 79, 82, 85);
    $npc->ModifyNPCStat("pr", $stats[$level]);
}

sub ScaleDiseaseResist {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15, 16, 17, 17, 18, 19, 20, 21, 22, 22, 23, 23, 24, 24, 25, 25, 26, 26, 27, 27, 28, 28, 29, 29, 30, 30, 31, 31, 32, 32, 33, 33, 34, 34, 35, 35, 36, 36, 37, 38, 39, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 58, 61, 64, 67, 70, 73, 76, 79, 82, 85);
    $npc->ModifyNPCStat("dr", $stats[$level]);
}

sub ScaleCorruptionResist {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 8, 8, 9, 10, 10, 11, 11, 12, 12, 13, 14, 14, 15, 16, 16, 17, 18, 18, 19, 20, 22, 23, 25, 26, 27, 29, 30, 32, 33, 34, 35, 35, 36, 37, 38, 39, 39, 40, 41, 42, 43, 43, 44, 45, 46, 47, 47, 48, 49, 50, 51, 51, 52, 53, 54, 55, 56, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 80, 83, 86, 89, 92, 95, 98, 101, 104, 107);
    $npc->ModifyNPCStat("cor", $stats[$level]);
}

sub ScalePhysicalResist {
    $npc = shift;
    $level = shift;
    
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }



    @stats = (0, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 143, 146, 149, 152, 155, 158, 161, 164, 167, 170);

    $value = $stats[$level];
    $modifier = 1;
    if ($npc->GetClass() != 1 && $npc->GetClass != 7 && $npc->GetClass != 9 && $npc->GetClass != 16) {
        $modifier = 1.2;
    }
    $value /= $modifier;
    $npc->ModifyNPCStat("phr", $value);
}

sub ScaleMinDamage {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 4, 6, 7, 7, 8, 8, 9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 12, 12, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 33, 34, 34, 35, 36, 44, 51, 59, 66, 74, 78, 81, 85, 89, 93, 96, 100, 104, 107, 111, 128, 145, 162, 179, 196, 213, 230, 247, 264, 281, 298, 305, 312, 318, 325, 400, 500, 594, 650, 720, 800, 900, 1275, 1300, 1359, 1475, 1510, 1610, 1650, 1700, 2964, 2976, 2988, 3000, 3012, 3024, 3042, 3060, 3078, 3096);

    $value = $stats[$level];
    $modifier = 1;

    if ($npc->GetClass() != 1 && $npc->GetClass != 7 && $npc->GetClass != 9 && $npc->GetClass != 16) {
        $modifier = 1.3;
    }

    $value /= $modifier;

    $npc->ModifyNPCStat("min_hit", $value);
}

sub ScaleMaxDamage {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 27, 30, 32, 35, 37, 39, 41, 42, 44, 46, 48, 50, 52, 55, 57, 59, 61, 64, 66, 68, 74, 79, 85, 90, 96, 102, 107, 113, 118, 124, 127, 130, 133, 136, 139, 152, 165, 178, 191, 204, 231, 258, 284, 311, 338, 365, 392, 418, 445, 472, 536, 599, 663, 727, 790, 854, 917, 981, 1045, 1108, 1172, 1193, 1214, 1235, 1256, 1600, 2050, 2323, 2500, 2799, 3599, 4599, 4904, 5100, 5292, 5578, 5918, 6200, 6275, 6350, 9755, 10153, 10551, 10949, 11347, 11745, 12143, 12541, 12939, 13337);

    $value = $stats[$level];
    $modifier = 1;

    if ($npc->GetClass() != 1 && $npc->GetClass != 7 && $npc->GetClass != 9 && $npc->GetClass != 16) {
        $modifier = 1.5;
    }

    $value /= $modifier;

    $npc->ModifyNPCStat("max_hit", $value);
}

sub ScaleHPRegenRate {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5.5, 5.7, 6.2, 6.75, 7.25, 7.75, 8.25, 8.75, 9.25, 9.75, 10.5, 11.75, 13.25, 14.5, 16.25, 18.75, 21.25, 25, 28, 30, 32.5, 37.5, 42.5, 50, 58.5, 67, 75.5, 84, 92.5, 101, 109.5, 118, 126.5, 135, 144.545, 154.09, 163.635, 173.18, 182.725, 192.275, 201.82, 211.365, 220.91, 230.455, 240, 249.545, 259.09, 268.635, 278.18, 375, 450, 565, 650, 700, 1200, 1700, 2200, 2225, 2250, 2275, 2300, 2325, 2350, 2375, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500);
    $npc->ModifyNPCStat("hp_regen", $stats[$level]);
}

sub ScaleAttackDelay {
    $npc = shift;
    $level = shift;    
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 29, 28, 27, 25, 24, 23, 22, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 20, 20, 20, 20, 20, 20, 19, 19, 19, 19, 19, 18, 18, 18, 18, 18, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15);
    $npc->ModifyNPCStat("attack_delay", $stats[$level]);
}

sub ScaleAttackSpeed {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    #@stats = (0, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 29, 28, 27, 25, 24, 23, 22, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 20, 20, 20, 20, 20, 20, 19, 19, 19, 19, 19, 18, 18, 18, 18, 18, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16);
    $npc->ModifyNPCStat("attack_speed", 0);
}

sub ScaleSpellScale {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100);
    $npc->ModifyNPCStat("spell_scale", $stats[$level]);
}

sub ScaleHealScale {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = (0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100);
    $npc->ModifyNPCStat("heal_scale", $stats[$level]);
}

sub ScaleSpecialAbilities {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    @stats = ("21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "21,1", "8,1", "8,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1", "8,1^21,1");
    $npc->ModifyNPCStat("special_abilities", $stats[$level]);
}

sub ScaleAvoidance {
    $npc = shift;
    $level = shift;
    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    $npc->ModifyNPCStat("avoidance", 0);
}

sub ScaleSpells {
    $npc = shift;
    $level = shift;
    $originalLevel = shift;
    if ($level < 10) {
        $npc->ModifyNPCStat("npc_spells_id", 0);
        return;
    }

    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }

    if ($originalLevel >= $level-5 && $originalLevel < $level+5 && $npc->GetNPCSpellsID() > 0) {
        $npc->ModifyNPCStat("npc_spells_id", $npc->GetNPCSpellsID());
        return;
    }
    
    $spell_id = 0;
    if ($npc->GetClass() == 2) { $spell_id = 1; } #cleric 
    if ($npc->GetClass() == 12) { $spell_id = 2; } #wizard
    if ($npc->GetClass() == 11) { $spell_id = 3; } #necro
    if ($npc->GetClass() == 13) { $spell_id = 4; } #mage
    if ($npc->GetClass() == 14) { $spell_id = 5; } #enchanter
    if ($npc->GetClass() == 10) { $spell_id = 6; } #shaman
    if ($npc->GetClass() == 6) { $spell_id = 7; } #druid
    if ($npc->GetClass() == 3) { $spell_id = 8; } #paladin
    if ($npc->GetClass() == 5) { $spell_id = 9; } #shadowknight
    if ($npc->GetClass() == 4) { $spell_id = 10; } #ranger
    if ($npc->GetClass() == 8) { $spell_id = 11; } #bard
    if ($npc->GetClass() == 15) { $spell_id = 12; } #beastlord

    $npc->ModifyNPCStat("npc_spells_id", $spell_id);
}

sub ScaleSpellEffects {
    $npc = shift;
    $level = shift;
    
     $originalLevel = shift;

    if ($level < 1) {
        $level = 1;
    }
    if ($level > 100) {
        $level = 100;
    }
    if ($level < 10) {
        $npc->ModifyNPCStat("npc_spells_effects_id", 0);
        return;
    }

    #$originalLevel >= $level-5 && 
    if ($originalLevel < $level+5 && $npc->GetNPCSpellsID() > 0) {
        return;
    }
    $npc->ModifyNPCStat("npc_spells_effects_id", 0);    
}