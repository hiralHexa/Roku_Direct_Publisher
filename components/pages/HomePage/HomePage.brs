sub init()
    print "HomePage : Init"
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
    m.appResponse = m.global.appResponse
    m.isFirstTime = true
    m.categoriesCount = 0
    m.lastFocusIndex = 0
    m.isFirstRowSelected = -1
    m.response = {}
    m.appConfig = m.global.appConfig
end sub

sub SetControls()
    m.background = m.top.findNode("background")
    m.searchGroup = m.top.FindNode("searchGroup")
    m.menuTitleLabel = m.top.findNode("MenuTitleLabel")
    m.SearchBackground = m.top.FindNode("SearchBackground")
    m.searchIcon = m.top.findNode("searchIcon")
    m.rectOverlay = m.top.findNode("RectOverlay")
    m.AnimatePoster = m.top.FindNode("AnimatePoster")
    m.shortDetailsViewControl = m.top.findNode("shortDetailsViewControl")
    m.gHomePage = m.top.findNode("gHomePage")
    m.HeaderBox = m.top.findNode("HeaderBox")
    m.homeRowListControl = m.top.findNode("HomeRowListControl")
    m.rlHomeRowList = m.homeRowListControl.findNode("rlHomeRowList")
    m.gNoItemsFound = m.top.findNode("gNoItemsFound")
    m.lNoItemsFound = m.top.findNode("lNoItemsFound")
    m.gNoItemsFound.visible = false
end sub

sub SetupColorAndFont()
    if (m.appResponse.background_color <> invalid and m.appResponse.background_color <> "")
        m.background.color = m.appResponse.background_color
    end if 
    m.searchIcon.blendColor = m.theme.UnfocusColor
    m.rectOverlay.color = m.theme.Black
    m.menuTitleLabel.color = m.theme.White
    m.menuTitleLabel.font = m.fonts.openSansBold40
end sub

sub SetObservers()
    m.top.observeField("focusedChild", "OnFocusedChild")
    m.homeRowListControl.observeField("focusedRowItem", "HomePageRowList_FocusPosition_Changed")
    m.homeRowListControl.observeField("selectedRowItem", "HomePageRowList_OnVideoClickedInRow")
    m.rlHomeRowList.observeField("rowItemFocused", "HomePageRowList_RlsItems_RowItemFocused")
    m.top.observeField("isDeeplinkingContentFound","OnDeepLinkingContentFound")
end sub

sub Initialize()
    if (m.IsFirstTime = true)
        LoadData()
    end if
end sub

sub LoadData()
    GetCategories()
end sub

sub GetCategories()
    m.CategoriesProgramToAdd = CreateObject("roArray",0,true)
    m.CategoriessDataTask = CreateObject("roSGNode", "APIAction")
    m.CategoriessDataTask.functionName = "GetCategories"
    m.CategoriessDataTask.ObserveField("result", "OnCategoriesDataResponse")
    m.CategoriessDataTask.control = "RUN"
end sub

sub OnCategoriesDataResponse(event as dynamic)
    categories = []
    tabData = event.getData()
    isRowFill = false
    withObjCategory = true
    m.scene.callFunc("ShowHideLoader",false)
    if (tabData.ok AND tabData.data <> Invalid AND tabData.data.categories <> invalid AND tabData.data.categories.count() > 0)
        objResponse = tabData.data
        for each dataItem in objResponse.categories
            for each data in dataItem.items()
                if isRowFill = false
                    if data.key = "playlistName"
                        for each rowName in objResponse["playlists"]
                            if rowName.name = dataItem.playlistName
                                for each rowItem in rowName.itemIds
                                    for each movieItem in objResponse["movies"]
                                        movies = objResponse["movies"]
                                        if movieItem.id = rowItem
                                            categories.push(movieItem)
                                        end if
                                    end for
                                    for each sVideoItem in objResponse["shortFormVideos"]
                                        sVideo = objResponse["shortFormVideos"]
                                        if sVideoItem.id = rowItem
                                            categories.push(sVideoItem)
                                        end if
                                    end for
                                end for 
                            end if
                        end for
                        dataItem.programs = categories
                    else
                        for each dataItem in objResponse.categories
                            Data = objResponse[dataItem.name]
                            dataItem.programs = Data
                            if withObjCategory = false
                                m.CategoriesProgramToAdd.push(dataItem)
                            end if 
                        end for
                        ' isRowFill = true
                    end if
                end if
            end for
        end for
        if withObjCategory = true
            m.CategoriesProgramToAdd.push(dataItem)
            withObjCategory = false
        end if 
        m.HomeRowListControl.content = m.CategoriesProgramToAdd
        if m.HomeRowListControl.visible = false
            m.HomeRowListControl.visible = true
        end if
        m.scene.allVideos = m.CategoriesProgramToAdd
    else if (tabData.ok AND tabData.data <> Invalid AND tabData.data.count() > 0)
        objResponse = tabData.data
        for each dataItem in objResponse.items()
            if type(dataItem.value) = "roArray" and  dataItem.value.count() > 0
                dataItem.name = dataItem.key
                Data = objResponse[dataItem.name]
                for each item in Data
                    categories.push(item)
                end for
                dataItem.programs = Data
                m.CategoriesProgramToAdd.push(dataItem)
            end if 
        end for
        m.HomeRowListControl.content = m.CategoriesProgramToAdd
        if m.HomeRowListControl.visible = false
            m.HomeRowListControl.visible = true
        end if
        m.scene.allVideos = m.CategoriesProgramToAdd
        if (not IsNullOrEmpty(m.scene.deepLinkingMediaType)) and (not IsNullOrEmpty(m.scene.deepLinkingContentId))
            FetchDeepLinkingData(m.scene.deepLinkingContentId)
        else
            m.scene.deepLinkingMediaType = ""
            m.scene.deepLinkingContentId = ""
        end if
    else
        SetNoItemsText()
    end if
end sub

sub FetchDeepLinkingData(contentID as string)
    m.scene.isDeeplinking = false
    videoInfo = {}
    For i = 0 to m.rlHomeRowList.content.GetChildCount() - 1
        childRow = m.rlHomeRowList.content.GetChild(i)
        If(childRow <> invalid And childRow.GetChildCount() > 0)
            For j = 0 to childRow.GetChildCount() - 1
                childNode = childRow.GetChild(j)
                If(childNode <> invalid)
                    If childNode.ID = contentID
                        m.scene.isDeeplinking = true
                        videoInfo["ID"] = childNode.ID
                        videoInfo["CatId"] = childNode.CatId
                        videoInfo["shortDescription"] = childNode.shortDescription
                        videoInfo["thumbnail"] = childNode.thumbnail
                        videoInfo["tags"] = childNode.tags
                        videoInfo["content"] = childNode.content
                        videoInfo["typename"] = childNode.typename
                        videoInfo["vastURL"] = childNode.vastURL
                        Exit For
                    End If
                End If
            End For
        End If
    End For
    m.scene.callFunc("ShowHideLoader",false)
    If m.scene.isDeeplinking = false
        m.scene.callFunc("ShowErrorDialog","No Data found!")
    else
        m.scene.callFunc("StartVideo", videoInfo)
    End If
    m.scene.deepLinkingMediaType = ""
    m.scene.deepLinkingContentId = ""
end sub

sub SetNoItemsText()
    m.gNoItemsFound.visible = true
    m.lNoItemsFound.text = "FAILED TO GET DATA."
    m.lNoItemsFound.color = m.theme.White
    m.lNoItemsFound.font = m.fonts.openSansBold36
    m.scene.callFunc("ShowHideLoader",false)
end sub

sub HomePageRowList_OnVideoClickedInRow(event as dynamic)
    m.RowVideoData = event.getData()
    if m.RowVideoData <> invalid
        m.scene.callFunc("StartVideo",m.RowVideoData)
    end if
end sub

sub HomePageRowList_FocusPosition_Changed(event as dynamic)
    focusData = event.getData()
    if(focusData <> invalid)
        m.shortDetailsViewControl.itemContent = focusData
    end if
end sub

sub HomePageRowList_RlsItems_RowItemFocused(event as dynamic)
    m.focusedRowItem = event.getData()
    m.childRow = m.rlHomeRowList.content.getChild(m.focusedRowItem[0])
    m.childNode = m.childRow.getChild(m.focusedRowItem[1])
end sub

sub OnFocusedChild()
    If m.top.hasFocus()
        restoreFocusRowlist = RestoreFocus()
        If not restoreFocusRowlist
            SetFocus(m.rlHomeRowList)
        End If
    End If
end sub

sub SearchIconFocus()
    if m.searchIcon <> invalid
        m.SearchBackground.blendColor = m.theme.ThemeColor
        m.SearchBackground.visible = true
        searchBoundingRect = m.menuTitleLabel.boundingRect()
        m.menuTitleLabel.text = "Search"
        SetFocus(m.searchIcon)
        ShowSearchIconAnimate()
    end if
end sub

sub ShowSearchIconAnimate()
    scale = 1 + (1 * 0.20)
    m.searchIcon.scale = [scale,scale]
end sub

sub ShowSearchIconUnFocusAnimate()
    scale = 1 + (0 * 0.20)
    m.searchIcon.scale = [scale,scale]
    m.searchIcon.blendColor = m.theme.UnfocusColor
    m.SearchBackground.visible = false
end sub

sub OKKeyEvent()
    if m.searchIcon.IsInFocusChain() or m.searchIcon.hasFocus()
        m.scene.callFunc("ShowSearchPage")
     else
        print "Search Icon has not Focus"
    end if
end sub

sub UPKeyEvent()
    if m.rlHomeRowList <> invalid and m.rlHomeRowList.content <> invalid and  m.rlHomeRowList.hasFocus()
        SearchIconFocus()
        m.rectOverlay.visible = true
        m.menuTitleLabel.visible = true
    else if m.gNoItemsFound.visible = true
        SearchIconFocus()
        m.menuTitleLabel.visible = true
    end if
end sub

function BackKeyEvent()
    result = false
    if m.menuTitleLabel.visible = true
        DownKeyEvent()
        m.menuTitleLabel.visible = false
        result = true
    end if
    return result
end function

sub DownKeyEvent()
    if m.searchIcon.IsInFocusChain() or m.searchIcon.hasFocus()
        m.searchIcon.blendColor = m.theme.UnfocusColor
        ShowSearchIconUnFocusAnimate()
        SetFocus(m.rlHomeRowList)
        m.rectOverlay.visible = false
        m.menuTitleLabel.visible = false
        result=true
    end if
end sub

function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        print "HomePage : onKeyEvent : key = " key " press = " press
        If key = "OK"
            OKKeyEvent()
            result = true
        Else If key = "up"
            UPKeyEvent()
            result = true
        Else If key = "down"
            DownKeyEvent()
            result = true
        Else If key = "back"
            result = BackKeyEvent()
        End If
    end if
    return result
end function
