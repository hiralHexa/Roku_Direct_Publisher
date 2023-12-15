sub init()
    print "MainScene : Init "
    setGlobalNode()
    SetLocals()
    SetControls()
    CreateBusySpinnerControls()
    SetObservers()
    SetupColor()
    CreateDeepLinkingControls()
    CreateToastMessageControls()
    Initialize()
end sub

sub SetLocals()
    m.exitCalled = false
    m.exitPopUpOpened = false
    m.subscribePopUpOpened = false
    m.theme = m.global.appTheme
    m.fonts = m.global.Fonts
    m.appConfig = m.global.appConfig
    m.appLaunchCompleteBeaconSent = false
    m.appDialogInitiateBeaconSent = false
    m.appDialogCompleteBeaconSent = false
    m.ViewStackManager = CreateViewStackManager()
end sub

sub SetControls()
    m.gPageContainer = m.top.findNode("gPageContainer")
    m.rBackground = m.top.FindNode("rBackground")
    m.pBackgound = m.top.FindNode("pBackgound")
    m.gPreLoader = m.top.findNode("gPreLoader")
    m.rectPreLoader = m.top.FindNode("RectPreLoader")
    m.bsPreloader = m.top.findNode("bsPreloader")
    m.lPreloader = m.top.findNode("lPreloader")
    m.pSplash = m.top.findNode("pSplash")
    m.logo = m.top.FindNode("Logo")
end sub

sub SetupColor()
    m.rectPreLoader.color = m.theme.Black
end sub

sub SetObservers()
    m.top.observeField("BacktoHomePage","OnBacktoHomePage")
end sub

' Beacon Events'
Sub sendAppLaunchCompleteBeacon()
    If (m.appLaunchCompleteBeaconSent = false)
        print "MainScene : Sending AppLaunchComplete..."
        m.top.signalBeacon("AppLaunchComplete")
        m.appLaunchCompleteBeaconSent = true
    End If
End Sub

Sub sendAppDialogInitiateBeacon()
    If (m.appDialogInitiateBeaconSent = false and m.appLaunchCompleteBeaconSent = false)
        print "MainScene : Sending AppDialogInitiate..."
        m.top.signalBeacon("AppDialogInitiate")
        m.appDialogInitiateBeaconSent = true
    End If
End Sub

Sub sendAppDialogCompleteBeacon()
    If (m.appDialogCompleteBeaconSent = false and m.appDialogInitiateBeaconSent = true)
        print "MainScene : Sending AppDialogComplete..."
        m.top.signalBeacon("AppDialogComplete")
        m.appDialogCompleteBeaconSent = true
    End If
End Sub

sub DeletePages()
    print "MainScene : DeletePages : "
    if m.VideoPlayerControl <> invalid
        m.videoPlayerControl.callFunc("ClosePlayer")
        m.videoPlayerControl.visible = false
        m.top.removeChild(m.videoPlayerControl)
    end if
    if (m.HomePage <> invalid)
        m.gPageContainer.removeChild(m.HomePage)
        m.HomePage = invalid
    end if
end sub

sub Initialize()
    sendAppDialogCompleteBeacon()
    StartApp()
end sub

sub StartApp()
    ShowHideLoader(true)
    CallGetSettingsDataAPI()
end sub

sub CallGetSettingsDataAPI()
    m.CategoriesProgramToAdd = CreateObject("roArray",0,true)
    m.CategoriessDataTask = CreateObject("roSGNode", "APIAction")
    m.CategoriessDataTask.functionName = "GetSettingsData"
    m.CategoriessDataTask.ObserveField("result", "OnGetSettingsDataResponse")
    m.CategoriessDataTask.control = "RUN"
end sub

sub OnGetSettingsDataResponse(event as dynamic)
    response = event.getData()
    if (response.ok AND response.data <> Invalid and response.data.settings <> invalid)
        appResponse = response.data.settings
        if appResponse.unique_app_key <> invalid and appResponse.is_paid_subscriber = 1
            GlobalSet("appResponse",appResponse)
            SetUpAppConfigs(appResponse)
            showHomePage(true)
            ShowHideLoader(false)
        end if
    else
        showErrorPage(true)
        ShowHideLoader(false)
    end if 
end sub

sub SetUpAppConfigs(appResponse as dynamic)
    m.rBackground.color = appResponse.background_color
    m.pBackgound.uri = appResponse.background_image

    m.theme.ThemeColor = appResponse.background_color
    m.theme.focused_button_background_color = appResponse.focused_button_background_color
    m.theme.unfocused_button_background_color = appResponse.unfocused_button_background_color
    m.theme.focused_button_text_color = appResponse.focused_button_text_color
    m.theme.unfocused_button_text_color = appResponse.unfocused_button_text_color
    m.theme.primary_text_color = appResponse.primary_text_color
    m.theme.secondary_text_color = appResponse.secondary_text_color
    m.theme.focus_indicator_color = appResponse.focus_indicator_color
    m.theme.loading_indicator_color = appResponse.loading_indicator_color
    m.theme.progressbar_color = appResponse.progressbar_color

    m.global.setField("appTheme", m.theme)
end sub

' Start Deep Linking
sub CreateDeepLinkingControls()
    m.top.deepLinkingContentId = ""
    m.top.deepLinkingMediaType = ""
end sub

sub CreateToastMessageControls()
    m.ToastMsgBox = m.top.findNode("ToastMsgBox")
    m.ToastMsgText = m.top.findNode("ToastMsgText")
    m.toastMessageTimer = m.top.FindNode("toastMessageTimer")
    m.toastMessageTimer.observeField("fire", "toastMessageTimerExpired")
end sub

sub HandleInputEvent(deeplinkData)
    ' print "MainScene : HandleDeepLinkingInputEvent : DeepLinking Data : " deeplinkData
    contentID = deeplinkData.contentid
    mediaType = deeplinkData.mediaType

    m.top.deepLinkingContentId = ""
    m.top.deepLinkingMediaType = ""

    isValidDeepLink = false
    if IsNullOrEmpty(contentID)
        msg = "Required contentId not provided."
    else if IsNullOrEmpty(mediaType)
        msg = "Required mediaType not provided."
    else if (Lcase(mediaType) <> "movie")
        msg = "Provided mediaType is not supported."
    else
        msg = "Fetching details for provided id..."
        isValidDeepLink = true
    end if

    if not isValidDeepLink
        m.top.DeeplinkMsg = msg
    end if
    DeletePages()
    Initialize()
    m.top.deepLinkingContentId = contentID
    m.top.deepLinkingMediaType = mediaType
    m.top.deepLinkingLand = true
end sub

sub onDeepLinkingLand()
    ' print "MainScene : OnDeepLinkingLand"
    m.top.deepLinkingLand = false
    contentID = lcase(m.top.deepLinkingContentId)
    mediaType = m.top.deepLinkingMediaType
    isValidDeepLink = false
    if (contentID <> invalid and mediaType <> invalid)
        if(Lcase(mediaType) = "movie")
            m.top.DeeplinkMsg = "Fetching details for provided id..."
            isValidDeepLink = true
        else
            m.top.DeeplinkMsg = "Provided mediaType is not supported."
        end if
    else
        if (contentID <> invalid or mediaType <> invalid)
            m.top.DeeplinkMsg = "Wrong arguments provided for deeplinking."
        end if
    end if

    if (not IsNullOrEmpty(m.top.DeeplinkMsg))
        ShowDeeplinkDialog(m.top.DeeplinkMsg)
        m.toastMessageTimer.control = "start"
    end if

    if (not isValidDeepLink)
        m.top.deepLinkingContentId = ""
        m.top.deepLinkingMediaType = ""
    end if
end sub

sub ShowDeeplinkDialog(message as string)
    sendAppDialogInitiateBeacon()
    m.top.dialog = invalid
    dialog = createObject("roSGNode", "ProgressDialog")
    dialog.title = "Deeplinking..."
    dialog.message = message
    dialog.optionsDialog = false
    m.top.dialog = dialog
    m.top.dialog = dialog
end sub

sub ShowErrorDialog(message as string, title = "Error Message" as string, isRefresh = false as boolean)
    m.top.dialog = invalid
    dialog = createObject("roSGNode", "Dialog")
    dialog.title = title
    dialog.optionsDialog = true
    dialog.message = message
    m.top.dialog = dialog
    if (isRefresh)
        m.closeDialogTimer.control = "start"
    end if
end sub

sub CloseDeeplinkDialog()
    if m.videoPlayerControl <> invalid
        m.videoPlayerControl.setFocus(true)
    end if
    if (m.top.dialog <> invalid)
        ' print "MainScene : CloseDeeplinkDialog : dialog closed"
        m.top.dialog.close = true
        m.top.dialog = invalid
    end if
    m.top.isDeeplinking = false
    sendAppDialogCompleteBeacon()
    sendAppLaunchCompleteBeacon()
end sub

sub ChangeDeeplinkDialogMessage()
    if (m.top.dialog <> invalid)
        m.top.dialog.message = m.top.DeeplinkMsg
    end if
end sub

sub toastMessageTimerExpired()
    ' print "MainScene : toastMessageTimerExpired"
    if (m.top.deepLinkingContentId = "")
        m.toastMessageTimer.control = "stop"
        m.ToastMsgBox.visible = false
        m.top.DeeplinkMsg = ""
        CloseDeeplinkDialog()
    end if
end sub

sub splashTimerExpired()
    m.pSplash.visible = false
end sub
' End Deep Linking

sub CreateBusySpinnerControls()
    m.lPreloader.text = "Please wait..."
    m.bsPreloader.poster.uri = "pkg:/images/loader/loader.png"
    m.bsPreloader.poster.width = "160"
    m.bsPreloader.poster.height = "160"
    m.lPreloader.color = m.theme.White
    m.lPreloader.font = m.fonts.openSansbold30
end sub

sub ShowHideLoader(isShow as boolean, message = "Please wait..." as string, setFocus1 = true as boolean)
    m.gPreLoader.visible = isShow
    if setFocus1
        m.gPreLoader.setFocus(isShow)
        if (isShow = false)
            RestoreFocus()
        end if
    end if
    m.lPreloader.text = message
    m.bsPreloader.translation = "[880, 400]"
    m.lPreloader.translation = "[0, 600]"
end sub

sub showHomePage(appResponse as dynamic, isReplace = false as boolean)
    ShowHideLoader(false)
    m.HomePage = GetHomePageObject(isReplace)
    if (isReplace = true)
        m.ViewStackManager.ReplaceScreen(m.HomePage)
    else
        m.ViewStackManager.ShowScreen(m.HomePage)
    end if
    setFocus(m.HomePage)
    if (not IsNullOrEmpty(m.top.deeplinkingContentId) and m.top.deeplinkingData <> invalid and not IsNullOrEmpty(m.top.deeplinkingMediaType))
        m.HomePage.isDeeplinkingContentFound = true
    end if
end sub

function GetHomePageObject(isReplace as boolean) as object
    if isReplace
        m.gPageContainer.removeChild(m.HomePage)
        m.HomePage = invalid
    end if
    if m.HomePage = invalid
        m.HomePage = createObject("roSGNode", "HomePage")
        m.HomePage.visible = false
        m.HomePage.id = "HomePage"
    end if
    m.gPageContainer.appendChild(m.HomePage)
    return m.HomePage
end function

sub showErrorPage(isReplace = false as boolean)
    ShowHideLoader(false)
    m.ErrorPage = GetErrorPageObject(isReplace)
    if (isReplace = true)
        m.ViewStackManager.ReplaceScreen(m.ErrorPage)
    else
        m.ViewStackManager.ShowScreen(m.ErrorPage)
    end if
    setFocus(m.ErrorPage)
end sub

function GetErrorPageObject(isReplace as boolean) as object
    if isReplace
        m.gPageContainer.removeChild(m.ErrorPage)
        m.ErrorPage = invalid
    end if
    if m.ErrorPage = invalid
        m.ErrorPage = createObject("roSGNode", "ErrorPage")
        m.ErrorPage.visible = false
        m.ErrorPage.id = "ErrorPage"
    end if
    m.gPageContainer.appendChild(m.ErrorPage)
    return m.ErrorPage
end function

sub ShowSearchPage(isReplace = false as boolean)
    m.SearchPage = GetSearchPageObject(true)
    if (isReplace = true)
        m.ViewStackManager.ReplaceScreen(m.SearchPage)
    else
        m.ViewStackManager.ShowScreen(m.SearchPage)
    end if
    setFocus(m.SearchPage)
end sub

function GetSearchPageObject(isReplace as boolean) as object
    if isReplace
        m.gPageContainer.removeChild(m.SearchPage)
        m.SearchPage = invalid
    end if
    if m.SearchPage = invalid
        m.SearchPage = createObject("roSGNode", "SearchPage")
        m.SearchPage.visible = false
        m.SearchPage.id = "SearchPage"
    end if
    m.gPageContainer.appendChild(m.SearchPage)
    return m.SearchPage
end function

sub StartVideo(videoData as dynamic)
    print "Main : StartVideo : videoID : " videoData
    if (videoData <> invalid)
        m.videoPlayerControl = GetVideoPlayer(videoData)
        m.top.appendChild(m.videoPlayerControl)
        SetFocus(m.videoPlayerControl)
        m.videoPlayerControl.visible = true
    end if
end sub

sub GetVideoPlayer(videoData as dynamic) as object
    m.videoPlayerControl = invalid
    if (m.videoPlayerControl = invalid)
        m.videoPlayerControl = createObject("roSGNode", "VideoPlayer")
        m.videoPlayerControl.videoData = videoData
        m.videoPlayerControl.observeField("isVideoPlayerStopped", "StopVideoPlayback")
    end if
    return m.videoPlayerControl
end sub

sub StopVideoPlayback()
    if (m.videoPlayerControl <> invalid)
        m.videoPlayerControl.visible = false
        m.top.removeChild(m.videoPlayerControl)
        m.ViewStackManager.FocusTop()
    end if
end sub

sub ShowHideExitConfirmation()
    if (m.exitPopUpOpened = false)
        dialogData = {
            titleText: "Exit Application"
            messageText: "Are you sure you want to exit application?"
            videoPoster: "pkg:/images/assets/poster_fhd.png"
            positiveBtnText: "Yes"
            negativeBtnText: "No"
            restartFlag: false
        }
        m.vExitCustomDialog = CreateObject("roSGNode", "ExitOrResumeDialog")
        m.vExitCustomDialog.id = "ExitOrResumeDialog"
        m.vExitCustomDialog.dialogData = dialogData
        m.vExitCustomDialog.isExitBox = true
        m.vExitCustomDialog.observeField("selectedButton", "exitConfirmButtonGroup_ButtonSelected")
        m.top.appendChild(m.vExitCustomDialog)
        m.vExitCustomDialog.setFocus(true)
        m.exitPopUpOpened = true
    else
        if (m.vExitCustomDialog <> invalid)
            m.top.removeChild(m.vExitCustomDialog)
        end if
        m.ViewStackManager.FocusTop()
        m.exitPopUpOpened = false
    end if
end sub

sub exitConfirmButtonGroup_ButtonSelected(event as dynamic)
    data = event.GetData()
    if (data = "1" or data = "back")
        ShowHideExitConfirmation()
    else if (data = "0")
        m.exitCalled = true
        m.top.outRequest = { "ExitApp": true }
    end if
end sub

sub OnBacktoHomePage()
    if (m.ViewStackManager.GetViewCount() > 1 and m.top.BacktoHomePage)
        m.top.BacktoHomePage = false
        m.ViewStackManager.HideTop()
        if m.SearchPage <> invalid
            m.SearchPage = invalid
            m.HomePage.setFocus(true)
        else if m.DetailPageWithMarkupGrid <> invalid
            m.DetailPageWithMarkupGrid = invalid
            m.HomePage.setFocus(true)
        end if
    end if
end sub

function BackKeyEvent()
    result = false
    print "MainScene : onKeyEvent : View Stack Count : " m.ViewStackManager.GetViewCount()
    if m.videoDetailTask <> invalid then
        m.videoDetailTask.control = "stop"
        m.videoDetailTask = invalid
    end if

    if (m.videoPlayerControl <> invalid and m.videoPlayerControl.visible = true)
        print "MainScene : onKeyEvent : StopVideoPlayback"
        StopVideoPlayback()
        result = true
    else
        if (m.ViewStackManager.GetViewCount() > 1)
            m.ViewStackManager.HideTop()
            result = true
        else if m.exitCalled = false
            if (m.ViewStackManager.GetViewCount() = 1 or m.ViewStackManager.GetViewCount() = 0)
                if (m.exitPopUpOpened = false or m.exitCalled = false)
                    ShowHideExitConfirmation()
                    result = true
                end if
            end if
        end if
    end if
    return result
end function

function OnkeyEvent(key as string, press as boolean) as boolean
    print "MainScene : onKeyEvent : key = " key " press = " press "++++++++++++++++++++"
    result = false
    if press
        print "MainScene : onKeyEvent : key = " key " press = " press
        if key = "back"
            print "Main Scene : Back Key Event"
            result = BackKeyEvent()
        end if
    end if
    return result
end function
