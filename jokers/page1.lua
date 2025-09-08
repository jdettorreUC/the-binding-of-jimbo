--Page 1 Jokers Atlas
SMODS.Atlas{
    key = 'TBOJ_Jokers',
    path = 'TBOJ_jokers.png',
    px = 71,
    py = 95
}

--ID 001 (Sad Onion)

SMODS.Joker{

    key = 'sad_onion',
    atlas = 'TBOJ_Jokers',
    pos = {x= 0, y = 0},


    rarity = 1,
    cost = 4,
    unlocked = true,
    blueprint_compat = true,


    config = {extra = { chips = 50 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,

    loc_txt = {
        name = 'Sad Onion',
        text = {
            '{C:chips}+#1#{} Chips',
        }
    },


    calculate = function(self, card, context)  
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

--ID 002 (The Inner Eye)

SMODS.Joker{

    key = 'the_inner_eye',
    atlas = 'TBOJ_Jokers',
    pos = {x= 1, y = 0},


    rarity = 1,
    cost = 4,
    unlocked = true,
    blueprint_compat = true,


    config = {extra = { mult = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    loc_txt = {
        name = 'The Inner Eye',
        text = {
            [1] = 'This Joker gains {C:mult}+6{} Mult if',
            [2] = 'played hand is a {C:attention}Three of a Kind{}',
            [3] = '{C:inactive}(Currently {C:mult}+#1#{} {C:inactive}Mult)',
        }
    },


    calculate = function(self, card, context)
        if context.before and context.scoring_hand and context.scoring_name == "Three of a Kind" then
            card.ability.extra.mult = card.ability.extra.mult + 6
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

--ID 003 (Spoon Bender)

--ID 004 (Cricket's Head)

--ID 005 (My Reflection)

--[[
SMODS.Joker {
    key = 'my_reflection',
    atlas = 'TBOJ_Jokers',
    pos = {x = 4, y = 0},

    rarity = 1,
    cost = 4,
    unlocked = true,
    blueprint_compat = true,

    config = {extra = { Xmult = 3 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,

    loc_txt = {
        name = 'My Reflection',
        text = {
            [1] = '{C:mult}x#1#{} mult if played hand is {C:attention}symmetrical',
            [2] = '{C:inactive}(Non-Stone enhancements excluded)'
        }
    },

    
}
    ]]

--ID 006 (Number One)

--ID 007 (Blood of the Martyr)

--ID 008 (Brother Bobby)

--ID 009 (Skatole)

--ID 010 (Halo of Flies)

--ID 011 (1up!)

--ID 012 (Magic Mushroom)

--ID 013 (The Virus)

--ID 014 (Roid Rage)

--ID 015 (<3)

--ID 016 (Raw Liver)

--ID 017 (Skeleton Key)

--ID 018 (A Dollar)

--ID 019 (BOOM!)

--ID 020 (Transcendence)

--ID 021 (The Compass)

--ID 022 (Lunch)

--ID 023 (Dinner)

--ID 024 (Dessert)

--ID 025 (Breakfast)

--ID 026 (Rotten Meat)

--ID 027 (Wooden Spoon)

--ID 028 (The Belt)

--ID 029 (Mom's Underwear)

--ID 030 (Mom's Heels)

--ID 031 (Mom's Lipstick)

--ID 032 (Wire Coat Hanger)

--ID 033 (The Bible)

--ID 034 (The Book of Belial)

--ID 035 (The Necronomicon)

--ID 036 (The Poop)

--ID 037 (Mr. Boom)

--ID 038 (Tammy's Head)

--ID 039 (Mom's Bra)

--ID 040 (Kamikaze!)

--ID 041 (Mom's Pad)

--ID 042 (Bob's Rotten Head)

--ID 043 DNE

--ID 044 (Teleport!)

--ID 045 (Yum Heart)

--ID 046 (Lucky Foot)

--ID 047 (Doctor's Remote)

--ID 048 (Cupid's Arrow)

--ID 049 (Shoop Da Whoop!)

--ID 050 (Steven)

--ID 051 (Pentagram)

--ID 052 (Dr. Fetus)

--ID 053 (Magneto)

--ID 054 (Treasure Map)

--ID 055 (Mom's Eye)

--ID 056 (Lemon Mishap)

--ID 057 (Distant Admiration)

--ID 058 (Book of Shadows)

--ID 059 DNE

--ID 060 (The Ladder)

--ID 061 DNE

--ID 062 (Mark of the Vampire)

--ID 063 (The Battery)

--ID 064 (Steam Sale)

--ID 065 (Anarchist Cookbook)

--ID 066 (The Hourglass)

--ID 067 (Sister Maggy)

--ID 068 (Technology)

--ID 069 (Chocolate Milk)

--ID 070 (Growth Hormones)

--ID 071 (Mini Mush)

--ID 072 (Rosary)

--ID 073 (Cube of Meat)

--ID 074 (A Quarter)

--ID 075 (PHD)

--ID 076 (X-Ray Vision)

--ID 077 (My Little Unicorn)

--ID 078 (Book of Revelations)

--ID 079 (The Mark)

SMODS.Joker {
    key = 'the_mark',
    atlas = 'TBOJ_Jokers',
    pos = {x = 15, y = 3},

    rarity = 1,
    cost = 4,
    unlocked = true,
    blueprint_compat = true,

    config = {extra = { chips = 6, mult = 6} },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,

    loc_txt = {
        name = 'The Mark',
        text = {
            [1] = 'Played {C:attention}6s{} score',
            [2] = '{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult',
        }
    },

        calculate = function(self, card, context)  
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 6 then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips,
                card = card
            }
        end
    end
}

--ID 080 (The Pact)

--ID 081 (Dead Cat)

--ID 082 (Lord of the Pit)

--ID 083 (The Nail)

--ID 084 (We Need to go Deeper!)

SMODS.Joker {
    key = 'we_need_to_go_deeper',
    atlas = 'TBOJ_Jokers',
    pos = {x = 0, y = 4},

    rarity = 1,
    cost = 4,
    unlocked = true,
    blueprint_compat = true,

    config = {extra = { chips = 0} },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,

    loc_txt = {
        name = 'We Need To Go Deeper!',
        text = {
            [1] = 'Played {C:attention}Spades{} score {C:chips}+10{} Chips',
            [2] = 'per {C:attention}Spade{} scored this round',
            [3] = '{C:inactive}(Currently{} {C:chips}+#1#{} {C:inactive}Chips)'
        }
    },

        calculate = function(self, card, context)

            if context.individual and context.cardarea == G.play and context.other_card:is_suit("Spades") then
                card.ability.extra.chips = card.ability.extra.chips + 10
                return {
                    chips = card.ability.extra.chips,
                    card = card
                }
            end

            if context.end_of_round and not context.individual then
                card.ability.extra.chips = 0
                return {
                    message = "Reset",
                }
            end
        end
}

--ID 085 (Deck of Cards)

--ID 086 (Monstro's Tooth)

--ID 087 (Loki's Horns)

--ID 088 (Little Chubby)

--ID 089 (Spider Bite)

--ID 090 (The Small Rock)

SMODS.Joker {
    key = 'the_small_rock',
    atlas = 'TBOJ_Jokers',
    pos = {x = 6, y = 4},

    rarity = 1,
    cost = 4,
    unlocked = true,
    blueprint_compat = true,
    --enhancement_gate = 'm_stone',

    config = {extra = {mult = 4 } },

    loc_vars = function(self, info_queue, card)
        --info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return {vars = { card.ability.extra.mult }}
    end,

    loc_txt = {
        name = 'The Small Rock',
        text = {
            [1] = 'Played {C:attention}Stone Cards{}',
            [2] = 'give {C:mult}+#1#{} mult when scored',
        }
    },

    calculate = function(self, card, context)  
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_stone') then
            return {
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end
}

--ID 091 (Spelunker Hat)

SMODS.Joker {
    key = 'spelunker_hat',
    atlas = 'TBOJ_Jokers',
    pos = {x = 7, y = 4},

    rarity = 1,
    cost = 4,
    unlocked = true,
    blueprint_compat = true,

    config = {extra = { money = 3 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,

    loc_txt = {
        name = 'Spelunker Hat',
        text = {
            [1] = '{C:attention}Stone Cards{} held in hand',
            [2] = 'earn {C:money}$#1#{} at end of round',
        }
    },

        calculate = function(self, card, context)  
        if context.cardarea == G.hand and context.end_of_round and context.individual and SMODS.has_enhancement(context.other_card, 'm_stone') then
            --MUST use "dollars" not "money"
            return {
                dollars = card.ability.extra.money,
                card = card
            }
        end
    end
}

--ID 092 (Super Bandage)

--ID 093 (The Gamekid)

--ID 094 (Sack of Pennies)

--ID 095 (Robo-Baby)

--ID 096 (Little C.H.A.D.)

--ID 097 (The Book of Sin)

--ID 098 (The Relic)

--ID 099 (Little Gish)

--ID 100 (Little Steven)

--ID 101 (The Halo)

--ID 102 (Mom's Bottle of Pills)

--ID 103 (The Common Cold)

--ID 104 (The Parasite)

--ID 105 (The D6)

--ID 106 (Mr. Mega)

--ID 107 (The Pinking Shears)

--ID 108 (The Wafer)

--ID 109 (Money = Power)

--ID 110 (Mom's Contacts)

--ID 111 (The Bean)

--ID 112 (Guardian Angel)

--ID 113 (Demon Baby)

--ID 114 (Mom's Knife)

--ID 115 (Ouija Board)

--ID 116 (9 Volt)

--ID 117 (Dead Bird)

--ID 118 (Brimstone)

--ID 119 (Blood Bag)

--ID 120 (Odd Mushroom - Skinny)

--ID 121 (Odd Mushroom - Wide)

--ID 122 (Whore of Babylon)

--ID 123 (Monster Manual)