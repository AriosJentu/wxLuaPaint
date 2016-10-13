local infoText = [[
Автор: 				Максимов Павел (Б8103а)
Известен как: 		Arios Jentu
Начало работы: 	12.10.2016

GitHub: 			github.com/AriosJentu
VK: 				vk.com/AriosJentu

Проект распространяется свободно]]

local SavingCoordinates = {} 	--Таблица с сохраняющими координатами
local SavingPaint = {}			--Таблица с сохранением истории рисования
local Drawing = false			--Переменная рисования. True - когда нужно рисовать
local isMouse = false 			--Переменная, отвечающая за векторное перемещение (инструмент "Мышь")

local DefaultColour = "000000"	--Цвет кисти по умолчанию
local DefaultBrushSize = 2		--Размер кисти по умолчанию

local ObjectTable = {}			--Таблица объектов - хранит в себе отрезок из таблицы истории, в котором лежит данный объект

--Событие нажатия на ЛКМ на редакторе
addEvent(PaintFrame, "onMouseDown", function(evt)
	
	if isMouse then 	--Активен ли инструмент "Мышь"

	else				--Если нет, то

		SavingCoordinates = {getEventPositions(evt)}	--Сохранение координат
		Drawing = true 									--Когда зажата ЛКМ, то нужно активировать рисование на перемещение мыши
		executeEvent(PaintFrame, "onMouseMove", evt) 	--Вызов события перемещения для того, чтобы поставить точку

		local id = #ObjectTable+1 						--Идентификация для таблицы объектов
		ObjectTable[id] = {}							--Создание таблицы для данного объекта
		--print(id)
		ObjectTable[id].Start = #SavingPaint			--Сохранение начального идентификатора из таблицы всего рисунка

	end

end)

--Событие отпускания ЛКМ на редакторе
addEvent(PaintFrame, "onMouseUp", function(evt)
	Drawing = false			--При отпускании ЛКМ происходит деактивация рисования

	if isMouse then			--Активен ли инструмент "Мышь"						

	else					--Если нет


		local id = #ObjectTable					--То идентификатор объекта
		--print(id)
		ObjectTable[id].Finish = #SavingPaint	--Сохранение конечного идентификатора из таблицы всего рисунка

		--print(getObjectRectangle(id))
		--updateObject(id, 50, 150, randomHex(), 3)
	end
end)

--Установка графического обработчика
local paint = setFrameDrawing(PaintFrame)
paint:Clear()

--Событие при перемещении мыши
addEvent(PaintFrame, "onMouseMove", function(evt)

	--Обновление графического обработчика
	paint = setFrameDrawing(PaintFrame)

	--Если активна переменная рисования
	if Drawing then

		local oldCoords = SavingCoordinates				--Сохраняем старые координаты для рисования линии
		SavingCoordinates = {getEventPositions(evt)}	--Обновляем координаты из события
	
		--Рисуем линию, началом которой являются старые координаты, а концом - новые
		paintLine(oldCoords, SavingCoordinates, DefaultColour, DefaultBrushSize)

		--Вносим линию в таблицу, чтобы обновлять рисунок
		table.insert(SavingPaint, {old = oldCoords, new = SavingCoordinates, defCol = DefaultColour, defSize = DefaultBrushSize})

	end

end)

--Событие при изменении размеров окна
addEvent(PaintFrame, "onResize", function(evt)

	Drawing = false							--Отключаем рисование
	paint:Clear()							--Очищаем нарисованое

	--Работа с нижней панелью
	local w, h = getSize(evt:GetSize())		--Получаем размеры окна
	setSize(ToolPanel, w, 20)				--Устанавливаем размеры нижней панели для 
	setPosition(ToolPanel, 0, h-71)			--Устанавливаем положение нижней панели в зависимости от размера окна

	setText(LabelFSize, "Размер окна: "..w.."x"..h)
	setPosition(LabelFSize, w-155, 1)

	reRendering()
end)

--Событие нажатия на кнопку "Выход" в меню окна - закрыть окно
addEvent(PaintFrame, "onMenu", function() PaintFrame:Close() end, idExit)

--Событие нажатия на кнопку "Очистить" в меню окна
addEvent(PaintFrame, "onMenu", function() 
	paint:Clear() 		--Очистить поле рисования
	SavingPaint = {}	--Очищаем таблицу сохранения координат
end, idCler)

--Событие нажатия на кнопку "Отменить" в меню окна
addEvent(PaintFrame, "onMenu", function() 
	if ObjectTable[#ObjectTable] ~= nil then	--Если таблица с объектами ещё есть 
		destroyObject(#ObjectTable) 			--То удаляем последний
	end
end, idUndo)

--Событие нажатия на кнопку информации в меню окна
addEvent(PaintFrame, "onMenu", function() 

	--Показать окно информации
	wx.wxMessageBox(infoText, "Информация", wx.wxOK) 

	reRendering()
end, idAbts)



--События окна с цветом
--Сначала клавиша для открытия окна
addEvent(PaletteButton, "onMouseEnter", function()
	setColor(PaletteButton, "C01818", "FFFFFF")
end)
addEvent(PaletteButton, "onMouseLeave", function()
	setColor(PaletteButton, "444444", "FFFFFF")
end)

addEvent(SaveButton, "onMouseEnter", function()
	setColor(SaveButton, "C01818", "FFFFFF")
end)
addEvent(SaveButton, "onMouseLeave", function()
	setColor(SaveButton, "18C018", "FFFFFF")
end)
addEvent(SaveButton, "onMouseUp", function() 
	ColorFrame:Close() 
	
	DefaultColour 		= getText(HexEdit)
	DefaultBrushSize 	= getText(SpinBrush) 
end)


addEvent(MouseButton, "onMouseEnter", function()
	setColor(MouseButton, "C01818", "FFFFFF")
end)
addEvent(MouseButton, "onMouseLeave", function()
	setColor(MouseButton, isMouse and "18C018" or "444444", "FFFFFF")
end)

addEvent(PaletteButton, "onMouseUp", function() ColorFrame:Show() end)
addEvent(MouseButton, "onMouseUp", function()
	isMouse = not isMouse
	setColor(MouseButton, isMouse and "18C018" or "444444", "FFFFFF")
end)

addEvent(MouseButton, "onMouseUp", function()
	isMouse = not isMouse
	setColor(MouseButton, isMouse and "18C018" or "444444", "FFFFFF")
end)


--При закрытии окна палитры, окно просто свернуть, а не закрыть
addEvent(ColorFrame, "onClose", function() ColorFrame:Hide() end)

--При закрытии основного окна
addEvent(PaintFrame, "onClose", function(event)  
	ColorFrame:Close() 		--Закрыть окно палитры
	ColorFrame:Destroy()	--Удалить это окно
	event:Skip()			--И предотвратить цикл повтора данного события (тк при вызове функции закрытия этого окна будет вызвано это событие)
end)

--Событие для ключей
addEvent(PaintFrame, "onKey", function(keys)
	local key = getKey(keys) 						--Получение текстового ключа

	if isKeyPressed("ctrl") and key == "Z" then		--Если нажат CTRL и нажат Z
		
		print("True, CTRL+Z") 						--Вывести, что действие совершается

		if ObjectTable[#ObjectTable] ~= nil then 	--То если таблица не пустая
			destroyObject(#ObjectTable) 			--Удалить актуальный объект
		end
	end
end)

--Цикл по полям ввода цвета
for _, v in pairs({SpinRed, SpinGreen, SpinBlue}) do

	--Событие на редактирование Spin
	addEvent(v, "onSpinEdit", function(evt)

		--Получение цветов
		local r, g, b = getText(SpinRed), getText(SpinGreen), getText(SpinBlue)
		local color = fromRGBToHEX(r, g, b)
		
		--Установка HEX цвета
		setColor(ColorMonitor, color, color)
		setText(HexEdit, color)
	end)

end

addEvent(HexEdit, "onEdit", function(evt)
	
	local text = getText(HexEdit)
	--[[for i = 0, 6-text:len() do
		text = "0"..text
	end]]
	if text:len() > 6 then setText(HexEdit, text:sub(2, text:len() ) ) end
	if text:len() < 6 then setText(HexEdit, "0"..text) end
	if not tonumber(text, 16) then 
		setText(HexEdit, fromRGBToHEX(
			getText(SpinRed), 
			getText(SpinGreen), 
			getText(SpinBlue)
			)
		) 
	end

	local color 	= getText(HexEdit)
	local r, g, b 	= fromHEXToRGB(color)

	setText(SpinRed, 	r)
	setText(SpinGreen,	g)
	setText(SpinBlue, 	b)

	--Установка HEX цвета
	setColor(ColorMonitor, color, color)
end)

--============================================--
--============= ФУНКЦИИ ВЕКТОРОВ =============--
--============================================--
--Перерисовка линий
function paintLine(tabCoordOld, tabCoordNew, defColor, defSize)
	setPaintBrush(paint, defColor)			--Установка кисти
	setPaintPen(paint, defColor, defSize)	--Установка ручки

	drawLine(paint, 						--Рисование линии
		tabCoordOld[1], 
		tabCoordOld[2], 
		tabCoordNew[1], 
		tabCoordNew[2])
end

--Перерисова сохранённой графики
function reRendering()

	--Цикл по обновлению панели рисования
	for _, i in pairs(SavingPaint) do	

		--Перерисовка линий
		paintLine(i.old, i.new, i.defCol, i.defSize)

	end

end

--Получить координаты прямоугольной области, которой при
function getObjectRectangle(objectID)

	--Идентификатор для точки начала для данного объекта
	local id = ObjectTable[objectID].Start

	--Переменные минимальной и максимальной позиции элементов (идут на вывод, так как именно они и образуют прямоугольную область, в которой они лежат)
	local minX, minY = SavingPaint[id].old[1], SavingPaint[id].old[2]
	local maxX, maxY = minX, minY

	--Цикл от начального до конечного элемента объекта
	for i = ObjectTable[objectID].Start, ObjectTable[objectID].Finish do

		--Цикл по old и new координатам
		for _, v in pairs(SavingPaint[i]) do
			--При минимуме выставляем минимум
			if v[1] < minX then minX = v[1] end
			if v[2] < minX then minY = v[2] end

			--При максимуме выставляем максимум
			if v[1] > maxX then maxX = v[1] end
			if v[2] > maxX then maxY = v[2] end
		end

	end
	--Возвращаем координаты
	return minX, minY, maxX, maxY
end

--Обновление параметров объекта
function updateObject(objectID, x, y, defCol, defSize)

	local id 			= ObjectTable[objectID].Start	--Такой-же идентификатор

	local ax, ay 		= getObjectRectangle(objectID)	--Координаты начала области с точками
	local difX, difY	= x-ax, y-ay 					--Рассчёт разности между старой координатой и новой
	
	--Цикл по всем точкам объекта
	for i = ObjectTable[objectID].Start, ObjectTable[objectID].Finish do

		--Получение актуальных координат 
		local ax, ay = SavingPaint[i].old[1], SavingPaint[i].old[2]
		local bx, by = SavingPaint[i].new[1], SavingPaint[i].new[2]

		SavingPaint[i].old 		= {ax+difX, ay+difY} 	or SavingPaint[i].old 		--Обновление старых координат
		SavingPaint[i].new 		= {bx+difX, by+difY} 	or SavingPaint[i].new 		--Обновление новых координат
		SavingPaint[i].defCol 	= defCol 				or SavingPaint[i].defCol 	--Обновление цвета
		SavingPaint[i].defSize 	= defSize 				or SavingPaint[i].defSize 	--Обновление размера кисти

	end
	--Очистка формы
	paint:Clear()

	--Перерендеринг всей картинки
	reRendering()
end

--Удаление объекта с экрана
function destroyObject(objectID)

	--Цикл по всем точкам объекта
	for i = ObjectTable[objectID].Start, ObjectTable[objectID].Finish do
		--Обнуление сохраняющей таблицы, без потери индексов
		SavingPaint[i] = nil
	end
	ObjectTable[objectID] = nil
	--Очистка формы
	paint:Clear()

	--Перерендеринг
	reRendering()

end