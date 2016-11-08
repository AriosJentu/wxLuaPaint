iconDir 		= APPDIR.."icons/logo.png"

PaintFrame 		= createFrame(10, 10, 640, 480, "Графический редактор", "full")
PaintFrame:Show()
centerElement(PaintFrame)
setAppIcon(PaintFrame, iconDir)
setColor(PaintFrame, "FFFFFF", "444444")

ScrollPane, Scrolling = createScrollPane(71, 0, 640-71, 480-51, _, PaintFrame)
setColor(ScrollPane, "CCCCCC", "CCCCCC")

PaintPanel = createPanel(2, 2, 640-73-4-5, 480-51-4-5, ScrollPane)
setColor(PaintPanel, "FFFFFF", "444444")

resizer = createPanel(640-73-7, 480-51-7, 5, 5, ScrollPane)
setColor(resizer, "555555", "555555")

addObjectOnPane(resizer, ScrollPane)

paint = setFrameDrawing(PaintPanel)
paint:Clear()

ToolPanel 		= createPanel(0, 0, 71, 480, PaintFrame)
setColor(ToolPanel, "444444", "444444")

createMenu(PaintFrame, {"Файл", "Помощь"})
idUndo			= addMenuItem("Файл", "Отменить")
idRend			= addMenuItem("Файл", "Перерисовать")
idCler 			= addMenuItem("Файл", "Очистить")
idExit 			= addMenuItem("Файл", "Выход")
idAbts			= addMenuItem("Помощь", "О программе")

SavingColours = {
	"FF0000", "00FF00", "0000FF", "4444FF", 
	"6600FF", "143F72", "FF9900", "18C018", 
	"C01818", "1818C0", "D73030", "30D730", 
	"FFFFFF", "000000", "333333", "444444", 
	"555555", "666666", "AAAAAA", "EEEEEE"
}

SideButton = {}
local n = 0
for i, v in pairs(ToolRegistry) do
	
	local x = 3

	n = n+1
	if not tostring(n/2):find(".5") then x = 36 end	

	SideButton[i] = createIconButton(x, (math.ceil(n/2)-1)*33 + 3, 30, 30, v.Icon, _, ToolPanel)
	setColor(SideButton[i], CurrentTool == v and "18C018" or "444444", "FFFFFF")

	addEvent(SideButton[i], "onMouseEnter", function()
		setColor(SideButton[i], "C01818", "FFFFFF")
	end)
	addEvent(SideButton[i], "onMouseLeave", function()
		setColor(SideButton[i], CurrentTool == v and "18C018" or "444444", "FFFFFF")
	end)
	addEvent(SideButton[i], "onMouseUp", function()
		if i ~= "Mouse" then
			setCurrentTool(v)
		
			for m in pairs(SideButton) do
				if m ~= "Mouse" then setColor(SideButton[m], "444444", "FFFFFF") end
			end

			setColor(SideButton[i], "18C018", "FFFFFF")
		end
	end)
end

ColorDialog = nil

n = math.ceil(n/2)
--print(n)
ColorButton = {}
local DefaultColors = {"000000", "FFFFFF"}
CurrentColour 		= {"000000", "FFFFFF"}	

for i = 1, 2 do

	ColorButton[i] = createButton((i-1)*33+3, n*36+3, 30, 30, "", _, ToolPanel)
	setColor(ColorButton[i], DefaultColors[i], DefaultColors[i])
	
	addEvent(ColorButton[i], "onMouseUp", function()
		
		local r, g, b = getColor(ColorButton[i])
		local data = wx.wxColourData()
		data:SetColour(wx.wxColour(r, g, b))

		for m = 0, 15 do
			data:SetCustomColour(m, wx.wxColour(fromHEXToRGB(SavingColours[m+1])))
		end

		ColorDialog = createColorDialog(PaintFrame, data)

		if ColorDialog:ShowModal() == wx.wxID_OK then

			local x, y, z = getColFromColour(ColorDialog:GetColourData():GetColour())
			
			CurrentColour[i] = fromRGBToHEX(x, y, z)
			setColor(ColorButton[i], CurrentColour[i], CurrentColour[i])
			
			for m = 0, 15 do
				local thisColour = getColFromColour(ColorDialog:GetColourData():GetCustomColour(m), true) 
				SavingColours[m+1] = thisColour
			end

		end

		ColorDialog:Close()
		ColorDialog:Destroy()

	end)
end

local label = createLabel(3, (n+1)*36+3, 63, 25, "Размер:", _, ToolPanel)
setColor(label, "FFFFFF", "FFFFFF")
SpinSizer = createSpin(3, (n+1)*36+22, 63, 30, "0", ToolPanel, 1, 128)

n = n+1

local labels = createLabel(3, (n+1)*40, 63, 25, "Масштаб:", _, ToolPanel)
setColor(labels, "FFFFFF", "FFFFFF")
SpinScale = createSpin(3, (n+1)*40+22, 63, 30, "100", ToolPanel, 20, 500)


PaintFrame:SetMinSize(wx.wxSize(320, (n+2)*40+70))


function closeApplication(evt)
	PaintFrame:Close()
	
	if evt then
		evt:Skip()
	end
	SkippingEvent = true
end