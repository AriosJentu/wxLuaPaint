--Функционал по работе с графической библиотекой
function setFrameDrawing(frame)
	local paint = wx.wxPaintDC(frame)
	return paint
end

function setPaintBrush(paint, color)
	paint:SetBrush(wx.wxBrush(wx.wxColour( fromHEXToRGB(color) ), 1))
end
function setPaintPen(paint, color, borderSize)
	paint:SetPen(wx.wxPen(wx.wxColour( fromHEXToRGB(color) ), borderSize or 1, 0 ))
end
function drawPixel(paint, x, y)
	paint:DrawPoint(x, y)
end
function drawRectangle(paint, x, y, w, h)
	paint:DrawRectangle(x, y, w, h)
end
function drawEllipse(paint, x, y, w, h)
	paint:DrawEllipse(x, y, w, h)
end
function drawLine(paint, ax, ay, bx, by)
	paint:DrawLine(ax, ay, bx, by)
end