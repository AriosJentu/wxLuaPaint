CurrentTool = nil

ToolRegistry = {}

DrawTool = {}
DrawTool.__index = DrawTool

Figure = {}
Figure.__index = Figure

Figures = {}


function Figure.New()
	local self = setmetatable({}, Figure)

	self.Points = {}
	self.Tool = nil
	self.PenColor = nil
	self.BrushColor = nil
	self.BrushSize = nil

	table.insert(Figures, self)

	return self
end

function DrawTool.New(name)

	local self 		= setmetatable({}, DrawTool)

	self.Name 		= name
	self.Continious	= false
	self.OnDraw		= function(tab) end
	self.Draw 		= function(paint, tab) end
	self.Icon 		= APPDIR.."icons/def.png"
	
	ToolRegistry[name] = self

	return self
end

function DrawTool.DrawFigure(self, paint, figure)

	setPaintBrush(paint, figure.BrushColor)			--Установка кисти
	setPaintPen(paint, figure.PenColor, figure.BrushSize)

	if self.Continious then

		for i in pairs(figure.Points) do
			if figure.Points[i+1] then
				local ins = {old = figure.Points[i], new = figure.Points[i+1]}
				self.Draw(paint, ins)
			end
		end
	else
		local ins = {old = figure.Points[1], new = figure.Points[2]}
		self.Draw(paint, ins)
	end
end

function setCurrentTool(tool) CurrentTool = tool end

Mouse 			= DrawTool.New("Mouse")
Mouse.Icon 		= APPDIR.."icons/mouse.png"

Pen 			= DrawTool.New("Pen")
Pen.Draw 		= drawLine
Pen.Continious 	= true 
Pen.Icon 		= APPDIR.."icons/pen.png"

Line 			= DrawTool.New("Line")
Line.Draw 		= drawLine
Line.Icon 		= APPDIR.."icons/line.png"

Rectangle 		= DrawTool.New("Rectangle")
Rectangle.Draw 	= drawRectangle
Rectangle.Icon 	= APPDIR.."icons/rectangle.png"

Ellipse 		= DrawTool.New("Ellipse")
Ellipse.Draw 	= drawEllipse
Ellipse.Icon 	= APPDIR.."icons/ellipse.png"

setCurrentTool(Pen)