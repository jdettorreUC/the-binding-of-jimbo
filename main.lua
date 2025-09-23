SMODS.current_mod.optional_features = {
    cardareas = {
        discard = true,
        deck = true
    }
}

assert(SMODS.load_file('content/enhancements.lua'))()
assert(SMODS.load_file('content/jokers/page1.lua'))()
assert(SMODS.load_file('content/consumables/reverse_tarots.lua'))()