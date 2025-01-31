function TwitchStatsScreen_OnLoad()
    
    BuhEmotesPackentStatKeys = {}
    local n = 0;
    local totalEmotesSent = 0;
    for k,v in pairs(BuhEmotesPacktatistics) do
        if BuhEmotesPack_defaultpack[k] ~= nil and v[2] > 0 then -- Only add if the emote still exsists
            n=n+1;
            totalEmotesSent = totalEmotesSent + v[2];
            BuhEmotesPackentStatKeys[n]=k;
        end
    end
    
    TwitchStatsScreenSentListTitle:SetText("Sent " .. totalEmotesSent .. " emotes")
    
    --Sort the sent stats list by usage
    table.sort(BuhEmotesPackentStatKeys, function(left, right)
        return BuhEmotesPacktatistics[left][2] > BuhEmotesPacktatistics[right][2]
    end);

    FilteredBuhEmotesPackentStatKeys = BuhEmotesPackentStatKeys;

    TwitchEmoteRecievedStatKeys = {}
    local n = 0;
    local totalEmotesSeen = 0;
    for k,v in pairs(BuhEmotesPacktatistics) do
        if BuhEmotesPack_defaultpack[k] ~= nil and v[3] > 0 then -- Only add if the emote still exsists
            n=n+1;
            totalEmotesSeen = totalEmotesSeen + v[3];
            TwitchEmoteRecievedStatKeys[n]=k;
        end
    end
    TwitchStatsScreenSeenListTitle:SetText("Seen " .. totalEmotesSeen .. " emotes")

    --Sort the seen stats list by nr of times seen
    table.sort(TwitchEmoteRecievedStatKeys, function(left, right)
        return BuhEmotesPacktatistics[left][3] > BuhEmotesPacktatistics[right][3]
    end);

    FilteredTwitchEmoteRecievedStatKeys = BuhEmotesPackentStatKeys;

    TwitchStatsScreen:SetBackdrop({
        bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background-Dark',
        edgeFile = 'Interface\\DialogFrame\\UI-DialogBox-Background-Dark',
        tile = true,
        tileSize = 32,
        edgeSize = 1,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        } 
    })

    TwitchStatsScreen.closeButton = CreateFrame('Button', "TwitchStatsCloseButton", TwitchStatsScreen, 'UIPanelCloseButtonNoScripts')
	TwitchStatsScreen.closeButton:SetScript('OnClick', function() TwitchStatsScreen:Hide() end)
	TwitchStatsScreen.closeButton:SetPoint('TOPRIGHT', 0, 2)

    local engineeringGemTexture = "Interface\\ItemSocketingFrame\\UI-EngineeringSockets";
    local emoteBorderTex = {tex=engineeringGemTexture, w=43, h=43, left=0.01562500, right=0.68750000, top=0.41210938, bottom=0.49609375, r=1, g=1, b=1, CBx=49, CBy=47, CBLeft=0.01562500, CBRight=0.78125000, CBTop=0.22070313, CBBottom=0.31250000, OBx=49, OBy=47, OBLeft=0.01562500, OBRight=0.78125000, OBTop=0.31640625, OBBottom=0.40820313};
    local topEmoteBorder = TwitchStatsScreen:CreateTexture(nil, "BACKGROUND", nil, 1);
    topEmoteBorder:SetTexture(emoteBorderTex.tex);
    topEmoteBorder:SetWidth(emoteBorderTex.w * 2);
    topEmoteBorder:SetHeight(emoteBorderTex.h * 2);
    topEmoteBorder:SetTexCoord(emoteBorderTex.left, emoteBorderTex.right, emoteBorderTex.top, emoteBorderTex.bottom);
    topEmoteBorder:SetPoint('CENTER', TwitchStatsScreen, "TOPLEFT", 128, -108)
    topEmoteBorder:Show();

    local topSentImagePath = BuhEmotesPack_defaultpack[BuhEmotesPackentStatKeys[1]] or "Interface\\AddOns\\BuhEmotesPack\\Emotes\\1337.tga";
    local animdata = BuhEmotesPack_animation_metadata[topSentImagePath]
    TwitchStatsScreen.topSentEmoteTexture = TwitchStatsScreen.topSentEmoteTexture or TwitchStatsScreen:CreateTexture(nil, "BACKGROUND", nil, 2);
    local topEmoteTexture = TwitchStatsScreen.topSentEmoteTexture

    if animdata ~= nil then
        topEmoteTexture:SetTexture(topSentImagePath);
        topEmoteTexture:SetTexCoord(BuhEmotesPack_GetTexCoordsForFrame(animdata, 0)) 
    else
        local size = string.match(topSentImagePath, ":(.*)")
        if size then
            topSentImagePath = string.gsub(topSentImagePath, size, "")
        end

        topEmoteTexture:SetTexture(topSentImagePath);
    end
    
    topEmoteTexture:SetWidth(70);
    topEmoteTexture:SetHeight(70);
    topEmoteTexture:SetPoint('CENTER', TwitchStatsScreen, "TOPLEFT", 128, -108)
    topEmoteTexture:Show();

    if #BuhEmotesPackentStatKeys >= 1 and BuhEmotesPacktatistics[BuhEmotesPackentStatKeys[1]][2] > 0 then
        TwitchStatsScreenTopSentText:SetText(BuhEmotesPackentStatKeys[1] .. " sent " .. BuhEmotesPacktatistics[BuhEmotesPackentStatKeys[1]][2] .. "x")
    else
        TwitchStatsScreenTopSentText:SetText("No emotes sent yet");
    end

    if #TwitchEmoteRecievedStatKeys >= 1 and BuhEmotesPacktatistics[TwitchEmoteRecievedStatKeys[1]][3] > 0 then
        TwitchStatsScreenTopRecievedText:SetText(TwitchEmoteRecievedStatKeys[1] .. " seen " .. BuhEmotesPacktatistics[TwitchEmoteRecievedStatKeys[1]][3] .. "x")
    else
        TwitchStatsScreenTopRecievedText:SetText("No emotes seen yet");
    end

    topEmoteBorder = TwitchStatsScreen:CreateTexture(nil, "BACKGROUND", nil, 1);
    topEmoteBorder:SetTexture(emoteBorderTex.tex);
    topEmoteBorder:SetWidth(emoteBorderTex.w * 2);
    topEmoteBorder:SetHeight(emoteBorderTex.h * 2);
    topEmoteBorder:SetTexCoord(emoteBorderTex.left, emoteBorderTex.right, emoteBorderTex.top, emoteBorderTex.bottom);
    topEmoteBorder:SetPoint('CENTER', TwitchStatsScreen, "TOPLEFT", 384, -108)
    topEmoteBorder:Show();

    local topSeenImagePath = BuhEmotesPack_defaultpack[TwitchEmoteRecievedStatKeys[1]] or "Interface\\AddOns\\BuhEmotesPack\\Emotes\\1337.tga";
    local animdata = BuhEmotesPack_animation_metadata[topSeenImagePath]

    TwitchStatsScreen.topSeenEmoteTexture = TwitchStatsScreen.topSeenEmoteTexture or TwitchStatsScreen:CreateTexture(nil, "BACKGROUND", nil, 2);
    topEmoteTexture = TwitchStatsScreen.topSeenEmoteTexture;

    if animdata ~= nil then
        topEmoteTexture:SetTexture(topSeenImagePath);
        topEmoteTexture:SetTexCoord(BuhEmotesPack_GetTexCoordsForFrame(animdata, 0)) 
    else
        local size = string.match(topSeenImagePath, ":(.*)")
        if size then
            topSeenImagePath = string.gsub(topSeenImagePath, size, "")
        end

        topEmoteTexture:SetTexture(topSeenImagePath);
    end

    topEmoteTexture:SetWidth(70);
    topEmoteTexture:SetHeight(70);
    topEmoteTexture:SetPoint('CENTER', TwitchStatsScreen, "TOPLEFT", 384, -108)
    topEmoteTexture:Show();

    local searchBox = CreateFrame("EditBox", "logEditBox", TwitchStatsScreen, "InputBoxTemplate")
    searchBox:SetFrameStrata("DIALOG")
    searchBox:SetSize(150,16)
    searchBox:SetAutoFocus(false)
    searchBox:SetText("")
    searchBox:SetPoint("TOPLEFT", 10, -185)
    searchBox:HookScript("OnTextChanged", function(editbox, changedByUser)
        -- set filtered stat keys here
        -- call TwitchStatsSentScrollBar_Update() and TwitchStatsRecievedScrollBar_Update
        local text = searchBox:GetText();
        if(text == '') then
            FilteredTwitchEmoteRecievedStatKeys = TwitchEmoteRecievedStatKeys
            FilteredBuhEmotesPackentStatKeys = BuhEmotesPackentStatKeys
        else
            local receivedResultsCount = 1;
            FilteredTwitchEmoteRecievedStatKeys = {}
            for i=1, #TwitchEmoteRecievedStatKeys  do
                local pattern = "^.*" .. text:lower() .. ".*";
                
                if string.find(TwitchEmoteRecievedStatKeys[i]:lower(), pattern) == 1 then
                    FilteredTwitchEmoteRecievedStatKeys[receivedResultsCount] = TwitchEmoteRecievedStatKeys[i];
                    receivedResultsCount = receivedResultsCount + 1
                end
            end

            --todo: refactor this copied code
            local sentResultsCount = 1;
            FilteredBuhEmotesPackentStatKeys = {}
            for i=1, #BuhEmotesPackentStatKeys  do
                local pattern = text:lower();
                pattern = "^.*" .. text:lower() .. ".*";

                if string.find(BuhEmotesPackentStatKeys[i]:lower(), pattern) == 1 then
                    FilteredBuhEmotesPackentStatKeys[sentResultsCount] = BuhEmotesPackentStatKeys[i];
                    sentResultsCount = sentResultsCount + 1
                end
            end
        end

        TwitchStatsSentScrollBar_Update();
        TwitchStatsRecievedScrollBar_Update();
    end)

    --Instantiate the scroll list entries
    for i=2, 17  do
        local twitchStatSentScrollEntry = CreateFrame('Button', "TwitchStatsSentEntry"..i, TwitchStatsScreen, 'TwitchStatsEntryTemplate')
        twitchStatSentScrollEntry:SetPoint("TOPLEFT", "TwitchStatsSentEntry"..(i-1), "BOTTOMLEFT", 0, 0);

        local twitchStatRecievedScrollEntry = CreateFrame('Button', "TwitchStatsRecievedEntry"..i, TwitchStatsScreen, 'TwitchStatsEntryTemplate')
        twitchStatRecievedScrollEntry:SetPoint("TOPLEFT", "TwitchStatsRecievedEntry"..(i-1), "BOTTOMLEFT", 0, 0);
        --print("constructed TwitchStatsSentEntry" .. i .. " (parent TwitchStatsSentEntry" ..(i-1) )
    end

    TwitchStatsScreen:Show()
    TwitchStatsSentScrollBar:Show()
    TwitchStatsRecievedScrollBar:Show()
end

function TwitchStatsSentScrollBar_Update()
    local nrOfItemsVisible = 17
    local lineplusoffset; -- an index into our data calculated from the scroll offset
    local filteredStatKeys = FilteredBuhEmotesPackentStatKeys
    
    FauxScrollFrame_Update(TwitchStatsSentScrollBar,#filteredStatKeys,nrOfItemsVisible,16);
    for line=1, nrOfItemsVisible do
      lineplusoffset = line + FauxScrollFrame_GetOffset(TwitchStatsSentScrollBar);
      if lineplusoffset <= #filteredStatKeys then
        local cEmote = filteredStatKeys[lineplusoffset];
        local fullEmotePath = BuhEmotesPack_defaultpack[cEmote];
        local animdata = BuhEmotesPack_animation_metadata[fullEmotePath]
        local texturestr = nil
        if animdata ~= nil then
            texturestr = BuhEmotesPack_BuildEmoteFrameStringWithDimensions(fullEmotePath, animdata, 0, 16, 16)
        else
            local size = string.match(fullEmotePath, ":(.*)")
            texturestr = "|T"..string.gsub(fullEmotePath, size, "16:16").."|t"
        end

        getglobal("TwitchStatsSentEntry"..line):SetText("|cFFfce703" .. lineplusoffset ..".|r ".. texturestr .." " .. " |cFF00FF00"..cEmote.."|r sent: " .. BuhEmotesPacktatistics[cEmote][2] .. "x");
        getglobal("TwitchStatsSentEntry"..line):Show();
        
      else
        getglobal("TwitchStatsSentEntry"..line):Hide();
      end
    end
end

-- todo: refactor this copied code
function TwitchStatsRecievedScrollBar_Update()
    local nrOfItemsVisible = 17
    local lineplusoffset; -- an index into our data calculated from the scroll offset
    local filteredStatKeys = FilteredTwitchEmoteRecievedStatKeys

    FauxScrollFrame_Update(TwitchStatsRecievedScrollBar,#filteredStatKeys,nrOfItemsVisible,16);
    for line=1, nrOfItemsVisible do
      lineplusoffset = line + FauxScrollFrame_GetOffset(TwitchStatsRecievedScrollBar);
      if lineplusoffset <= #filteredStatKeys then
        local cEmote = filteredStatKeys[lineplusoffset];
        local fullEmotePath = BuhEmotesPack_defaultpack[cEmote]

        local animdata = BuhEmotesPack_animation_metadata[fullEmotePath]
        local texturestr = nil
        if animdata ~= nil then
            texturestr = BuhEmotesPack_BuildEmoteFrameStringWithDimensions(fullEmotePath, animdata, 0, 16, 16)
        else
            local size = string.match(fullEmotePath, ":(.*)")
            texturestr = "|T"..string.gsub(fullEmotePath, size, "16:16").."|t"
        end
        
        getglobal("TwitchStatsRecievedEntry"..line):SetText("|cFFfce703" .. lineplusoffset ..".|r ".. texturestr .." " .. " |cFF00FF00"..cEmote.."|r seen: " .. BuhEmotesPacktatistics[cEmote][3] .. "x");
        getglobal("TwitchStatsRecievedEntry"..line):Show();
        
      else
        getglobal("TwitchStatsRecievedEntry"..line):Hide();
      end
    end
end