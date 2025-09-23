SMODS.Atlas{
    key = 'TBOJ_enhancements',
    path = 'TBOJ_enhancements.png',
    px = 71,
    py = 95
}

--Infested (for fly/spider related items) - Scores +1 mult and +2 chips for each infested card in the deck
SMODS.Enhancement {
    key = 'infested',
    atlas = 'TBOJ_enhancements',
    pos = {x = 0, y = 1},

    config = {extra = {mult = 1, chips = 2} },
    loc_vars = function(self, info_queue, card)
        local infested_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_tboj_infested') then infested_tally = infested_tally + 1 end
            end
        end
        return { vars = { card.ability.extra.mult * infested_tally, card.ability.extra.chips * infested_tally} }
    end,

    loc_txt = {
        name = 'Infested Card',
        text = {
            [1] = 'Scores {C:mult}+1{} Mult and {C:chips}+2{} Chips',
            [2] = 'per {C:attention}Infested Card{} in deck',
            [3] = '{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult and {C:chips}+#2# {C:inactive}Chips)',
        }
    },

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local infested_tally = 0
            if G.playing_cards then
                for _, playing_card in ipairs(G.playing_cards) do
                    if SMODS.has_enhancement(playing_card, 'm_tboj_infested') then infested_tally = infested_tally + 1 end
                end
            end
            return {mult = card.ability.extra.mult * infested_tally, chips = card.ability.extra.chips * infested_tally}
        end
    end,
}

--Soiled (for poop related items) - +10 mult when scored, -10 mult when in hand (doesn’t have to be this specific effect, just want it to be good when scored, bad when in hand)

--Charged (for battery related items) - Card increases rank after scoring, permanently gains x0.25 mult when “fully charged” (Ace into 2)
SMODS.Enhancement {
    key = 'charged',
    atlas = 'TBOJ_enhancements',
    pos = {x = 1, y = 1},

    config = {extra = { charge_rate = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.charge_rate } }
    end,

    loc_txt = {
        name = 'Charged Card',
        text = {
            [1] = 'Increase rank by {C:attention}#1#{} after',
            [2] = 'scoring, permanently gains',
            [3] = '{X:mult,C:white}X0.25{} mult when rank resets',
            [4] = '{C:inactive}({C:attention}Ace {C:inactive}into {C:attention}2{C:inactive})'
        }
    },

    calculate = function(self, card, context)
        if context.after and context.cardarea == G.play then
            if card:get_id() + card.ability.extra.charge_rate > 14 then
                card.ability.perma_x_mult = card.ability.perma_x_mult + 0.25
            end
            SMODS.modify_rank(card, card.ability.extra.charge_rate)
        end
    end,
}

--Explosive (for bomb related items) - Destroy self when scored, permanently adds its chips to adjacent scoring cards
SMODS.Enhancement {
    key = 'explosive',
    atlas = 'TBOJ_enhancements',
    pos = {x = 2, y = 0},

    config = { extra = {donated_chips = 0}},
    shatters = true,
    loc_vars = function(self, info_queue, card)
        card.ability.extra.donated_chips = 0
        return { vars = { card.ability.extra.donated_chips } }
    end,

    loc_txt = {
        name = 'Explosive Card',
        text = {
            [1] = '{C:attention}Explodes{} after scoring, permanently',
            [2] = 'adding total chips to {C:attention}adjacent{}',
            [3] = 'scoring cards in hand',
        }
    },

    calculate = function(self, card, context)
        if context.after and context.cardarea == G.play then
            local base_chips = 0
            local bonus_chips = 0

            if card:get_id() < 11 then
                base_chips = card:get_id()
            elseif card:get_id() < 14 then
                base_chips = 10
            else
                base_chips = 11
            end

            if card.ability.perma_bonus then
                bonus_chips = card.ability.perma_bonus
            end

            card.ability.extra.donated_chips = card.ability.extra.donated_chips + base_chips + bonus_chips

            local card_pos = nil
            for pos, scoring_card in ipairs(context.scoring_hand) do
                if scoring_card == card then
                    card_pos = pos
                    break
                end
            end

            if context.scoring_hand[card_pos + 1] then
                if not (context.scoring_hand[card_pos + 1]).debuff then
                    local right_card = context.scoring_hand[card_pos + 1]
                    right_card.ability.perma_bonus = right_card.ability.perma_bonus + card.ability.extra.donated_chips
                end
            end

            if context.scoring_hand[card_pos - 1] then
                if not (context.scoring_hand[card_pos - 1]).debuff then
                    local left_card = context.scoring_hand[card_pos - 1]
                    left_card.ability.perma_bonus = left_card.ability.perma_bonus + card.ability.extra.donated_chips
                end
            end

            SMODS.destroy_cards(card)
        end
    end,
}

--Bone - x1.25 chips, 1/6 chance this card gets destroyed
SMODS.Enhancement {
    key = 'bone',
    atlas = 'TBOJ_enhancements',
    pos = {x = 1, y = 0},

    config = {x_chips = 1.25, extra = { odds = 6} },
    shatters = true,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'tboj_bone')
        return { vars = { card.ability.x_chips, numerator, denominator } }
    end,

    loc_txt = {
        name = 'Bone Card',
        text = {
            [1] = '{X:chips,C:white}X#1#{} Chips',
            [2] = '{C:green}#2# in #3#{} chance to',
            [3] = 'destroy card',
        }
    },

    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card and
            SMODS.pseudorandom_probability(card, 'tboj_bone', 1, card.ability.extra.odds) then
            return { remove = true }
        end
    end,
}

--Bloodied - Gains x0.5 mult per card destroyed this ante, resets after Boss Blind
SMODS.Enhancement {
    key = 'bloodied',
    atlas = 'TBOJ_enhancements',
    pos = {x = 0, y = 0},

    config = {extra = {xmult = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult} }
    end,

    loc_txt = {
        name = 'Bloodied Card',
        text = {
            [1] = 'Gains {X:mult,C:white}X0.5{} Mult per card',
            [2] = '{C:attention}destroyed{} this ante, resets',
            [3] = 'when {C:attention}Boss Blind{} is defeated',
            [4] = '{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult)'
        }
    },

    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.selling_card then
            local destroyed_count = 0
            for i, destroyed_card in ipairs(context.removed) do
                if (destroyed_card.ability.set ~= "Joker") then
                    destroyed_count = destroyed_count + 1
                end
            end
            card.ability.extra.xmult = card.ability.extra.xmult + (0.5 * destroyed_count)
        end

        if context.end_of_round and context.game_over == false and context.beat_boss then
            card.ability.extra.xmult = 1
        end

        if context.main_scoring and context.cardarea == G.play then
            return {xmult = card.ability.extra.xmult}
        end
    end,
}
