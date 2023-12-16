sub init()
    print "HomeRowList : init"
    SetLocals()
    SetControls()
    SetupFonts()
    SetupColor()
    SetObservers()
end sub

sub SetLocals()
    m.theme = m.global.appTheme
    m.fonts = m.global.fonts
    m.appConfig = m.global.appConfig
    if m.global.appResponse <> invalid
        m.appResponse = m.global.appResponse
    end if
    m.scene = m.top.GetScene()
    m.lastFocusedRowIndex = -1
    m.lastFocusedColumnIndex = -1
end sub

sub SetControls()
    m.rlHomeRowList = m.top.findNode("rlHomeRowList")
    m.pNoDataFound = m.top.findNode("pNoDataFound")
    m.focusedRowItem = m.top.findNode("focusedRowItem")
end sub

sub SetupFonts()
    m.rlHomeRowList.rowLabelFont = m.fonts.openSansBold40
end sub

sub SetupColor()
    if m.theme.secondary_text_color <> invalid and m.theme.secondary_text_color <> "" and m.theme.focus_indicator_color <> invalid and m.theme.focus_indicator_color <> ""
        m.rlHomeRowList.rowLabelColor = m.theme.secondary_text_color
        m.rlHomeRowList.focusBitmapBlendColor = m.theme.focus_indicator_color
    else
        m.rlHomeRowList.rowLabelColor = m.theme.White
        m.rlHomeRowList.focusBitmapBlendColor = m.theme.White
    end if
end sub

sub SetObservers()
    m.rlHomeRowList.observeField("rowItemSelected", "RlSItems_RowItemSelected")
    m.rlHomeRowList.observeField("rowItemFocused", "RlsItems_RowItemFocused")
end sub

function OnRowListDataReceived()
    CategoryVideosItemData = m.top.content
    m.mainContent = createObject("roSGNode", "ContentNode")
    for each CategoryVideosData in CategoryVideosItemData
        if CategoryVideosData.count() > 0 and CategoryVideosData.programs.count() > 0
            CategoryVideosItem = m.mainContent.CreateChild("ContentNode")
            CategoryVideosItem.id = CategoryVideosData.ID
            totalItem = CategoryVideosData.totalItem
            CategoryVideosItem.title = MakeFirstCharacterCapital(CategoryVideosData.name)
            if totalItem <> invalid then CategoryVideosItem.title += " ("+totalItem.ToStr()+")"
            if CategoryVideosData.programs <> invalid
                for each item in CategoryVideosData.programs
                    programItem = CreateObject("roSGNode", "HomeItemData")
                    programItem.id = item.id
                    programItem.title = item.title
                    programItem.shortDescription = item.shortDescription
                    programItem.thumbnail = item.thumbnail
                    programItem.tags = item.tags
                    programItem.genres = item.genres
                    programItem.rating = item.rating
                    programItem.content = item.content
                    if m.appResponse.vast_url <> invalid and m.appResponse.url <> ""
                        programItem.vastURL = m.appResponse.vast_url
                    end if 
                    programItem.typename = "HomeRowList"
                    CategoryVideosItem.appendChild(programItem)
                end for
            end if
        end if
    end for
    m.rlHomeRowList.content = m.mainContent
    m.rlHomeRowList.setFocus(true)
end function

sub RlsItems_RowItemFocused(event as object)
    focusedItem = event.GetData()
    childRow = m.rlHomeRowList.content.getChild(focusedItem[0])
    childNode = childRow.getChild(focusedItem[1])
    position = [m.lastFocusedRowIndex, m.lastFocusedColumnIndex, childRow.id]
    m.top.FocusPosition = position
    if (childNode <> invalid)
            m.top.focusedRowItem = {
            id : childNode.id
            title : childNode.title
            shortDescription : childNode.shortDescription
            thumbnail : childNode.thumbnail
            tags : childNode.tags
            vastURL : childNode.vastURL
            genres : childNode.genres
            rating : childNode.rating
            duration : childNode.duration   
            content : childNode.content
            typename : childNode.typename
        }
    end if
end sub

sub RlsItems_RowItemSelected(event as object)
    data = event.GetData()
    childRow = m.rlHomeRowList.content.getChild(data[0])
    childNode = childRow.getChild(data[1])
    IF (childNode <> invalid)
        m.top.selectedRowItem = {
            id : childNode.id
            title : childNode.title
            shortDescription : childNode.shortDescription
            thumbnail : childNode.thumbnail
            tags : childNode.tags
            vastURL : childNode.vastURL
            genres : childNode.genres
            rating : childNode.rating
            duration : childNode.duration   
            content : childNode.content
            typename : childNode.typename
        }
    end if
end sub
