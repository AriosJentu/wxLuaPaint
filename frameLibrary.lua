local elementAlpha = {} --Таблица сохранения альфа-канала
local funTab = {} 		--Таблица, в которую сохраняются функции по событиям

------------------------------------------------------------
--====================РАБОТА С КЛЮЧАМИ====================--
------------------------------------------------------------
--Ключ - ASCII код для определённой клавиши на клавиатуре

--Функция получения ключа
function getKey(id)
	
	if type(id) ~= "number" then id = getCode(id) or 0 end

	if id <= 32 or id > 96 then
		return tableChars[id]
	else
		return string.char(id)
	end
end
--Функция, которая возвращает ASCII-код ключа в событии onKeyboard
function getCode(evt) return evt:GetKeyCode() end


function getType(element)

	--переменная на вывод - тип элемента
	local typs = nil
	
	--Если в идентификаторе будет найдено wxButton, StaticText, etc
	if element ~= nil and element.Types then
		typs = element.Types
	else --В противном случае вернуть тип элемента
		typs = type(element) 
	end

	--Возврат аргумента
	return typs
end
--Проверка - нажат ли ключ
function isKeyPressed(key)

	--Если аргумент не является строкой или числом, то предположим, что он - событие, и пробьём его по коду для события.
	if type(key) ~= "number" and type(key) ~= "string" then key = getCode(key) or 0 end
	if 
		not 
			(string.byte(key) >= 32 and string.byte(key) <= 96) 
		then
			for i, v in pairs(tableChars) do
				if key == v then key = i end
			end
	end
	return wx.wxGetKeyState(tonumber(key) or 0) or false

end


------------------------------------------------------------
--===============ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ===============--
------------------------------------------------------------

--Функция по созданию окна
function createFrame(x, y, w, h, title, style, parent)

	--Аргумент, отвечающий за стиль
	if style == "full" 			then style = wx.wxDEFAULT_FRAME_STYLE  										--Все модули
	elseif style == "nores" 	then style = wx.wxMINIMIZE_BOX + wx.wxCLOSE_BOX  							--Только модуль закрыть и свернуть (без изменения размера)
	elseif style == "resize" 	then style = wx.wxMINIMIZE_BOX + wx.wxCLOSE_BOX + wx.wxRESIZE_BORDER end	--Только модуль закрыть и свернуть, но окно может менять размер (активные углы)

	--Создание окна
	local id 	= wx.wxID_ANY

	local frame = wx.wxFrame(
		parent 				or wx.NULL, 
		id, 
		tostring(title), 
		wx.wxPoint(x, y) 	or wx.wxDefaultPosition, 
		wx.wxSize(w, h) 	or wx.wxDefaultSize, 
		style 				or wx.wxDefault_FRAME_STYLE
	)
	
	--frame:Show(true)
	frame.HasMenu = false
	frame.Types = "frame"

	return frame, id
end

--Создание кнопки
function createButton(x, y, w, h, title, style, parent)

	--Если нет родительского элемента, то не создавать кнопку
	if not parent then 
		print("Error with CREATING BUTTON: needs parent")
		return false 
	end

	--Создать кнопку
	local id = wx.wxID_ANY

	local button = wx.wxButton(
		parent, 
		id, 
		tostring(title), 
		wx.wxPoint(x, y) 	or wx.wxDefaultPosition, 
		wx.wxSize(w, h) 	or wx.wxDefaultSize, 
		style 				or wx.wxBU_EXACTFIT
	)

	button.Types = "button"
	
	--Вернуть кнопку
	return button, id
end

--Создание кнопки
function createIconButton(x, y, w, h, iconDir, style, parent)

	--Если нет родительского элемента, то не создавать кнопку
	if not parent then 
		print("Error with CREATING BUTTON: needs parent")
		return false 
	end

	--Создать кнопку
	local id = wx.wxID_ANY

	local button = wx.wxBitmapButton(
		parent, 
		id, 
		wx.wxBitmap(iconDir), 
		wx.wxPoint(x, y) 	or wx.wxDefaultPosition, 
		wx.wxSize(w, h) 	or wx.wxDefaultSize, 
		style 				or wx.wxBU_AUTODRAW
	)

	button.Types = "iconbutton"
	
	--Вернуть кнопку
	return button, id
end


--Создание текстового поля
function createEdit(x, y, w, h, text, style, parent)

	--Если нет родительского элемента, то не создавать поле
	if not parent then 
		print("Error with CREATING EDIT: needs parent")
		return false 
	end

	--Стили эдитбокса
	--Если нажимать таб для переключения между различными элементами и энтер для применения (однострочный)
	if style == "tab" 			then style = wx.wxTE_PROCESS_TAB + wx.wxTE_PROCESS_ENTER					--Стандартный однострочный текст с применением на Enter и пролистыванием на Tab
	elseif style == "read" 		then style = wx.wxTE_READONLY												--Однострочный текст, атрибус "только для чтения"
	elseif style == "mline" 	then style = wx.wxTE_MULTILINE												--Многострочный текст
	elseif style == "mread" 	then style = wx.wxTE_MULTILINE + wx.wxTE_READONLY							--Многострочный текст, атрибут "только для чтения"
	elseif style == "pass" 		then style = wx.wxTE_PASSWORD + wx.wxTE_PROCESS_ENTER + wx.wxTE_PROCESS_TAB	--Однострочный пароль
	elseif style == "readpass" 	then style = wx.wxTE_PASSWORD + wx.wxTE_READONLY 							--Однострочный пароль, атрибут readonly
	elseif style == "rread" 	then style = wx.wxTE_RIGHT+wx.wxTE_READONLY									--Текст: положение справа и только читаемый (readonly)	
	elseif style == "default" 	then style = 0 end															--По умолчанию - обычный однострочный эдитбокс без дополнительных свистоперделок

	--Создание
	local id = wx.wxID_ANY

	local edit = wx.wxTextCtrl(
		parent, 
		id, 
		tostring(text), 
		wx.wxPoint(x, y) 	or wx.wxDefaultPosition, 
		wx.wxSize(w, h) 	or wx.wxDefaultSize, 
		style 				or 0
	)

	edit.Types = "edit"

	--Вернуть
	return edit, id
end

--Создание обычного текста на экране
function createLabel(x, y, w, h, text, style, parent)

	--Если нет родительского элемента, то не создавать лейбл
	if not parent then 
		print("Error with CREATING LABEL: needs parent")
		return false 
	end

	--Выравнивание текста на экране (в соответствии с координатами и размерами элемента)
	if style == "aleft" 		then style = wx.wxALIGN_LEFT
	elseif style == "aright" 	then style = wx.wxALIGN_RIGHT
	elseif style == "acent" 	then style = wx.wxALIGN_CENTRE_HORIZONTAL end

	--Создание
	local id = wx.wxID_ANY

	local label = wx.wxStaticText(
		parent, 
		id, 
		tostring(text), 
		wx.wxPoint(x, y) 	or wx.wxDefaultPosition, 
		wx.wxSize(w, h) 	or wx.wxDefaultSize, 
		style 				or 0
	)

	label.Types = "label"

	return label, id
end


--Функция создания меню
local tableOfMenus = {} --Таблица со списком меню
function createMenu(frame, args)
	
	--Меню-бар - верхняя часть окна
	local menuBar = wx.wxMenuBar()
	--Цикл по аргументу args - таблице
	for _, v in pairs(args) do
		--Создаётся меню, которое помещается в таблицу под заданным названием меню
		tableOfMenus[v] = wx.wxMenu()

		--В меню-бар помещается созданный элемент меню
		menuBar:Append(tableOfMenus[v], v)
	end

	--На окно помещается меню-бар
	frame:SetMenuBar(menuBar)

	frame.HasMenu = true

end

--Добавление в меню элемент
function addMenuItem(bar, name)
	--Получение любого числа, которое будет идентификатором
	local id = math.random(32768)
	--Добавление имени в меню
	tableOfMenus[bar]:Append(id, name)

	--Возращение идентификатора элемента для вызова событий
	return id
end

--Создание панели
function createPanel(x, y, w, h, parent)

	--Если нет родительского элемента, то не создавать поле
	if not parent then 
		print("Error with CREATING PANEL: needs parent")
		return false 
	end

	--Создание
	local id = wx.wxID_ANY

	local panel = wx.wxPanel(
		parent, 
		id, 
		wx.wxPoint(x, y) 	or wx.wxDefaultPosition, 
		wx.wxSize(w, h) 	or wx.wxDefaultSize, 
		wx.wxTAB_TRAVERSAL
	)

	panel.Types = "panel"

	--Вернуть
	return panel, id
end

function createSpin(x, y, w, h, val, parent, min, max)

	--Если нет родительского элемента, то не создавать поле
	if not parent then 
		print("Error with CREATING SPIN: needs parent")
		return false 
	end

	--Создание
	local id = wx.wxID_ANY

	local spin = wx.wxSpinCtrl(
		parent, 
		id, 
		tostring(val) or "0",
		wx.wxPoint(x, y) 	or wx.wxDefaultPosition, 
		wx.wxSize(w, h) 	or wx.wxDefaultSize, 
		wx.wxSP_ARROW_KEYS,
		tonumber(min) or 0,
		tonumber(max) or 255
	)

	spin.Types = "spin"

	return spin, id
end

function createColorButton(x, y, w, h, color, style, parent)

	--Если нет родительского элемента, то не создавать поле
	if not parent then 
		print("Error with CREATING COLOR BUTTON: needs parent")
		return false 
	end

	--Создание
	local id = wx.wxID_ANY

	local colpic = wx.wxColourPickerCtrl(
		parent, 
		id, 
		wx.wxColour(fromHEXToRGB(color)) or wx.wxColour(fromHEXToRGB("000000")),
		wx.wxPoint(x, y) 	or wx.wxDefaultPosition, 
		wx.wxSize(w, h) 	or wx.wxDefaultSize, 
		wx.wxCLRP_DEFAULT_STYLE
	)

	colpic.Types = "colorpicker"

	return colpic, id
end

function createColorDialog(parent, data)
	--Если нет родительского элемента, то не создавать поле
	if not parent then 
		print("Error with CREATING COLOR DIALOG: needs parent")
		return false 
	end

	local coldiag = wx.wxColourDialog(parent, data)

	coldiag.Types = "coldiag"
	return coldiag
end

function createScrollZone(x, y, w, h, style, parent)
	--Если нет родительского элемента, то не создавать поле
	if not parent then 
		print("Error with CREATING SCROLL ZONE: needs parent")
		return false 
	end

	local id = wx.wxID_ANY

	local scpane = wx.wxScrolledWindow(
		parent,
		id,
		wx.wxPoint(x, y) 	or wx.wxDefaultPosition,
		wx.wxSize(w, h)		or wx.wxDefaultSize,
		style or wx.wxHSCROLL+wx.wxVSCROLL
	)

	scpane.Types = "scrollwin"

	return scpane, id

end	

function createScrollPane(x, y, w, h, types, parent)
	--Если нет родительского элемента, то не создавать поле
	if not parent then 
		print("Error with CREATING SCROLL ZONE: needs parent")
		return false 
	end


	local id = wx.wxID_ANY

	local paneBack = createPanel(x, y, w, h, parent)
	setColor(paneBack, "444444", "444444")
	local centralPanel = createPanel(0, 0, w-10, h-10, paneBack)
	setColor(centralPanel, "FFFFFF", "FFFFFF")

	centralPanel.MinW, centralPanel.MinH = w-10, h-10

	local quad = createPanel(w-10, h-10, 11, 11, paneBack)
	setColor(quad, "333333", "333333")

	local sVert = createPanel(w-10, 0, 10, h-10, paneBack)
	local sHorz = createPanel(0, h-10, w-10, 10, paneBack)
	setColor(sVert, "555555", "555555")
	setColor(sHorz, "555555", "555555")

	local vScroller = createPanel(1, 0, 8, 60, sVert)
	local hScroller = createPanel(0, 1, 60, 8, sHorz)
	setColor(vScroller, "888888", "888888")
	setColor(hScroller, "888888", "888888")

	paneBack.Moving = false

	addEvent(parent, "onResize", function(evt, typ)
		local aw, ah = getSize(evt:GetSize())
		local ax, ay = getPositions(paneBack)
		if getType(parent) == "frame" then 
		
			if parent.HasMenu then
				ay = ay+51 
			else
				ay = ay+20
			end

		end

		aw = aw-ax - 1
		ah = ah-ay

		local sw, sh = aw-10, ah-10

		if aw ~= nil then
			setSize(paneBack, aw, ah)


			local asw, ash = sw, sh

			local bx, by = getPositions(centralPanel)

			if bx+centralPanel.MinW < (aw-10) then
				bx = (aw-10)-centralPanel.MinW
			end
			if by+centralPanel.MinH < (ah-10) then
				by = (ah-10)-centralPanel.MinH
			end

			if bx > 0 then 
				bx = 0 
				setPosition(hScroller, 0, 1)
			end
			if by > 0 then 
				by = 0 
				setPosition(vScroller, 1, 0)
			end

			if sw < centralPanel.MinW then 
				asw = centralPanel.MinW 
			end
			if sh < centralPanel.MinH then 
				ash = centralPanel.MinH 
			end

			setSize(centralPanel, asw, ash)
			setPosition(centralPanel, bx, by)

			setPosition(sVert, sw, 0)
			setPosition(sHorz, 0, sh)
			setPosition(quad, sw, sh)

			setSize(sVert, 10, sh)
			setSize(sHorz, sw, 10)
		end
	end)

	centralPanel.scSize, centralPanel.mPos = 0, 0
	addEvent(vScroller, "onMouseDown", function(evt)
		centralPanel.scSize = vScroller:GetScreenPosition().y
		_, centralPanel.mPos = getMousePosition()

		paneBack.Moving = "vert"
	end)
	addEvent(hScroller, "onMouseDown", function(evt)
		centralPanel.scSize = hScroller:GetScreenPosition().x
		centralPanel.mPos = getMousePosition()

		paneBack.Moving = "horz"
	end)

	addEvent(vScroller, "onMouseUp", function(evt)
		paneBack.Moving = false
		centralPanel.scSize, centralPanel.mPos = 0, 0
	end)
	addEvent(hScroller, "onMouseUp", function(evt)
		paneBack.Moving = false
		centralPanel.scSize, centralPanel.mPos = 0, 0
	end)

	addEvent(vScroller, "onMouseMove", function(evt)

		if paneBack.Moving == "vert" then			
			rePosScroll(centralPanel, "vert")
		end
	end)

	addEvent(hScroller, "onMouseMove", function(evt)

		if paneBack.Moving == "horz" then	
			rePosScroll(centralPanel, "horz")
		end
	end)




	centralPanel.Types = "scrollpane"
	centralPanel.HScroll = {sl = hScroller, bk = sHorz}
	centralPanel.VScroll = {sl = vScroller, bk = sVert}
	centralPanel.Back = paneBack
	paneBack.Types = "scrollpaneback"

	return centralPanel, paneBack
end

function rePosScroll(element, topbot)
	local oldMouse = element.mPos
	local oldPos = element.scSize
	local mouseX, mouseY = getMousePosition()
	local scrNX, scrNY = element.HScroll.sl:GetScreenPosition().x, element.VScroll.sl:GetScreenPosition().y

	local firstW, firstH = scrNX-oldPos, scrNY-oldPos
	local secW, secH = mouseX-oldMouse, mouseY-oldMouse
	local oldCordX = getPositions(element.HScroll.sl)
	local _, oldCordY = getPositions(element.VScroll.sl)

	local x, y = oldCordX+secW-firstW, oldCordY+secH-firstH

	local w = getSize(element.HScroll.bk:GetSize())
	local _, h = getSize(element.VScroll.bk:GetSize())
	w, h = w-60, h-60

	if x < 0 then x = 0
	elseif x > w then x = w
	end
	if y < 0 then y = 0
	elseif y > h then y = h
	end

	local sizesW, sizesH = getSize(element.Back:GetSize())
			
	if sizesW-10 > element.MinW then x = 0
	else

		local sx, sy = getPositions(element)
		local scrollPerc = (x/w)

		sx = -scrollPerc*(element.MinW-(sizesW-10))

		if topbot == "horz" then
			setPosition(element, sx, sy)
		end
	end

	if sizesH-10 > element.MinH then x = 0
	else

		local sx, sy = getPositions(element)
		local scrollPerc = (y/h)

		sy = -scrollPerc*(element.MinH-(sizesH-10))


		if topbot == "vert" then
			setPosition(element, sx, sy)
		end

	end

	if topbot == "vert" then
		 setPosition(element.VScroll.sl, 1, y)
	end
	if topbot == "horz" then
		 setPosition(element.HScroll.sl, x, 1)
	end
end

function addObjectOnPane(object, pane)
	local x, y = getPositions(object)
	local w, h = getSize(object:GetSize())

	if x+w > pane.MinW then pane.MinW = x+w end
	if y+h > pane.MinH then pane.MinH = y+h end

	setSize(pane, pane.MinW, pane.MinH)


	addEvent(object, "onResize", function()

		local ax, ay = getPositions(object)
		local aw, ah = getSize(object:GetSize())

		if ax > x then pane.MinW = ax+aw end
		if ay > y then pane.MinH = ay+ah end

	end)
end

function setPaneMinSizes(pane, w, h)
	pane.MinW, pane.MinH = w, h

	local aw, ah = getSize(pane.Back:GetSize())

	if aw-10 > w then aw = aw-10 else aw = pane.MinW end
	if ah-10 > h then ah = ah-10 else ah = pane.MinH end

	setSize(pane, aw, ah)
end

------------------------------------------------------------
--============= ФУНКЦИИ УСТАНОВКИ ПАРАМЕТРОВ =============--
------------------------------------------------------------

--Функция по установке иконки для окна
function setAppIcon(element, iconDir)
	
	--Если элемент не является окном, то закрыть действие
	if getType(element) ~= "frame" then 
		print("Error with FRAME ICON: element is not frame")
		return false 
	end

	element:SetIcon(wx.wxIcon(iconDir, 0))
end

--Положение и размер
function setPosition(element, x, y) return element:Move(wx.wxPoint(x, y)) end
function setSize(element, w, h) return element:SetSize(wx.wxSize(w, h)) end
--Шрифт
function setFont(element, name, size, fam, style, weig, ulin) 

	--Семейство шрифтов (если заданный шрифт их поддерживает)
	if fam == "decor" 		then fam = wx.wxFONTFAMILY_DECORATIVE	--Стиль декоративный
	elseif fam == "formal" 	then fam = wx.wxFONTFAMILY_ROMAN		--Стиль как у Times New Roman
	elseif fam == "hwrite" 	then fam = wx.wxFONTFAMILY_SCRIPT		--Стиль рукописного ввода
	elseif fam == "serif" 	then fam = wx.wxFONTFAMILY_SWISS		--Стиль с засечками
	elseif fam == "modern" 	then fam = wx.wxFONTFAMILY_MODERN		--Современный стиль
	elseif fam == "mono" 	then fam = wx.wxFONTFAMILY_TELETYPE		--Стиль моношрифта 
	elseif fam == "max" 	then fam = wx.wxFONTFAMILY_MAX			--Смесь стилей

	else fam = wx.wxFONTFAMILY_Current end 							--Стандартный (regular)

	--Стиль шрифта
	if style == "italic" 	then style = wx.wxFONTSTYLE_ITALIC		--Шрифт с наклоном
	elseif style == "slant" then style = wx.wxFONTSTYLE_SLANT		--Шрифт со скосом

	else style = wx.wxFONTSTYLE_NORMAL end							--Стандартный (без наклона)

	--Толщина шрифта
	if weig == "bold" 		then weig = wx.wxFONTWEIGHT_BOLD		--Жирный шрифт
	elseif weig == "light" 	then weig = wx.wxFONTWEIGHT_LIGHT		--Тонкий шрифт

	else weig = wx.wxFONTWEIGHT_NORMAL end 							--Стандартный (regular)

	--Возвращение результата функции установки шрифта (Ulin - подчёркивание - underline)
	return element:SetFont(wx.wxFont(size, fam, style, weig, ulin, name)) 

end

--Установка цвета элементу
function setColor(element, back, main)
	element:SetForegroundColour(wx.wxColour(fromHEXToRGB(main)))
	element:SetBackgroundColour(wx.wxColour(fromHEXToRGB(back)))
end

--Установка текста элементу
function setText(element, text) 
	if getType(element) == "edit" or getType(element) == "spin" then
		--Для поля ввода своя функция 
		return element:SetValue(tostring(text)), (getType(element) == "edit" and element:SetInsertionPoint(element:GetValue():len()) or nil)
	else 
		--Для других - своя
		return element:SetLabel(tostring(text)) 
	end
end

--Установка альфаканала
function setAlpha(element, alpha)
	--Получение цвета
	local r, g, b = getColor(element)

	r, g, b = --Установим цвет элемента в зависимости от его текущей прозрачности и сохранённой
		(r or 255)*alpha/(elementAlpha[element] or 1), 
		(g or 255)*alpha/(elementAlpha[element] or 1), 
		(b or 255)*alpha/(elementAlpha[element] or 1)

	if r > 255 then r = 255 end
	if g > 255 then g = 255 end
	if b > 255 then b = 255 end

	elementAlpha[element] = alpha 		--Сохранение альфаканала

	--Установка цвета
	setColor(element, fromRGBToHEX(r, g, b), getColor(element, true, true))

end


------------------------------------------------------------
--============= ФУНКЦИИ ПОЛУЧЕНИЯ ПАРАМЕТРОВ =============--
------------------------------------------------------------

--Функция для получения шрифта
function getFont(element) return element:GetFont() end

function getIcon(iconDir) return wx.wxIcon(iconDir, 0) end

--Функция получения альфаканала
function getAlpha(element) return elementAlpha[element] or 1 end

function getColFromColour(colour, ishex)
	
	local color = colour:GetAsString()

	color = nonRGBCol(color)

	color = (( color:sub(1, -2) ):gsub("rgb", ""):gsub("a", ""):gsub(",", "") ):sub(2, -1)
	
	--print(getColor)
	local zap1, zap2, zap3 = color:match("(%d+) (%d+) (%d+)")
	
	if not ishex then 
		--То вернёт три числа
		return tonumber(zap1), tonumber(zap2), tonumber(zap3)
	else
		return string.format("%.2x%.2x%.2x", tonumber(zap1), tonumber(zap2), tonumber(zap3))
	end
end

--Получение цвета
function getColor(element, typ, ishex)
	--typ - true для получения цвета текста/передней части элемента, 
	--false - для получения цвета задней части элемента

	--Получаем цвет элемента с типом wxColour
	local color = tostring(element:GetBackgroundColour():GetAsString())
	if typ then color = tostring(element:GetForegroundColour():GetAsString()) end

	color = nonRGBCol(color)

	color = (( color:sub(1, -2) ):gsub("rgb", ""):gsub("a", ""):gsub(",", "") ):sub(2, -1)

	--print(getColor)
	local zap1, zap2, zap3 = color:match("(%d+) (%d+) (%d+)")
	
	--Если не требуется HEX-кодирование
	if not ishex then 
		--То вернёт три числа
		return tonumber(zap1), tonumber(zap2), tonumber(zap3)
	else
		return string.format("%.2x%.2x%.2x", tonumber(zap1), tonumber(zap2), tonumber(zap3))
	end

end
function nonRGBCol(color)

	if tostring(color) == "white" then color = "rgb(255, 255, 255)"
	elseif tostring(color) == "black" then color = "rgb(0, 0, 0)" 
	elseif tostring(color) == "red" then color = "rgb(255, 0, 0)" 
	elseif tostring(color) == "yellow" then color = "rgb(255, 255, 0)"
	elseif tostring(color) == "blue" then color = "rgb(0, 0, 255)"
	elseif tostring(color) == "green" then color = "rgb(0, 255, 0)"
	elseif tostring(color) == "brown" then color = "rgb(165, 42, 42)"
	elseif tostring(color) == "pink" then color = "rgb(255, 192, 203)"
	end

	return color
end
--Получение текста от элемента
function getText(element) 
	--Аналогично функции выше
	if getType(element) == "edit" or getType(element) == "spin" then
		--У эдитбокса своя 
		return element:GetValue()
	else 
		--Для других своя
		return element:GetLabel() 
	end
end

function getEventPositions(evt) return evt:GetPositionXY() end
function getEventSizes(evt) return evt:GetClientSizeWH() end

function getSize(sizes)
	return sizes:GetWidth(), sizes:GetHeight()
end
function getPositions(sizes)
	return sizes:GetPositionXY()
end


--------------------------------------------------------------
--==================РАБОТА С СОБЫТИЯМИ======================--
--------------------------------------------------------------

--Функция по переводу текстового названия события в числовой
function getEventID(name, key)

	name = 
		tonumber(tableOfEvents[name]) or 
		--tonumber(tableOfEvents[name][key or "all"]) or 
		tostring(tableOfEvents[name][key or "all"]) or nil
	return name

end

--Функция по созданию события
function addEvent(element, name, funct, key)

	--print(name)
	--Если нет элемента, то не делать ничего
	if not element then 
		print("Error with EVENT HANDLING: needs element")
		return false 
	end

	local id = wx.wxID_ANY

	local savedName = tostring(name)
	--Получаем номер события через название
	name = getEventID(name, key)

	if tostring(name) == "onMenu" or getType(element) == "coldiag" then id = key end	
	if tostring(name) == "onMouseDown" or tostring(name) == "onMouseUp" or tostring(name) == "onMouseDoubleClick" or tostring(name) == "onResize" then
		if not key then key = "all" end
	end


	if tostring(name) == "onMouseDown" or tostring(name) == "onMouseUp" or tostring(name) == "onMouseDoubleClick" then

		element:Connect(id, tableOfEvents[name].right, function(evt) funct(evt, "right") end)
		element:Connect(id, tableOfEvents[name].middle, function(evt) funct(evt, "middle") end)

		name = tableOfEvents[name].left

	elseif tostring(name) == "onResize" then

		element:Connect(id, tableOfEvents[name].max, function(evt) funct(evt, "max") end)
		name = tableOfEvents[name].resize

	end

	--Если события не существует
	if not tonumber(name) then 
		print("Error with EVENT HANDLING: no event for \""..tostring(name).."\"")
		return false 
	end

	local evs = savedName == "onResize" and "max" or "left"
	element:Connect(id, tonumber(name), function(evt) 
		
		if savedName == "onWheel" then 
			key = evt:GetWheelRotation() 
			if key > 0 then key = "up"
			else key = "down" end
		end

		funct(evt, key == "all" and evs or key) 
		evt:Skip()
	end)
	
	if funTab[element] == nil then funTab[element] = {} end
	funTab[element][name] = funct
	--print("funTab["..tostring(element).."]["..name.."]")
end

--Функция по вызову созданного события
function executeEvent(element, name, key, but)

	--Получаем ID события по имени
	local oldName = name --Сохраним для ошибки
	name = getEventID(name, key)

	--Если в таблице функций нет такого элемента
	if not funTab[element] then
		--То прервать функцию
		print("Error with EXECUTING EVENT: events for this element not handled")
		return false
	end

	if tostring(name) == "onMouseDown" or tostring(name) == "onMouseUp" or tostring(name) == "onMouseDoubleClick" then
		name = tableOfEvents[name].left

	elseif tostring(name) == "onResize" then
		name = tableOfEvents[name].resize

	end

	--Если в таблице есть элемент, но нет ID события на него
	if not funTab[element][name] then
		--То прервать функцию
		print("Error with EXECUTING EVENT: event \""..oldName.."\" not handled")
		return false
	end


	--исполняем функцию события
	funTab[element][name](key, but)
	--print("funTab["..tostring(element).."]["..name.."]")
end


--------------------------------------------------------------
--==================ФУНКЦИИ ПРИЛОЖЕНИЯ======================--
--------------------------------------------------------------

--Отцентровка элемента
function centerElement(element) return element:Centre() end

--Помещение окна вперёд
function bringToFront(element)
	if getType(element) == "frame" then
		element:Iconize(false)
		element:SetFocus()
		element:Raise()
	end
end

--Запустить приложение
function runApplication() return wx.wxGetApp():MainLoop() end
function closeApplication() return wx.wxGetApp():Exit() end

function getScreenSize()
	x, y = getSize( wx.wxDisplay():GetGeometry():GetSize() )
	return x, y
end

function getMousePosition()
	local n = wx.wxGetMousePosition()
	local x, y = n.x, n.y

	--print(x, y)
	return x, y
end

--print(getScreenSize())