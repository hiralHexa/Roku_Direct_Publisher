sub init()
    print "ProgramItem : Init"
    SetLocals()
    SetControls()
    SetupFonts()
    SetupColor()
end sub

sub SetLocals()
    m.fonts = m.global.fonts
    m.theme = m.global.appTheme
    m.appResponse = m.global.appResponse
end sub

sub SetControls()
    m.lgGridContentVertical = m.top.findNode("lgGridContentVertical")
    m.borderMask = m.top.findNode("borderMask")
    m.pVideoImage = m.top.findNode("pVideoImage")
    m.lTitle = m.top.findNode("lTitle")
    m.pDuration = m.top.findNode("pDuration")
    m.lDuration = m.top.findNode("lDuration")
end sub

sub SetupFonts()
    m.lTitle.font = m.fonts.openSansBold28
end sub

sub SetupColor()
    m.lTitle.color = m.theme.white
end sub

sub ItemContent_Changed()
    itemcontent = m.top.itemContent
    m.lTitle.text = itemcontent.title
    m.lTitle.visible = true
    m.lgGridContentVertical.visible = true
    boudingRect = m.pVideoImage.boundingRect()
    maskSize = [boudingRect.width, boudingRect.height]
    if m.global.designresolution = "720p"
        maskSize = [maskSize[0]/1.5,maskSize[1]/1.5]
    end if
    m.borderMask.maskSize = maskSize
    m.lgGridContentVertical.translation = [5,5]
    if itemContent.thumbnail <> invalid and itemContent.thumbnail <> ""
        m.pVideoImage.uri = itemcontent.thumbnail
    else
        m.pVideoImage.uri = "pkg:/images/focus/horiz-mask.png"
        m.pVideoImage.blendColor = m.theme.DarkGray
    end if

    if itemcontent.content.duration <> invalid and itemcontent.content.duration > 0
        m.lDuration.text = FormatTimeStringInHHMMSS(itemcontent.content.duration)
        m.lDuration.font = m.fonts.openSansBold25
        m.lDuration.color = m.theme.UnfocusColor
        m.pDuration.blendColor = m.theme.boxGrayLight
        m.pDuration.visible = true
        m.lDuration.visible = true
    end if

end sub

sub setSize(percent as float)
    backPer = percent
    if (percent < 0.5)
        backPer = 0.5
    end if
    ' m.pVideoLock.opacity = backPer
end sub

sub FocusPercent_Changed(event as dynamic)
    value = event.GetData()
    if ((m.top.rowListHasFocus and m.top.RowHasFocus) or m.top.gridHasFocus)
        setSize(value)
    else
        setSize(0)
    end if
end sub

sub ItemHasFocus_Changed(event as dynamic)
    value = event.GetData()
    if (value)
        SetSize(1)
    end if
end sub

sub RowHasFocus_Changed()
    if (m.top.RowHasFocus and m.top.ItemHasFocus)
        SetSize(1)
    else
        SetSize(0)
    end if
end sub

sub ParentHasFocus_Changed()
    if (((m.top.RowListHasFocus and m.top.RowHasFocus) or m.top.GridHasFocus) and (m.top.ItemHasFocus or m.top.FocusPercent = 1))
        SetSize(1)
    else
        SetSize(0)
    end if
end sub
