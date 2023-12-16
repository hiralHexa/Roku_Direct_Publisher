sub init()
    print "ShortDetailView : Init"
    SetLocals()
    SetNodes()
    SetupColor()
    SetObservers()
end sub

sub SetLocals()
    m.theme = m.global.appTheme
    m.fonts = m.global.Fonts
    m.appConfig = m.global.appConfig
    if m.global.appResponse <> invalid
        m.appResponse = m.global.appResponse
    end if
    m.scene = m.top.getScene()
    m.Overlay = false
    m.alignment= "left"
    m.titleWidth = 880
    m.descriptionWidth = 880
    m.descriptionmaxLines = 4
end sub

sub SetNodes()
    m.gDetails = m.top.findNode("gDetails")
    m.pVideoBackGround = m.top.findNode("pVideoBackGround")
    m.pVideo = m.top.findNode("pVideo")
    m.showAnimation = m.top.FindNode("showAnimation")
    m.hideAnimation=m.top.findNode("hideAnimation")
    m.lgTitleDescription = m.top.findNode("lgTitleDescription")
    m.PosterOverlay = m.top.findNode("PosterOverlay")
    m.RectOverlay = m.top.findNode("RectOverlay")
end sub

sub SetupColor()
    print 
    if (m.theme.background_color <> invalid and m.theme.background_color <> "")
        m.pVideoBackGround.color = m.theme.background_color
    else
        m.pVideoBackGround.color = m.theme.ThemeColor
    end if 
    m.PosterOverlay.blendColor = m.theme.ThemeColor
end sub

sub SetObservers()
    m.top.observeField("focusedChild","OnFocusedChild")
end sub

sub OnFocusedChild()
    if (m.top.IsInFocusChain() and m.top.hasFocus())
        focusRestored = RestoreFocus()
        if focusRestored = false
        end if
    end if
end sub

sub ItemContent_Changed()
    itemcontent = m.top.itemContent
    if (itemcontent <> invalid)
        m.lgTitleDescription.removeChild(m.lTitle)
        m.lgTitleDescription.removeChild(m.lDescription)
        m.lgTitleDescription.removeChild(m.lGenres)
        m.lgTitleDescription.removeChild(m.lRating)
        
        textColor = m.theme.White
        if m.appConfig.isLightTheme = true
            textColor = m.theme.Black
        end if

        if (not IsNullOrEmpty(itemcontent.title))
            m.lTitle = createObject("roSGNode", "Label")
            m.lTitle.id = "lTitle"
            m.lTitle.width = m.titleWidth
            m.lTitle.wrap = true
            m.lTitle.maxLines = 2
            m.lTitle.lineSpacing = 0
            m.lTitle.horizAlign = m.alignment
            m.lTitle.font = m.fonts.openSansbold72
            if (m.theme.primary_text_color <> invalid and m.theme.primary_text_color <> "")
                m.lTitle.color = m.theme.primary_text_color
            else
                m.lTitle.color = m.theme.White
            end if 
            m.lTitle.text = itemcontent.title
            m.lgTitleDescription.appendChild(m.lTitle)
        end if

        if (not IsNullOrEmpty(itemcontent.shortDescription))
            m.lDescription = createObject("roSGNode", "Label")
            m.lDescription.id = "lDescription"
            m.lDescription.width = m.descriptionWidth
            m.lDescription.wrap = true
            m.lDescription.maxLines = m.descriptionmaxLines
            m.lDescription.horizAlign = m.alignment
            m.lDescription.lineSpacing = -2
            m.lDescription.font = m.fonts.openSansReg35
            if (m.theme.secondary_text_color <> invalid and m.theme.secondary_text_color <> "")
                m.lDescription.color = m.theme.secondary_text_color
            else
                m.lDescription.color = m.theme.White
            end if
            m.lDescription.text = itemcontent.shortDescription
            m.lgTitleDescription.appendChild(m.lDescription)
        end if

        if (not IsNullOrEmpty(itemcontent.genres))
            m.lGenres = createObject("roSGNode", "Label")
            m.lGenres.id = "lGenres"
            m.lGenres.width = m.titleWidth
            m.lGenres.wrap = true
            m.lGenres.maxLines = 1
            m.lGenres.lineSpacing = 0
            m.lGenres.horizAlign = m.alignment
            m.lGenres.font = m.fonts.openSansReg35
            if (m.theme.secondary_text_color <> invalid and m.theme.secondary_text_color <> "")
                m.lGenres.color = m.theme.secondary_text_color
            else
                m.lGenres.color = m.theme.White
            end if 
            m.lGenres.text = itemcontent.genres
            m.lgTitleDescription.appendChild(m.lGenres)
        end if

        if itemcontent.rating <> invalid and itemcontent.rating.count() > 0
            for each ratingTitle in itemcontent.rating.items()
                m.lRating = createObject("roSGNode", "Label")
                m.lRating.id = "lRating"
                m.lRating.width = m.titleWidth
                m.lRating.wrap = true
                m.lRating.maxLines = 1
                m.lRating.lineSpacing = 0
                m.lRating.horizAlign = m.alignment
                m.lRating.font = m.fonts.openSansReg35
                if (m.theme.secondary_text_color <> invalid and m.theme.secondary_text_color <> "")
                    m.lRating.color = m.theme.secondary_text_color
                else
                    m.lRating.color = m.theme.Whit
                end if
                m.lRating.text = ratingTitle.key + " : " + ratingTitle.value
            end for
            m.lgTitleDescription.appendChild(m.lRating)
        end if

        InitializeControlTexts()
        if itemcontent.typename = "HomeRowList"
            ISCategory()
        else
            IsNotCategory()
        end if
    end if
    if m.scene.detailTranslation <> invalid
        m.lgTitleDescription.translation = [65,m.scene.detailTranslation + 20]
    end if 
end sub

sub OnAnimation()
    m.pVideo.uri = ""
    OnHideAnimation()
    m.hideAnimation.observeField("state","OnShowHideAnimation")
    m.pVideo.observeField("loadStatus","OnPosterStatus")
end sub

sub ISCategory()
    m.slButtonTextwidth = 265
    m.slButtonTextHeight = 46
    m.lgTitleDescription.itemSpacings = [8.0]
    if (m.theme.background_image <> invalid and m.theme.background_image <> "")
        m.pVideo.uri =  m.theme.background_image
    end if 
end sub

sub IsDetailWithGrid()
    boundingRect = m.lgTitleDescription.boundingRect()
    m.titleWidth = 880
    m.descriptionWidth = 880
    m.lgTitleDescription.translation = [65,1080-(boundingRect.height + 100)]
    m.alignment="center"
end sub

sub IsNotCategory()
    if m.appConfig.isDetailWithGrid = true
        IsDetailWithGrid()
    else if m.appConfig.isDetailWithGrid = false
        OnAnimation()
    end if
    m.lgTitleDescription.itemSpacings = [5,2.0,2.0,2.0,2.0]
    m.descriptionmaxLines = 4
    if (not IsNullOrEmpty(m.top.itemContent.thumbnail))
        m.pVideo.uri = m.appResponse.background_image
    end if
end sub


sub OnHideAnimation()
    m.hideAnimation.control="start"
    m.lastIndexContentUri = m.pVideo.uri
    m.pVideo.uri = m.lastIndexContentUri
end sub

sub OnShowHideAnimation(event as dynamic)
    if (m.hideAnimation.state="stopped")
        if (not IsNullOrEmpty(m.top.itemContent.image_url))
            m.pVideo.uri = m.top.itemContent.image_url
        end if
    end if
end sub

sub OnPosterStatus(event as dynamic)
    Status = event.getData()
    if Status = "ready"
        m.showAnimation.control = "start"
    end if
end sub

sub InitializeControlTexts()
    SetupFonts()
    isOverlay()
end sub

sub isOverlay()
    m.pVideo.width="1920"
    m.pVideo.height="1080"
    m.pVideo.loadWidth="1920"
    m.pVideo.loadHeight="1080"
    m.pVideo.translation ="[0,0]"
    m.pVideo.loadDisplayMode="scaleToZoom"
    if m.Overlay = true
        if m.appConfig.isLightTheme = true
            m.PosterOverlay.uri = "pkg:/images/overlay/detail_overlay.png"
        else
            if m.top.itemcontent.typename = "HomeRowList"
                m.PosterOverlay.uri = "pkg:/images/overlay/detail_overlay.png"
                m.pVideo.loadDisplayMode="scaleToFit"
            else
                m.PosterOverlay.uri = "pkg:/images/focus/WhiteOverlay.png"
                m.pVideo.width="1100"
                m.pVideo.height="619"
                m.pVideo.loadWidth="1100"
                m.pVideo.loadHeight="619"
                m.pVideo.translation ="[820,0]"
            end if
        end if
        m.PosterOverlay.visible = true
    else
        m.RectOverlay.color = m.theme.Black
        m.RectOverlay.visible = true
    end if
end sub

sub SetupFonts()
end sub
