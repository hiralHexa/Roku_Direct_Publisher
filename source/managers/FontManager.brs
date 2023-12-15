function CreateFontManager() as Object

    openSansBold = "pkg:/Fonts/OpenSans-Bold.ttf"
    openSansReg = "pkg:/Fonts/OpenSans-Regular.ttf"

    this = {}

    ' *** Open Sans Bold Fonts ***
    this.openSansbold72 = CreateFonts(openSansBold, 72)
    this.openSansbold56 = CreateFonts(openSansBold, 56)
    this.openSansbold50 = CreateFonts(openSansBold, 50)
    this.openSansbold45 = CreateFonts(openSansBold, 45)
    this.openSansbold54 = CreateFonts(openSansBold, 54)
    this.openSansbold46 = CreateFonts(openSansBold, 46)
    this.openSansbold44 = CreateFonts(openSansBold, 44)
    this.openSansBold36 = CreateFonts(openSansBold, 36)
    this.openSansBold32 = CreateFonts(openSansBold, 32)
    this.openSansBold40 = CreateFonts(openSansBold, 40)
    this.openSansBold30 = CreateFonts(openSansBold, 30)
    this.openSansbold24 = CreateFonts(openSansBold, 24)
    this.openSansBold28 = CreateFonts(openSansBold, 28)
    this.openSansBold26 = CreateFonts(openSansBold, 26)
    this.openSansBold24 = CreateFonts(openSansBold, 24)
    this.openSansBold25 = CreateFonts(openSansBold, 25)
    this.openSansBold23 = CreateFonts(openSansBold, 23)

    ' *** Open Sans Regular Fonts ***
    this.openSansReg60 = CreateFonts(openSansReg, 60)
    this.openSansReg48 = CreateFonts(openSansReg, 48)
    this.openSansReg40 = CreateFonts(openSansReg, 40)
    this.openSansReg36 = CreateFonts(openSansReg, 36)
    this.openSansReg35 = CreateFonts(openSansReg, 35)
    this.openSansReg32 = CreateFonts(openSansReg, 32)
    this.openSansReg30 = CreateFonts(openSansReg, 30)
    this.openSansReg28 = CreateFonts(openSansReg, 28)
    this.openSansReg25 = CreateFonts(openSansReg, 25)
    this.openSansReg24 = CreateFonts(openSansReg, 24)
    this.openSansReg22 = CreateFonts(openSansReg, 22)

    node = CreateObject("roSGNode", "node")
    node.addfields(this)
    return node
end function

function CreateFonts(uri as string, size as integer) as dynamic
    font = CreateObject("roSGNode", "Font")
    font.uri = uri
    font.size = size
    return font
end function
