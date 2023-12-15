sub init()
    print "VideoPlayer : Init"
    SetLocals()
    SetControls()
    SetObservers()
end sub

sub SetLocals()
    m.scene = m.top.GetScene()
    m.theme = m.global.appTheme
    m.fonts = m.global.fonts
    m.videoURL = ""
end sub

sub SetControls()
    m.videoPlayer = m.top.findNode("videoPlayer")
end sub

sub SetObservers()
    m.top.observeField("focusedChild", "OnFocusedChild")
    m.videoPlayer.observeField("state", "OnVideoPlayerStatusChange")
    m.videoPlayer.observeField("position", "OnVideoPositionChanged")
    m.top.observeField("videoData", "OnGetVideoData")
    m.videoPlayer.notificationInterval = 1
end sub

sub OnGetVideoData()
    videoData = m.top.videoData
    if videoData <> invalid and videoData.content <> invalid
        for each item in videoData.content.items()
            for each videoItem in item.value
                if videoItem <> invalid
                    if videoItem.quality = "UHD"
                        m.videoURL = videoItem.url
                    else if videoItem.quality = "FHD"
                        m.videoURL = videoItem.url
                    else if videoItem.quality = "HD"
                        m.videoURL = videoItem.url
                    else if videoItem.quality = "SD"
                        m.videoURL = videoItem.url
                    end if
                end if
            end for
        end for
        PlayVideo(videoData)
    else
        ClosePlayer()
    end if
end sub

function PlayVideo(videoData as dynamic)
    print "videoData >>>>>>>>>>>: " videoData
    videoContent = createObject("RoSGNode", "ContentNode")
    videoContent.url = m.videoURL
    videoContent.title = videoData.title
    videoContent.streamformat = "auto"
    videocontent.live = false
    m.videoPlayer.seekMode = "accurate"
    m.videoPlayer.content = videoContent

    if videoData.vastURL <> invalid and videoData.vastURL <> ""
        If m.PlayerTask <> invalid
            m.PlayerTask.unObserveField("isAdplaying")
            m.PlayerTask = invalid
        End If
        m.PlayerTask = CreateObject("roSGNode", "PlayerTask")
        m.PlayerTask.videodata = videoData
        m.PlayerTask.video = m.videoPlayer
        m.PlayerTask.adsURl = videoData.vastURL
        m.PlayerTask.bookmark = m.videoPlayer.seek
        m.PlayerTask.currentPosition = 0
        m.PlayerTask.observeField("currentState", "OnVideoPlayerStatusChange")
        m.PlayerTask.observeField("currentPosition", "OnVideoPositionChanged")
        m.PlayerTask.observeField("stopped", "OnStatusStopped")
        m.PlayerTask.observeField("isAdplaying", "OnStatusIsAdplaying")
        m.PlayerTask.functionName = "PlayContentWithAds"
        m.PlayerTask.control = "RUN"
    else
        StartPlayer()
    end if
end function

sub StartPlayer()
    m.videoPlayer.enableTrickPlay = true
    m.videoPlayer.enableUI = true
    m.videoPlayer.control = "play"
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
end sub

sub OnVideoPlayerStatusChange(event as dynamic)
    videoStatus = event.GetData()
    print "videoStatus :: " videoStatus
    if videoStatus = "finished"
        ClosePlayer()
    else if videoStatus = "error"
        ClosePlayer()
    end if
end sub

sub OnStatusStopped()
    ClosePlayer()
end sub

Sub ClosePlayer()
    m.PlayerTask = invalid
    m.videoPlayer.content = invalid
    m.videoPlayer.visible = false
    m.top.isVideoPlayerStopped = true
end Sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "VideoPlayer : onKeyEvent : key = " key " press = " press
        if (key = "back")
            ClosePlayer()
            result = true
        end if
    end if
    return result
end function
