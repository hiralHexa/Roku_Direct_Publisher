function IsNullOrEmpty(s as dynamic) as boolean
    return s = invalid or s = ""
end function

function ok(data as dynamic) as object
    result = {}
    result.ok = true
    result.data = data

    return result
end function

function error(data as string) as object
    result = {}
    result.ok = false
    result.error = data

    return result
end function

function getErrorReason(response as dynamic) as string
    unknown = "Unknown error. Please check your input, internet connection and try again"
    ' print "HelpFuncs : getErrorReason : ResponseError : " response
    if (response.reason.Len() = 0 )
        return unknown
    else
        if (response.code = 422 or response.code = 403 or response.code = 404)
            data = ParseJSON(response.reason)
						if data = invalid 'If, this is not json
								return response.reason
						end if

						msg = ""
						if data.message <> invalid
								msg = data.message
						else if data.detail <> invalid
								msg = data.detail
						end if

            return msg
        else
            return response.reason
        end if
    end if
end function

Function FormatTimeStringInHHMMSS(timeInSecond as integer) as String
    if (timeInSecond <> invalid)
				timeInSecond = timeInSecond
        timeInSecond = timeInSecond MOD (24 * 3600)
        hours = timeInSecond \ 3600
        timeInSecond = timeInSecond MOD 3600
        minutes = timeInSecond \ 60
        timeInSecond = timeInSecond MOD 60
        seconds = timeInSecond

        hrStr = hours
        minutesStr = minutes
        secondsStr = seconds
        durationString = ""
        if(hrStr > 0)
            if(hrStr < 10)
                durationString = "0" + hrStr.toStr() + "h "
            else
                durationString = hrStr.toStr() + "h "
            end if
        end if
        if(minutesStr > 0)
            if(minutesStr < 10)
                durationString += "0" + minutesStr.toStr() + "m "
            else
                durationString += minutesStr.toStr() + "m "
            end if
        end if
        if(secondsStr > 0)
            if(secondsStr < 10)
                durationString += "0" + secondsStr.toStr() + "s "
            else
                durationString += secondsStr.toStr() + "s"
            end if

        end if
        return durationString
    else
        return ""
    end if
End Function

Function FormatTime(timeInSecond as integer,fullTimeFormat = false as boolean) as String
    if (timeInSecond <> invalid)
				timeInSecond = timeInSecond
        timeInSecond = timeInSecond MOD (24 * 3600)
        hours = timeInSecond \ 3600
        timeInSecond = timeInSecond MOD 3600
        minutes = timeInSecond \ 60
        timeInSecond = timeInSecond MOD 60
        seconds = timeInSecond

        hrStr = hours.toStr()
        minutesStr = minutes.toStr()
        secondsStr = seconds.toStr()

        if (hours < 10)
          hrStr = "0" + hrStr
        end if
        if (minutes < 10)
          minutesStr = "0" + minutesStr
        end if
        if (seconds < 10)
          secondsStr = "0" + secondsStr
        end if
        if(fullTimeFormat = false)
            if(hrStr = "00" and minutesStr = "00")
                return minutesStr + ":" + secondsStr
            else
                return hrStr + ":" + minutesStr
            end if
        else
            return hrStr + ":" + minutesStr + ":" + secondsStr
        end if
    else
        return ""
    end if
End Function

Function GetBookmarkData(id as String) As Integer
    sec = CreateObject("roRegistrySection", "Bookmarks")
    if sec.Exists("Bookmark_" + id)
        return sec.Read("Bookmark_" + id).ToInt()
    end if
    return 0
End Function

Function SetBookmarkData(id as String, position as String) As Integer
    sec = CreateObject("roRegistrySection", "Bookmarks")
    sec.Write("Bookmark_" + id, position)
    sec.Flush()
End Function

Function GetEncryptedUrlString(inputString as String) as String
    ba1 = CreateObject("roByteArray")
    ba1.FromAsciiString(inputString)
    digest = CreateObject("roEVPDigest")
    digest.Setup("sha256")
    digest.Update(ba1)
    hash = digest.Final()
    return hash
End Function

Function GetButtonBorderData(borderWidth as integer, borderHeight as integer, borderSize as integer, borderColor as string, blendColor as string)
  borderData = {
      "height" : borderHeight,
      "width" : borderWidth,
      "size" : borderSize,
      "color" : borderColor
      "blendColor" : blendColor
  }
  return borderData
end function

Function GetCarouselSize(width as Integer, height as Integer)
    carouselSize = {
        "height"  : height,
        "width"   : width
    }
    return carouselSize
End Function

Function MakeFirstCharacterCapital(textString as dynamic, allCapital = false as boolean) as String
    if (textString = invalid)
        textString = ""
    end if
    if textString <> invalid and textString <> ""
        sentence = textString.split("")
        newString = ""
        isNextCapital = false
        for i=0 to sentence.count() -1 step 1
            if i = 0 or isNextCapital
                newString += UCase(sentence[i])
                isNextCapital = false
            else
                newString += sentence[i]
            end if
            if allCapital and sentence[i]  = " "
                isNextCapital = true
            end if
        end for
        ' print "HelpFuncs : MakeFirstCharacterCapital : newString : " newString
        return newString
    else
        return textString
    end if
End Function
