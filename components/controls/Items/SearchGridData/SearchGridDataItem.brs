sub init()
    SetLocals()
    SetControls()
    SetupFontsColors()
end sub

sub SetLocals()
    m.fonts = m.global.fonts
    m.theme = m.global.appTheme
end sub

sub SetControls()
    m.lgGridContentVertical = m.top.findNode("lgGridContentVertical")
    m.borderMask = m.top.findNode("borderMask")
    m.pVideoImage = m.top.findNode("pVideoImage")
    m.lTitle = m.top.findNode("lTitle")
end sub

sub SetupFontsColors()
    m.lTitle.font = m.fonts.openSansBold28
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
    ' m.lgGridContentVertical.translation = [5,5]
    if itemContent.thumbnail <> invalid and itemContent.thumbnail <> ""
        m.pVideoImage.uri = itemcontent.thumbnail
    else
        m.pVideoImage.uri = "pkg:/images/focus/horiz-mask.png"
        m.pVideoImage.blendColor = m.theme.DarkGray
    end if
end sub
