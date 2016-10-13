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

ColorFrame 		= createFrame(10, 10, 245, 165, "Цвета", "nores")
centerElement(ColorFrame)
setColor(ColorFrame, "444444", "444444")

SpinRed 		= createSpin(5, 0, 50, 30, "0", ColorFrame, 0, 255)
SpinGreen 		= createSpin(5, 35, 50, 30, "0", ColorFrame, 0, 255)
SpinBlue 		= createSpin(5, 70, 50, 30, "0", ColorFrame, 0, 255)
SpinBrush 		= createSpin(5, 105, 50, 30, "1", ColorFrame, 1, 128)

HexEdit 		= createEdit(160, 35, 80, 30, "000000", "default", ColorFrame)
HexInfo 		= createLabel(160, 5, 80, 30, "HEX Кодом:", _, ColorFrame)
setColor(HexEdit, "444444", "FFFFFF")
setColor(HexInfo, "FFFFFF", "FFFFFF")


local backPanel	= createPanel(160, 70, 80, 30, ColorFrame)
ColorMonitor 	= createPanel(1, 1, 78, 28, backPanel)
setColor(ColorMonitor, "000000", "000000")

SaveButton 		= createButton(160, 105, 80, 30, "ОК", _, ColorFrame) 
setColor(SaveButton, "18C018", "FFFFFF")

for i, v in pairs({"Красный", "Зеленый", "Синий", "Размер кисти"}) do
	local label = createLabel(60, 35*(i-1)+5, 100, 30, v, _, ColorFrame)
	setColor(label, "FFFFFF", "FFFFFF")
end

--Для мыши создавать графические объекты - например прозрачные панельки для перемещения