--Таблица символов
tableChars = {
	[wx.WXK_BACK] 		= "backspace",
	
	[wx.WXK_TAB] 		= "tab",

	[wx.WXK_RETURN] 	= "enter",
	[wx.WXK_ESCAPE] 	= "esc",
	[wx.WXK_SPACE] 		= "space",

	[wx.WXK_DELETE] 	= "delete",

	[wx.WXK_SHIFT] 		= "shift",
	[wx.WXK_ALT] 		= "alt",
	[wx.WXK_CONTROL] 	= "ctrl",

	[wx.WXK_MENU] 		= "menu",

	[wx.WXK_PAUSE] 		= "pause",
	[wx.WXK_HOME] 		= "home",

	[wx.WXK_LEFT] 		= "a_left",
	[wx.WXK_RIGHT] 		= "a_right",
	[wx.WXK_UP] 		= "a_up",
	[wx.WXK_DOWN] 		= "a_down",

	[wx.WXK_PRINT] 		= "prtsc",
	[wx.WXK_INSERT] 	= "insert",

	[wx.WXK_NUMPAD1] 	= "num_1",
	[wx.WXK_NUMPAD2] 	= "num_2",
	[wx.WXK_NUMPAD3] 	= "num_3",
	[wx.WXK_NUMPAD4] 	= "num_4",
	[wx.WXK_NUMPAD5] 	= "num_5",
	[wx.WXK_NUMPAD6] 	= "num_6",
	[wx.WXK_NUMPAD7] 	= "num_7",
	[wx.WXK_NUMPAD8] 	= "num_8",
	[wx.WXK_NUMPAD9] 	= "num_9",
	[wx.WXK_NUMPAD0] 	= "num_0",

	[wx.WXK_MULTIPLY] 	= "*",
	[wx.WXK_ADD] 		= "+",
	[wx.WXK_SUBTRACT] 	= "-",
	[wx.WXK_DECIMAL] 	= ".",
	[wx.WXK_DIVIDE] 	= "/",

	[wx.WXK_NUMLOCK] 	= "numlock",

	[wx.WXK_PAGEUP] 	= "pgup",
	[wx.WXK_PAGEDOWN] 	= "pgdn",

	[wx.WXK_F1] 		= "f1",
	[wx.WXK_F2] 		= "f2",
	[wx.WXK_F3] 		= "f3",
	[wx.WXK_F4] 		= "f4",
	[wx.WXK_F5] 		= "f5",
	[wx.WXK_F6] 		= "f6",
	[wx.WXK_F7] 		= "f7",
	[wx.WXK_F8] 		= "f8",
	[wx.WXK_F9] 		= "f9",
	[wx.WXK_F10] 		= "f10",
	[wx.WXK_F11] 		= "f11",
	[wx.WXK_F12] 		= "f12",
	[wx.WXK_F13] 		= "f13",
	[wx.WXK_F14] 		= "f14",
	[wx.WXK_F15] 		= "f15",
	[wx.WXK_F16] 		= "f16",
	[wx.WXK_F17] 		= "f17",
	[wx.WXK_F18] 		= "f18",
	[wx.WXK_F19]	 	= "f19",
	[wx.WXK_F20]	 	= "f20",
	[wx.WXK_F21]	 	= "f21",
	[wx.WXK_F22]	 	= "f22",
	[wx.WXK_F23]	 	= "f23",
	[wx.WXK_F24]	 	= "f24",

	--Numpad keyboard

	[wx.WXK_NUMPAD_SPACE] 		= "num_space",
	[wx.WXK_NUMPAD_TAB] 		= "num_tab",
	[wx.WXK_NUMPAD_ENTER] 		= "num_enter",

	[wx.WXK_NUMPAD_F1] 			= "num_f1",
	[wx.WXK_NUMPAD_F2] 			= "num_f2",
	[wx.WXK_NUMPAD_F3] 			= "num_f3",
	[wx.WXK_NUMPAD_F4] 			= "num_f4",

	[wx.WXK_NUMPAD_LEFT] 		= "num_left",
	[wx.WXK_NUMPAD_RIGHT] 		= "num_right",
	[wx.WXK_NUMPAD_UP] 			= "num_up",
	[wx.WXK_NUMPAD_DOWN] 		= "num_down",

	[wx.WXK_NUMPAD_HOME] 		= "num_home",
	[wx.WXK_NUMPAD_PAGEUP] 		= "num_pgup",
	[wx.WXK_NUMPAD_PAGEDOWN] 	= "num_pgdn",

	[wx.WXK_NUMPAD_END] 		= "num_end",
	[wx.WXK_NUMPAD_INSERT] 		= "num_ins",
	[wx.WXK_NUMPAD_DELETE] 		= "num_del",

	[wx.WXK_NUMPAD_MULTIPLY] 	= "num_mul",
	[wx.WXK_NUMPAD_ADD] 		= "num_add",
	[wx.WXK_NUMPAD_SUBTRACT] 	= "num_sub",
	[wx.WXK_NUMPAD_DIVIDE] 		= "num_div",

	[311] 						= "capslock",
	[383] 						= "num_5",

}

--Таблица событий
tableOfEvents = {
	["onMove"] 		= wx.wxEVT_MOVE							,
	["onEdit"]		= wx.wxEVT_COMMAND_TEXT_UPDATED			,
	["onResize"] 	= {
		["resize"] 	= wx.wxEVT_SIZE							,
		["max"] 	= wx.wxEVT_MAXIMIZE						,
		["all"]		= "onResize"
	}													,
	["onClose"] 	= wx.wxEVT_CLOSE_WINDOW					,
	["onActivate"] 	= wx.wxEVT_ACTIVATE						,
	["onKey"] 		= wx.wxEVT_CHAR_HOOK					,
	["onClick"] 	= wx.wxEVT_COMMAND_BUTTON_CLICKED		,
	["onMenu"]		= wx.wxEVT_COMMAND_MENU_SELECTED		,
	["onMouseMove"] = wx.wxEVT_MOTION						,
	["onSpinEdit"]	= wx.wxEVT_COMMAND_SPINCTRL_UPDATED		,
	["onMouseDown"] = 
	{
		["left"]	= wx.wxEVT_LEFT_DOWN						, 
		["right"] 	= wx.wxEVT_RIGHT_DOWN						, 
		["middle"]	= wx.wxEVT_MIDDLE_DOWN						,
		["all"]		= "onMouseDown"								
	}														,	
	["onMouseUp"] 	= 
	{
		["left"]	= wx.wxEVT_LEFT_UP							, 
		["right"]	= wx.wxEVT_RIGHT_UP							,  
		["middle"]	= wx.wxEVT_MIDDLE_UP						,
		["all"]		= "onMouseUp"						
	}														,
	["onMouseDoubleClick"] = 
	{
		["left"] 	= wx.wxEVT_LEFT_DCLICK						, 
		["right"]	= wx.wxEVT_RIGHT_DCLICK						,  
		["middle"]	= wx.wxEVT_MIDDLE_DCLICK					,
		["all"]		= "onMouseDoubleClick"				
	}														,
	["onMouseEnter"]= wx.wxEVT_ENTER_WINDOW		,
	["onMouseLeave"]= wx.wxEVT_LEAVE_WINDOW		,
	["onWheel"] 	= 
	{
		["up"] 		= wx.wxEVT_SCROLL_LINEUP	,
		["down"]	= wx.wxEVT_SCROLL_LINEDOWN
	}														,
	["onShows"] 	= wx.wxEVT_SHOW				,
	["onPaint"] 	= wx.wxEVT_PAINT 

}
--Символы, которые будут использоваться в рассчётах
Symbols = {
	Plus = "+",
	Subs = "-", 	--Substract
	Mply = "×", 	--Multiply
	Divd = "÷", 	--Divide
	Sqrt = "√", 	--Squadroot
	Perc = "%", 	--Percent
	Back = "←", 	--Backspace
	Negv = "±", 	--Negative
	Rvrs = "1/x",	--Reverce
	Dots = ".",		--Point/dot
	Inft = "Error", --"∞", 	--Infinite
	Result = "="
}
--Цветовые схемы
colorScheme = {

	Dark = {
		Frame 	= "444444", 	--Цвет внутренней части окна
		Text 	= "EEEEEE", 	--Цвет текста на окне и в основных клавишах
		EditB 	= "404040", 	--Цвет панелей ввода текста
		EditT 	= "EEEEEE", 	--Цвет текста в этих панелях
		ButD 	= "333333", 	--Цвет клавиш с действиями
		ButL 	= "252525", 	--Цвет клавиш с цифрами
		ButM 	= "EEEEEE",		--Цвет текста в клавишах "равно" и "очистить историю"
		Green 	= "2e7d32", 	--Цвет для кнопки "равно"
		Red 	= "b71c1c"		--Цвет для кнопки "очистить историю"
	},

	Light = {
		Frame 	= "EEEEEE", 
		Text 	= "444444", 
		EditB 	= "FFFFFF", 
		EditT 	= "333333", 
		ButD 	= "E4E4E4", 
		ButL 	= "DEDEDE", 
		ButM 	= "EEEEEE",
		Green	= "26c850", 
		Red 	= "df3939"
	},
}

--======================= ДОПОЛНЕНИЯ =======================
function fromHEXToRGB(color)
	--Если 8 символов (AARRGGBB) - то вернёт 4 числа - r, g, b, a
    if tostring(color):len() == 8 then
    	return 
    		tonumber(color:sub(3, 4), 16), 
    		tonumber(color:sub(5, 6), 16), 
    		tonumber(color:sub(7, 8), 16), 
    		tonumber(color:sub(1, 2), 16)
    --Если 6 символов (RRGGBB) - то вернёт 3 числа - r, g, b
    elseif tostring(color):len() == 6 then 
    	return 
    		tonumber(color:sub(1, 2), 16), 
    		tonumber(color:sub(3, 4), 16), 
    		tonumber(color:sub(5, 6), 16)
    end
end

function fromRGBToHEX(r, g, b, a)
	if a then
		return 
			string.format("%.2x%.2x%.2x%.2x", a or 0, r or 0, g or 0, b or 0)
	else
		return 
			string.format("%.2x%.2x%.2x", r or 0, g or 0, b or 0)
	end
end
function randomHex(alphat)
	if alphat then

		return 
			string.format("%.2x%.2x%.2x%.2x", 
				math.random(0, 255), 
				math.random(0, 255), 
				math.random(0, 255), 
				math.random(0, 255)
			)
	else
		return 
			string.format("%.2x%.2x%.2x", 
				math.random(0, 255), 
				math.random(0, 255), 
				math.random(0, 255)
			)
	end

end
