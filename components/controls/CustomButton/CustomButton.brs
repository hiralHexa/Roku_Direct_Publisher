Sub Init()
  Print "CustomButton : Init"
  SetLocals()
  SetControls()
  SetObservers()
  SetupFonts()
  SetupColor()
  OnBorderSize()
End Sub

Sub SetLocals()
    m.theme = m.global.appTheme
    m.fonts = m.global.fonts
End Sub

Sub SetControls()
    m.slButtonText = m.top.FindNode("slButtonText")
    m.btnImage = m.top.FindNode("btnImage")
    m.rButtonBackround = m.top.FindNode("rButtonBackround")
    m.Padding = 10
End Sub

Sub SetObservers()
    m.top.observeField("focusedChild", "OnFocusedChild")
End Sub

Sub SetupFonts()
End Sub

Sub SetupColor()
End Sub

sub OnBorderSize()

end sub

sub OnPosterImageDataChange()
    m.btnImage.uri = m.top.posterImage
    m.btnImage.visible = true
end sub

Sub OnMarginChange()
    m.slButtonText.Width = m.top.buttonWidth - (m.top.margin * 2) - (m.top.rightExtraPadding)
    m.slButtonText.height = m.top.buttonHeight
    if m.top.posterImage <> invalid and m.top.posterImage <> ""
    else
        m.slButtonText.translation =  [m.top.margin, 0]
    end if
    OnBorderSize()
End Sub

Sub OnButtonWidthChange()
    if m.top.posterImage <> invalid and m.top.posterImage <> ""
        m.slButtonText.Width = m.top.buttonWidth - m.btnImage.width
    else
        m.slButtonText.Width = m.top.buttonWidth
    end if
    OnBorderSize()
End Sub

Sub OnFontSizeChange()
    if m.top.fontSize <> invalid and m.top.fontSize <> ""
        textFont = m.top.fontSize
        ' m.slButtonText.font = m.fonts[textFont]
    end if
    SetTranslations()
End Sub

Sub OnButtonTextChange()
    m.slButtonText.text = m.top.buttonText
End Sub

Sub OnButtonHeightChange()
    m.slButtonText.height = m.top.buttonHeight
End Sub

Sub OnBackgroundColorChange()
    m.rButtonBackround.blendColor = m.top.backgroundColor
End Sub

Sub OnUnFocusTextColorChange()
    m.slButtonText.color = m.top.unfocusTextColor
    m.btnImage.blendcolor = m.top.unfocusTextColor
End Sub

Sub OnIsFilledBgOnFocusChange()
    If(m.top.isFilledBgOnFocus)
        ' m.slButtonText.font = m.fonts.openSansReg25
    End IF
End Sub

Sub OnFocusedChild()
    SetFocusItem(m.top.hasFocus())
End Sub

Sub SetTranslations()
    if m.top.posterImage <> invalid and m.top.posterImage <> ""
        Xpos = m.Padding
        btnImageRect = m.btnImage.boundingRect()
        yPos = (m.top.buttonHeight - btnImageRect.width) / 2
        m.btnImage.translation = [Xpos, yPos]

        slButtonText = m.slButtonText.boundingRect()
        m.slButtonText.translation = [Xpos + 50,0]
        m.slButtonText.height = m.top.buttonHeight
        m.slButtonText.width = (slButtonText.width + (Xpos * 2))
        m.rButtonBackround.width = slButtonText.width + (Xpos * 2) + 50 + btnImageRect.width
        m.slButtonText.horizAlign = "left"
        m.slButtonText.vertAlign = "center"
    end if
End Sub

Sub SetFocusItem(isFocused)
    If isFocused
        m.slButtonText.color = m.top.focusTextColor
        If(m.top.isFilledBgOnFocus)
            m.rButtonBackround.uri = "pkg:/images/focus/R5Filled_30px.9.png"
        Else
            m.rButtonBackround.uri = m.top.backGroundImage
        End If
        m.rButtonBackround.blendColor = m.top.focusBackgroundColor
        m.btnImage.blendColor = m.top.focusTextColor
        ' m.slButtonText.repeatCount = -1
    Else
        m.slButtonText.color = m.top.unfocusTextColor
        m.rButtonBackround.uri = m.top.focusBorderImage
        m.rButtonBackround.blendColor = m.top.backgroundColor
        ' m.slButtonText.repeatCount = 0
        m.btnImage.blendColor = m.top.unfocusTextColor
    End If
End Sub

Function OnkeyEvent(key as String, press as boolean) as boolean
    result = false
    If press
        Print "CustomButton : onKeyEvent : key = " key " press = " press
        If key = "back"
            result = false
        End If
    End If
    Return result
End Function
