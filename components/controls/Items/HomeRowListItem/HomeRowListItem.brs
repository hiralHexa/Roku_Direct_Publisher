sub init()
    SetLocals()
    SetControls()
    SetupFontsColor()
end sub

sub SetLocals()
    m.fonts = m.global.fonts
    m.theme = m.global.appTheme
    m.appConfig = m.global.appConfig
    if m.global.appResponse <> invalid
        m.appResponse = m.global.appResponse
    end if
    m.scalePerc = 0.224
end sub

sub SetControls()
    m.gSubRowName = m.top.findNode("gSubRowName")
    m.lRowName = m.top.findNode("lRowName")
    m.lgRowlistContentVertical = m.top.findNode("lgRowlistContentVertical")
    m.borderMask = m.top.findNode("borderMask")
    m.pVideoImage = m.top.findNode("pVideoImage")
    m.pDuration = m.top.findNode("pDuration")
    m.lDuration = m.top.findNode("lDuration")
    m.itemLabel = m.top.findNode("itemLabel")
end sub

sub SetupFontsColor()
    m.itemLabel.font = m.fonts.openSansBold28
    m.itemLabel.color = m.theme.White
end sub

sub ItemContent_Changed()
    itemcontent = m.top.itemContent
    m.lgRowlistContentVertical.visible = true
    boudingRect = m.pVideoImage.boundingRect()
    maskSize = [boudingRect.width, boudingRect.height]
    if m.global.designresolution = "720p"
        maskSize = [maskSize[0]/1.5,maskSize[1]/1.5]
    end if
    m.borderMask.maskSize = maskSize
    m.lgRowlistContentVertical.translation = [5,5]

    if itemContent.thumbnail <> invalid and itemContent.thumbnail <> ""
        m.pVideoImage.uri = itemcontent.thumbnail
    else
        m.pVideoImage.uri = "pkg:/images/focus/horiz-mask.png"
        m.pVideoImage.blendColor = m.theme.DarkGray
        m.lRowName.text = itemcontent.title
        if (m.theme.secondary_text_color <> invalid and m.theme.secondary_text_color <> "")
            m.lRowName.color = m.theme.secondary_text_color
        else
            m.lRowName.color = m.theme.White
        end if
            m.lRowName.font = m.fonts.openSansBold40
            m.gSubRowName.visible = true
    end if


    if itemcontent.content.duration <> invalid and itemcontent.content.duration > 0
        m.lDuration.text = FormatTimeStringInHHMMSS(itemcontent.content.duration)
        m.lDuration.font = m.fonts.openSansBold25
        if (m.theme.focused_button_text_color <> invalid and m.theme.focused_button_text_color <> "") and (m.theme.focused_button_background_color <> invalid and m.theme.focused_button_background_color <> "")
            m.lDuration.color = m.theme.focused_button_text_color
            m.pDuration.blendColor = m.theme.focused_button_background_color
        else
            m.lDuration.color = m.theme.Black
            m.pDuration.blendColor = m.theme.White
        end if
        m.pDuration.visible = true
    end if 

    if itemcontent.typename <> "HomeRowList"
        m.itemLabel.text = itemcontent.title
        ItemLableboundingRect = m.itemLabel.boundingRect()
        m.itemLabel.translation = [(410-ItemLableboundingRect.Width)/2,240]
        m.itemLabel.visible = true
    end if
end sub
