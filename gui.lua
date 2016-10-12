iconDir = APPDIR.."logo.png"

PaintFrame = createFrame(10, 10, 640, 480, "Графический редактор", "resize")
PaintFrame:Show()
centerElement(PaintFrame)
setAppIcon(PaintFrame, iconDir)
PaintFrame:SetMinSize(wx.wxSize(320, 240))

SidePanel = createPanel(0, 480-71, 640, 20, PaintFrame)
setColor(SidePanel, "444444", "444444")

createMenu(PaintFrame, {"Файл", "Помощь"})
idCler = addMenuItem("Файл", "Очистить")
--idPalt = addMenuItem("Файл", "Цвет")
idExit = addMenuItem("Файл", "Выход")
idAbts = addMenuItem("Помощь", "О программе")

