function getRequest(path as string, data as dynamic, headers as dynamic) as object
    req = createRoTransferInstance()
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)
    for each key in headers
        req.AddHeader(key, headers[key])
    end for
    compiledData = path
    delimeter = "?"
    for each key in data
        compiledData = compiledData + delimeter + key + "=" + req.Escape(data[key].ToStr())
        delimeter = "&"
    end for
    
    finalURL = compiledData.EncodeUri()
    req.SetUrl(finalURL)
    started = req.AsyncGetToString()
    if (started)
        event = wait(20000, port)
        if type(event) = "roUrlEvent"
            code = event.GetResponseCode()
            if (isSuccess(code))
                successResponse = success(event.GetString())
                return successResponse
            else
                if code < 0 then
                    req.asyncCancel()
                end if
                failureResponse = fail(code, event.GetFailureReason())
                return failureResponse
            end if
        end if
    end if
    return fail(-1, "Timeout happen")
end function

function postRequest(path as string, data as dynamic, headers as dynamic) as object
    req = createRoTransferInstance()
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)
    req.RetainBodyOnError(true)
    req.SetUrl(path)
    for each key in headers
        req.AddHeader(key, headers[key])
    end for
    started = req.AsyncPostFromString(FormatJson(data))
    if (started)
        event = wait(20000, port)
        if type(event) = "roUrlEvent"
            code = event.GetResponseCode()
            if (isSuccess(code))
                response = event.GetString()
                successResponse = success(response)
                return successResponse
            else
                if code < 0 then
                    req.asyncCancel()
                end if
                failureResponse = fail(code, event.GetString())
                return failureResponse
            end if
        end if
    end if
    return fail(-1, "Timeout happen")
end function

function deleteRequest(path as string, data as dynamic, headers as dynamic) as object
    req = createRoTransferInstance()
    req.setRequest("DELETE")
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)

    for each key in headers
        req.AddHeader(key, headers[key])
    end for

    compiledData = path
    delimeter = "?"

    for each key in data
        compiledData = compiledData + delimeter + key + "=" + req.Escape(data[key].ToStr())
        delimeter = "&"
    end for

    req.SetUrl(compiledData)
    started = req.AsyncGetToString()

    if (started)
        event = wait(20000, port)
        if type(event) = "roUrlEvent"
            code = event.GetResponseCode()
            if (isSuccess(code))
                successResponse = success(event.GetString())
                return successResponse
            else
                if code < 0 then
                    req.asyncCancel()
                end if
                failureResponse = fail(code, event.GetFailureReason())
                return failureResponse
            end if
        end if
    end if
    return fail(-1, "Timeout happen")
end function

function createRoTransferInstance() as dynamic
    req = CreateObject("roUrlTransfer")
    req.EnablePeerVerification(false)
    req.EnableHostVerification(false)
    return req
end function

function isSuccess(code as integer) as boolean
    return code >= 200 and code < 300
end function

function success(body as string) as object
    result = {}
    result.isSuccess = true
    result.response = body
    return result
end function

function fail(code as integer, reason as string) as object
    result = {}
    result.isSuccess = false
    result.code = code
    result.reason = reason
    return result
end function
