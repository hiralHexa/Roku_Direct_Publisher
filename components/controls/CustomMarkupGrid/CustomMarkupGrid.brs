sub init()
    print "CustomMarkupGrid : Init"
    SetLocals()
    SetControls()
    SetupFonts()
    SetupColor()
    SetObservers()
    Initialize()
end sub

sub SetLocals()
    m.scene = m.top.GetScene()
    m.theme = m.global.appTheme
    m.fonts = m.global.fonts
    m.appResponse = m.global.appResponse
end sub

sub SetControls()
    m.lTitleName = m.top.findNode("lTitleName")
    m.lNoItemsAvailable = m.top.findNode("lNoItemsAvailable")
    m.lCurrentIndexIndicator = m.top.findNode("lCurrentIndexIndicator")
    m.markupGrid = m.top.findNode("customMarkupGrid")
end sub

sub SetupFonts()
    m.lTitleName.font = m.fonts.openSansBold40
    m.lNoItemsAvailable.font = m.fonts.openSansbold30
    m.lCurrentIndexIndicator.font = m.fonts.openSansRegular32
end sub

sub SetupColor()
    if (m.appResponse <> invalid and m.theme.primary_text_color <> invalid and m.theme.primary_text_color <> "") and (m.appResponse.secondary_text_color <> invalid and m.appResponse.secondary_text_color <> "") and (m.appResponse.focus_indicator_color <> invalid and m.appResponse.focus_indicator_color <> "")
        m.primary_text_color = m.theme.primary_text_color
        m.secondary_text_color = m.theme.secondary_text_color
        m.focus_indicator_color = m.theme.focus_indicator_color
    else
        m.primary_text_color = m.theme.baseColorDarkGray
        m.secondary_text_color = m.theme.baseColorDarkGray
        m.focus_indicator_color = m.theme.baseColor
    end if

    m.lTitleName.color = m.secondary_text_color
    m.lNoItemsAvailable.color = m.secondary_text_color
    m.lCurrentIndexIndicator.color = m.primary_text_color
    m.markupGrid.focusFootprintBlendColor = m.focus_indicator_color
    m.markupGrid.focusBitmapBlendColor = m.focus_indicator_color
end sub

sub SetObservers()
    m.top.observeField("focusedChild","OnFocusedChild")
    m.markupGrid.observeField("itemSelected", "MgItems_ItemSelected")
    m.markupGrid.observeField("itemFocused", "MgItems_ItemFocused")
end sub

sub Initialize()
    m.gridContent = invalid
    m.top.customMarkupGrid = m.markupGrid
end sub

sub onGridTitleChange()
    if m.top.gridTitle <> ""
        m.markupGrid.translation = [0,70]
    else
        m.markupGrid.translation = [0,0]
    end if
end sub

Function MgItems_ItemSelected()
    ' selectedIndex = event.getData()
    ' childNode = m.markupGrid.content.getChild(selectedIndex)
End Function

Function MgItems_ItemFocused(event as dynamic)
    index = event.GetData()
    if (m.markupGrid <> invalid AND m.markupGrid.content <> invalid)
        m.top.currentFocusedItemIndex = index
        m.lCurrentIndexIndicator.text = (m.top.currentFocusedItemIndex + 1).tostr() + " / " + m.top.totalGridItems.tostr()
    end if
End Function

sub onTotalCountChanged()
    m.lCurrentIndexIndicator.text = "Total : " + m.top.totalGridItems.tostr()
end sub

sub onIsGridUpdated()
    if (m.top.gridContent = invalid OR m.top.gridContent.count() = 0)
        m.markupGrid.content = invalid
        m.gridContent  = invalid
        m.top.isGridUpdated = false
        m.lCurrentIndexIndicator.text = ""
        m.lNoItemsAvailable.text = "No videos are available!"
        m.lNoItemsAvailable.visible = true
        return
    end if
    m.lCurrentIndexIndicator.text = "Total : " + m.top.totalGridItems.tostr()
    m.lNoItemsAvailable.visible = false
    m.gridContent = m.top.gridContent

    m.row = CreateObject("roSGNode", "ContentNode")
    totalItems = m.gridContent.count() -1
    for i = 0 to totalItems
        item = m.gridContent[i]
        programItem = m.row.CreateChild("HomeItemData")
        programItem.id = item.id
        programItem.title = item.title
        programItem.shortDescription = item.shortDescription
        programItem.thumbnail = item.thumbnail
        programItem.tags = item.tags
        programItem.content = item.content
        programItem.vastURL = "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_ad_samples&sz=640x480&cust_params=sample_ct%3Dlinear&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator="
    end for

    m.markupGrid.itemSize = "[510, 291]"
    m.markupGrid.itemSpacing = "[50, 100]"
    m.markupGrid.numColumns = "2"

    m.markupGrid.content = m.row
    m.top.currentFocusedItemIndex = 0
end sub

sub OnFocusedChild()
    if (m.top.IsInFocusChain() and m.top.hasFocus() and m.top.visible = true)
        m.markupGrid.setFocus(true)
    else
    end if
end sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "CustomMarkupGrid : onKeyEvent : key = " key " press = " press
        if key = "down"
            if m.gridContent <> invalid AND m.gridContent.count() > 0
            end if
        end if
    end if
    return result
end function
