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
          'each 2 in your full deck', --#<number># refers to the arary index (starting from 1!!) of the returned vars from loc_vars function
          '{C:gray}Currently{} {C:mult}+#1#{} {C:gray}Mult{}'
        },
    },
    atlas = 'Jokers', --atlas' key
    rarity = 1, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    cost = 2, --cost
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
            displayedMult = getNumOfTwos()  
        end
        center.ability.extra.mult = displayedMult
        return {vars = {center.ability.extra.mult, center.ability.extra.multGain}} --returns an array of variables to the description
    end,
    --Calculate function performed during score calculatio. This is where the effects should be triggered!
    calculate = function(self,card,context)
        if context.joker_main then

            if pcall(getNumOfTwos) then
                card.ability.extra.mult = getNumOfTwos()  
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
                if v:get_id() == 2 then tally = tally+1 end
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
          'Eats the final scored card',
          'to gain {C:chips}Chips{} equal to its original value', --#<number># refers to the arary index (starting from 1!!) of the returned vars from loc_vars function
          '{C:gray}Currently{} {C:chips}+#1#{} {C:chips}chips{}'
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
                card.ability.extra.chips = card.ability.extra.chips+context.scoring_hand[card.ability.extra.currentCardIndex-1]:get_chip_bonus()
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


--Generic functions not tied to any specific card--

function getNumOfTwos()
    tally = 0
    for k, v in pairs(G.playing_cards) do
        if v:get_id() == 2 then tally = tally+1 end
    end
    return tally
end

----------------------------------------------
------------MOD CODE END----------------------
    