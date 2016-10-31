CurrentTool = nil

ToolRegistry = {}

DrawTool = {}
DrawTool.__index = DrawTool

function DrawTool.New(name)

	local self 		= setmetatable({}, DrawTool)

	self.Name 		= name
	self.Continious	= false
	self.OnDraw		= function(cords, sizes, color, brushsize) end
	self.Draw 		= function(paint, x, y, w, h) end
	self.Icon 		= APPDIR.."icons/def.png"
	
	ToolRegistry[name] = self

	return self
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