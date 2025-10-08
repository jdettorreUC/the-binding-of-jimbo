SMODS.Atlas{
    key = 'reverse_tarots',
    path = 'ReverseTarots.png',
    px = 71,
    py = 95
}

--The Fool? - Creates a reverse copy of the last used Tarot card (The Fool/The Fool? excluded)
SMODS.Consumable {
    key = 'reverse_fool',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 9, y = 2},

    loc_vars = function(self, info_queue, card)
        local reverse_fool_c = G.GAME.tboj_last_tarot and G.P_CENTERS[G.GAME.tboj_last_tarot] or nil
        local reversal = nil
        local last_tarot = reverse_fool_c and localize { type = 'name_text', key = reverse_fool_c.key, set = reverse_fool_c.set } or
            localize('k_none')
        local colour = (not reverse_fool_c or reverse_fool_c.name == 'The Fool' or reverse_fool_c.key == 'c_tboj_reverse_fool') and G.C.RED or G.C.GREEN
        
        local reverse_table = {
            ['c_magician'] = 'c_tboj_reverse_magician',
            ['c_high_priestess'] = 'c_tboj_reverse_high_priestess',
            ['c_empress'] = 'c_tboj_reverse_empress',
            ['c_emperor'] = 'c_tboj_reverse_emperor',
            ['c_heirophant'] = 'c_tboj_reverse_hierophant',
            ['c_lovers'] = 'c_tboj_reverse_lovers',
            ['c_chariot'] = 'c_tboj_reverse_chariot',
            ['c_justice'] = 'c_tboj_reverse_justice',
            ['c_hermit'] = 'c_tboj_reverse_hermit',
            ['c_wheel_of_fortune'] = 'c_tboj_reverse_wheel',
            ['c_strength'] = 'c_tboj_reverse_strength',
            ['c_hanged_man'] = 'c_tboj_reverse_hanged_man',
            ['c_death'] = 'c_tboj_reverse_death',
            ['c_temperance'] = 'c_tboj_reverse_temperance',
            ['c_devil'] = 'c_tboj_reverse_devil',
            ['c_tower'] = 'c_tboj_reverse_tower',
            ['c_star'] = 'c_tboj_reverse_star',
            ['c_moon'] = 'c_tboj_reverse_moon',
            ['c_sun'] = 'c_tboj_reverse_sun',
            ['c_judgement'] = 'c_tboj_reverse_judgement',
            ['c_world'] = 'c_tboj_reverse_world',
        }

        if not (not reverse_fool_c or reverse_fool_c.name == 'The Fool' or reverse_fool_c.key == 'c_tboj_reverse_fool') then
            local reversal_key = nil
            for k, v in pairs(reverse_table) do
                if reverse_fool_c.key == k then
                reversal_key = v
                elseif reverse_fool_c.key == v then
                reversal_key = k
                end
            end
            reversal = G.P_CENTERS[reversal_key]
            info_queue[#info_queue + 1] = reversal
        end

        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = ' ' .. last_tarot .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
                        }
                    }
                }
            }
        }

        return { vars = { reversal }, main_end = main_end }
    end,

    loc_txt = {
        name = 'The Fool?',
        text = {
            [1] = 'Creates a {C:attention}reverse{} copy of',
            [2] = 'the last {C:tarot}Tarot{} card',
            [3] = 'used during this run',
            [4] = '{s:0.8,C:tarot}The Fool{s:0.8}/{s:0.8,C:tarot}The Fool? {s:0.8}excluded'
        }
    },

    can_use = function(self, card)
        return (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables) and
            G.GAME.tboj_last_tarot and
            G.GAME.tboj_last_tarot ~= 'c_fool' and
            G.GAME.tboj_last_tarot ~= 'c_tboj_reverse_fool'
    end,

    use = function(self, card, area, copier)
        local reverse_table = {
            ['c_magician'] = 'c_tboj_reverse_magician',
            ['c_high_priestess'] = 'c_tboj_reverse_high_priestess',
            ['c_empress'] = 'c_tboj_reverse_empress',
            ['c_emperor'] = 'c_tboj_reverse_emperor',
            ['c_heirophant'] = 'c_tboj_reverse_hierophant',
            ['c_lovers'] = 'c_tboj_reverse_lovers',
            ['c_chariot'] = 'c_tboj_reverse_chariot',
            ['c_justice'] = 'c_tboj_reverse_justice',
            ['c_hermit'] = 'c_tboj_reverse_hermit',
            ['c_wheel_of_fortune'] = 'c_tboj_reverse_wheel',
            ['c_strength'] = 'c_tboj_reverse_strength',
            ['c_hanged_man'] = 'c_tboj_reverse_hanged_man',
            ['c_death'] = 'c_tboj_reverse_death',
            ['c_temperance'] = 'c_tboj_reverse_temperance',
            ['c_devil'] = 'c_tboj_reverse_devil',
            ['c_tower'] = 'c_tboj_reverse_tower',
            ['c_star'] = 'c_tboj_reverse_star',
            ['c_moon'] = 'c_tboj_reverse_moon',
            ['c_sun'] = 'c_tboj_reverse_sun',
            ['c_judgement'] = 'c_tboj_reverse_judgement',
            ['c_world'] = 'c_tboj_reverse_world',
        }

        local reversal = nil

        for k, v in pairs(reverse_table) do
            if G.GAME.tboj_last_tarot == k then
                reversal = v
                break
            elseif G.GAME.tboj_last_tarot == v then
                reversal = k
                break
            end
        end

        if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('timpani')
            SMODS.add_card({ key = reversal })
            card:juice_up(0.3, 0.5)
        end
        return true
    end,

}

--The Magician? - Discards 3 random cards in hand without spending a Discard
SMODS.Consumable {
    key = 'reverse_magician',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 8, y = 2},

    config = { extra = { discards = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.discards } }
    end,

    loc_txt = {
        name = 'The Magician?',
        text = {
            [1] = 'Discards {C:attention}#1#{} random cards in hand',
            [2] = 'without spending a {C:attention}Discard',
        }
    },

    can_use = function(self, card)
        if G.hand.cards then
            return (#G.hand.cards > 0)
        end
    end,

    use = function(self, card, area, copier)
        local not_selected = {}
        local numb_discarded = 0
        for _, playing_card in ipairs(G.hand.cards) do
            not_selected[#not_selected + 1] = playing_card
        end
        for i = 1, 3 do
            if G.hand.cards[i] then
                local selected_card, card_index = pseudorandom_element(not_selected, 'tboj_reverse_magician')
                G.hand:add_to_highlighted(selected_card, true)
                table.remove(not_selected, card_index)
                numb_discarded = numb_discarded + 1
                play_sound('card1', 1)
            end
        end

        G.FUNCS.discard_cards_from_highlighted(nil, true)
        SMODS.draw_cards(numb_discarded)

        if G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            G.FUNCS.draw_from_discard_to_deck()
        end

        return true
    end,

}

--The High Priestess? - Decrease the highest leveled hand by 2 levels, create a Negative copy of the corresponding Planet Card
SMODS.Consumable {
    key = 'reverse_high_priestess',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 7, y = 2},

    config = { extra = { level_decrease = 2 } },
    loc_vars = function(self, info_queue, card)
        local decreased_hand = "n/a"

        if G.GAME.hands then
            local max_level = 3
            for k, v in pairs(G.GAME.hands) do
                if G.GAME.hands[k].level >= max_level then
                    max_level = G.GAME.hands[k].level
                    decreased_hand = k
                end
            end
        end

        return { vars = { card.ability.extra.level_decrease, decreased_hand } }
    end,

    loc_txt = {
        name = 'The High Priestess?',
        text = {
            [1] = 'Decreases the highest leveled hand by',
            [2] = '{C:attention}#1#{} levels and creates a {C:dark_edition}Negative{} copy of',
            [3] = 'the corresponding {C:planet}Planet{} card',
            [4] = '{C:inactive}(Currently: {C:attention}#2#{C:inactive})'
        }
    },

    can_use = function(self, card)
        if G.GAME.hands then
            for k, v in pairs(G.GAME.hands) do
                if G.GAME.hands[k].level >= 3 then
                    return true
                end
            end
        end
    end,

    use = function(self, card, area, copier)
        local decreased_hand = "n/a"
        if G.GAME.hands then
            local max_level = 3
            for k, v in pairs(G.GAME.hands) do
                if G.GAME.hands[k].level >= max_level then
                    max_level = G.GAME.hands[k].level
                    decreased_hand = k
                end
            end
        end
        
        for k, v in pairs(G.P_CENTER_POOLS.Planet) do
            if v.config.hand_type == decreased_hand then
                SMODS.smart_level_up_hand(card, decreased_hand, nil, (0 - card.ability.extra.level_decrease))
                SMODS.add_card {set = "Planet", key = G.P_CENTER_POOLS.Planet[k].key, edition = "e_negative"}
                return true
            end
        end
    end,

}


--The Empress? - Debuffs 2 selected cards in hand then creates a random Spectral card
SMODS.Consumable {
    key = 'reverse_empress',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 6, y = 2},

    config = { max_highlighted = 2 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    loc_txt = {
        name = 'The Empress?',
        text = {
            [1] = 'Debuffs {C:attention}2{} selected cards in hand',
            [2] = 'then creates a random {C:spectral}Spectral{} card',
            [3] = '{C:inactive}(Must have room)'
        }
    },

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted == card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        for _, highlighted_card in pairs(G.hand.highlighted) do
            SMODS.debuff_card(highlighted_card, true, 'tboj_reverse_empress')
        end

        if G.consumeables.config.card_limit - #G.consumeables.cards > 0 then
            SMODS.add_card{set = 'Spectral'}
        end
    end,

}


--The Emperor? - Changes next non-boss blind into a boss blind, gives the investment tag

SMODS.Consumable {
    key = 'reverse_emperor',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 5, y = 2},

        loc_txt = {
        name = 'The Emperor?',
        text = {
            [1] = 'Rerolls upcoming {C:attention}Non-Boss Blind',
            [2] = 'into a random {C:attention}Boss Blind{} and',
            [3] = 'creates a free {C:attention}Investment Tag'
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_investment', set = 'Tag', specific_vars = { 25 } }
    end,

    can_use = function(self, card)
        --maybe fix this later? i don't know how to check this with a flag otherwise
        if G.GAME.tags then
            for i = 1, #G.GAME.tags do
                if (G.GAME.tags[i]).key == "tag_investment" then
                    return false
                end
            end
        end
        return G.GAME.blind_on_deck ~= "Boss" and not G.GAME.blind.in_blind and G.STATE ~= G.STATES.SHOP
    end,

    use = function(self, card, area, copier)
        if G.GAME.blind_on_deck == "Small" then
            local par = G.blind_select_opts.small.parent
            G.GAME.round_resets.blind_choices.Small = get_new_boss()
            G.blind_select_opts.small:remove()
            G.blind_select_opts.small = UIBox{
            T = {par.T.x, 0, 0, 0, },
            definition =
                {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
                UIBox_dyn_container({create_UIBox_blind_choice('Small')},false,get_blind_main_colour('Small'), mix_colours(G.C.BLACK, get_blind_main_colour('Small'), 0.8))
                }},
            config = {align="bmi",
                        offset = {x=0,y=G.ROOM.T.y + 9},
                        major = par,
                        xy_bond = 'Weak'
                    }
            }

            par.config.object = G.blind_select_opts.small
            par.config.object:recalculate()
            G.blind_select_opts.small.parent = par
            G.blind_select_opts.small.alignment.offset.y = 0

        else
            local par = G.blind_select_opts.big.parent
            G.GAME.round_resets.blind_choices.Big = get_new_boss()
            G.blind_select_opts.big:remove()
            G.blind_select_opts.big = UIBox{
            T = {par.T.x, 0, 0, 0, },
            definition =
                {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
                UIBox_dyn_container({create_UIBox_blind_choice('Big')},false,get_blind_main_colour('Big'), mix_colours(G.C.BLACK, get_blind_main_colour('Big'), 0.8))
                }},
            config = {align="bmi",
                        offset = {x=0,y=G.ROOM.T.y + 9},
                        major = par,
                        xy_bond = 'Weak'
                    }
            }

            par.config.object = G.blind_select_opts.big
            par.config.object:recalculate()
            G.blind_select_opts.big.parent = par
            G.blind_select_opts.big.alignment.offset.y = 0
        end
        add_tag(Tag('tag_investment'))
        return true
    end,
}

--The Hierophant? - Enhances 1 selected card into a Bone Card
SMODS.Consumable {
    key = 'reverse_hierophant',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 4, y = 2},

    config = { max_highlighted = 1, mod_conv = 'm_tboj_bone'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted } }
    end,

    loc_txt = {
        name = 'The Hierophant?',
        text = {
            [1] = 'Enhances {C:attention}#1#{} selected',
            [2] = 'card into a',
            [3] = '{C:attention}Bone Card',
        }
    },

    -- apparently, if you're just creating a consumable that converts to an enhancement, this functionality is built in

    -- can_use = function(self, card)
    --     return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    -- end,

    -- use = function(self, card, area, copier)
    --     for i = 1, #G.hand.highlighted do
    --         G.hand.highlighted[i]:set_ability(card.ability.mod_conv)
    --     end
    --     return true
    -- end
}

--The Lovers? - convert the left card into a bloodied card and destroy the right card
SMODS.Consumable {
    key = 'reverse_lovers',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 3, y = 2},

    config = { max_highlighted = 2, mod_conv = 'm_tboj_bloodied'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted } }
    end,

    loc_txt = {
        name = 'The Lovers?',
        text = {
            [1] = 'Select {C:attention}#1#{} cards, enhance',
            [2] = 'the {C:attention}left{} card into a {C:attention}Bloodied Card',
            [3] = 'and destroy the {C:attention}right{} card',
        }
    },

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted == card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        G.hand.highlighted[1]:set_ability(card.ability.mod_conv)
        SMODS.destroy_cards(G.hand.highlighted[2])
        return true
    end
}

--The Chariot? - Apply Eternal to a random Joker and apply Perishable to a random Joker
SMODS.Consumable {
    key = 'reverse_chariot',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 2, y = 2},

    loc_txt = {
        name = 'The Chariot?',
        text = {
            [1] = 'Applies {C:attention}Eternal{} to a random Joker',
            [2] = 'and applies {C:attention}Perishable{} to a random Joker',
        }
    },

    config = { extra = { affected_jokers = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.affected_jokers } }
    end,

    can_use = function(self, card)
        local eligable_joker_count = 0
        if G.jokers and #G.jokers.cards > 0 then
            for k, v in pairs (G.jokers.cards) do
                if not (G.jokers.cards[k].ability.eternal or G.jokers.cards[k].ability.perishable) then
                    eligable_joker_count = eligable_joker_count + 1
                end
            end
        end
        return eligable_joker_count >= card.ability.extra.affected_jokers
    end,

    use = function(self, card, area, copier)
            local eligable_jokers = {}
            for k, v in pairs (G.jokers.cards) do
                if not (G.jokers.cards[k].ability.eternal or G.jokers.cards[k].ability.perishable) then
                    eligable_jokers[k] = v
                end
            end
            local perishable_joker, index = pseudorandom_element(eligable_jokers, 'tboj_reverse_chariot')
            table.remove(eligable_jokers, index)
            SMODS.Stickers["perishable"]:apply(perishable_joker, true)
            SMODS.Stickers["eternal"]:apply(pseudorandom_element(eligable_jokers, 'tboj_reverse_chariot'), true)
        return true
    end,

}

--Justice? - Creates a copy of the last destroyed card
SMODS.Consumable {
    key = 'reverse_justice',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 1, y = 2},

    loc_txt = {
        name = 'Justice?',
        text = {
            [1] = 'Creates a {C:attention}copy{} of',
            [2] = 'the last {C:attention}destroyed{} card',
        }
    },

    --only using this variable if gilded consumables are a thing
    config = { extra = { copies = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.copies } }
    end,

    can_use = function(self, card)
        if G.hand.cards and #G.hand.cards > 0 then
            return G.GAME.tboj_last_removed_card.set ~= nil and G.GAME.tboj_last_removed_card.rank ~= nil and G.GAME.tboj_last_removed_card.suit ~= nil
        end
    end,

    --breaks on restart, not sure why
    use = function(self, card, area, copier)
            local new_card = SMODS.add_card {
                 set = G.GAME.tboj_last_removed_card.set,
                 rank = G.GAME.tboj_last_removed_card.rank,
                 suit = G.GAME.tboj_last_removed_card.suit,
                 enhancement = G.GAME.tboj_last_removed_card.enhancement,
                 edition = G.GAME.tboj_last_removed_card.edition,
                 seal = G.GAME.tboj_last_removed_card.seal,
             }
            new_card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
        return true
    end,

}

--The Hermit? - Halves money (max of $20), gives a Coupon Tag and D6 Tag
SMODS.Consumable {
    key = 'reverse_hermit',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 0, y = 2},

    loc_txt = {
        name = 'The Hermit?',
        text = {
            [1] = 'Halves money and creates',
            [2] = 'a free {C:attention}Coupon Tag{} and {C:attention}D6 Tag{}',
            [3] = '{C:inactive}(Max of{} {C:money}-$20{}{C:inactive})',
        }
    },

    config = { extra = { max = -20 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_coupon', set = 'Tag' }
        info_queue[#info_queue + 1] = { key = 'tag_d_six', set = 'Tag' }
        return { vars = { card.ability.extra.max } }
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(math.max(0 - math.ceil(G.GAME.dollars / 2), -20))
        add_tag(Tag('tag_coupon'))
        -- why did you name it like this
        add_tag(Tag('tag_d_six'))
        return true
    end,

}

--The Wheel of Fortune? - 1/20 chance to add Gilded or Negative edition to a random Joker

SMODS.Consumable {
    key = 'reverse_wheel',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 9, y = 1},

    config = { extra = {odds = 20} },
    loc_vars = function(self, info_queue, card)
        -- SMODS.get_probability_vars(trigger_obj, base_numerator, base_denominator, key, from_roll)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'tboj_reverse_wheel')
        return { vars = { numerator, denominator } }
    end,

    -- Will ONLY have a chance for negative until I add the new Gilded edition
    loc_txt = {
        name = 'The Wheel of Fortune?',
        text = {
            [1] = '{C:green}#1# in #2#{} chance to add',
            [2] = '{C:dark_edition}Negative{} edition',
            [3] = 'to a random {C:attention}Joker{}',
        }
    },

    can_use = function(self, card)
        if G.jokers then
            for i = 1, #G.jokers.cards do
                if (G.jokers.cards[i]).edition == nil then
                    return true
                end
            end
        end
        return false
    end,

    use = function(self, card, area, copier)
        --SMODS.pseudorandom_probability(trigger_obj, seed, base_numerator, base_denominator, key)
        if SMODS.pseudorandom_probability(card, 'tboj_reverse_wheel', 1, card.ability.extra.odds) then
            local editionless = {}
            for k, v in pairs(G.jokers.cards) do
                if (G.jokers.cards[k]).edition == nil then
                    editionless[k] = v
                end
            end
            local newly_editioned = pseudorandom_element(editionless, 'tboj_reverse_wheel')
            -- will need another pseudorandom elm to pick from negative or gilded
            newly_editioned:set_edition('e_negative', true)
        end
        -- add animations
        return true
    end,

}

--Strength? - Decreases the rank of up to 2 selected cards

SMODS.Consumable {
    key = 'reverse_strength',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 8, y = 1},

        loc_txt = {
        name = 'Strength?',
        text = {
            [1] = 'Decreases rank of',
            [2] = 'up to {C:attention}2{} selected',
            [3] = 'cards by {C:attention}1',
        }
    },

    config = { max_highlighted = 2 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
            SMODS.modify_rank(G.hand.highlighted[i], -1)
        end
        return true
    end,

}

--The Hanged Man? - Adds 2 random cards to hand

SMODS.Consumable {
    key = 'reverse_hanged_man',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 7, y = 1},

        loc_txt = {
        name = 'The Hanged Man?',
        text = {
            [1] = 'Creates {C:attention}2{} random',
            [2] = '{C:attention}Playing cards{} and',
            [3] = 'adds them to your hand',
        }
    },

    config = { extra = {cards = 2} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards } }
    end,

    can_use = function(self, card)
        return #G.hand.cards ~= 0
    end,

    use = function(self, card, area, copier)
        for i = 1, card.ability.extra.cards do
            --function poll_edition(_key, _mod, _no_neg, _guaranteed, _options) end
            local rand_edition = poll_edition("tboj_reverse_hanged_man", 2, true)
            --table|{key?: string, mod?: number, guaranteed?: boolean, options?: table, type_key?: string}
            local rand_seal = SMODS.poll_seal("tboj_reverse_hanged_man", 10)
            local new_card = SMODS.add_card {
                set = "Playing Card",
                edition = rand_edition,
                seal = rand_seal
            }
            -- adds to deck view
            new_card:add_to_deck()
            -- updates deck size
            G.deck.config.card_limit = G.deck.config.card_limit + 1
        end
        return true
    end,

}

--Death? - Select 1 card, remove its enhancements and gain the corresponding consumables

SMODS.Consumable {
    key = 'reverse_death',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 6, y = 1},

        loc_txt = {
        name = 'Death?',
        text = {
            [1] = 'Select {C:attention}1{} card, remove',
            [2] = '{C:attention}all enhancements{} and gain',
            [3] = 'the corresponding {C:attention}consumables{}',
            [4] = '{C:inactive}(Example:{} {C:attention}Mult Card{} {C:inactive}={} {C:attention}The Empress{}{C:inactive})',
        }
    },

    config = { max_highlighted = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    can_use = function(self, card)
        if G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted then
            for i = 1, #G.hand.highlighted do
                local card = G.hand.highlighted[i]
                --need to do next because base counts as an enhancement...?
                if next(SMODS.get_enhancements(card)) or card.edition or card.seal then
                    return true
                end
            end
        end
    end,

    -- this needs cleaned up later, i'm just being lazy right now
    use = function(self, card, area, copier)
        local enhancement_to_consumable = {
            ["m_mult"] = "c_empress",
            ["m_lucky"] = "c_magician",
            ["m_stone"] = "c_tower",
            ["m_steel"] = "c_chariot",
            ["m_gold"] = "c_devil",
            ["m_glass"] = "c_justice",
            ["m_bonus"] = "c_heirophant",
            ["m_wild"] = "c_lovers",
            ["m_tboj_bone"] = "c_tboj_reverse_hierophant",
            ["m_tboj_bloodied"] = "c_tboj_reverse_lovers",
            ["m_tboj_explosive"] = "c_tboj_reverse_tower",
        }

        local seal_to_spectral = {
            ["Red"] = "c_deja_vu",
            ["Gold"] = "c_talisman",
            ["Blue"] = "c_trance",
            ["Purple"] = "c_medium",
        }

        for i = 1, #G.hand.highlighted do
            for k, v in pairs(enhancement_to_consumable) do
                if SMODS.has_enhancement(G.hand.highlighted[i], k) then
                    --keep in mind this will need to change for pill enhancements as it specifies "Tarot"
                    local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, v)
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    break
                end
            end
        end

        for i = 1, #G.hand.highlighted do
            if (G.hand.highlighted[i]).edition ~= nil then
                local card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, "c_aura")
                card:add_to_deck()
                G.consumeables:emplace(card)
            end
        end

        for i = 1, #G.hand.highlighted do
            for k, v in pairs(seal_to_spectral) do
                if (G.hand.highlighted[i]).seal == k then
                    local card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, v)
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                end
            end
        end

        for i = 1, #G.hand.highlighted do
            local card = G.hand.highlighted[i]
            card:set_ability("c_base")
            card.edition = nil
            card.seal = nil
        end

    end,

}

--Temperance? - Gives $5 per empty Joker slot

SMODS.Consumable {
    key = 'reverse_temperance',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 5, y = 1},

    config = { extra = { money = 0 } },

    loc_vars = function(self, info_queue, card)
        local money = 0
        if G.jokers then
            money = (money + G.jokers.config.card_limit - #G.jokers.cards) * 5
        end
        card.ability.extra.money = money
        return { vars = { card.ability.extra.money } }
    end,

        loc_txt = {
        name = 'Temperance?',
        text = {
            [1] = 'Gives {C:money}$5{} per',
            [2] = 'empty Joker slot',
            [3] = '{C:inactive}(Currently{} {C:money}$#1#{}{C:inactive})',
        }
    },

    can_use = function(self, card)
        return true
    end,

    -- need to study functionality of these animations later
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                --this function gives the money
                ease_dollars(card.ability.extra.money, true)
                return true
            end
        }))
    end,

}

--The Devil? - Applies Rental to a random Joker and gain a Handy tag or Garbage tag
SMODS.Consumable {
    key = 'reverse_devil',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 4, y = 1},

    config = { extra = { interest_cap_mod = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.interest_cap_mod } }
    end,

    loc_txt = {
        name = 'The Devil?',
        text = {
            [1] = 'Applies {C:attention}Rental{} to a random Joker',
            [2] = 'then increases interest cap by {C:money}$#1#',
        }
    },

    can_use = function(self, card)
        if G.jokers and #G.jokers.cards > 0 then
            for k, v in pairs (G.jokers.cards) do
                if not G.jokers.cards[k].ability.rental then
                    return true
                end
            end
        end
    end,

    use = function(self, card, area, copier)
        local eligable_jokers = {}
            for k, v in pairs (G.jokers.cards) do
                if not G.jokers.cards[k].ability.eternal then
                    eligable_jokers[k] = v
                end
            end
        SMODS.Stickers["rental"]:apply(pseudorandom_element(eligable_jokers, 'tboj_reverse_devil'), true)
        G.GAME.interest_cap = G.GAME.interest_cap + card.ability.extra.interest_cap_mod
    end,

}

--The Tower? - Converts 1 selected card into an Explosive Card
SMODS.Consumable {
    key = 'reverse_tower',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 3, y = 1},

    config = { max_highlighted = 1, mod_conv = 'm_tboj_explosive'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted } }
    end,

    loc_txt = {
        name = 'The Tower?',
        text = {
            [1] = 'Enhances {C:attention}#1#{} selected',
            [2] = 'card into an',
            [3] = '{C:attention}Explosive Card',
        }
    },
}


--The Star? - Convert up to 3 selected Diamonds into a random non-Diamond suit

SMODS.Consumable {
    key = 'reverse_star',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 2, y = 1},

        loc_txt = {
        name = 'The Star?',
        text = {
            [1] = 'Converts up to {C:attention}3{}',
            [2] = 'selected {C:attention}Diamonds{} to',
            [3] = 'random non-{C:attention}Diamond{} suits',
        }
    },

    config = { max_highlighted = 3 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    can_use = function(self, card)
        if G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted then
            for i = 1, #G.hand.highlighted do
                if (G.hand.highlighted[i]):is_suit("Diamonds") == false then
                    return false
                end
            end
            return true
        end
    end,

    use = function(self, card, area, copier)
        local non_diamonds = {}

        for k, v in pairs(SMODS.Suits) do
            if k ~= "Diamonds" then
                non_diamonds[k] = k
            end
        end

        for i = 1, #G.hand.highlighted do
            local selected_suit = pseudorandom_element(non_diamonds, pseudoseed("nodiamonds"))
            SMODS.change_base(G.hand.highlighted[i], selected_suit)
        end
        return true
    end,

}

--The Moon? - Convert up to 3 selected Clubs into a random non-Club suit

SMODS.Consumable {
    key = 'reverse_moon',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 1, y = 1},

        loc_txt = {
        name = 'The Moon?',
        text = {
            [1] = 'Converts up to {C:attention}3{}',
            [2] = 'selected {C:attention}Clubs{} to',
            [3] = 'random non-{C:attention}Club{} suits',
        }
    },

    config = { max_highlighted = 3 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    can_use = function(self, card)
        if G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted then
            for i = 1, #G.hand.highlighted do
                if (G.hand.highlighted[i]):is_suit("Clubs") == false then
                    return false
                end
            end
            return true
        end
    end,

    use = function(self, card, area, copier)
        local non_clubs = {}

        for k, v in pairs(SMODS.Suits) do
            if k ~= "Clubs" then
                non_clubs[k] = k
            end
        end

        for i = 1, #G.hand.highlighted do
            local selected_suit = pseudorandom_element(non_clubs, pseudoseed("noclubs"))
            SMODS.change_base(G.hand.highlighted[i], selected_suit)
        end
        return true
    end,

}

--The Sun? - Convert up to 3 selected Hearts into a random non-Heart suit

SMODS.Consumable {
    key = 'reverse_sun',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 0, y = 1},

        loc_txt = {
        name = 'The Sun?',
        text = {
            [1] = 'Converts up to {C:attention}3{}',
            [2] = 'selected {C:attention}Hearts{} to',
            [3] = 'random non-{C:attention}Heart{} suits',
        }
    },

    config = { max_highlighted = 3 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    can_use = function(self, card)
        if G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted then
            for i = 1, #G.hand.highlighted do
                if (G.hand.highlighted[i]):is_suit("Hearts") == false then
                    return false
                end
            end
            return true
        end
    end,

    use = function(self, card, area, copier)
        local non_hearts = {}

        for k, v in pairs(SMODS.Suits) do
            if k ~= "Hearts" then
                non_hearts[k] = k
            end
        end

        for i = 1, #G.hand.highlighted do
            local selected_suit = pseudorandom_element(non_hearts, pseudoseed("nohearts"))
            SMODS.change_base(G.hand.highlighted[i], selected_suit)
        end
        return true
    end,

}

--Judgement? - Destroy the leftmost Joker and create a random non-Negative Joker tag
SMODS.Consumable {
    key = 'reverse_judgement',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 9, y = 0},

    --currently unused variables, but may use them if i decide gilded consumables are a thing
    config = { extra = {tags_created = 1, jokers_destroyed = 1} },
    loc_txt = {
        name = 'Judgement?',
        text = {
            [1] = 'Destroy a random {C:attention}Joker{} and create',
            [2] = 'a random non-Negative {C:attention}Joker tag',
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_uncommon', set = 'Tag' }
        info_queue[#info_queue + 1] = { key = 'tag_rare', set = 'Tag' }
        info_queue[#info_queue + 1] = { key = 'tag_foil', set = 'Tag' }
        info_queue[#info_queue + 1] = { key = 'tag_holo', set = 'Tag' }
        info_queue[#info_queue + 1] = { key = 'tag_polychrome', set = 'Tag' }
        info_queue[#info_queue + 1] = { key = 'tag_top_up', set = 'Tag', specific_vars = { 2 } }
        --need to localize top-up or else the value will be nil
        return { vars = { card.ability.tags_created, card.ability.jokers_destroyed } }
    end,

    can_use = function(self, card)
        if G.jokers and #G.jokers.cards > 0 then
            for k, v in pairs (G.jokers.cards) do
                if not G.jokers.cards[k].ability.eternal then
                    return true
                end
            end
        end
    end,

    use = function(self, card, area, copier)
        local destroyable_jokers = {}
        local eligable_tags = {
            [1] = 'tag_uncommon',
            [2] = 'tag_rare',
            [3] = 'tag_foil',
            [4] = 'tag_holo',
            [5] = 'tag_polychrome',
            [6] = 'tag_top_up'
        }
            for k, v in pairs (G.jokers.cards) do
                if not G.jokers.cards[k].ability.eternal then
                    destroyable_jokers[k] = v
                end
            end
        
        SMODS.destroy_cards(pseudorandom_element(destroyable_jokers, 'tboj_reverse_judgement'))
        add_tag(Tag(pseudorandom_element(eligable_tags, 'tboj_reverse_judgement')))
        return true
    end,

}


--The World? - Convert up to 3 selected Spades into a random non-Spade suit

SMODS.Consumable {
    key = 'reverse_world',
    set = 'Tarot',
    atlas = 'reverse_tarots',
    unlocked = true,
    discovered = true,
    cost = 3,
    pos = {x = 8, y = 0},

        loc_txt = {
        name = 'The World?',
        text = {
            [1] = 'Converts up to {C:attention}3{}',
            [2] = 'selected {C:attention}Spades{} to',
            [3] = 'random non-{C:attention}Spade{} suits',
        }
    },

    config = { max_highlighted = 3 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    can_use = function(self, card)
        if G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted then
            for i = 1, #G.hand.highlighted do
                if (G.hand.highlighted[i]):is_suit("Spades") == false then
                    return false
                end
            end
            return true
        end
    end,

    use = function(self, card, area, copier)
        local non_spades = {}

        for k, v in pairs(SMODS.Suits) do
            if k ~= "Spades" then
                non_spades[k] = k
            end
        end

        for i = 1, #G.hand.highlighted do
            local selected_suit = pseudorandom_element(non_spades, pseudoseed("nospades"))
            SMODS.change_base(G.hand.highlighted[i], selected_suit)
        end
        return true
    end,

}
