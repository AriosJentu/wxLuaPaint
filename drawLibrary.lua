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

function drawPixel(paint, ins)

	local x, y = ins.old[1], ins.old[2]

	paint:DrawPoint(ins.old[1], ins.old[2])
end
function drawRectangle(paint, ins)

	local x, y, w, h = getWidthed(ins.old[1], ins.old[2], ins.new[1], ins.new[2])

	paint:DrawRectangle(x, y, w, h)
end
function drawEllipse(paint, ins)

	local x, y, w, h = getWidthed(ins.old[1], ins.old[2], ins.new[1], ins.new[2])

	paint:DrawEllipse(x, y, w, h)
end
function drawLine(paint, ins)

	local x, y, ax, ay = ins.old[1], ins.old[2], ins.new[1], ins.new[2]

	--print(x, y, ax, ay)

	paint:DrawLine(x, y, ax, ay)
end

function getWidthed(x, y, w, h)

	local sx, sy, sw, sh = x, y, w, h

	w, h = sw-sx, sh-sy
	if w < 0 then x = sw w = sx-sw end
	if h < 0 then y = sh h = sy-sh end

	return x, y, w, h

end