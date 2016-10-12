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

	--Получаем текстовый идентификатор элемента
	local name = tostring(element) --Вернёт "table:0xXXXXXXXX (wxName:0xXXXXXXXX)"

	--переменная на вывод - тип элемента
	local typs = nil
	
	--Если в идентификаторе будет найдено wxButton, StaticText, etc
	if name:find("wxButton") 			then typs = "button" --То вернёт кнопку
	elseif name:find("wxStaticText") 	then typs = "label"
	elseif name:find("wxTextCtrl") 		then typs = "edit"
	elseif name:find("wxFrame") 		then typs = "frame"
	elseif name:find("wxPaintDC") 		then typs = "paint"

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
		style 				or wx.wxDEFAULT_FRAME_STYLE
	)
	
	frame:Show(true)

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
		print("Error with CREATING EDIT: needs parent")
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

	--Вернуть
	return panel, id
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

	else fam = wx.wxFONTFAMILY_DEFAULT end 							--Стандартный (regular)

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
	if getType(element) == "edit" then
		--Для поля ввода своя функция 
		return element:SetValue(tostring(text)), element:SetInsertionPoint(element:GetValue():len())
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

--Получение цвета
function getColor(element, typ, ishex)
	--typ - true для получения цвета текста/передней части элемента, 
	--false - для получения цвета задней части элемента

	--Получаем цвет элемента с типом wxColour
	local color = tostring(element:GetBackgroundColour():GetAsString())
	if typ then color = tostring(element:GetForegroundColour():GetAsString()) end

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
--Получение текста от элемента
function getText(element) 
	--Аналогично функции выше
	if getType(element) == "edit" then
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


--------------------------------------------------------------
--==================РАБОТА С СОБЫТИЯМИ======================--
--------------------------------------------------------------

--Функция по переводу текстового названия события в числовой
function getEventID(element, name, key)

	name = tonumber(tableOfEvents[name]) or tonumber(tableOfEvents[name][key or "left" or "up"]) or nil
	return name

end

--Функция по созданию события
function addEvent(element, name, funct, key)

	--Если нет элемента, то не делать ничего
	if not element then 
		print("Error with EVENT HANDLING: needs element")
		return false 
	end

	local id = wx.wxID_ANY
	if name == "onMenu" then id = key end	
	--Получаем номер события через название
	name = getEventID(element, name, key)

	--Если события не существует
	if not tonumber(name) then 
		print("Error with EVENT HANDLING: no event for \""..tostring(name).."\"")
		return false 
	end

	local ret = element:Connect(id, name, funct)
	
	if funTab[element] == nil then funTab[element] = {} end
	funTab[element][name] = funct
end

--Функция по вызову созданного события
function executeEvent(element, name, key)

	--Получаем ID события по имени
	local oldName = name --Сохраним для ошибки
	name = getEventID(element, name, key)

	--Если в таблице функций нет такого элемента
	if not funTab[element] then
		--То прервать функцию
		print("Error with EXECUTING EVENT: events for this element not handled")
		return false
	end

	--Если в таблице есть элемент, но нет ID события на него
	if not funTab[element][name] then
		--То прервать функцию
		print("Error with EXECUTING EVENT: event \""..oldName.."\" not handled")
		return false
	end

	--исполняем функцию события
	funTab[element][name](key)
end


--------------------------------------------------------------
--==================ФУНКЦИИ ПРИЛОЖЕНИЯ======================--
--------------------------------------------------------------

--Отцентровка элемента
function centerElement(element) return element:Centre() end

--Запустить приложение
function runApplication() return wx.wxGetApp():MainLoop() end