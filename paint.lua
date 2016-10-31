infoText = [[
Автор: 				Максимов Павел (Б8103а)
Известен как: 		Arios Jentu
Начало работы: 	12.10.2016

GitHub: 			github.com/AriosJentu
VK: 				vk.com/AriosJentu

Проект распространяется свободно]]

--Директория пакетов
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
--Запуск модуля WXWidgets
wx = require("wx")

--Переменная, отвечающая за то, в какой директории на данный момент запускается программа
APPDIR = arg[0]:gsub("paint.lua", "")

--Подключение модулей:
--1) Набор таблиц - таблица событий и таблица символов
dofile(APPDIR.."defaultTables.lua")
--2) Библиотека функций работы с графикой, ключами и событиями
dofile(APPDIR.."frameLibrary.lua")
--3) Библиотека функций по рисованию
dofile(APPDIR.."drawLibrary.lua")
--5) Библиотека функций по работе с кистями
dofile(APPDIR.."brushUtils.lua")

--4) Окно приложения
dofile(APPDIR.."gui.lua")
--6) События для окна
dofile(APPDIR.."events.lua")


--Запускаем программу
runApplication()
