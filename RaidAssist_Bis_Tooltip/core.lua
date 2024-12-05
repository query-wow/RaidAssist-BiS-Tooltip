local function AddTooltipBorderAndText(tooltip)
    -- Check if the tooltip has an item link
    local _, link = tooltip:GetItem()
    if not link then
        tooltip:SetBackdropBorderColor(nil) -- Remove the border if no item is linked
        return
    end

    -- Extract the item ID from the item link
    local itemID = tonumber(link:match("item:(%d+):"))
    if not itemID then
        tooltip:SetBackdropBorderColor(nil) -- Remove the border if item ID is not found
        return
    end

    -- Check for RaidAssist BiS List
    local RABisList = _G["RaidAssistBisList"]
    local isBiS = false
    if RABisList then
        local bisList = RABisList:GetCharacterItemList()
        if bisList then
            isBiS = tContains(bisList, itemID)
        end
    end

    -- Determine the border and message based on BiS status
    if isBiS then
        -- Add a thicker green border and BiS text with a contrasting background
        tooltip:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background", -- Default tooltip background
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border", -- Default border texture
            tile = true, tileSize = 16, edgeSize = 24, -- Increased edge size for thicker border
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        tooltip:SetBackdropBorderColor(0, 1, 0, 1) -- Green border
        tooltip:SetBackdropColor(0.05, 0.05, 0.05, 0.9) -- Dark background for contrast
        tooltip:AddLine("This is your BiS Item", 0, 1, 0) -- Green text
    end

    tooltip:Show() -- Ensure the tooltip updates
end

-- Hook into the GameTooltip
GameTooltip:HookScript("OnTooltipSetItem", AddTooltipBorderAndText)
GameTooltip:HookScript("OnTooltipCleared", function(self)
    self:SetBackdropBorderColor(nil) -- Reset the backdrop when the tooltip is cleared
end)
