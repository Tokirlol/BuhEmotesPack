local BuhEmotesPack_TimeSinceLastUpdate = 0
local BuhEmotesPack_T = 0;

function BuhEmotesPackAnimator_OnUpdate(self, elapsed)

    if (BuhEmotesPack_TimeSinceLastUpdate >= 0.033) then
        -- Update animated emotes in chat windows
        for i = 1, NUM_CHAT_WINDOWS do
            for _, visibleLine in ipairs(_G["ChatFrame" .. i].visibleLines) do
                if(_G["ChatFrame" .. i]:IsShown() and visibleLine.messageInfo ~= BuhEmotesPack_HoverMessageInfo) then 
                    BuhEmotesPackAnimator_UpdateEmoteInFontString(visibleLine);
                end
            end
        end

        -- Update animated emotes in suggestion list
        if (EditBoxAutoCompleteBox and EditBoxAutoCompleteBox:IsShown() and
            EditBoxAutoCompleteBox.existingButtonCount ~= nil) then
            for i = 1, EditBoxAutoCompleteBox.existingButtonCount do
                local cBtn = EditBoxAutoComplete_GetAutoCompleteButton(i);
                if (cBtn:IsVisible()) then
                    BuhEmotesPackAnimator_UpdateEmoteInFontString(cBtn, 16, 16);
                else
                    break
                end
            end
        end

        -- Update animated emotes in statistics screen
        if(TwitchStatsScreen:IsVisible()) then
           
            local topSentImagePath = BuhEmotesPack_defaultpack[BuhEmotesPackentStatKeys[1]] or "Interface\\AddOns\\BuhEmotesPack\\Emotes\\1337.tga";
            local animdata = BuhEmotesPack_animation_metadata[topSentImagePath:match("(Interface\\AddOns\\BuhEmotesPack\\Emotes.-.tga)")]
            
            if(animdata ~= nil) then
                local cFrame = BuhEmotesPack_GetCurrentFrameNum(animdata)
                TwitchStatsScreen.topSentEmoteTexture:SetTexCoord(BuhEmotesPack_GetTexCoordsForFrame(animdata, cFrame)) 
            end
                

            local topSeenImagePath = BuhEmotesPack_defaultpack[TwitchEmoteRecievedStatKeys[1]] or "Interface\\AddOns\\BuhEmotesPack\\Emotes\\1337.tga";
            local animdata = BuhEmotesPack_animation_metadata[topSeenImagePath:match("(Interface\\AddOns\\BuhEmotesPack\\Emotes.-.tga)")]
            if(animdata ~= nil) then
                local cFrame = BuhEmotesPack_GetCurrentFrameNum(animdata)
                TwitchStatsScreen.topSeenEmoteTexture:SetTexCoord(BuhEmotesPack_GetTexCoordsForFrame(animdata, cFrame)) 
            end
            

            for line=1, 17 do
                local sentEntry = getglobal("TwitchStatsSentEntry"..line)
                local recievedEntry = getglobal("TwitchStatsRecievedEntry"..line)

                if(sentEntry:IsVisible()) then
                    BuhEmotesPackAnimator_UpdateEmoteInFontString(sentEntry, 16, 16);
                end

                if(recievedEntry:IsVisible()) then
                    BuhEmotesPackAnimator_UpdateEmoteInFontString(recievedEntry, 16, 16);
                end
            end
        end
        

        BuhEmotesPack_TimeSinceLastUpdate = 0;
    end

    BuhEmotesPack_T = BuhEmotesPack_T + elapsed
    BuhEmotesPack_TimeSinceLastUpdate = BuhEmotesPack_TimeSinceLastUpdate +
                                        elapsed;
end

local function escpattern(x)
    return (
            --x:gsub('%%', '%%%%')
             --:gsub('^%^', '%%^')
             --:gsub('%$$', '%%$')
             --:gsub('%(', '%%(')
             --:gsub('%)', '%%)')
             --:gsub('%.', '%%.')
             --:gsub('%[', '%%[')
             --:gsub('%]', '%%]')
             --:gsub('%*', '%%*')
             x:gsub('%+', '%%+')
             :gsub('%-', '%%-')
             --:gsub('%?', '%%?'))
            )
end

-- This will update the texture escapesequence of an animated emote
-- if it exsists in the contents of the fontstring
function BuhEmotesPackAnimator_UpdateEmoteInFontString(fontstring, widthOverride, heightOverride)
    local txt = fontstring:GetText();
    if (txt ~= nil) then
        for emoteTextureString in txt:gmatch("(|TInterface\\AddOns\\BuhEmotesPack\\Emotes.-|t)") do
            local imagepath = emoteTextureString:match("|T(Interface\\AddOns\\BuhEmotesPack\\Emotes.-.tga).-|t")

            local animdata = BuhEmotesPack_animation_metadata[imagepath];
            if (animdata ~= nil) then
                local framenum = BuhEmotesPack_GetCurrentFrameNum(animdata);
                local nTxt;
                if(widthOverride ~= nil or heightOverride ~= nil) then
                    nTxt = txt:gsub(escpattern(emoteTextureString),
                                        BuhEmotesPack_BuildEmoteFrameStringWithDimensions(
                                        imagepath, animdata, framenum, widthOverride, heightOverride))
                else
                    nTxt = txt:gsub(escpattern(emoteTextureString),
                                      BuhEmotesPack_BuildEmoteFrameString(
                                        imagepath, animdata, framenum))
                end

                -- If we're updating a chat message we need to alter the messageInfo as wel
                if (fontstring.messageInfo ~= nil) then
                    fontstring.messageInfo.message = nTxt
                end
                fontstring:SetText(nTxt);
                txt = nTxt;
            end
        end
    end
end



function BuhEmotesPack_GetAnimData(imagepath)
    return BuhEmotesPack_animation_metadata[imagepath]
end

function BuhEmotesPack_GetCurrentFrameNum(animdata)
    return math.floor((BuhEmotesPack_T * animdata.framerate) % animdata.nFrames);
end

function BuhEmotesPack_GetTexCoordsForFrame(animdata, framenum)
    local fHeight = animdata.frameHeight;
    return 0, 1 ,framenum * fHeight / animdata.imageHeight, ((framenum * fHeight) + fHeight) / animdata.imageHeight
end

function BuhEmotesPack_BuildEmoteFrameString(imagepath, animdata, framenum)
    local top = framenum * animdata.frameHeight;
    local bottom = top + animdata.frameHeight;

    local emoteStr = "|T" .. imagepath .. ":" .. animdata.frameHeight .. ":" ..
                        animdata.frameWidth .. ":0:0:" .. animdata.imageWidth ..
                        ":" .. animdata.imageHeight .. ":0:" ..
                        animdata.frameWidth .. ":" .. top .. ":" .. bottom ..
                        "|t";
    return emoteStr
end

function BuhEmotesPack_BuildEmoteFrameStringWithDimensions(imagepath, animdata,
                                                        framenum, framewidth,
                                                        frameheight)
    local top = framenum * animdata.frameHeight;
    local bottom = top + animdata.frameHeight;

    local emoteStr = "|T" .. imagepath .. ":" .. framewidth .. ":" ..
                        frameheight .. ":0:0:" .. animdata.imageWidth .. ":" ..
                        animdata.imageHeight .. ":0:" .. animdata.frameWidth ..
                        ":" .. top .. ":" .. bottom .. "|t";
    return emoteStr
end