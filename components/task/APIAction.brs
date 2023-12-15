sub Init()
end sub

function GetSettingsData() as void
    response = SampleTV_API().GetSettingsData()
    m.top.result = response
end function

function GetCategories() as void
    response = SampleTV_API().GetCategories()
    m.top.result = response
end function
