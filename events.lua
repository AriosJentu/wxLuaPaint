local SavingCoordinates 	= {} 	
local SavePainted 			= {}
local FigureList = {}

local IsDrawing 			= false	

local CurrentToolSize = 1	
local CurrentFigure = nil	

local ZoomPercent = 100

local ObjectTable 	= {}		

addEvent(PaintFrame, "onResize", function(evt, max)

	IsDrawing = false	

	if max ~= "max" then
		local w, h = getSize(evt:GetSize())

		setSize(ToolPanel, 71, h)
		setSize(ScrollPane, w-71-2, h-51)
		--setSize(Scrolling, w-71-2, h-51)	
	
		--paint:Clear()
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

	--paint:Clear()
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

		setPaneMinSizes(ScrollPane, newX+9, newY+9)
	end
end)


addEvent(PaintFrame, "onMenu", closeApplication, idExit)
addEvent(PaintFrame, "onMenu", function()
	--paint:Clear()
	reRendering()
end, idRend)

addEvent(PaintFrame, "onMenu", function() 
	paint:Clear() 
	SavePainted = {}
	Figures = {}
end, idCler)


addEvent(SpinSizer, "onMouseUp", function()

	CurrentToolSize = getText(SpinSizer) 
end)

addEvent(PaintFrame, "onKey", function(keys)
	
	if key == "ctrl" then print(true) reRendering() end

	if isKeyPressed("ctrl") and getKey(keys) == "Z" then undo() end

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
local IsPanelMoving = false
local SavePanelCoordinate = {}

function onMouseDown(evt, key)

	--print("Down "..key)
	if key == "middle" then

		local scrX, scrY = getPositions(ScrollPane)
		local curX, curY = getMousePosition()
	
		IsPanelMoving = true
		SavePanelCoordinate = {curX, curY, scrX, scrY}

		return false
	end

	if not IsMouseActive then

		IsLeftMouse = key == "left" and true or false

		SavingCoordinates = {getEventPositions(evt)}
		IsDrawing 			= true
		
		CurrentFigure = Figure.New()
		table.insert(CurrentFigure.Points, SavingCoordinates)
		CurrentFigure.Tool = CurrentTool
		CurrentFigure.PenColor = CurrentColour[IsLeftMouse and 1 or 2]
		CurrentFigure.BrushColor = CurrentColour[IsLeftMouse and 2 or 1]
		CurrentFigure.BrushSize = CurrentToolSize*(ZoomPercent/100)
		
		executeEvent(PaintPanel, "onMouseMove", evt) 
	else
		if key == "left" then
			onMouseDown(evt, "middle")
		end
	end

end

function onMouseUp(evt, key)

	--if key == "middle" then
	if IsPanelMoving then

		SavePanelCoordinate = {}
		IsPanelMoving = false

		reRendering()

	end

	if not IsMouseActive then
		if not IsDrawing then return false end
		
		if not CurrentTool.Continious then
			
			reRendering()

			table.insert(CurrentFigure.Points, {getEventPositions(evt)})

			CurrentTool:DrawFigure(paint, CurrentFigure)
			CurrentFigure = nil

		end

	end

	IsDrawing = false
end

function onMouseMove(evt)
	
	paint = setFrameDrawing(PaintPanel)

	if IsDrawing then
		if CurrentTool.Continious then

			table.insert(CurrentFigure.Points, {getEventPositions(evt)})

			CurrentTool:DrawFigure(paint, CurrentFigure)

		else

			CurrentFigure.Points[2] = {getEventPositions(evt)}

			reRendering()

			setPaintBrush(paint, CurrentColour[ IsLeftMouse and 2 or 1])			--Установка кисти
			setPaintPen(paint, CurrentColour[ IsLeftMouse and 1 or 2], CurrentToolSize*(ZoomPercent/100))
			CurrentTool.Draw(paint, {old = SavingCoordinates, new = {getEventPositions(evt)}})

		end

	end

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

			setPosition(ScrollPane, newX, newY)

			setScrollPosition(ScrollPane, (newY/(ph-h))*100, (newX/(pw-w))*100 )
		end
	end
end

-------------------------------------------------
addEvent(PaintPanel, "onMouseDown", onMouseDown)
addEvent(PaintPanel, "onMouseUp", onMouseUp)
addEvent(PaintPanel, "onMouseMove", onMouseMove)

local StartCycle = false

addEvent(SpinScale, "onMouseUp", function()

	zoomPic(getText(SpinScale))

end)
addEvent(SpinScale, "onMouseLeave", function()

	reRendering()

end)

addEvent(SideButton.Mouse, "onMouseDown", function()
	IsMouseActive = not IsMouseActive
	setColor(SideButton.Mouse, IsMouseActive and "18C018" or "444444", "FFFFFF")
end)
addEvent(SideButton.Mouse, "onMouseLeave", function()
	setColor(SideButton.Mouse, IsMouseActive and "18C018" or "444444", "FFFFFF")
end)

addEvent(ScrollPane, "onWheel", function(evt, dir)
	
	if isKeyPressed("ctrl") then
		if dir == "up" then
			setText( SpinScale, getText(SpinScale) + 5 )
			zoomPic(getText(SpinScale))
		else
			setText( SpinScale, getText(SpinScale) - 5 )
			zoomPic(getText(SpinScale))

		end

	else

		reRendering()

	end
end)


-------------------------------------------------
----------ФУНКЦИИ ПО РАБОТЕ С ОБЪЕКТАМИ----------
-------------------------------------------------
function undo()
	Figures[#Figures] = nil
	reRendering()
end

function reRendering()

	paint:Clear()

	for _, v in pairs(Figures) do
		v.Tool:DrawFigure(paint, v)
	end

end
addEvent(PaintFrame, "onMenu", undo, idUndo)

local PreviousZoom = 1
function zoomPic(perc)

	ZoomPercent = perc
	perc = perc/100

	local newX, newY = getPositions(resizer)
	newX, newY = (newX/PreviousZoom)*perc, (newY/PreviousZoom)*perc

	setPosition(resizer, newX, newY)
	setSize(PaintPanel, newX-2, newY-2)
	setPaneMinSizes(ScrollPane, newX+9, newY+9)

	for i, v in pairs(Figures) do

		for _, j in pairs(v.Points) do
			j[1], j[2] = (j[1]/PreviousZoom)*perc, (j[2]/PreviousZoom)*perc
		end

		v.BrushSize = math.floor((v.BrushSize/PreviousZoom)*perc * 100) / 100
		--print("Brush "..v.BrushSize)
	end

	PreviousZoom = perc

end