SMODS.Atlas{
    key = 'reverse_tarots',
    path = 'ReverseTarots.png',
    px = 71,
    py = 95
}

--The Fool? - Creates a reverse copy of the last used Tarot card (The Fool/The Fool? excluded)

--The Magician? -

--The High Priestess? - Decrease the most played hand by 1 level, increase 3 other hands by 1 level

--The Empress? -

--The Emperor? - Reroll the Boss Blind

--The Hierophant? - Enhances 2 selected cards into Bone Cards

--The Lovers? -

--The Chariot? -

--Justice? -

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
            [2] = 'its {C:attention}enhancements{} and gain',
            [3] = 'the corresponding {C:attention}consumables{}',
            [4] = '{C:inactive}(Example:{} {C:attention}Mult Card{} {C:inactive}={} {C:attention}The Empress{}{C:inactive})',
        }
    },

    config = { max_highlighted = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end,

    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
            if SMODS.has_enhancement(G.hand.highlighted[i], "m_mult") then
                local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_empress")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif SMODS.has_enhancement(G.hand.highlighted[i], "m_lucky") then
                local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_magician")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif SMODS.has_enhancement(G.hand.highlighted[i], "m_stone") then
                local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_tower")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif SMODS.has_enhancement(G.hand.highlighted[i], "m_steel") then
                local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_chariot")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif SMODS.has_enhancement(G.hand.highlighted[i], "m_gold") then
                local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_devil")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif SMODS.has_enhancement(G.hand.highlighted[i], "m_glass") then
                local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_justice")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif SMODS.has_enhancement(G.hand.highlighted[i], "m_bonus") then
                local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_heirophant")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif SMODS.has_enhancement(G.hand.highlighted[i], "m_wild") then
                local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_lovers")
                card:add_to_deck()
                G.consumeables:emplace(card)
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
            if (G.hand.highlighted[i]).seal == "Red" then
                local card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, "c_deja_vu")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif (G.hand.highlighted[i]).seal == "Gold" then
                local card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, "c_talisman")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif (G.hand.highlighted[i]).seal == "Blue" then
                local card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, "c_trance")
                card:add_to_deck()
                G.consumeables:emplace(card)
            elseif (G.hand.highlighted[i]).seal == "Purple" then
                local card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, "c_medium")
                card:add_to_deck()
                G.consumeables:emplace(card)
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

--The Devil? - 

--The Tower? - Converts 1 selected card into an Explosive Card

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

--Judgement? - Destroy leftmost Joker and create a Joker of equal rarity or higher (Cannot create a Legendary Joker)

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
