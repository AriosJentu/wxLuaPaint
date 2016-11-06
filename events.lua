local SavingCoordinates 	= {} 	
local SavePainted 			= {}
local FigureList = {}

local IsDrawing 			= false	
local IsMouseActive			= false	

local CurrentToolSize = 1	
local CurrentFigure = nil	

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
		local w, h = getSize(evt:GetSize())
		setSize(ToolPanel, 71, h)
		setSize(ScrollPane, w-71-2, h-51)
		--setSize(Scrolling, w-71-2, h-51)	
	
		paint:Clear()
		reRendering()
	end				

end)

local Resizing = false
local SavedObjectPosition = {0, 0, 0, 0}
addEvent(resizer, "onMouseDown", function(evt)
	Resizing = true
	local mX, mY = getMousePosition()
	local objX, objY = getPositions(resizer)

	SavedObjectPosition = {mX, mY, objX, objY}

end)
addEvent(resizer, "onMouseUp", function()
	Resizing = false

	paint:Clear()
	reRendering()
end)
addEvent(resizer, "onMouseMove", function(evt)
	if Resizing then
		local CurrentMousePosition = {getMousePosition()}

		local difX, difY = (CurrentMousePosition[1]-SavedObjectPosition[1]), 
							(CurrentMousePosition[2]-SavedObjectPosition[2])

		local newX, newY = SavedObjectPosition[3]+difX, SavedObjectPosition[4]+difY

		setPosition(resizer, newX, newY)
		setSize(PaintPanel, newX-2, newY-2)

		setPaneMinSizes(ScrollPane, newX+7, newY+7)
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
	FigureList = {}
end, idCler)


addEvent(SpinSizer, "onMouseUp", function() CurrentToolSize = getText(SpinSizer) end)

addEvent(PaintFrame, "onKey", function(keys)
	if isKeyPressed("ctrl") and getKey(keys) == "Z" then undo() end
	if getKey(keys) == "M" then CurrentColour[1] = "6600FF" end

	--print(isKeyPressed("ctrl"),  isKeyPressed("shift"), "'"..getKey(keys).."'")
	if isKeyPressed("ctrl") and isKeyPressed("shift") then 
		local jk = getKey(keys)
		if jk == "=" or jk == "-" then
			local mn = jk == "=" and 1 or -1
			setText(SpinSizer, tostring( tonumber(getText(SpinSizer))+mn ) )
			executeEvent(SpinSizer, "onMouseUp")
		end
	end
end)

addEvent(PaintFrame, "onMenu", function() 
	wx.wxMessageBox(infoText, "Информация", wx.wxOK) 
	reRendering()
end, idAbts)

-------------------------------------------------
local IsLeftMouse = false
function onMouseDown(evt, key)

	if not IsMouseActive then
		if key == "middle" then return false end

		IsLeftMouse = key == "left" and true or false
		--print(IsLeftMouse)

		SavingCoordinates 	= {getEventPositions(evt)}
		IsDrawing 			= true
		
		--[[CurrentFigure = Figure.New()
		CurrentFigure.Points = {getEventPositions(evt)}
		CurrentFigure.Tool = CurrentTool
		CurrentFigure.PenColor = CurrentColour[1]
		CurrentFigure.BrushColor = CurrentColour[2] ]]
		
		table.insert(ObjectTable, {Start = #SavePainted})
		executeEvent(PaintPanel, "onMouseMove", evt) 
	end
end

function onMouseUp(evt)
	if not IsMouseActive then
		if not IsDrawing then return false end
		
		--table.insert(FigureList, CurrentFigure)
		
		if not CurrentTool.Continious then
			local tb = {
				{CoordBlock[1], CoordBlock[2]}, 
				{CoordBlock[3], CoordBlock[4]}, 
				CurrentColour[1], 
				CurrentColour[2], 
				CurrentToolSize, 
				CurrentTool
			}
			
			if not IsLeftMouse then tb[3], tb[4] = tb[4], tb[3] end

			saveDrawed(tb)
			paintObject(tb)

			paint:Clear()
			reRendering()
		end

		ObjectTable[#ObjectTable].Finish = #SavePainted

	end

	IsDrawing = false
end

function onMouseMove(evt)
	
	paint = setFrameDrawing(PaintPanel)

	if IsDrawing then
		if CurrentTool.Continious then
			
			local oldCoords 	= SavingCoordinates
			SavingCoordinates 	= {getEventPositions(evt)}

			local tb = {oldCoords, SavingCoordinates, CurrentColour[1], CurrentColour[2], CurrentToolSize, CurrentTool}

			if not IsLeftMouse then tb[3], tb[4] = tb[4], tb[3] end

			saveDrawed(tb)
			paintObject(tb)

			--movePointTo(12, 100, 100)

		else

			local sz = {getEventPositions(evt)}
			CoordBlock = {SavingCoordinates[1], SavingCoordinates[2], sz[1], sz[2]}

			print(CurrentColour[1], CurrentColour[2])	

			paint:Clear()
			reRendering()

			setPaintBrush(paint, CurrentColour[2])			--Установка кисти
			setPaintPen(paint, CurrentColour[1], CurrentToolSize)
			CurrentTool.Draw(paint, {SavingCoordinates, sz})

		end

	end
end
-------------------------------------------------
addEvent(PaintPanel, "onMouseDown", onMouseDown)
addEvent(PaintPanel, "onMouseUp", onMouseUp)
addEvent(PaintPanel, "onMouseMove", onMouseMove)

-------------------------------------------------
------------ПЕРЕМЕЩЕНИЕ ПОЛЯ РИСОВАНИЯ-----------
-------------------------------------------------
local IsPanelMoving = false
local SavePanelCoordinate = {}

addEvent(PaintPanel, "onMouseDown", function()

	local scrX, scrY = getPositions(ScrollPane)
	local curX, curY = getMousePosition()

	
	IsPanelMoving = true
	SavePanelCoordinate = {curX, curY, scrX, scrY}

end, "middle")

addEvent(PaintPanel, "onMouseUp", function()
	SavePanelCoordinate = {}
	IsPanelMoving = false

	paint:Clear()
	reRendering()

end)

addEvent(PaintPanel, "onMouseMove", function()

	if IsPanelMoving then

		local w, h = getSize(ScrollPane:GetSize())
		local pw, ph = getSize(Scrolling:GetSize())
		pw, ph = pw-10, ph-10

		if w > pw or h > ph then
			
			local CurrentMousePosition = {getMousePosition()}

			local difX, difY = (CurrentMousePosition[1]-SavePanelCoordinate[1]), 
								(CurrentMousePosition[2]-SavePanelCoordinate[2])

			local newX, newY = SavePanelCoordinate[3]+difX, SavePanelCoordinate[4]+difY

			if newX > 0 then newX = 0 end
			if newY > 0 then newY = 0 end

			if newX < pw-w then newX = pw-w end
			if newY < ph-h then newY = ph-h end

			print(newX, newY, w-pw, h-ph)
			setPosition(ScrollPane, newX, newY)
		end
	end

end)

addEvent(PaintPanel, "onWheel", function(evt, key)
	
end)

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
function saveDrawed(ins)

	CurrentTool.OnDraw(ins)
	table.insert(SavePainted, ins)
	--for i in pairs(SavePainted) do print(SavePainted[i].defColF, SavePainted[i].defColS) end
end
function paintObject(ins)

	setPaintBrush(paint, ins[4])			--Установка кисти
	setPaintPen(paint, ins[3], ins[5])		--Установка ручки

	ins[6].Draw(paint, ins)
end
function reRendering()

	for _, i in pairs(SavePainted) do	
		paintObject(i)
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