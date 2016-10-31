local SavingCoordinates 	= {} 	
local SavePainted 			= {}

local IsDrawing 			= false	
local IsMouseActive			= false	

local CurrentToolSize = 1		

local ObjectTable 	= {}		

addEvent(SideButton.Mouse, "onMouseDown", function()
	IsMouseActive = not IsMouseActive
	setColor(SideButton.Mouse, IsMouseActive and "18C018" or "444444", "FFFFFF")
end)
addEvent(SideButton.Mouse, "onMouseLeave", function()
	setColor(SideButton.Mouse, IsMouseActive and "18C018" or "444444", "FFFFFF")
end)

addEvent(PaintFrame, "onResize", function(evt, max)

	IsDrawing = false	

	if max ~= "max" then
		local _, h = getSize(evt:GetSize())
		setSize(ToolPanel, 71, h)
		paint:Clear()
		reRendering()
	end				

end)

addEvent(PaintFrame, "onMenu", closeApplication, idExit)
addEvent(PaintFrame, "onMenu", function()
	paint:Clear()
	reRendering()
end, idRend)

addEvent(PaintFrame, "onMenu", function() 
	paint:Clear() 
	SavePainted = {}
end, idCler)

addEvent(PaintFrame, "onKey", function(keys)
	if isKeyPressed("ctrl") and getKey(keys) == "Z" then undo() end
	if getKey(keys) == "M" then CurrentColour[1] = "6600FF" end
end)

addEvent(PaintFrame, "onMenu", function() 
	wx.wxMessageBox(infoText, "Информация", wx.wxOK) 
	reRendering()
end, idAbts)

-------------------------------------------------
local IsLeftMouse = false
function onMouseDown(evt, key)
	if not IsMouseActive then

		IsLeftMouse = key == "left" and true or false
		--print(IsLeftMouse)

		SavingCoordinates 	= {getEventPositions(evt)}
		IsDrawing 			= true
		table.insert(ObjectTable, {Start = #SavePainted})
		executeEvent(PaintFrame, "onMouseMove", evt) 
	end
end

function onMouseUp(evt)
	if not IsMouseActive then
		if not IsDrawing then return false end

		if not CurrentTool.Continious then
			local tb = {
				{CoordBlock[1], CoordBlock[2]}, 
				{CoordBlock[3], CoordBlock[4]}, 
				CurrentColour[1], CurrentColour[2], CurrentToolSize, CurrentTool
			}
			
			if not IsLeftMouse then tb[3], tb[4] = tb[4], tb[3] end

			saveDrawed(unpack(tb))
			paintObject(unpack(tb))

			paint:Clear()
			reRendering()
		end

		ObjectTable[#ObjectTable].Finish = #SavePainted

	end

	IsDrawing = false
end

function onMouseMove(evt)
	
	paint = setFrameDrawing(PaintFrame)

	if IsDrawing then
		if CurrentTool.Continious then
			
			local oldCoords 	= SavingCoordinates
			SavingCoordinates 	= {getEventPositions(evt)}

			local tb = {oldCoords, SavingCoordinates, CurrentColour[1], CurrentColour[2], CurrentToolSize, CurrentTool}

			if not IsLeftMouse then tb[3], tb[4] = tb[4], tb[3] end

			saveDrawed(unpack(tb))
			paintObject(unpack(tb))

			--movePointTo(12, 100, 100)

		else
			
			local positions = SavingCoordinates
			local sizes = {getEventPositions(evt)}

			local x, y = positions[1], positions[2]
			local w, h = sizes[1], sizes[2]

			if not (CurrentTool.Name == "Line") then

				w, h = sizes[1]-positions[1], sizes[2]-positions[2]

				if w < 0 then x = sizes[1] w = positions[1]-sizes[1] end
				if h < 0 then y = sizes[2] h = positions[2]-sizes[2] end
			end

			CoordBlock = {x, y, w ,h}
		end
	end
end
-------------------------------------------------
addEvent(PaintFrame, "onMouseDown", onMouseDown)
addEvent(PaintFrame, "onMouseUp", onMouseUp)
addEvent(PaintFrame, "onMouseMove", onMouseMove)

addEvent(SpinSizer, "onMouseUp", function() CurrentToolSize = getText(SpinSizer) end)

-------------------------------------------------
----------ФУНКЦИИ ПО РАБОТЕ С ОБЪЕКТАМИ----------
-------------------------------------------------
function undo()
	if tonumber(#ObjectTable) and ObjectTable[#ObjectTable] ~= nil then
		destroyObject(#ObjectTable) 
	end

	paint:Clear()
	reRendering()
end
addEvent(PaintFrame, "onMenu", undo, idUndo)
function saveDrawed(old, new, col1, col2, siz, brush)

	CurrentTool.OnDraw(old, new, col, siz)
	table.insert(SavePainted, {	
		old 	= old, 
		new 	= new, 
		defColF = col1,
		defColS = col2, 
		defSize = siz,
		brush 	= brush
	})
	--for i in pairs(SavePainted) do print(SavePainted[i].defColF, SavePainted[i].defColS) end
end
function paintObject(tabCoordOld, tabCoordNew, defColorF, defColorS, defSize, brush)
	setPaintBrush(paint, defColorS)			--Установка кисти
	setPaintPen(paint, defColorF, defSize)	--Установка ручки

	brush.Draw(paint, 					--Рисование
		tabCoordOld[1], 
		tabCoordOld[2], 
		tabCoordNew[1], 
		tabCoordNew[2])
end
function reRendering()

	for _, i in pairs(SavePainted) do	
		--print("Colors for "..n..": "..i.defColF.." "..i.defColS)
		paintObject(i.old, i.new, i.defColF, i.defColS, i.defSize, i.brush)
	end

end

function getObjectRectangle(objectID)


	local id = ObjectTable[objectID].Start

	local minX, minY = SavePainted[id].old[1], SavePainted[id].old[2]
	local maxX, maxY = minX, minY

	for i = ObjectTable[objectID].Start, ObjectTable[objectID].Finish do

		for _, v in pairs(SavePainted[i]) do

			if v[1] < minX then minX = v[1] end
			if v[2] < minX then minY = v[2] end

			if v[1] > maxX then maxX = v[1] end
			if v[2] > maxX then maxY = v[2] end
		end

	end

	return minX, minY, maxX, maxY
end

--Обновление параметров объекта
function updateObject(objectID, x, y, defColF, defColS, defSize, brush)

	local id 			= ObjectTable[objectID].Start

	local ax, ay 		= getObjectRectangle(objectID)
	local difX, difY	= x-ax, y-ay 					
	
	--Цикл по всем точкам объекта
	for i = ObjectTable[objectID].Start, ObjectTable[objectID].Finish do

		--Получение актуальных координат 
		local ax, ay = SavePainted[i].old[1], SavePainted[i].old[2]
		local bx, by = SavePainted[i].new[1], SavePainted[i].new[2]

		SavePainted[i].old 		= {ax+difX, ay+difY} 	or SavePainted[i].old 		
		SavePainted[i].new 		= {bx+difX, by+difY} 	or SavePainted[i].new 	
		SavePainted[i].defColF 	= defColF 				or SavePainted[i].defColF 	
		SavePainted[i].defColS 	= defColS 				or SavePainted[i].defColS	
		SavePainted[i].defSize 	= defSize 				or SavePainted[i].defSize 
		SavePainted[i].brush 	= brush 				or SavePainted[i].brush 

	end

	paint:Clear()
	reRendering()
end

function movePointTo(point, x, y)
	if SavePainted[point] ~= nil then

		SavePainted[point].new = {x, y}

		if SavePainted[point+1] ~= nil and isPointInObject(point+1, getPointObject(point)) then
			SavePainted[point+1].old = {x, y}
		end

		paint:Clear()
		reRendering()

	end
end

function isPointInObject(point, object)
	if getPointObject(point) == object then return true
	else return false
	end
end

function getPointObject(point)
	local obj = 0

	for i, v in pairs(ObjectTable) do
		if v.Finish ~= nil then
			
			--print(point, type(point), v.Start, v.Finish)
			if point > v.Start and point <= v.Finish then
				obj = i
				break
			else
				obj = false
			end
		end
	end
	return obj
end

function destroyObject(objectID)

	--if not tonumber(ObjectTable[objectID].Start+1) then return false end
	if not tonumber(ObjectTable[objectID].Finish) then return false end

	for i = ObjectTable[objectID].Start+1, ObjectTable[objectID].Finish do
		SavePainted[i] = nil
	end

	ObjectTable[objectID] = nil
	paint:Clear()	
	reRendering()

end