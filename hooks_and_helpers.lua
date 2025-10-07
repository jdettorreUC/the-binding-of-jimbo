
local init_game_object_ref = Game.init_game_object

function Game:init_game_object()
  local ret = init_game_object_ref(self)

  --Last removed card for Reverse Justice
    ret.tboj_last_removed_card = {
        rank = nil,
        suit = nil,
        enhancement = nil,
        set = nil,
        edition = nil,
        seal = nil
    }

    --Last used tarot for Reverse Fool
    ret.tboj_last_tarot = nil

  return ret

end


local calculate_context_ref = SMODS.calculate_context

function SMODS.calculate_context(context, return_table)
    local ret = calculate_context_ref(context, return_table)

    --G.GAME.tboj_last_removed_card
    if G.STAGE == G.STAGES.RUN and context.remove_playing_cards and not context.selling_card then
        if context.removed then
            local last_removed_card = context.removed[#context.removed]
            G.GAME.tboj_last_removed_card.rank = last_removed_card.base.value
            G.GAME.tboj_last_removed_card.suit = last_removed_card.base.suit
            G.GAME.tboj_last_removed_card.enhancement = next(SMODS.get_enhancements(last_removed_card))
            if G.GAME.tboj_last_removed_card.enhancement then
                G.GAME.tboj_last_removed_card.set = "Enhanced"
            else
                G.GAME.tboj_last_removed_card.set = "Base"
            end
            G.GAME.tboj_last_removed_card.edition = last_removed_card.edition
            G.GAME.tboj_last_removed_card.seal = last_removed_card.seal
        end
    end

    --G.GAME.tboj_last_tarot
    if G.STAGE == G.STAGES.RUN and context.using_consumeable then
        if context.consumeable then
            if context.consumeable.config.center.set == 'Tarot' then
                G.GAME.tboj_last_tarot = context.consumeable.config.center_key
            end
        end
    end

    return ret

end