iconDir 		= APPDIR.."logo.png"

PaintFrame 		= createFrame(10, 10, 640, 480, "Графический редактор", "resize")
PaintFrame:Show()
centerElement(PaintFrame)
setAppIcon(PaintFrame, iconDir)
PaintFrame:SetMinSize(wx.wxSize(320, 240))

ToolPanel 		= createPanel(0, 480-71, 640, 20, PaintFrame)
setColor(ToolPanel, "444444", "444444")

createMenu(PaintFrame, {"Файл", "Помощь"})
idCler 			= addMenuItem("Файл", "Очистить")
idUndo			= addMenuItem("Файл", "Отменить")
idExit 			= addMenuItem("Файл", "Выход")
idAbts			= addMenuItem("Помощь", "О программе")


LabelFSize 		= createLabel(640-155, 1, 151, 19, "Размер окна:", _, ToolPanel)
setColor(LabelFSize, "FFFFFF", "FFFFFF")

PaletteButton 	= createButton(1, 1, 60, 19, "Цвета", _, ToolPanel)
setColor(PaletteButton, "444444", "FFFFFF")

MouseButton 	= createButton(63, 1, 60, 19, "Мышь", _, ToolPanel)
setColor(MouseButton, "444444", "FFFFFF")

ColorFrame 		= createFrame(10, 10, 160, 120, "Цвета", "nores")
centerElement(ColorFrame)
setColor(ColorFrame, "444444", "444444")