infoText = [[
Автор: 				Максимов Павел (Б8103а)
Известен как: 		Arios Jentu
Начало работы: 	12.10.2016

GitHub: 			github.com/AriosJentu
VK: 				vk.com/AriosJentu

Проект распространяется свободно]]

local SavingCoordinates = {} 	--Таблица с сохраняющими координатами
local SavingPaint = {}			--Таблица с сохранением истории рисования
local Drawing = false			--Переменная рисования. True - когда нужно рисовать

local DefaultColour = "000000"	--Цвет кисти по умолчанию
local DefaultBrushSize = 1		--Размер кисти по умолчанию

--Событие нажатия на ЛКМ на фоне
addEvent(PaintFrame, "onMouseDown", function(evt)
	--Сохранение координат
	SavingCoordinates = {getEventPositions(evt)}
	--Когда зажата ЛКМ, то нужно активировать рисование на перемещение мыши
	Drawing = true
	--Вызов события перемещения для того, чтобы поставить точку
	executeEvent(PaintFrame, "onMouseMove", evt)
end)

addEvent(PaintFrame, "onMouseUp", function(evt)
	Drawing = false
end)

local paint = setFrameDrawing(PaintFrame)
addEvent(PaintFrame, "onMouseMove", function(evt)

	paint = setFrameDrawing(PaintFrame)

	if Drawing then
		local oldCoords = SavingCoordinates
		SavingCoordinates = {getEventPositions(evt)}
		--executeEvent(PaintFrame, "onPaint")
	
		paintLine(oldCoords, SavingCoordinates, DefaultColour, DefaultBrushSize)

		table.insert(SavingPaint, {old = oldCoords, new = SavingCoordinates, defCol = DefaultColour, defSize = DefaultBrushSize})

	end

	--paint:delete()
end)

addEvent(PaintFrame, "onResize", function(evt)

	Drawing = false
	paint:Clear()

	local w, h = getSize(evt:GetSize())
	setSize(SidePanel, w, 20)
	setPosition(SidePanel, 0, h-71)

	for _, i in pairs(SavingPaint) do	

		paintLine(i.old, i.new, i.defCol, i.defSize)

	end
end)

addEvent(PaintFrame, "onMenu", function() PaintFrame:Close() end, idExit)
addEvent(PaintFrame, "onMenu", function() 
	paint:Clear() 
	SavingPaint = {}
end, idCler)

addEvent(PaintFrame, "onMenu", function() 
	wx.wxMessageBox(infoText, "Информация", wx.wxOK) 

	for _, i in pairs(SavingPaint) do	

		paintLine(i.old, i.new, i.defCol, i.defSize)

	end
end, idAbts)

function paintLine(tabCoordOld, tabCoordNew, defColor, defSize)
	setPaintBrush(paint, defColor)
	setPaintPen(paint, defColor, defSize)
	drawLine(paint, tabCoordOld[1], tabCoordOld[2], tabCoordNew[1], tabCoordNew[2])
end