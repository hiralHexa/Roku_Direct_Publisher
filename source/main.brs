Function Main(args as Dynamic)
    screen = CreateObject("roSGScreen")
    port = CreateObject("roMessagePort")
    screen.setMessagePort(port)

    m.scene = screen.CreateScene("MainScene")
    m.scene.id = "MainScene"

    inputObject = CreateObject("roInput")
    inputObject.SetMessagePort(port)

    if args.contentId <> invalid and args.mediaType <> invalid
        print "Main : Deeplink Args : " args
        m.scene.deeplinkingContentId = LCase(args.contentId)
        m.scene.deeplinkingMediaType = LCase(args.mediaType)
        m.scene.deepLinkingLand = true
    else
        print "Main : No Launch Deeplinking..."
    end if

    screen.show()
    m.scene.observeField("outRequest", port)

    While(true)
        msg = Wait(0, port)
        msgType = type(msg)

        If msgType = "roSGScreenEvent"
            If msg.isScreenClosed()
                Exit While
            End If
        Else If msgType = "roSGNodeEvent"
            Print "Main : Message Type : " msgType
            Print "Main : Message Field : " msg.GetField()
            ' When The AppManager want to send command back to Main
            If(msg.GetField() = "outRequest")
                request = msg.GetData()
                Print "Main : Request : " request
                If(request <> invalid)
                    If(request.DoesExist("ExitApp") AND (request.ExitApp = true))
                        Print "Main : Closing Screen."
                        screen.close()
                    End If
                End If
            End If
        Else If msgType = "roInputEvent"
            Print "Main : Input Event"
            if (msg.isInput() = true)
                messageInfo = msg.GetInfo()
                print "Main : messageInfo : "  messageInfo
                if (messageInfo.contentId <> invalid and messageInfo.mediaType <> invalid)
                    print "Main : Input DeepLinking"
                    m.scene.callFunc("HandleInputEvent", messageInfo)
                end if
            end if
        End If
    End While
End Function
