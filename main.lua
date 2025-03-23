--- STEAMODDED HEADER
--- MOD_NAME: Balaichu
--- MOD_ID: Balaichu
--- MOD_AUTHOR: [TheOtterly]
--- MOD_DESCRIPTION: joker insert test
--- PREFIX: xmpl
----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = 'Jokers', --atlas key 
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

--Rai Tuah--
SMODS.Joker{
    key = 'RaiTwoah', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Rai twoah',
        text = {
          'Gains {C:mult}+#2#{} Mult for',
          'each {C:attention}2{} in your full deck', --#<number># refers to the arary index (starting from 1!!) of the returned vars from loc_vars function
          '{C:gray}Currently{} {C:mult}+#1#{} {C:gray}Mult{}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 0, y = 0}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        mult = 0, --How much mult will be added after calulation
        multGain = 2, --How much mult will be added per 2
      }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        displayedMult = 0
        if pcall(getNumOfTwos) then
            displayedMult = getNumOfTwos()*2  
        end
        center.ability.extra.mult = displayedMult
        return {vars = {center.ability.extra.mult, center.ability.extra.multGain}} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)
        if context.joker_main then

            if pcall(getNumOfTwos) then
                card.ability.extra.mult = getNumOfTwos()*2
            end
            return { 
                mult = card.ability.extra.mult
            }
        end

        if context.playing_card_added then
            --Looks like every variable mentioned in the docs is actually in the context variable!
            --So when the docs mention "cards" make sure to instead use context.cards
            tally = 0
            for k, v in pairs(context.cards) do
                if type(v) ~= "boolean" and v:get_id() == 2 then tally = tally+1 end
            end

            if tally > 0 then
                return { 
                    message = 'RAI TUAH'
                }
            end
            
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}
  
--Vorca--
SMODS.Joker{
    key = 'Vorca', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Vorca',
        text = {
          'Eats the final scored card to gain {C:chips}Chips{}',
          ' equal to double its original value', --#<number># refers to the arary index (starting from 1!!) of the returned vars from loc_vars function
          '{C:inactive}(Currently{} {C:chips}+#1#{} {C:chips}chips){}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 0}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        chips = 0, --How much chips will be added after calulation
        cardIndexToDestroy = 1, -- Which card to destroy, calculated during scoring phase
        currentCardIndex = 0 --Current index for the cards during the destruction phase
      }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {vars = {center.ability.extra.chips}} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then
            card.ability.extra.currentCardIndex = 1
            return { 
                chips = card.ability.extra.chips
            }
        end

        --This context is used for triggering joker effects on playing cards.
        if context.individual and context.cardarea == G.play then
            card.ability.extra.cardIndexToDestroy = #context.scoring_hand
            return { 
                --message = tostring(--#context.scoring_hand). --# symbol is a quick way to get size of array
            }
        end

        if context.destroy_card and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.currentCardIndex = card.ability.extra.currentCardIndex+1

            if card.ability.extra.currentCardIndex > card.ability.extra.cardIndexToDestroy then
                card.ability.extra.chips = card.ability.extra.chips+(context.scoring_hand[card.ability.extra.currentCardIndex-1]:get_chip_bonus()*2)
                return { 
                    message = "NOM", --# symbol is a quick way to get size of array
                    remove = true
                }
            end

        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Otterly tyop--
SMODS.Joker{
    key = 'OtterlyTyop', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Otterly Tyop',
        text = {
          '{C:green}1 in 4{} chnace orf',
          '{C:mult}10x Mult{} ot be addded to {C:chips}Chips{}',
          '{C:green}1 in 8{} chcnae fro ',
          '{C:attention}10%{} of {C:chips}Chips{} to eb aded ot {C:mult}Mult{}.'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 2, y = 0}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        oddsMultToChip = 4, --1 in 2, so save the "in x"
        oddsChipToMult = 8 --1 in 4
      }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        displayedMult = 0
        if pcall(getNumOfTwos) then
            displayedMult = getNumOfTwos()  
        end
        center.ability.extra.mult = displayedMult
        return {vars = {center.ability.extra.mult, center.ability.extra.multGain}} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self, card, context)
            odds = pseudorandom(pseudoseed('OtterlyTyop'))
            if context.joker_main then
                if odds < G.GAME.probabilities.normal/card.ability.extra.oddsMultToChip then
                    hand_chips = hand_chips + (mult*10)
                    update_hand_text({ delay = 0 }, { mult = mult, chips = hand_chips })
                    SMODS.juice_up_blind()
                    return {
                        message = "Chips!"
                    }
                end

                if odds < G.GAME.probabilities.normal/card.ability.extra.oddsChipToMult then
                    mult = mult+(hand_chips/10)
                    hand_chips = hand_chips - (hand_chips/10)
                    update_hand_text({ delay = 0 }, { mult = mult, chips = hand_chips })
                    SMODS.juice_up_blind()
                    return {
                        message = "Mult!"
                    }
                end
            end

            if context.final_scoring_step and context.cardarea == G.play then
                --pseudorandom returns a value between 0 and 1
                --Game probability.normal is just the variable "normal" in the "Game" init function. Use it if you want it to be affected by probability modifiers
                --normal is always just 1, so you can just divide it by how unlikely you want. So "1 in 4 chance" is just G.GAME.probabilities.normal/4!
                --You can just send the pseudorandom with the seed being the name of the joker. If pseudorandom returns less than, it matches the odds (so random < 1/4 will only return true one in 4 times)
            end

		end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Maple Get those big ol ears out of my joker--
SMODS.Joker{
    key = 'GetThoseEarsOut', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Get Those Big Ol\' ears out of my Joker!',
        text = {
         'Gains {C:mult}+1 Mult{} per', 
         '{C:attention}consecutive{} hand played without',
         'changing the {C:attention}poker hand{} type',
         '{C:gray}(Currently{} {C:mult}+#1#{} {C:gray}Mult){}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 3, y = 0}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        mult = 0,
        played_hand_type = 'UNSET'
      }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {vars = {center.ability.extra.mult}} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        --Before scoring begins, check if we need to reset
        if context.cardarea == G.jokers and context.before then
            --If unset, allow +1 regardless to player can start
            if card.ability.extra.played_hand_type == 'UNSET' then
                card.ability.extra.mult = card.ability.extra.mult + 1
                card.ability.extra.played_hand_type = context.scoring_name
            elseif next(context.poker_hands[card.ability.extra.played_hand_type]) then --If set, check if the type matches
                card.ability.extra.mult = card.ability.extra.mult + 1
            else --Player breaks consecutiveness
                card.ability.extra.mult = 0
                card.ability.extra.played_hand_type = context.scoring_name
                return {
                    message = 'RESET'
                }
            end
        end

        --Apply mult
        if context.joker_main then 
			return {
                mult = card.ability.extra.mult
			}
        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Raibuprofen--
SMODS.Joker{
    key = 'Raibuprofen', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Raibuprofen',
        text = {
          '{C:chips}+#1# Chips{}',
          '{C:chips}-50 Chips{} for the', --#<number># refers to the arary index (starting from 1!!) of the returned vars from loc_vars function
          'first discard of the round'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 4, y = 0}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        chips = 200, --How many chips left
        is_first_discard = 1, --Is this the first discord (1=yes, 0=no)
      }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {vars = {center.ability.extra.chips}} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then
            return { 
                chips = card.ability.extra.chips
            }
        end

        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.is_first_discard = 1
            if card.ability.extra.is_first_discard == 0 then
                return
                {
                    message = 'Reset!'
                }
            end
        end

        if context.pre_discard then
            if card.ability.extra.is_first_discard == 1 then
                card.ability.extra.is_first_discard = 0
                card.ability.extra.chips = card.ability.extra.chips - 50
                if card.ability.extra.chips <= 0 then 
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                                G.jokers:remove_card(self)
                                card:remove()
                                card = nil
                            return true; end})) 
                end
                return {
                    message = '-50',
                    pre_discard = true,
                }
            end
        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Pants feet--
SMODS.Joker{
    key = 'Pantsfeet', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Pants Feet',
        text = {
          'Applies {X:mult,C:white} X1.0 {} Mult',
          'per scored card in hand'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 5, y = 0}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then
            return { 
                xmult = #context.scoring_hand
            }
        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Chilemex--
SMODS.Joker{
    key = 'Chilemex', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Chilemex',
        text = {
          'Gains {X:mult,C:white} X0.05 {} Mult',
          'every time you draw from your deck',
          '{C:inactive} Currently {}{X:mult,C:white}X#1#{}{C:inactive} Mult {}'
        },
    },
    atlas = 'Jokers', --atlas' key
    soul_pos = {x=1, y=1}, -- Tells where in the spritesheet the thing to put on top of the card for 3d effect
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 8, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 1}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            card_xmult = 1
          }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        info_queue[#info_queue+1] = {key = "guestartist0", set = "Other"} --In the en-us lua file, checks the "other" array for the variable titled whatever the key is
        return {vars = {center.ability.extra.card_xmult}} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then
            return { 
                xmult = card.ability.extra.card_xmult
            }
        end

        if context.hand_drawn then
            card.ability.extra.card_xmult = card.ability.extra.card_xmult + 0.05
            return {
                message = "x0.25 mult"
            }
        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Lavastan Pawker--
SMODS.Joker{
    key = 'Pawker', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Pawker',
        text = {
          'Gains {X:mult,C:white} X0.5 {} Mult',
          'for each {C:attention}Spectral Pack{} opened',
          '{c:inactive}(Currently{} {X:mult,C:white}X#1#{} {c:inactive}Mult){}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 2, y = 1}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
          mult = 1, --How many chips left
        }
      },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        info_queue[#info_queue+1] = {key = "guestartist1", set = "Other"} --In the en-us lua file, checks the "other" array for the variable titled whatever the key is
        return {vars = {center.ability.extra.mult}}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then
            return { 
                xmult = card.ability.extra.mult
            }
        end

        if context.open_booster then
            if context.card.ability.name:find('Spectral') then
                card.ability.extra.mult = card.ability.extra.mult + 0.5
                return {
                    message = 'Upgrade!'
                }
            end

        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Raiju Daki--
SMODS.Joker{
    key = 'Dakimakura', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Dakimakura',
        text = {
          'Gives {C:chips}+50 Chips{}',
          'per hands left this round.', --#<number># refers to the arary index (starting from 1!!) of the returned vars from loc_vars function
          '{C:gray}(Currently{} {C:chips}+#1# Chips{}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 3, y = 1}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        chips = 0 --How many chips left
      }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        
        return {vars = {G.GAME.current_round.hands_left*50}} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then
            return { 
                chips = (G.GAME.current_round.hands_left+1)*50
            }
        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Thundering raiju--
SMODS.Joker{
    key = 'ThunderingRaiju', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Thundering Raiju',
        text = {
          'Thundering Raiju deals {X:mult,C:white} X1 {} Mult',
          'where X is the number of',
        ' enhanced jokers you control.',
          '{C:inactive}(Foil, holographic,',
           '{C:inactive}polychrome, and negative',
           '{C:inactive}are all enhancements){}',
          '{C:inactive}Currently{} {X:mult,C:white} X#1# {} {C:inactive}Mult{}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 4, y = 1}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        mult = 1
      }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        local displayedMult = 0
        if pcall(getModifiedJokers) then
            displayedMult = getModifiedJokers()
        end
        if displayedMult < 1 then
            return {vars = {1}}
        end
        return {vars = {displayedMult}} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then
            local numOfEnhancedJokers = getModifiedJokers()
            if numOfEnhancedJokers < 1 then
                return { 
                    xmult = 1
                }
            end

            return { 
                xmult = getModifiedJokers()
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Raichu pokemon TCG card--
SMODS.Joker{
    key = 'ShinyRaichu', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Shiny Raichu',
        text = {
            '{C:green}1 in 6{} chance',
            'to add a Foil, Holographic',
            'or Polychrome to a random', 
            'joker at the end of a round',
            '{C:inactive}(Will not affect jokers that already{}',
            '{C:inactive}have an enhancement){}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 2}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
      }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        
        --end of round effects
        if context.end_of_round and context.cardarea == G.jokers then
            local odds = pseudorandom(pseudoseed('RaichuTCG'))
            if odds < G.GAME.probabilities.normal/6 then

                local num_of_eligible_jokers = 0
                local eligible_editionless_jokers = EMPTY(eligible_editionless_jokers)
                for k, v in pairs(G.jokers.cards) do
                    if v.ability.set == 'Joker' and (not v.edition) then
                        table.insert(eligible_editionless_jokers, v)
                        num_of_eligible_jokers = num_of_eligible_jokers + 1
                    end
                end
                
                --No jokers that have not been enhanced
                if num_of_eligible_jokers == 0 then
                    return {}
                end

                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    local eligible_card = pseudorandom_element(eligible_editionless_jokers, pseudoseed('ShinyRaichu'))
                    local over = false
                    local edition = nil
                    edition = poll_edition('wheel_of_fortune', nil, true, true)
                    eligible_card:set_edition(edition, true)
                return true end }))

                return {
                    message = "Enhanced!"
                }
            end
        end
            --pseudorandom returns a value between 0 and 1
            --Game probability.normal is just the variable "normal" in the "Game" init function. Use it if you want it to be affected by probability modifiers
            --normal is always just 1, so you can just divide it by how unlikely you want. So "1 in 4 chance" is just G.GAME.probabilities.normal/4!
            --You can just send the pseudorandom with the seed being the name of the joker. If pseudorandom returns less than, it matches the odds (so random < 1/4 will only return true one in 4 times)
        
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Kel--
SMODS.Joker{
    key = 'Kel', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Kel',
        text = {
          'When Blind Selected',
          'refill all {C:attention}Edible Jokers{}',
        },
    },
    atlas = 'Jokers', --atlas' key
    soul_pos = {x=2, y=2}, -- Tells where in the spritesheet the thing to put on top of the card for 3d effect
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 2}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            seltzer_init = 10 --If player has seltzer, keep its current amount. Seltzer is hard-coded to subtract 1, so instead
          }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        info_queue[#info_queue+1] = {key = "guestartist3", set = "Other"} --In the en-us lua file, checks the "other" array for the variable titled whatever the key is
        return  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        --Some extra disables because the player might trigger these before playing a hand
        if context.setting_blind then
            for k, v in pairs(G.jokers.cards) do
                if v.ability.name == 'Ramen' then
                    v.ability.x_mult = 2
                elseif v.ability.name == 'Popcorn' then
                    v.ability.mult = 20
                elseif v.ability.name == 'Ice Cream' then
                    v.ability.extra.chips = 100
                elseif v.ability.name == 'Turtle Bean' then
                    v.ability.h_size = 5
                elseif v.ability.name == 'Seltzer' then
                    v.ability.extra = 10
                elseif v.ability.name == 'j_xmpl_Raibuprofen' then
                    v.ability.extra.chips = 200
                end
            end
            return {
                message = 'Refill!'
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Raimew--
SMODS.Joker{
    key = 'RaiMew',
	loc_txt = {
		name = 'RaiMew',
		text = {
			-- Example of using colour in loc_vars as a colour variable, V:1 is what lets the colour change for each suit.
			"All Lucky {V:1}#1#{} cards",
			"will trigger all random effects",
			"{C:inactive}(Suit changes every round){}",
		}
	},
	blueprint_compat = false,
	perishable_compat = false,
	eternal_compat = true,
	rarity = 2,
	cost = 6,
	config = { extra = { should_store_probabilities = 1, old_probabilities = 1 } },
	atlas = 'Jokers',
	pos = { x = 5, y = 1 },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				localize(G.GAME.current_round.castle2_card.suit, 'suits_singular'), -- gets the localized name of the suit
				colours = { G.C.SUITS[G.GAME.current_round.castle2_card.suit] } -- sets the colour of the text affected by `{V:1}`
			}
		}
	end,
    calculate = function(self,card,context)

        --Check if the first card is lucky
        if context.before then
            card.ability.cur_index = 1
            if context.scoring_hand[1].ability.effect == "Lucky Card" and context.scoring_hand[card.ability.cur_index]:is_suit(G.GAME.current_round.castle2_card.suit) then
                card.ability.extra.old_probabilities = G.GAME.probabilities.normal
                card.ability.extra.should_store_probabilities = 0
                G.GAME.probabilities.normal = 100
            end
        end

        --Triggers PER card
        if context.individual and context.cardarea == G.play then
            card.ability.cur_index = card.ability.cur_index+1 --check the NEXT card
            --Make sure not to overflow
            if card.ability.cur_index <= #context.scoring_hand then
                --so if the NEXT card is lucky, then activate the luck at the end of scoring
                --Because this function actually triggers AFTER a card has been evaluated
                if context.scoring_hand[card.ability.cur_index].ability.effect == "Lucky Card" and context.scoring_hand[card.ability.cur_index]:is_suit(G.GAME.current_round.castle2_card.suit) then
                    if card.ability.extra.should_store_probabilities == 1 then
                        card.ability.extra.old_probabilities = G.GAME.probabilities.normal
                        card.ability.extra.should_store_probabilities = 0
                        G.GAME.probabilities.normal = 100
                    end
                else
                    --Return to normal since lucky card streak has been finished 
                    G.GAME.probabilities.normal = card.ability.extra.old_probabilities
                    card.ability.extra.should_store_probabilities = 1
                end
            else
                --deactivate luck if no more cards to score
                G.GAME.probabilities.normal = card.ability.extra.old_probabilities
                card.ability.extra.should_store_probabilities = 1
            end
        end

    end

}

--Birthday button--
SMODS.Joker{
    key = 'BirthdayButton', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Birthday Button',
        text = {
          'Gives {X:mult,C:white} X1 {} Mult equal',
          'to the current Ante.',
          '{C:inactive}Currently {}{X:mult,C:white}X#1#{} {C:inactive}Mult{}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 3, y = 2}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        card_mult = 1
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {vars = {G.GAME.round_resets.ante}}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then
            return {
                xmult = G.GAME.round_resets.ante
            }
        end

        if context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss then
            return {
                message = "x1 mult"
            }
        end
        

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Birthday button--
SMODS.Joker{
    key = 'Twin', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Twin Joker',
        text = {
            'If played hand contains a {C:attention}Pair{}',
            'convert all cards to the same {C:attention}suit{}',
            'and {C:attention}rank{} as the first scored card'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 4, y = 2}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        --Next call will check if it contains a pair
        if context.after and next(context.poker_hands["Pair"]) then
            
            local first_card_rank
            local first_card_suit
            local is_stone = false
            local is_wild = false
            
            --[[If stone card, copy stone card effect to everyone
            if context.scoring_hand[1].ability.effect == 'Stone Card' and not context.scoring_hand[1].vampired then
                
                first_card_rank = context.scoring_hand[1].base.id
                first_card_suit = context.scoring_hand[1].base.suit
            elseif context.scoring_hand[1].ability.name == "Wild Card" then --Wild card = suit is wildcard
                first_card_rank = context.scoring_hand[1]:get_id()
                first_card_suit = 'WildCard'
            else
                first_card_rank = context.scoring_hand[1]:get_id()
                first_card_suit = localize(context.scoring_hand[1], 'suits_singular')
            end


            for k, v in pairs(context.full_hand) do
                
                if first_card_suite == 'Stone' then
                    
                    v.ability.effect = 'Stone Card'
                elseif first_card_suite == 'WildCard' then
                    v.ability.name = 'Wild Card'
                end

                v:set_base(first_card_rank)
                v:change_suit(first_card_suit)
            end
            --]]

            for k, v in pairs(context.full_hand) do
                --v:change_suit(tostring(context.scoring_hand[1].base.suit))
                --v:juice_up()
                
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = context.scoring_hand[1]
                        local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                        local rank_suffix = '8'
                        
                        
                        --Ten is "T" because localthunk is lazy
                        if tostring(context.scoring_hand[1].base.value) == '10' then
                            rank_suffix = 'T'
                        elseif string.len(rank_suffix) == 1 then --All other numbers are only 1 in length 
                            rank_suffix = tostring(context.scoring_hand[1].base.value)
                        else --Face cards are stuff like "King" but we need only the first letter
                            rank_suffix = string.sub(context.scoring_hand[1].base.value, 1, 1)
                        end
                    
                        --G.P_Cards is expecting "<suit>_<rank>" ex H_K is king of hearts, or C_T is ten of clubs
                        v:set_base(G.P_CARDS[suit_prefix..rank_suffix]);
                        --G.hand.cards[i]:flip();
                        --play_sound('tarot2', percent, 0.6);
                        --G.hand.cards[i]:juice_up(0.3, 0.3);
                        --v:set_base(tostring(context.scoring_hand[1].base.value))
                        --v:change_suit(tostring(context.scoring_hand[1].base.suit));
                        --v:juice_up();
                        return true 
                        end }))
                
            end

            return {
                message = 'Twinned!'
            }
        end
        

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}


--Generic functions not tied to any specific card--

--returns how many 2's are in the player's deck
function getNumOfTwos()
    local tally = 0
    for k, v in pairs(G.playing_cards) do
        if v:get_id() == 2 then tally = tally+1 end
    end
    return tally
end

--Returns how many modified jokers the player has
function getModifiedJokers()
    local tally = 0
    for k, v in pairs(G.jokers.cards) do
        if v.edition then tally = tally+1 end
    end
    return tally
end

--IDK this is some code I copy pasted for raimew
--Does something to interpret a random card suite from the player's deck and put it in raimew

--[[ This is called a hook. It's a less intrusive way of running your code when base game functions
	get called than lovely injections. It works by saving the base game function, local igo, then
	overwriting the current function with your own. You then run the saved function, igo, to make
	the function do everything it was previously already doing, and then you add your code in, so
	that it runs either before or after the rest of the function gets used.
							
	This function hooks into Game:init_game_object in order to create the custom
	G.GAME.current_round.castle2_card variable that the above joker uses whenever a run starts.]]
    local igo = Game.init_game_object
    function Game:init_game_object()
        local ret = igo(self)
        ret.current_round.castle2_card = { suit = 'Spades' }
        return ret
    end
    
    -- This is a part 2 of the above thing, to make the custom G.GAME variable change every round.
    function SMODS.current_mod.reset_game_globals(run_start)
        -- The suit changes every round, so we use reset_game_globals to choose a suit.
        G.GAME.current_round.castle2_card = { suit = 'Spades' }
        local valid_castle_cards = {}
        for _, v in ipairs(G.playing_cards) do
            if not SMODS.has_no_suit(v) then -- Abstracted enhancement check for jokers being able to give cards additional enhancements
                valid_castle_cards[#valid_castle_cards + 1] = v
            end
        end
        if valid_castle_cards[1] then
            local castle_card = pseudorandom_element(valid_castle_cards, pseudoseed('2cas' .. G.GAME.round_resets.ante))
            G.GAME.current_round.castle2_card.suit = castle_card.base.suit
        end
    end

----------------------------------------------
------------MOD CODE END----------------------
    