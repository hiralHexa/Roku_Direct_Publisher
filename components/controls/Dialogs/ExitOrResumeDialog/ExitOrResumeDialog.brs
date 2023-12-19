sub init()
    m.theme = m.global.appTheme
    m.appConfig = m.global.appConfig
    m.fonts = m.global.Fonts
    if m.global.appResponse <> invalid
        m.appResponse = m.global.appResponse
    end if
    m.lgExitBox = m.top.findNode("lgExitBox")
    m.lgbtngrp = m.top.findNode("lgbtngrp")
    m.showAnimation = m.top.findNode("showAnimation")
    m.showAnimation.control = "start"
    m.exitResume_message = m.top.findNode("exitResume_message")
    m.rectBackground = m.top.findNode("rectBackground")
    m.pYesBtnBorder = m.top.findNode("pYesBtnBorder")
    m.pNoBtnBorder = m.top.findNode("pNoBtnBorder")
    m.msg_title = m.top.findNode("msg_title")
    m.yesBtn = m.top.findNode("yesBtn")
    m.noBtn = m.top.findNode("noBtn")
    m.pShowPoster = m.top.findNode("pShowPoster")
    m.exitCalled = false
    m.focusKey = 1
    if (m.appResponse <> invalid and m.theme.focused_button_background_color <> invalid and m.theme.focused_button_background_color <> "") and (m.theme.unfocused_button_background_color <> invalid and m.theme.unfocused_button_background_color <> "") and (m.theme.focused_button_text_color <> invalid and m.theme.focused_button_text_color <> "") and (m.theme.unfocused_button_text_color <> invalid and m.theme.unfocused_button_text_color <> "")
        m.focused_button_background_color = m.theme.focused_button_background_color
        m.unfocused_button_background_color = m.theme.unfocused_button_background_color
        m.focused_button_text_color = m.theme.focused_button_text_color
        m.unfocused_button_text_color = m.theme.unfocused_button_text_color
    else
        m.focused_button_background_color = m.theme.ThemeColor
        m.unfocused_button_background_color = m.theme.Gray
        m.focused_button_text_color = m.theme.Black
        m.unfocused_button_text_color = m.theme.White
    end if 

    m.pYesBtnBorder.blendcolor = m.unfocused_button_background_color
    m.pNoBtnBorder.blendcolor = m.focused_button_background_color
    m.yesBtn.color = m.unfocused_button_text_color
    m.noBtn.color = m.focused_button_text_color

    SetupFonts()
    SetupColor()
end sub

sub OnIsResumeBoxChanged()
    UpdateText()
end sub

sub UpdateText()
    dialogData = m.top.dialogData
    m.msg_title.text = dialogData.titleText
    m.exitResume_message.text = dialogData.messageText
    if m.top.isResumeBox
        m.pShowPoster.uri = dialogData.videoPoster
        m.pShowPoster.width = 315
        m.pShowPoster.height = 315
        m.pShowPoster.translation = [803, 170]
        m.msg_title.translation = [0,505]
        m.exitResume_message.translation = [0,510]
        m.pYesBtnBorder.translation = [525,700]
        m.yesBtn.translation = [525,700]
        m.pNoBtnBorder.translation = [975,700]
        m.noBtn.translation = [975,700]
    end if
    if m.top.isExitBox
        if m.appResponse <> invalid and m.appResponse.app_logo <> invalid and m.appResponse.app_logo <> ""
            m.pShowPoster.uri = m.appResponse.app_logo
            brLogo = m.pShowPoster.boundingRect()
            m.pShowPoster.loadwidth = brLogo.width
            m.pShowPoster.loadheight = brLogo.height
            m.pShowPoster.width = brLogo.width
            m.pShowPoster.height = brLogo.height
            m.exitCalled = true
            brexitDialog = m.lgExitBox.boundingRect()
            m.lgExitBox.translation = [(1920-brexitDialog.width)/2,(1080-brexitDialog.height)/2]
            brlgbtngrpDialog = m.lgbtngrp.boundingRect()
            m.lgbtngrp.translation = [(1920-brlgbtngrpDialog.width)/2,m.lgExitBox.translation[1] + brexitDialog.height + 15]
            m.pShowPoster.translation = [(1920-brLogo.width)/2,(1080-(brLogo.height + brexitDialog.height + brlgbtngrpDialog.height + 20))/2]
        end if
    end if
    if dialogData.restartFlag
        m.yesBtn.text = dialogData.positiveBtnText
        m.noBtn.visible = false
        m.pNoBtnBorder.visible = false
        m.focusKey = 0
        m.yesBtn.translation = [760, 815]
        m.pYesBtnBorder.translation = [760, 725]
    else
        m.yesBtn.text = dialogData.positiveBtnText
        m.noBtn.text = dialogData.negativeBtnText
        m.focusKey = 1
        m.pNoBtnBorder.blendcolor = m.focused_button_background_color
        m.pYesBtnBorder.blendcolor = m.unfocused_button_background_color

        m.yesBtn.color = m.unfocused_button_text_color
        m.noBtn.color = m.focused_button_text_color
    end if
end sub

sub SetupFonts()
    if(m.top.isResumeBox = false)
        m.msg_title.font = m.fonts.openSansBold36
        m.exitResume_message.font = m.fonts.openSansReg30
        m.yesBtn.font = m.fonts.openSansbold30
        m.noBtn.font = m.fonts.openSansbold30
    else
        m.msg_title.font = m.fonts.openSansBold36
        m.exitResume_message.font = m.fonts.openSansReg30
        m.yesBtn.font = m.fonts.openSansbold30
        m.noBtn.font = m.fonts.openSansbold30
    end if
end sub

sub SetupColor()
    m.yesBtn.color = m.focused_button_text_color
    m.pYesBtnBorder.blendcolor = m.focused_button_background_color
    m.pNoBtnBorder.blendcolor = m.unfocused_button_background_color
    m.rectBackground.color = m.focused_button_text_color
    m.noBtn.color = m.unfocused_button_text_color
    m.exitResume_message.color = m.unfocused_button_text_color
end sub

sub On_bExitResumeYes_button_pressed()
    m.top.selectedButton = "0"
    m.exitCalled = true
end sub

sub On_bExitResumeNo_button_pressed()
    m.top.selectedButton = "1"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = true
    if (press)
        print "ExitOrResumeDialog : onKeyEvent : key = " key " press = " press
        if key = "back"
            handled = false
        else if key = "right"
            if m.focusKey = 0 and m.pNoBtnBorder.visible and m.noBtn.visible
                m.focusKey = 1
                m.pNoBtnBorder.blendcolor = m.focused_button_background_color
                m.pYesBtnBorder.blendcolor = m.unfocused_button_background_color
                m.yesBtn.color = m.unfocused_button_text_color
                m.noBtn.color = m.focused_button_text_color
            end if
        else if key = "left" and m.pYesBtnBorder.visible and m.yesBtn.visible
            if m.focusKey = 1
                m.focusKey = 0
                m.pYesBtnBorder.blendcolor = m.focused_button_background_color
                m.pNoBtnBorder.blendcolor = m.unfocused_button_background_color
                m.yesBtn.color = m.focused_button_text_color
                m.noBtn.color = m.unfocused_button_text_color
            end if
        else if key = "OK"
            if m.focusKey = 0
                On_bExitResumeYes_button_pressed()
            else if m.focusKey = 1
                On_bExitResumeNo_button_pressed()
            end if
        end if
    end if

    return handled
end function
