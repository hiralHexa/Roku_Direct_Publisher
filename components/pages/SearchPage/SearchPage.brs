sub init()
    print "SearchPage : init"
    SetLocals()
    SetControls()
    SetupFonts()
    setupColors()
    SetObservers()
    CreateBusySpinnerControls()
    Initialize()
end sub

sub SetLocals()
    m.scene = m.top.GetScene()
    m.theme = m.global.appTheme
    m.fonts = m.global.fonts
    m.appResponse = m.global.appResponse
    m.lastSearchTerm = ""
end sub

sub SetControls()
    m.bgPoster = m.top.findNode("bgPoster")
    m.lKeyBoardTitle = m.top.findNode("lKeyBoardTitle")
    m.miniKeyboard = m.top.FindNode("miniKeyboard")
    m.rBackground = m.top.findNode("rBackground")
    m.gRightSection = m.top.FindNode("gRightSection")
    m.pVideoPoster = m.top.FindNode("pVideoPoster")
    m.lVideoTitles = m.top.FindNode("lVideoTitles")
    m.lVideoDescription = m.top.FindNode("lVideoDescription")
    m.SearchResultsProgramsGridControl = m.top.findNode("SearchResultsProgramsGridControl")
    m.lSearchHint = m.top.FindNode("lSearchHint")
    m.lNoItems = m.top.FindNode("lNoItems")
    m.customMarkupGrid = m.SearchResultsProgramsGridControl.findNode("customMarkupGrid")

    m.gPreLoader = m.top.FindNode("gPreLoader")
    m.bsPreloader = m.top.FindNode("bsPreloader")
    m.lPreloader = m.top.FindNode("lPreloader")
end sub

sub SetupFonts()
    print "SearchPage : SetupFonts"
    m.lVideoTitles.font = m.fonts.openSansRegular46
    m.lVideoDescription.font = m.fonts.openSansRegular30
    m.lKeyBoardTitle.font = m.fonts.openSansbold30
    m.lSearchHint.font = m.fonts.openSansbold30
    m.lNoItems.font = m.fonts.openSansbold30
end sub

sub setupColors()
    m.rBackground.color = m.theme.black
    ' m.miniKeyboard.textEditBox.textColor = m.theme.baseColorDarkGray
    ' m.miniKeyboard.focusedKeyColor = m.theme.baseColor
    ' m.miniKeyboard.KeyColor = m.theme.baseColorDarkGray

    if (m.appResponse <> invalid and m.theme.primary_text_color <> invalid and m.theme.primary_text_color <> "") and (m.theme.secondary_text_color <> invalid and m.appResponse.secondary_text_color <> "") and (m.appResponse.focus_indicator_color <> invalid and m.appResponse.focus_indicator_color <> "")
        m.primary_text_color = m.theme.primary_text_color
        m.secondary_text_color = m.theme.secondary_text_color
        m.focus_indicator_color = m.theme.focus_indicator_color
    else
        m.primary_text_color = m.theme.white
        m.secondary_text_color = m.theme.white
        m.focus_indicator_color = m.theme.black
    end if
    if m.appResponse.background_image <> invalid
        m.bgPoster.uri = m.appResponse.background_image
    end if 
    m.lKeyBoardTitle.color = m.primary_text_color
    m.lVideoTitles.color = m.secondary_text_color
    m.lVideoDescription.color = m.secondary_text_color
    m.lSearchHint.color = m.secondary_text_color
    m.lNoItems.color = m.secondary_text_color
end sub

sub SetObservers()
    m.SearchResultsProgramsGridControl.observeField("currentFocusedItemIndex", "onCustomMarkupGridItemFocused")
    m.customMarkupGrid.observeField("itemSelected", "onCustomMarkupGridItemSelected")
    m.customMarkupGrid.observeField("itemFocused", "onCustomMarkupGridItemFocused")
    m.miniKeyboard.observeField("text", "OnKeyboard_TextChange")
    m.top.observeField("focusedChild", "OnFocusedChild")
end sub


'=======> ShowHide Loader'
sub CreateBusySpinnerControls()
    m.lPreloader.text = "Please wait..."
    m.bsPreloader.poster.uri = "pkg:/images/loader/loader.png"
    m.bsPreloader.poster.width = "100"
    m.bsPreloader.poster.height = "100"
    m.bsPreloader.poster.blendColor = m.theme.baseColorDarkGray
    m.lPreloader.color = m.theme.baseColorDarkGray
    m.lPreloader.font = m.fonts.openSansbold30
end sub

sub ShowHideLoader(isShow as boolean, message = "Please wait..." as string, focusSet = true as boolean)
    m.gPreLoader.visible = isShow
    if focusSet
        m.gPreLoader.setFocus(isShow)
        if (isShow = false)
            RestoreFocus()
        end if
    end if
    m.lPreloader.text = message
    m.bsPreloader.translation="[1250,470]"
    m.lPreloader.translation="[680,680]"
end sub
'=======> ShowHide Loader'

sub Initialize()
    'm.miniKeyboard.focusBitmapUri = "pkg:/images/others/keyboard_hover.9.png"
    m.SearchResultsProgramsGridControl.makeLabelVisible = true
end sub

sub onCustomMarkupGridItemSelected(data as dynamic)
    selectedIndex = data.getData()
    searchData = m.customMarkupGrid.content.getChild(selectedIndex)
    print "SearchPage : onCustomMarkupGridItemSelected : vData : "
    m.RowVideoData = {
        id : searchData.id
        title : searchData.title
        shortDescription : searchData.shortDescription
        thumbnail : searchData.thumbnail
        tags : searchData.tags
        content : searchData.content
        vastURL : searchData.vastURL

    }
    if m.RowVideoData <> invalid
        m.scene.callFunc("StartVideo", m.RowVideoData)
    end if
end sub

sub onCustomMarkupGridItemFocused(data as dynamic)
    itemFocused = data.getData()
    print "SearchPage : onCustomMarkupGridItemFocused : itemFocused : " itemFocused
    if itemFocused <> invalid and itemFocused <> -1
        focusedContent = m.customMarkupGrid.content.getChild(itemFocused)
        m.lVideoTitles.text = focusedContent.title
        m.lVideoDescription.text = focusedContent.shortDescription
        m.lVideoTitles.visible = true
        m.lVideoDescription.visible = true
    end if
end sub

sub OnKeyboard_TextChange()
    print "SearchPage : OnKeyboard_TextChange"
    ShowHideLoader(true, "Please wait...", false)
    m.lNoItems.visible = false
    m.SearchResultsProgramsGridControl.visible = false
    searchTerm = m.miniKeyboard.text

    if (searchTerm <> m.lastSearchTerm AND searchTerm <> "")
        m.lastSearchTerm = searchTerm
        m.SearchResultsProgramsGridControl.gridTitle = "Search results for : " + m.lastSearchTerm
        m.SearchResultsProgramsGridControl.gridContent = []
        if m.lastSearchTerm <> invalid
            DoSearch(m.lastSearchTerm)
        end if
        m.lSearchHint.visible = false
    else if (searchTerm = "")
        ShowHideLoader(false)
        m.lSearchHint.visible = true
        m.lNoItems.visible = false
        ' m.lVideoTitles.text = ""
        ' m.lVideoDescription.text = ""
        ' m.pVideoPoster.uri = "invalid"
        m.SearchResultsProgramsGridControl.visible = false
        m.lastSearchTerm = searchTerm
    end if
end sub

sub DoSearch(searchTerm as string)
    VideoData = m.scene.allVideos
    ' print " DoSearch"
    ShowHideLoader(true, "Please wait...", false)
    m.VideoItemDetails = []
    if VideoData <> invalid
        for each VideoDataItem in VideoData
            if VideoDataItem.programs <> invalid and  VideoDataItem.programs.count() > 0
                for each item in VideoDataItem.programs
                    if lcase(item.title).Instr(searchTerm) >= 0
                        m.VideoItemDetails.Push(item)
                    end if
                end for
            end if
        end for
    end if
    if m.VideoItemDetails <> invalid and m.VideoItemDetails.count() > 0
        createSearchVideoGrid()
    else
        m.lNoItems.visible = true
        ShowHideLoader(false)
        SetFocus(m.miniKeyboard)
    end if
end sub

sub createSearchVideoGrid()
    print "SearchPage : createSearchVideoGrid"
    ShowHideLoader(false)
    SetFocus(m.miniKeyboard)
    if (m.lastSearchTerm <> "" and m.VideoItemDetails.count() > 0)
        m.SearchResultsProgramsGridControl.visible = true
        m.SearchResultsProgramsGridControl.gridContent = m.VideoItemDetails
        m.SearchResultsProgramsGridControl.totalGridItems = m.VideoItemDetails.count()
        m.lNoItems.visible = false
    else
        m.customMarkupGrid.content = invalid
        m.SearchResultsProgramsGridControl.visible = false
        ' m.lVideoTitles.text = ""
        ' m.lVideoDescription.text = ""
        ' m.pVideoPoster.uri = "invalid"
        m.lNoItems.visible = true
        m.lSearchHint.visible = false
    end if
end sub

sub OnFocusedChild()
    print "SearchPage : OnFocusedChild"
    if (m.top.hasFocus())
        if not RestoreFocus()
            if m.customMarkupGrid.visible and m.customMarkupGrid.content <> invalid
                SetFocus(m.customMarkupGrid)
            else
                SetFocus(m.miniKeyboard)
            end if
        end if
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press
        print "SearchPage : onKeyEvent : key = " key " press = " press
        if key = "left"
            if (m.customMarkupGrid.hasFocus() or m.customMarkupGrid.IsInFocusChain())
                SetFocus(m.miniKeyboard)
                handled = true
            end if
        else if key = "right"
            if (m.miniKeyboard.hasFocus() or m.miniKeyboard.IsInFocusChain()) AND m.customMarkupGrid <> invalid AND m.customMarkupGrid.content <> invalid AND m.customMarkupGrid.content.getChildCount() > 0 AND m.SearchResultsProgramsGridControl.visible = true
                SetFocus(m.customMarkupGrid)
                handled = true
            end if
        else if key = "back"
            if (m.customMarkupGrid.hasFocus() or m.customMarkupGrid.IsInFocusChain())
                SetFocus(m.miniKeyboard)
                handled = true
            end if
        end if
    end if
    return handled
end function
