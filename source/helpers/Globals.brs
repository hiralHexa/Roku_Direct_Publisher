sub setGlobalNode()
    appConfig = getAppConfigFromFile()
    deviceInfo = createObject("roDeviceInfo")
    globalFields = {
        appConfig     : appConfig
        appTheme      : getAppThemeFromFile()
        apiEndPoints  : getApiEndPoints(appConfig)
        deviceId      : deviceInfo.GetChannelClientId()
        appId         : appConfig.appID
        fonts         : CreateFontManager()
        designResolution : deviceInfo.GetDisplayMode()
    }
    m.global.addFields(globalFields)
end sub

' Reset all global fields except appConfig
function ResetGlobalFields()
    ' print "Globals : ResetGlobalFields : Removing all global fields " ' m.global
    globalFields = ["appConfig", "appTheme", "fonts"]
    m.global.removeFields(globalFields)
    ' print "Globals : ResetGlobalFields : m.global " ' m.global
end function

sub getAppConfigFromFile() as dynamic
    ' print "Globals : getAppConfigFromFile "
    config = ReadAsciiFile("pkg:/source/data/appConfig.json")
    configJson = ParseJson(config)
    if configJson <> invalid
        ' print "Globals : getAppConfigFromFile : App config file loaded : " ' config
    else
        ' print "*** Error : Globals : getAppConfigFromFile : Invalid configuration"
    end if

    return configJson
end sub

sub getApiEndPoints(appConfig as object) as dynamic
    print "Globals : getApiEndPoints : appConfig : " appConfig
    baseUrl = appConfig.baseUrl
    print "baseUrl >>>>>>>>>>>>>>>>>>>> " baseUrl
    apiEndPoints = {
        JSONBaseURL : baseUrl,
        GetSettingsData : "pkg:/source/data/response.json"
    }
    return apiEndPoints
end sub

sub getAppThemeFromFile() as dynamic
    ' print "Globals : getAppThemeFromFile "
    theme = ReadAsciiFile("pkg:/source/data/appTheme.json")
    themeJson = ParseJson(theme)
    if themeJson <> invalid
        ' print "Globals : getAppThemeFromFile : App Theme file loaded : " ' config
    else
        ' print "*** Error : Globals : getAppThemeFromFile : Invalid theme configuration!"
    end if

    return themeJson
end sub

sub GlobalSet(key as string, entity as dynamic)
    if (type(entity) = invalid)
        ' print "*** Utilities ERROR *** GlobalSet"
    else
        if (m.global.hasField(key))
            m.global.setField(key, entity)
        else
            obj = {}
            obj[key] = entity
            m.global.addFields(obj)
        end if
    end if
end sub

function GlobalGet(key as string, default=invalid as dynamic) as dynamic
    if (m.global.hasField(key))
        return m.global.getField(key)
    else
        return default
    end if
end function
