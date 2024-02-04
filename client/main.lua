local activeMenu

-- Global functions
-- [ Post | Open | Closed ]

function Post(fn, ...)
	SendNUIMessage({
		func = fn,
		args = { ... }
	})
end

function Open(position, eles, onSelect, onClose, canClose)
	local canClose = canClose == nil and true or canClose
	activeMenu = {
		position = position,
		eles = eles,
		canClose = canClose,
		onSelect = onSelect,
		onClose = onClose
	}

	LocalPlayer.state:set('context:active', true)

	Post('Open', eles, position)
end

function Closed()
	SetNuiFocus(false, false)

	local menu = activeMenu
	local cb = menu.onClose

	activeMenu = nil

	LocalPlayer.state:set('context:active', false)

	if cb then
		cb(menu)
	end
end

-- Exports
-- [ Preview | Open | Close ]

exports('PreviewMenu', Open)

exports('OpenMenu', function(...)
	Open(...)
	SetNuiFocus(true, true)
end)

exports('CloseMenu', function()
	if not activeMenu then
		return
	end

	Post('Closed')

	Closed()
end)

exports('RefreshMenu', function(eles, position)
	if not activeMenu then
		return
	end

	activeMenu.eles = eles or activeMenu.eles
	activeMenu.position = position or activeMenu.position

	Post('Open', activeMenu.eles, activeMenu.position)
end)

-- NUI Callbacks
-- [ closed | selected | changed ]

RegisterNUICallback('closed', function(_, cb)
	if not activeMenu or (activeMenu and not activeMenu.canClose) then
		return cb(false)
	end
	cb(true)
	Closed()
end)

RegisterNUICallback('selected', function(data, cb)
	if not activeMenu or not activeMenu.onSelect or not data.index then
		return
	end

	local index = tonumber(data.index)
	local ele = activeMenu.eles[index]

	if not ele or ele.input then
		return
	end

	activeMenu:onSelect(ele)
	if cb then cb('ok') end
end)

RegisterNUICallback('changed', function(data, cb)
	if not activeMenu or not data.index or not data.value then
		return
	end

	local index = tonumber(data.index)
	local ele = activeMenu.eles[index]

	if not ele or not ele.input then
		return
	end

	if ele.inputType == 'number' then
		ele.inputValue = tonumber(data.value)

		if ele.inputMin then
			ele.inputValue = math.max(ele.inputMin, ele.inputValue)
		end

		if ele.inputMax then
			ele.inputValue = math.min(ele.inputMax, ele.inputValue)
		end
	elseif ele.inputType == 'text' then
		ele.inputValue = data.value
	elseif ele.inputType == 'radio' then
		ele.inputValue = data.value
	end
	if cb then cb('ok') end
end)

-- Keybind

local function focusPreview()
	if not activeMenu or not activeMenu.onSelect then
		return
	end

	SetNuiFocus(true, true)
end

if PREVIEW_KEYBIND then
	RegisterCommand('previewContext', focusPreview, false)

	RegisterKeyMapping('previewContext', 'Preview Active Context', 'keyboard', PREVIEW_KEYBIND)
end

exports('focusPreview', focusPreview)