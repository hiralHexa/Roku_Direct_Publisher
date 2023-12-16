sub init()
    print "ErrorPage : Init"
    SetLocals()
    SetControls()
    SetupColorAndFont()
    SetObservers()
    Initialize()
end sub

sub SetLocals()
    m.scene = m.top.GetScene()
    m.fonts = m.global.fonts
    m.theme = m.global.appTheme
    if m.global.appResponse <> invalid
        m.appResponse = m.global.appResponse
    end if
    m.appConfig = m.global.appConfig
end sub

sub SetControls()
    m.rBackground = m.top.FindNode("rBackground")
    m.gNoItemsFound = m.top.findNode("gNoItemsFound")
    m.lNoItemsFound = m.top.findNode("lNoItemsFound")
    m.bOKBtn = m.top.FindNode("bOKBtn")
    m.bOKBtn.setFocus(true)
end sub

sub SetupColorAndFont()
    m.rBackground.color = m.theme.BackGroundColor
end sub

sub SetObservers()
end sub

sub Initialize()
    SetNoItemsText()
end sub

sub SetNoItemsText()
    m.gNoItemsFound.visible = true
    m.lNoItemsFound.text = "FAILED TO GET DATA."
    m.lNoItemsFound.color = m.theme.White
    m.lNoItemsFound.font = m.fonts.openSansBold36

    m.bOKBtn.focusTextColor = m.theme.white
    m.bOKBtn.unfocusTextColor = m.theme.black
    m.bOKBtn.backgroundColor = m.theme.white
    m.bOKBtn.fontSize = "openSansBold23"
    m.bOKBtn.focusBorderImage = "pkg:/images/focus/filled_r6.9.png"
    m.bOKBtn.backGroundImage = "pkg:/images/focus/filled_r6.9.png"
    m.bOKBtn.focusBackgroundColor = m.theme.themeColor
    m.bOKBtn.margin = 20
end sub