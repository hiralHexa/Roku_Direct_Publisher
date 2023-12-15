'*********************************************************************
'** (c) 2016-2017 Roku, Inc.  All content herein is protected by U.S.
'** copyright and other applicable intellectual property laws and may
'** not be copied without the express permission of Roku, Inc., which
'** reserves all rights.  Reuse of any of this content for any purpose
'** without the permission of Roku, Inc. is strictly prohibited.
'*********************************************************************

Library "Roku_Ads.brs"

sub init()
    m.top.functionName = "PlayContentWithAds"
    m.top.id = "PlayerTask"
    m.appConfig = m.global.appConfig
    m.scene = m.top.GetScene()
end sub


sub playContentWithAds()
    video = m.top.video
    content = video.content
    m.videodata = m.top.videodata

    print "Final : m.top.adsURl > " m.top.adsURl
    adsURl = m.top.adsURl
    view = video.getParent()
    RAF = Roku_Ads()
    RAF.enableNielsenDAR(true)
    RAF.setNielsenAppId("P2871BBFF-1A28-44AA-AF68-C7DE4B148C32")
    RAF.setNielsenGenre("GV")

    If CreateObject("roDeviceInfo").IsRIDADisabled()
        clientId = CreateObject("roDeviceInfo").GetRandomUUID()
    Else
        clientId = CreateObject("roDeviceInfo").GetChannelClientId()
    End If
    RAF.setAdUrl(adsURl)
    RAF.enableAdMeasurements(true)
    RAF.setContentGenre("") 'if unset, ContentNode has it as []
    RAF.setContentLength(1800)
    RAF.setNielsenProgramId(m.videodata.title)
    RAF.setContentId(m.videodata.id)

    m.lastPos = 0
    keepPlaying = true

    adPods = RAF.getAds() 'array of ad pods
    ' show the pre-roll ads, If any
    If adPods <> invalid and adPods.count() > 0
        video.control = "stop"
        m.top.isAdplaying = true
        keepPlaying = RAF.showAds(adPods, invalid, view)
    End If

    port = CreateObject("roMessagePort")
    If keepPlaying
        video.unobserveField("position")
        video.unobserveField("state")
        video.observeField("position", port)
        video.observeField("state", port)
        ' If m.top.bookmark > 0 then video.seek = m.top.bookmark
        video.visible = true
        video.control = "play"
        m.top.isAdplaying = false
        video.setFocus(true) 'so we can handle a Back key interruption
    End If

    curPos = 0
    isPaused = false
    adPods = invalid
    isPlayingPostroll = false
    while keepPlaying
        msg = wait(0, port)
        if type(msg) = "roSGNodeEvent"
            print "msg.GetField() ===> " msg.GetField()
            if msg.GetField() = "position" then
                ' keep track of where we reached in content
                curPos = msg.GetData()
                m.top.currentPosition = curPos
                ' check for mid-roll ads
                adPods = RAF.getAds(msg)
                if adPods <> invalid and adPods.count() > 0
                    print "PlayerTask: mid-roll ads, stopping video"
                    'ask the video to stop - the rest is handled in the state=stopped event below
                    video.control = "stop"
                end if
            else if msg.GetField() = "state" then
                curState = msg.GetData()
                m.top.currentState = curState
                print "PlayerTask: state = "; curState
                if curState = "stopped" then
                    if adPods = invalid or adPods.count() = 0 then
                        exit while
                    end if

                    print "PlayerTask: playing midroll/postroll ads"
                    keepPlaying = RAF.showAds(adPods, invalid, view)
                    adPods = invalid
                    if isPlayingPostroll then
                        exit while
                    end if
                    if keepPlaying then
                        print "PlayerTask: mid-roll finished, seek to "; stri(curPos)
                        video.visible = true
                        video.seek = curPos
                        video.control = "play"
                        video.setFocus(true) 'important: take the focus back (RAF took it above)
                    end if

                else if curState = "finished" then
                    m.top.isAdPlaying = false
                    print "PlayerTask: main content finished"
                    ' render post-roll ads
                    adPods = RAF.getAds(msg)
                    if adPods = invalid or adPods.count() = 0 then
                        exit while
                    end if
                    print "PlayerTask: has postroll ads"
                    isPlayingPostroll = true
                    ' stop the video, the post-roll would show when the state changes to  "stopped" (above)
                    video.control = "stop"
                end if
            end if
        end if
    end while

    video.visible = false
    m.top.currentPosition = -1
    m.top.stopped = true
    print "PlayerTask: exiting playContentWithAds()"
end sub
