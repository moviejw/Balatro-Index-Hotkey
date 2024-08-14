--- STEAMODDED HEADER
--- MOD_NAME: Card Select Index Hotkey
--- MOD_ID: snuqol
--- MOD_AUTHOR: [snumodder]
--- MOD_DESCRIPTION: Add upgraded keyboard shortcuts to the game
----------------------------------------------
------------MOD CODE -------------------------
local keyupdate_ref = Controller.key_press_update
local selected_index = 1  

function Controller.key_press_update(self, key, dt)
    keyupdate_ref(self, key, dt)
    
    keys_to_ui = {
        ["z"] = "sort_value",
        ["x"] = "sort_rank",
        ["return"] = "play_hand",
        ["space"] = "discard_hand",
        ["a"] = "run_info",
    }

    if G.STATE == G.STATES.SELECTING_HAND then
        local num_cards = #G.hand.cards
        if key == "right" then
            G.hand.cards[selected_index]:stop_hover()
            selected_index = selected_index + 1
            if selected_index > num_cards then
                selected_index = 1
            end
            G.hand.cards[selected_index]:hover()
        elseif key == "left" then
            G.hand.cards[selected_index]:stop_hover()
            selected_index = selected_index - 1
            if selected_index < 1 then
                selected_index = num_cards
            end
            G.hand.cards[selected_index]:hover()
        end
        
        
        if key == "up" then
            local card = G.hand.cards[selected_index]
            if not card_is_highlighted(card) then
                G.hand:add_to_highlighted(card)
                play_sound('cardSlide2', nil, 0.3)
            end
        elseif key == "down" then
            local card = G.hand.cards[selected_index]
            if card_is_highlighted(card) then
                G.hand:remove_from_highlighted(card, false)
                play_sound('cardSlide2', nil, 0.3)
            end
        end

        
        if tableContains(keys_to_ui, key) then
            if keys_to_ui[key] == "play_hand" then
                G.hand.cards[selected_index]:stop_hover()
                local play_button = G.buttons:get_UIE_by_ID('play_button')
                if play_button.config.button == 'play_cards_from_highlighted' then
                    G.FUNCS.play_cards_from_highlighted()
                end
            elseif keys_to_ui[key] == "discard_hand" then
                G.hand.cards[selected_index]:stop_hover()
                local discard_button = G.buttons:get_UIE_by_ID('discard_button')
                if discard_button.config.button == 'discard_cards_from_highlighted' then
                    G.FUNCS.discard_cards_from_highlighted()
                end
            elseif keys_to_ui[key] == "sort_value" then
                G.FUNCS.sort_hand_value()
            elseif keys_to_ui[key] == "sort_rank" then
                G.FUNCS.sort_hand_suit()
            elseif keys_to_ui[key] == "run_info" then
                local run_info_button = G.HUD:get_UIE_by_ID('run_info_button')
                if run_info_button.config.button == 'run_info' then
                    G.FUNCS.run_info()
                end
            end
        end
    end
end

function tableContains(table, key)
    for k, v in pairs(table) do
        if k == key then
            return true
        end
    end
    return false
end

function card_is_highlighted(card)
    for i = #G.hand.highlighted, 1, -1 do
        if G.hand.highlighted[i] == card then
            return true
        end
    end
    return false
end

----------------------------------------------
------------MOD CODE END----------------------
