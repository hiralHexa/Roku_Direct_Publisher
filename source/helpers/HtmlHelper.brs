sub ParseString(inputString as string) as string
    parsedHTMLString = ParseHTML(inputString)
    parsedString = parsedHTMLString.replace("\n", chr(10))
    return parsedString
end sub

sub ParseHTML(descriptionHTML as string) as string
    descriptionHTML = descriptionHTML.replace("<i>", "").replace("</i>", "").replace("<em>", "").replace("</em>", "").replace("<li>", "").replace("</li>", chr(10)).replace("<br/>", chr(10)).replace("<br>", chr(10)).replace("</br>", "").replace("<strong>", "").replace("</strong>", "").replace("<span>", "").replace("</span>", "").replace("&nbsp;", " ").replace("&hellip;", "…").replace("&mdash;", "—").replace("&ndash;", "–")
    descriptionHTML = descriptionHTML.replace("&quot;", """").replace("&apos;", "'").replace("&lt;", "<").replace("&gt;", ">")
    xmlstring = "<XMLDetails>" + descriptionHTML + "</XMLDetails>"
    metadataxml = createObject("roXMLElement")
    metadataxml.parse(xmlstring)

    finalText = ""
    for each para in metadataxml.GetChildElements()
      if (para.getName() = "p")
          partText =  para.GetText()
          if (partText <> "")
              finalText = finalText + partText + chr(10)
          end if
      end if
    end for

    if (finalText <> "" and finalText <> " " and finalText <> invalid)
        descriptionHTML = finalText
    else
        descriptionHTML = descriptionHTML.replace("<p>", "").replace("</p>", chr(10))
    end if

    descriptionHTML = StringRemoveHTMLTags(descriptionHTML)
    return descriptionHTML
end sub

function StringRemoveHTMLTags(baseStr as String) as String
    r = createObject("roRegex", "<[^<]+?>", "i")
    return r.replaceAll(baseStr, "")
end function
