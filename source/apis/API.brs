function SampleTV_API()
    gThis = GetGlobalAA()
    if gThis.SampleTV_API = invalid
        gThis.SampleTV_API = SampleTV_API_New()
    end if
    return gThis.SampleTV_API
end function

function SampleTV_API_New()
    this = {}
    this.GetSettingsData = SampleTV_API_GetSettingsData
    this.GetCategories = SampleTV_API_GetCategories
    return this
end function

function SampleTV_API_GetSettingsData()
    path = GlobalGet("apiEndPoints").GetSettingsData
    headers = {}
    data = {}
    ' response = getRequest(path, data, headers)
    ' if (response.isSuccess)
    '     return ok(ParseJSON(response.response))
    ' else
    '     return error(getErrorReason(response))
    ' end if
    response = ReadAsciiFile(GlobalGet("apiEndPoints").GetSettingsData)
    return ok(ParseJson(response))
    return response
end function

function SampleTV_API_GetCategories()
    path = GlobalGet("apiEndPoints").JSONBaseURL
    headers = {}
    data = {}
    response = getRequest(path, data, headers)
    if (response.isSuccess)
        return ok(ParseJSON(response.response))
    else
        return error(getErrorReason(response))
    end if
    ' response = ReadAsciiFile(GlobalGet("apiEndPoints").JSONBaseURL)
    ' return ok(ParseJson(response))
    return response
end function
