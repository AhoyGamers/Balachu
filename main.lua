--- STEAMODDED HEADER
--- MOD_NAME: Balaichu
--- MOD_ID: Balaichu
--- MOD_AUTHOR: [TheOtterly]
--- MOD_DESCRIPTION: Happy birthday raichu!
--- PREFIX: xmpl
----------------------------------------------
------------MOD CODE -------------------------


--First emoji deck options

local atlas_key = 'xmpl_atlas' -- Make sure it uses the mod prefix (here it's xmple but check top) then add '_atlas'
-- See end of file for notes
local atlas_path = 'raichuDeck.png' -- Filename for the image in the asset folder
local atlas_path_hc = 'raichuDeck.png' -- Filename for the high-contrast version of the texture, if existing

local suits = {'hearts', 'clubs', 'diamonds', 'spades'} -- Which suits to replace
local ranks = {'Jack', 'Queen', "King", "Ace",} -- Which ranks to replace
--local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace",} Use this to change ALL cards
local description = 'Emotes' -- English-language description, also used as default

SMODS.Atlas{  
    key = atlas_key..'_lc',
    px = 71,
    py = 95,
    path = atlas_path,
    prefix_config = {key = false}, -- See end of file for notes
}

if atlas_path_hc then
    SMODS.Atlas{  
        key = atlas_key..'_hc',
        px = 71,
        py = 95,
        path = atlas_path_hc,
        prefix_config = {key = false}, -- See end of file for notes
    }
end

for _, suit in ipairs(suits) do
    SMODS.DeckSkin{
        key = suit.."_skin",
        suit = suit:gsub("^%l", string.upper),
        ranks = ranks,
        lc_atlas = atlas_key..'_lc',
        hc_atlas = (atlas_path_hc and atlas_key..'_hc') or atlas_key..'_lc',
        loc_txt = {
            ['en-us'] = description
        },
        posStyle = 'deck'
    }
end


--Add custom raichu deck--
SMODS.Atlas {
	key = "raiDeck",
	path = "Raichu_deck.png",
	px = 71,
	py = 95,
}

--  Deck
SMODS.Back {
    key = "Raichu_deck",
    unlocked = true,
    config = {
        vouchers = {
            'v_overstock_norm',
        }
    },
    unlocked = false,
    unlock_condition = {type = 'win_stake', stake = 3},
    pos = { x = 0, y = 0 },
	atlas = "raiDeck",
    loc_txt = {
        name = "Raichu deck",
        text = {
			"Start with {C:attention}Overstock{}",
            "All Balaichu cards are",
            "common permanently",
            "(It's a bug",
            "you'll have to restart to fix)"
        }
    },

	apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                --Whatever you want to change or modify before game starts
                --Go into every joker and set rarity to common?
                for key, item in pairs(G.P_CENTERS) do
                    if item.name and string.find(item.name, "j_xmpl") then
                        item.rarity = 1
                        --sendDebugMessage("Iterated over "..tostring(item.name), "MyDebugLogger")
                    end
                end
                return true
            end
        }))
    end
}

--End of deck changes. Rest are for jokers--

SMODS.Atlas{
    key = 'Jokers', --atlas key 
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

--Animated atlas for leorb--
--Needs to be custom so the X and Y can be changed.
--Note the x and are are the just the x and y of the spritesheet, divided by the number of items, divided by 2
--IE. PX = (<Length of spritesheet in pixels> divided by <Number of leoOrb sprites per row>) divided by 2
SMODS.Atlas{
    key = 'LeOrb', --atlas key 
    path = 'leOrb_sprites.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 95, --width of one card
    py = 127-- height of one card
}

--Animated atlas for leorb--
--Needs to be custom so the X and Y can be changed.
--Note the x and are are the just the x and y of the spritesheet, divided by the number of items, divided by 2
--IE. PX = (<Length of spritesheet in pixels> divided by <Number of leoOrb sprites per row>) divided by 2
SMODS.Atlas{
    key = 'Maple', --atlas key 
    path = 'MapleFrames.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95-- height of one card
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
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 0, y = 0}, --Reminder
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
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
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
    discovered = false, --whether or not it starts discovered
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
    atlas = 'Maple', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
    eternal_compat = true, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 3, y = 0}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        mult = 0,
        played_hand_type = 'UNSET',
        cur_frame = 0
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
                local obj = G.P_CENTERS.j_xmpl_GetThoseEarsOut
                card.ability.extra.cur_frame = 0
                obj.pos.x = card.ability.extra.cur_frame
                card.ability.extra.mult = card.ability.extra.mult + 1
                card.ability.extra.played_hand_type = context.scoring_name
            elseif card.ability.extra.played_hand_type == context.scoring_name then --If set, check if the type matches
                card.ability.extra.mult = card.ability.extra.mult + 1

                if card.ability.extra.mult % 3 == 0 then --Only increase the frame every 3 mult
                    card.ability.extra.cur_frame = card.ability.extra.cur_frame+1
                end
                
            else --Player breaks consecutiveness
                card.ability.extra.mult = 0
                card.ability.extra.played_hand_type = context.scoring_name
                card.ability.extra.cur_frame = 0
                return {
                    message = 'RESET'
                }
            end
        end

        --Apply mult
        if context.joker_main then 
            if card.ability.extra.played_hand_type == 'UNSET' then
                local obj = G.P_CENTERS.j_xmpl_GetThoseEarsOut 
                obj.pos.x = 0
            end
			return {
                mult = card.ability.extra.mult
			}
        end


        --update animation
        if G.P_CENTERS and G.P_CENTERS.j_xmpl_GetThoseEarsOut then
            local obj = G.P_CENTERS.j_xmpl_GetThoseEarsOut --j_xmple_<key> is what the atlas defaults to. xmple is from the prefix variable allll the way at the beginning of the mod, inside the comments
            if (card.ability.extra.cur_frame < 5) then --Remember rows by columns, and subtract by one because lua is dumb
              obj.pos.x = card.ability.extra.cur_frame
            end
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
    discovered = false, --whether or not it starts discovered
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
    discovered = false, --whether or not it starts discovered
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
    discovered = false, --whether or not it starts discovered
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

        if context.hand_drawn and not context.blueprint then
            card.ability.extra.card_xmult = card.ability.extra.card_xmult + 0.05
            return {
                message = "x0.05 mult"
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
    discovered = false, --whether or not it starts discovered
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
          '{C:gray}(Currently{} {C:chips}+#1# Chips{})'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 7, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
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
        info_queue[#info_queue+1] = {key = "guestartist2", set = "Other"} --In the en-us lua file, checks the "other" array for the variable titled whatever the key is
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
    discovered = false, --whether or not it starts discovered
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
    discovered = false, --whether or not it starts discovered
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
    discovered = false, --whether or not it starts discovered
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
    discovered = false, --whether or not it starts discovered
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

--Twin Joker--
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
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other (should only copy the mult NOT the card destruction!)
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
        if context.after and next(context.poker_hands["Pair"]) and not context.blueprint then
            
            local first_card_rank
            local first_card_suit
            local is_stone = false
            local is_wild = false

            for k, v in pairs(context.full_hand) do
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        --Copy card(<card to copy>, <card to replace>)
                        --copy_card(context.scoring_hand[1], v, nil, nil, v.edition)
                        v:set_ability(context.scoring_hand[1].config.center)
                        v:set_base(context.scoring_hand[1].config.card)
                        v:juice_up()
                        return true 
                        end }))
                
            end
            return {
                message = tostring(context.scoring_hand[1].ability.effect)
            }
        end
        

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Me's a crowd Joker--
SMODS.Joker{
    key = 'MesACrowd', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Me\'s a crowd',
        text = {
            'Scored cards that have the same',
            '{C:attention}suit{} and {C:attention}rank{} as an',
            'already-scored card give {C:mult}+11{} Mult'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other 
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 5, y = 2}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            mult = 11,
            card_list = { }
        }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.individual and context.cardarea == G.play then
            for k, v in pairs(card.ability.extra.card_list) do
                if (v:get_id() == context.other_card:get_id())
                and (v:is_suit(context.other_card.base.suit) or context.other_card.config.center == G.P_CENTERS.m_wild)
                or (context.other_card.config.center == G.P_CENTERS.m_stone and v.config.center == G.P_CENTERS.m_stone) then --Allow stone card duplicates
                    return {
                        mult = card.ability.extra.mult,
                        card = card
                    }
                end
            end

            if not context.blueprint then
                    table.insert(card.ability.extra.card_list, context.other_card) 
            end

        end

        --Clear list of scored cards after hand calculated
        if context.after and not context.other_card then 
            card.ability.extra.card_list = {}
        end 

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Otterly--
SMODS.Joker{
    key = 'Otterly', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Otterly',
        text = {
            'Creates a {C:attention}Negative Misprint{}',
            'when a {C:attention}Boss Blind{} is defeated'
        },
    },
    atlas = 'Jokers', --atlas' key
    soul_pos = {x=1, y=3},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other 
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 3}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {

        }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        info_queue[#info_queue + 1] = G.P_CENTERS.j_misprint
        info_queue[#info_queue+1] = {key = "guestartist3", set = "Other"} --In the en-us lua file, checks the "other" array for the variable titled whatever the key is
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.end_of_round and context.cardarea == G.jokers and not context.retrigger_joker and G.GAME.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function() 

                local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_misprint")
                card:set_edition({ negative = true,})
                card:add_to_deck()
                G.jokers:emplace(card)

                return true
                end}))   
        end


    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Wings of time--
SMODS.Joker{
    key = 'WingsOfTime', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Wings of Time',
        text = {
            'For every {C:attention}Joker{} sold',
            'Go back one {C:attention}Ante{}',
            '{C:inactive}(Does not include this joker){}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other 
    eternal_compat = false, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 2, y = 3}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {

        }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.selling_card and context.card.ability.set == "Joker" then
            if context.card.ability.name ~= 'j_xmpl_WingsOfTime' then
                ease_ante(-1)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante-1
            end
        end


    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Gabe Prower--
SMODS.Joker{
    key = 'GabePrower', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Gabe Prower',
        text = {
            'Creates a Fool {C:attention}Tarot Card{}',
            'whenever a {C:attention}Arcana Pack{} is opened',
            '{C:inactive}Must have room{}'
        },
    },
    atlas = 'Jokers', --atlas' key
    soul_pos = {x=4, y=3},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other 
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 3, y = 3}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        --save the played hand after scoring
        if context.open_booster and context.card.ability.name:find('Arcana') then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    card:juice_up()
                    local newcard = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_fool', 'car')
					newcard:add_to_deck()
					G.consumeables:emplace(newcard)
					G.GAME.consumeable_buffer = 0
                end
                return true end }))
        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Milanor--
SMODS.Joker{
    key = 'Milanor', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Milanor',
        text = {
            'Adds another copy of the latest',
            '{C:attention}Tag{} when a blind is skipped'
        },
    },
    atlas = 'Jokers', --atlas' key
    soul_pos = {x=0, y=4},
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 5, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other 
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 5, y = 3}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            tag_added = false
        }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        info_queue[#info_queue+1] = {key = "guestartist4", set = "Other"}
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.skip_blind then 
            --G.GAME.tags[1].name
            add_tag(Tag(G.GAME.tags[#G.GAME.tags].key))
            --add_tag(Tag('tag_double'))

        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--LeOrb--
SMODS.Joker{
    key = 'LeOrb', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'LeOrb',
        text = {
            'Bonus cards give',
             '{X:blue,C:white}X1.5{} Chips',
            'when scored'
        },
    },
    atlas = 'LeOrb', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other 
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 0}, --reminder this is in its own atlas with all the sprites
    config = { 
        extra = {
            tag_added = false
        }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.individual and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, "m_bonus") then
                return {
                    xchips = 1.5
                }
            end
        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Toshabi--
SMODS.Joker{
    key = 'Toshabi', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Toshabi',
        text = {
            'Levels up the final played',
            '{C:attention}Poker Hand{} of the round'
        },
    },
    atlas = 'Jokers', --atlas' key
    soul_pos = {x=2, y=4},
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other 
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 1, y = 4}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            final_poker_hand = 'UNSET'
        }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        info_queue[#info_queue+1] = {key = "guestartist5", set = "Other"}
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        --save the played hand after scoring
        if context.joker_main then
            card.ability.extra.final_poker_hand = context.scoring_name
        end

        --end of round effects
        if context.end_of_round and context.cardarea == G.jokers then
            card:juice_up()
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(card.ability.extra.final_poker_hand, 'poker_hands'),chips = G.GAME.hands[card.ability.extra.final_poker_hand].chips, mult = G.GAME.hands[card.ability.extra.final_poker_hand].mult, level=G.GAME.hands[card.ability.extra.final_poker_hand].level})
            level_up_hand(nil, card.ability.extra.final_poker_hand, nil, 1)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end


    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Pocat--
SMODS.Joker{
    key = 'Pocat', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Pocat',
        text = {
            'Creates a {C:attention}Ramen Joker{}',
            'in your {C:attention}Consumables{} when',
            'a {C:attention}Boss Blind{} is defeated',
            '{C:inactive}Must have room{}'
        },
    },
    atlas = 'Jokers', --atlas' key
    soul_pos = {x=4, y=4},
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 6, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other 
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 3, y = 4}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.end_of_round and context.cardarea == G.jokers and not context.retrigger_joker and G.GAME.blind.boss then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    card:juice_up()
                                                --type, where to place, ?, ? ,? ,?,      Key (custom ones start with j_xmple_<key>), source
                    local newcard = create_card('Joker',G.consumeables, nil, nil, nil, nil, 'j_ramen', 'car')
					newcard:add_to_deck()
					G.consumeables:emplace(newcard)
					G.GAME.consumeable_buffer = 0
                end
                return true end }))
        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Skibidi raichu--
SMODS.Joker{
    key = 'Skibidi', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Skibidi Joker',
        text = {
            'If the {C:attention}First Hand{} of round',
            'contains a {C:attention}Flush{} then',
            'create the {C:attention}Tarot Card{}',
            'for the suit.'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other 
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 0, y = 5}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
        extra = {
            is_first_hand = 1 --Has the first hand been played?
        }
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        return {}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then
            if card.ability.extra.is_first_hand == 1 and next(context.poker_hands["Flush"]) then
                card.ability.extra.is_first_hand = 0
                local tarot_type = '' --Determines which tarot card should be spawned

                if context.scoring_hand[#context.scoring_hand]:is_suit("Diamonds") then
                    tarot_type = "c_star"
                elseif context.scoring_hand[#context.scoring_hand]:is_suit("Clubs") then
                    tarot_type = "c_moon"
                elseif context.scoring_hand[#context.scoring_hand]:is_suit("Hearts") then
                    tarot_type = "c_sun"
                elseif context.scoring_hand[#context.scoring_hand]:is_suit("Spades") then
                    tarot_type = "c_world"
                end


                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    card:juice_up()
                                                --type, where to place, ?, ? ,? ,?,      Key (custom ones start with j_xmple_<key>), source
                    local newcard = create_card('Tarot',G.consumeables, nil, nil, nil, nil, tarot_type, 'car')
					newcard:add_to_deck()
                    play_sound('tarot1')
					G.consumeables:emplace(newcard)
					G.GAME.consumeable_buffer = 0
                end
                return true end }))

                return {
                    message = "Skibidi"
                }
            end
            
        end

        if context.end_of_round then
            card.ability.extra.is_first_hand = 1
        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}

--Hatsune Raichu--
SMODS.Joker{
    key = 'HatsuneRaichu', --How the code refers to the joker
    loc_txt = { -- local text
        name = 'Hatsune Raichu',
        text = {
            'Applies {X:mult,C:white} X1.0 {} Mult for',
            'each hand size under {C:attention}8{}',
            '{C:inactive}Currently{} {X:mult,C:white} X#1#{} {C:inactive}Mult{}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 4, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = false, --whether or not it starts discovered
    blueprint_compat = false, --can it be blueprinted/brainstormed/other 
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = {x = 5, y = 4}, --position in joker spritesheet, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
    },
    --local variables unique to this joker
    --Recalculated when description shown
    loc_vars = function(self,info_queue,center) --center refers to the "config" variable 
        if pcall(getHandsize) then
            if 9-G.hand.config.card_limit > 0 then
                return {vars = {9-G.hand.config.card_limit}}
            end
            return {vars = {1}}
        end 
        --Only triggers if getHandSize returns an error (IE g.hand doesn't exist cause we're in the main menu)
        return {vars = {1}}  --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)

        if context.joker_main then

            if 9-G.hand.config.card_limit > 0 then
                return {
                    xmult = 9-G.hand.config.card_limit --9 minus instead of 8 minus because otherwise its zero lol
                }
            end

            --ensure xmult cant become less than 1 due to turlte bean
            return {
                xmult = 1 
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

function getHandsize()
    return G.hand.config.card_limit
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

---LeOrb animation ----
--Forcibly updates the leOrb animation
--If the actual animation is showing extra fraames (or the frames are off)
--Then go exit the card size in the leOrb Atlas. (That's why leorb has his own atlas)
local upd = Game.update
leOrb_dt = 0
function Game:update(dt)
  upd(self,dt)
  leOrb_dt = leOrb_dt + dt
  if G.P_CENTERS and G.P_CENTERS.j_xmpl_LeOrb and leOrb_dt > 0.1 then
    leOrb_dt = 0
    local obj = G.P_CENTERS.j_xmpl_LeOrb --j_xmple_<key> is what the atlas defaults to. IDK how to get rid of j_xmple
    if (obj.pos.x == 5 and obj.pos.y == 3) then --Remember rows by columns, and subtract by one because lua is dumb
      obj.pos.x = 0
      obj.pos.y = 0
    elseif (obj.pos.x < 5) then obj.pos.x = obj.pos.x + 1
    elseif (obj.pos.y < 3) then
      obj.pos.x = 0
      obj.pos.y = obj.pos.y + 1
      end
   end
end


----Custom challgnes
---Add custom challenges
local function INIT()

    local banned = {}
    for k, v in pairs(G.P_CENTERS) do
        if not banned[k] then
            if string.find(k, "j_") then
                if not string.find(k, "j_xmpl_") then
                    banned[#banned+1] = { id = k }
                end
            end
        end
    end

    local challenges = G.CHALLENGES
	G.localization.misc.challenge_names["hungryVorca"] = "The Hungry, Hungry Vorca"
    G.localization.misc.challenge_names["onlyBalachu"] = "Only Balachu Cards"
    
    table.insert(G.CHALLENGES,#G.CHALLENGES+1,{
        name = "The Hungry, Hungry Vorca",
        id = 'hungryVorca',
        rules = {
            custom = {
            },
            modifiers = {
                {id = 'joker_slots', value = 4},
            }
        },
        jokers = {
            {id = 'j_xmpl_Vorca', eternal = true},
        },
        consumeables = {
        },
        vouchers = {
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {
            },
            banned_tags = {
            },
            banned_other = {
            }
        }
    })

    table.insert(G.CHALLENGES,#G.CHALLENGES+1,{
        name = "Only Balachu Cards",
        id = 'onlyBalachu',
        rules = {
            custom = {
            },
            modifiers = {
            }
        },
        jokers = {
        },
        consumeables = {
        },
        vouchers = {
        },
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = banned
        }
    })

    
end



---end of challenges
INIT()
----------------------------------------------
------------MOD CODE END----------------------
    