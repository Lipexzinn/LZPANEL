--// Serviços
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer

--// CONFIG
local FOV_RADIUS = 120
local AIM_NPC_ENABLED = false
local ESP_NPC_ENABLED = false
local AIM_PLAYER_ENABLED = false
local ESP_PLAYER_ENABLED = false
local FLY_ENABLED = false
local NOCLIP_ENABLED = false
local SPEED_ENABLED = false
local DOUBLE_JUMP_ENABLED = false
local GODMODE_ENABLED = false
local SPIN_ENABLED = false
local RUN_ENABLED = false
local GUI_VISIBLE = false
local TEAMCHECK_ENABLED = true
local TELEPORT_TO_CLICK_ENABLED = false
local SCARY_ENABLED = false

--// AIMBOT PLAYER IMPROVEMENTS
local AIMBOT_SMOOTHNESS = 0.15
local AIMBOT_PREDICTION = true
local AIMBOT_PREDICTION_STRENGTH = 0.8
local AIMBOT_LOCK_RANGE = 150
local AIMBOT_FOV_STRICTNESS = 0.85
local AIMBOT_VISIBILITY_CHECK = true

--// Controle de botão direito
local RIGHT_MOUSE_PRESSED = false

local NPC_SCAN_INTERVAL = 2.5
local PLAYER_SCAN_INTERVAL = 0.5
local TARGET_UPDATE_INTERVAL = 0.05
local ESP_UPDATE_INTERVAL = 0.08
local PLAYER_LIST_REFRESH_INTERVAL = 0.6
local COPY_LIST_REFRESH_INTERVAL = 0.6

local FLY_SPEED = 70
local SPEED_VALUE = 35
local SPIN_SPEED = 100

--// Lista de players ignorados
local ignoredPlayers = {}

--// CUSTOM TELEPORT
local customTeleports = {}

--// SCARY MODE
local scaryBackup = {}

--// GUI PRINCIPAL
local gui = Instance.new("ScreenGui")
gui.Name = "LZPainel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// NOTIFICAÇÃO DE EXECUÇÃO
local notification = Instance.new("Frame")
notification.Size = UDim2.new(0, 380, 0, 65)
notification.Position = UDim2.new(0.5, -190, 1, -80)
notification.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
notification.BorderSizePixel = 2
notification.BorderColor3 = Color3.fromRGB(0, 255, 100)
notification.Parent = gui
notification.ZIndex = 999

local notifCorner = Instance.new("UICorner", notification)
notifCorner.CornerRadius = UDim.new(0, 10)

local notifStroke = Instance.new("UIStroke", notification)
notifStroke.Color = Color3.fromRGB(0, 255, 100)
notifStroke.Thickness = 2
notifStroke.Transparency = 0

local notifTitle = Instance.new("TextLabel")
notifTitle.Size = UDim2.new(1, -20, 0, 25)
notifTitle.Position = UDim2.new(0, 10, 0, 8)
notifTitle.BackgroundTransparency = 1
notifTitle.Text = "SCRIPT EXECUTADO COM SUCESSO!"
notifTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
notifTitle.Font = Enum.Font.GothamBold
notifTitle.TextSize = 16
notifTitle.TextXAlignment = Enum.TextXAlignment.Center
notifTitle.ZIndex = 1000
notifTitle.Parent = notification

local notifDesc = Instance.new("TextLabel")
notifDesc.Size = UDim2.new(1, -20, 0, 22)
notifDesc.Position = UDim2.new(0, 10, 0, 35)
notifDesc.BackgroundTransparency = 1
notifDesc.Text = "Aperte F2 para abrir/fechar o painel"
notifDesc.TextColor3 = Color3.fromRGB(220, 220, 220)
notifDesc.Font = Enum.Font.Gotham
notifDesc.TextSize = 14
notifDesc.TextXAlignment = Enum.TextXAlignment.Center
notifDesc.ZIndex = 1000
notifDesc.Parent = notification

task.spawn(function()
	notification.Position = UDim2.new(0.5, -190, 1, 20)
	notification.BackgroundTransparency = 1
	notifTitle.TextTransparency = 1
	notifDesc.TextTransparency = 1
	notifStroke.Transparency = 1

	local tweenIn = TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -190, 1, -80),
		BackgroundTransparency = 0
	})
	local tweenTextIn = TweenService:Create(notifTitle, TweenInfo.new(0.4), {TextTransparency = 0})
	local tweenTextIn2 = TweenService:Create(notifDesc, TweenInfo.new(0.4), {TextTransparency = 0})
	local tweenStrokeIn = TweenService:Create(notifStroke, TweenInfo.new(0.4), {Transparency = 0})

	tweenIn:Play()
	tweenTextIn:Play()
	tweenTextIn2:Play()
	tweenStrokeIn:Play()

	task.wait(4)

	local tweenOut = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, -190, 1, 20),
		BackgroundTransparency = 1
	})
	local tweenTextOut = TweenService:Create(notifTitle, TweenInfo.new(0.5), {TextTransparency = 1})
	local tweenTextOut2 = TweenService:Create(notifDesc, TweenInfo.new(0.5), {TextTransparency = 1})
	local tweenStrokeOut = TweenService:Create(notifStroke, TweenInfo.new(0.5), {Transparency = 1})

	tweenOut:Play()
	tweenTextOut:Play()
	tweenTextOut2:Play()
	tweenStrokeOut:Play()

	tweenOut.Completed:Wait()
	notification:Destroy()
end)

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 340, 0, 560)
panel.Position = UDim2.new(0.5, -170, 0.5, -280)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundTransparency = 1
title.Text = "LZ PAINEL"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = panel

local panelScroll = Instance.new("ScrollingFrame")
panelScroll.Size = UDim2.new(1, -16, 1, -44)
panelScroll.Position = UDim2.new(0, 8, 0, 36)
panelScroll.CanvasSize = UDim2.new(0, 0, 0, 580)
panelScroll.ScrollBarThickness = 6
panelScroll.BackgroundTransparency = 1
panelScroll.BorderSizePixel = 0
panelScroll.Parent = panel

local panelListLayout = Instance.new("UIListLayout")
panelListLayout.Padding = UDim.new(0, 8)
panelListLayout.Parent = panelScroll

local function createButton(order, text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.86, 0, 0, 40)
	btn.Position = UDim2.new(0.07, 0, 0, 0)
	btn.LayoutOrder = order
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = panelScroll
	Instance.new("UICorner", btn)
	return btn
end

local btnAimbotNPC = createButton(1, "AIMBOT (NPC): OFF")
local btnESPNPC = createButton(2, "ESP (NPC): OFF")
local btnAimbotPlayer = createButton(3, "AIMBOT (PLAYER): OFF")
local btnESPPlayer = createButton(4, "ESP (PLAYER): OFF")
local btnTeleportPlayer = createButton(5, "TELEPORTAR (PLAYER)")
local btnCopyOutfitPlayer = createButton(6, "COPIAR ROUPA (PLAYER)")
local btnCustomTeleport = createButton(7, "CUSTOM TELEPORT")
local btnFollowPlayer = createButton(8, "SEGUIR PLAYER: OFF")
local btnTeleportToClick = createButton(9, "TELEPORT TO CLICK: OFF")
local btnScary = createButton(10, "ASSUSTAR: OFF")
local btnSpin = createButton(11, "GIRAR: OFF")
local btnRun = createButton(12, "CORRER: OFF")
local btnFly = createButton(13, "FLY: OFF")
local btnNoClip = createButton(14, "NOCLIP: OFF")
local btnSpeed = createButton(15, "SPEED: OFF")
local btnDoubleJump = createButton(16, "PULO DUPLO: OFF")
local btnGodMode = createButton(17, "GODMODE: OFF")

local activeSlider = nil
local function createSlider(order, titleText, minValue, maxValue, initialValue, onChanged)
	local wrap = Instance.new("Frame")
	wrap.Size = UDim2.new(0.86, 0, 0, 58)
	wrap.Position = UDim2.new(0.07, 0, 0, 0)
	wrap.LayoutOrder = order
	wrap.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	wrap.BorderSizePixel = 0
	wrap.Parent = panelScroll
	Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -12, 0, 20)
	label.Position = UDim2.new(0, 6, 0, 4)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.Parent = wrap

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -20, 0, 10)
	bar.Position = UDim2.new(0, 10, 0, 34)
	bar.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	bar.BorderSizePixel = 0
	bar.Parent = wrap
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
	fill.BorderSizePixel = 0
	fill.Parent = bar
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(0, 0, 0.5, 0)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.BorderSizePixel = 0
	knob.Parent = bar
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local currentValue = math.clamp(initialValue, minValue, maxValue)
	local function setByAlpha(alpha)
		local value = minValue + (maxValue - minValue) * alpha
		value = math.floor(value + 0.5)
		currentValue = math.clamp(value, minValue, maxValue)
		local normalized = (currentValue - minValue) / (maxValue - minValue)
		fill.Size = UDim2.new(normalized, 0, 1, 0)
		knob.Position = UDim2.new(normalized, 0, 0.5, 0)
		label.Text = string.format("%s: %d", titleText, currentValue)
		onChanged(currentValue)
	end

	local function setFromMouse(mouseX)
		local x = mouseX - bar.AbsolutePosition.X
		local alpha = math.clamp(x / math.max(1, bar.AbsoluteSize.X), 0, 1)
		setByAlpha(alpha)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			activeSlider = setFromMouse
			setFromMouse(input.Position.X)
		end
	end)

	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			activeSlider = setFromMouse
			setFromMouse(input.Position.X)
		end
	end)

	setByAlpha((currentValue - minValue) / (maxValue - minValue))
end

createSlider(18, "Fly Velocidade", 20, 220, FLY_SPEED, function(v)
	FLY_SPEED = v
end)

createSlider(19, "Speed Velocidade", 16, 220, SPEED_VALUE, function(v)
	SPEED_VALUE = v
end)

createSlider(20, "Spin Velocidade", 10, 250, SPIN_SPEED, function(v)
	SPIN_SPEED = v
end)

--// Painel secundário de teleporte
local tpPanel = Instance.new("Frame")
tpPanel.Size = UDim2.new(0, 270, 0, 425)
tpPanel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 355, panel.Position.Y.Scale, panel.Position.Y.Offset)
tpPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tpPanel.BorderSizePixel = 0
tpPanel.Visible = false
tpPanel.Parent = gui
Instance.new("UICorner", tpPanel).CornerRadius = UDim.new(0, 10)

local tpTitle = Instance.new("TextLabel")
tpTitle.Size = UDim2.new(1, 0, 0, 32)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "TELEPORTAR (PLAYER)"
tpTitle.TextColor3 = Color3.new(1, 1, 1)
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 14
tpTitle.Parent = tpPanel

local tpScroll = Instance.new("ScrollingFrame")
tpScroll.Size = UDim2.new(1, -16, 1, -44)
tpScroll.Position = UDim2.new(0, 8, 0, 36)
tpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tpScroll.ScrollBarThickness = 6
tpScroll.BackgroundTransparency = 1
tpScroll.BorderSizePixel = 0
tpScroll.Parent = tpPanel

local tpListLayout = Instance.new("UIListLayout")
tpListLayout.Padding = UDim.new(0, 6)
tpListLayout.Parent = tpScroll

--// Painel secundário de copiar roupa
local copyPanel = Instance.new("Frame")
copyPanel.Size = UDim2.new(0, 270, 0, 425)
copyPanel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 630, panel.Position.Y.Scale, panel.Position.Y.Offset)
copyPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
copyPanel.BorderSizePixel = 0
copyPanel.Visible = false
copyPanel.Parent = gui
Instance.new("UICorner", copyPanel).CornerRadius = UDim.new(0, 10)

local copyTitle = Instance.new("TextLabel")
copyTitle.Size = UDim2.new(1, 0, 0, 32)
copyTitle.BackgroundTransparency = 1
copyTitle.Text = "COPIAR ROUPA (PLAYER)"
copyTitle.TextColor3 = Color3.new(1, 1, 1)
copyTitle.Font = Enum.Font.GothamBold
copyTitle.TextSize = 14
copyTitle.Parent = copyPanel

local copyScroll = Instance.new("ScrollingFrame")
copyScroll.Size = UDim2.new(1, -16, 1, -44)
copyScroll.Position = UDim2.new(0, 8, 0, 36)
copyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
copyScroll.ScrollBarThickness = 6
copyScroll.BackgroundTransparency = 1
copyScroll.BorderSizePixel = 0
copyScroll.Parent = copyPanel

local copyListLayout = Instance.new("UIListLayout")
copyListLayout.Padding = UDim.new(0, 6)
copyListLayout.Parent = copyScroll

--// Painel secundário de custom teleport
local customTpPanel = Instance.new("Frame")
customTpPanel.Size = UDim2.new(0, 270, 0, 425)
customTpPanel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 630, panel.Position.Y.Scale, panel.Position.Y.Offset)
customTpPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
customTpPanel.BorderSizePixel = 0
customTpPanel.Visible = false
customTpPanel.Parent = gui
Instance.new("UICorner", customTpPanel).CornerRadius = UDim.new(0, 10)

local customTpTitle = Instance.new("TextLabel")
customTpTitle.Size = UDim2.new(1, 0, 0, 32)
customTpTitle.BackgroundTransparency = 1
customTpTitle.Text = "CUSTOM TELEPORT"
customTpTitle.TextColor3 = Color3.new(1, 1, 1)
customTpTitle.Font = Enum.Font.GothamBold
customTpTitle.TextSize = 14
customTpTitle.Parent = customTpPanel

local customTpInputFrame = Instance.new("Frame")
customTpInputFrame.Size = UDim2.new(1, -16, 0, 50)
customTpInputFrame.Position = UDim2.new(0, 8, 0, 36)
customTpInputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
customTpInputFrame.BorderSizePixel = 0
customTpInputFrame.Parent = customTpPanel
Instance.new("UICorner", customTpInputFrame).CornerRadius = UDim.new(0, 6)

local customTpInput = Instance.new("TextBox")
customTpInput.Size = UDim2.new(1, -8, 1, -8)
customTpInput.Position = UDim2.new(0, 4, 0, 4)
customTpInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
customTpInput.BorderSizePixel = 0
customTpInput.TextColor3 = Color3.new(1, 1, 1)
customTpInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
customTpInput.PlaceholderText = "Nome do teleporte"
customTpInput.Font = Enum.Font.Gotham
customTpInput.TextSize = 12
customTpInput.Parent = customTpInputFrame
Instance.new("UICorner", customTpInput).CornerRadius = UDim.new(0, 4)

local customTpSaveBtn = Instance.new("TextButton")
customTpSaveBtn.Size = UDim2.new(1, -16, 0, 35)
customTpSaveBtn.Position = UDim2.new(0, 8, 0, 92)
customTpSaveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
customTpSaveBtn.BorderSizePixel = 0
customTpSaveBtn.TextColor3 = Color3.new(1, 1, 1)
customTpSaveBtn.Font = Enum.Font.GothamBold
customTpSaveBtn.TextSize = 12
customTpSaveBtn.Text = "SALVAR"
customTpSaveBtn.Parent = customTpPanel
Instance.new("UICorner", customTpSaveBtn).CornerRadius = UDim.new(0, 6)

local customTpScroll = Instance.new("ScrollingFrame")
customTpScroll.Size = UDim2.new(1, -16, 1, -145)
customTpScroll.Position = UDim2.new(0, 8, 0, 133)
customTpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
customTpScroll.ScrollBarThickness = 6
customTpScroll.BackgroundTransparency = 1
customTpScroll.BorderSizePixel = 0
customTpScroll.Parent = customTpPanel

local customTpListLayout = Instance.new("UIListLayout")
customTpListLayout.Padding = UDim.new(0, 6)
customTpListLayout.Parent = customTpScroll

--// Painel secundário de seguir player
local followPanel = Instance.new("Frame")
followPanel.Size = UDim2.new(0, 270, 0, 425)
followPanel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 905, panel.Position.Y.Scale, panel.Position.Y.Offset)
followPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
followPanel.BorderSizePixel = 0
followPanel.Visible = false
followPanel.Parent = gui
Instance.new("UICorner", followPanel).CornerRadius = UDim.new(0, 10)

local followTitle = Instance.new("TextLabel")
followTitle.Size = UDim2.new(1, 0, 0, 32)
followTitle.BackgroundTransparency = 1
followTitle.Text = "SEGUIR PLAYER"
followTitle.TextColor3 = Color3.new(1, 1, 1)
followTitle.Font = Enum.Font.GothamBold
followTitle.TextSize = 14
followTitle.Parent = followPanel

local followScroll = Instance.new("ScrollingFrame")
followScroll.Size = UDim2.new(1, -16, 1, -44)
followScroll.Position = UDim2.new(0, 8, 0, 36)
followScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
followScroll.ScrollBarThickness = 6
followScroll.BackgroundTransparency = 1
followScroll.BorderSizePixel = 0
followScroll.Parent = followPanel

local followListLayout = Instance.new("UIListLayout")
followListLayout.Padding = UDim.new(0, 6)
followListLayout.Parent = followScroll

--// Estado de input Fly
local flyInput = {
	W = false,
	A = false,
	S = false,
	D = false,
	Space = false,
	Ctrl = false,
}

--// Utilitários de posição/estado
local TELEPORT_PANEL_VISIBLE = false
local COPY_PANEL_VISIBLE = false
local CUSTOM_TP_PANEL_VISIBLE = false
local FOLLOW_PANEL_VISIBLE = false
local FOLLOW_ENABLED = false
local followTargetPlayer = nil
local speedBaseWalk = nil
local lastJumpRequest = 0
local lastFollowListUpdate = 0
local FOLLOW_LIST_REFRESH_INTERVAL = 0.6
local lastCustomTpListUpdate = 0
local CUSTOM_TP_LIST_REFRESH_INTERVAL = 0.6
local lastAimbotCameraUpdate = 0

local function syncSidePanelsPosition()
	tpPanel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 355, panel.Position.Y.Scale, panel.Position.Y.Offset)
	copyPanel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 630, panel.Position.Y.Scale, panel.Position.Y.Offset)
	customTpPanel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 905, panel.Position.Y.Scale, panel.Position.Y.Offset)
	followPanel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 1180, panel.Position.Y.Scale, panel.Position.Y.Offset)
end

local function setTeleportPanelVisible(visible)
	TELEPORT_PANEL_VISIBLE = visible
	tpPanel.Visible = visible and GUI_VISIBLE
	syncSidePanelsPosition()
end

local function setCopyPanelVisible(visible)
	COPY_PANEL_VISIBLE = visible
	copyPanel.Visible = visible and GUI_VISIBLE
	syncSidePanelsPosition()
end

local function setCustomTpPanelVisible(visible)
	CUSTOM_TP_PANEL_VISIBLE = visible
	customTpPanel.Visible = visible and GUI_VISIBLE
	syncSidePanelsPosition()
end

local function setFollowPanelVisible(visible)
	FOLLOW_PANEL_VISIBLE = visible
	followPanel.Visible = visible and GUI_VISIBLE
	syncSidePanelsPosition()
end

local function togglePanel()
	GUI_VISIBLE = not GUI_VISIBLE

	if GUI_VISIBLE then
		panel.Visible = true
		panel.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(panel, TweenInfo.new(0.25), {
			Size = UDim2.new(0, 340, 0, 560),
		}):Play()
	else
		local tween = TweenService:Create(panel, TweenInfo.new(0.2), {
			Size = UDim2.new(0, 0, 0, 0),
		})
		tween:Play()
		tween.Completed:Wait()
		panel.Visible = false
	end

	tpPanel.Visible = GUI_VISIBLE and TELEPORT_PANEL_VISIBLE
	copyPanel.Visible = GUI_VISIBLE and COPY_PANEL_VISIBLE
	customTpPanel.Visible = GUI_VISIBLE and CUSTOM_TP_PANEL_VISIBLE
	followPanel.Visible = GUI_VISIBLE and FOLLOW_PANEL_VISIBLE
end

--// Drag painel
local dragging = false
local dragStart
local startPos

panel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = panel.Position
	end
end)

panel.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if activeSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
		activeSlider(input.Position.X)
	end

	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		panel.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
		syncSidePanelsPosition()
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		activeSlider = nil
	end
end)

--// FOV
local fov = Drawing.new("Circle")
fov.Radius = FOV_RADIUS
fov.Color = Color3.new(1, 1, 1)
fov.Thickness = 2
fov.Filled = false
fov.Visible = false

--// Cache e timers
local npcCache = {}
local playerCache = {}
local npcEspMap = {}
local playerEspMap = {}

local lastNPCScan = 0
local lastPlayerScan = 0
local lastTargetUpdate = 0
local lastESPUpdate = 0
local lastPlayerListUpdate = 0
local lastCopyListUpdate = 0
local currentTarget = nil

local function hasAimbotEnabled()
	return AIM_NPC_ENABLED or AIM_PLAYER_ENABLED
end

local function hasESPEnabled()
	return ESP_NPC_ENABLED or ESP_PLAYER_ENABLED
end

local function isAnyFeatureEnabled()
	return hasAimbotEnabled()
		or hasESPEnabled()
		or TELEPORT_PANEL_VISIBLE
		or COPY_PANEL_VISIBLE
		or CUSTOM_TP_PANEL_VISIBLE
		or FOLLOW_PANEL_VISIBLE
		or FOLLOW_ENABLED
		or FLY_ENABLED
		or NOCLIP_ENABLED
		or SPEED_ENABLED
		or DOUBLE_JUMP_ENABLED
		or GODMODE_ENABLED
		or SPIN_ENABLED
		or RUN_ENABLED
		or TELEPORT_TO_CLICK_ENABLED
end

local function isValidNPC(model)
	if not model or not model:IsA("Model") then
		return false
	end
	if Players:GetPlayerFromCharacter(model) ~= nil then
		return false
	end
	local humanoid = model:FindFirstChild("Humanoid")
	local head = model:FindFirstChild("Head")
	return humanoid ~= nil and head ~= nil and humanoid.Health > 0
end

local function isPlayerIgnored(targetPlayer)
	return ignoredPlayers[targetPlayer.UserId] == true
end

local function isPlayerOnSameTeam(targetPlayer)
	if not TEAMCHECK_ENABLED then
		return false
	end

	if not player.Team or not targetPlayer.Team then
		return false
	end

	return player.Team == targetPlayer.Team
end

local function isValidPlayerCharacter(model)
	if not model or not model:IsA("Model") then
		return false
	end
	local targetPlayer = Players:GetPlayerFromCharacter(model)
	if targetPlayer == nil or targetPlayer == player then
		return false
	end

	if AIM_PLAYER_ENABLED and isPlayerOnSameTeam(targetPlayer) then
		return false
	end

	local humanoid = model:FindFirstChild("Humanoid")
	local head = model:FindFirstChild("Head")
	return humanoid ~= nil and head ~= nil and humanoid.Health > 0
end

local function getCharacterRoot()
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart")
end

local function getCharacterHumanoid()
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChildOfClass("Humanoid")
end

local function makeESPEntry(map, model)
	local line = Drawing.new("Line")
	line.Color = Color3.fromRGB(255, 255, 255)
	line.Thickness = 1.5
	line.Visible = false

	local text = Drawing.new("Text")
	text.Color = Color3.fromRGB(255, 255, 255)
	text.Size = 13
	text.Center = true
	text.Outline = true
	text.Visible = false

	map[model] = { line = line, text = text }
end

local function destroyESPEntry(map, model)
	local entry = map[model]
	if not entry then
		return
	end
	if entry.line then
		entry.line:Remove()
	end
	if entry.text then
		entry.text:Remove()
	end
	map[model] = nil
end

local function setAllESPVisible(map, visible)
	for _, entry in pairs(map) do
		entry.line.Visible = visible
		entry.text.Visible = visible
	end
end

local function refreshNPCCache()
	local alive = {}
	table.clear(npcCache)

	for _, model in ipairs(workspace:GetDescendants()) do
		if isValidNPC(model) then
			table.insert(npcCache, model)
			alive[model] = true
			if not npcEspMap[model] then
				makeESPEntry(npcEspMap, model)
			end
		end
	end

	for model, _ in pairs(npcEspMap) do
		if not alive[model] then
			destroyESPEntry(npcEspMap, model)
		end
	end
end

local function refreshPlayerCache()
	local alive = {}
	table.clear(playerCache)

	for _, plr in ipairs(Players:GetPlayers()) do
		local char = plr.Character
		if char and plr ~= player then
			local humanoid = char:FindFirstChild("Humanoid")
			local head = char:FindFirstChild("Head")
			if humanoid and head and humanoid.Health > 0 then
				table.insert(playerCache, char)
				alive[char] = true
				if not playerEspMap[char] then
					makeESPEntry(playerEspMap, char)
				end
			end
		end
	end

	for model, _ in pairs(playerEspMap) do
		if not alive[model] then
			destroyESPEntry(playerEspMap, model)
		end
	end
end

local function isTargetVisible(target)
	if not AIMBOT_VISIBILITY_CHECK then
		return true
	end

	local head = target:FindFirstChild("Head")
	if not head then
		return false
	end

	local ray = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 500)
	if ray == nil then
		return true
	end

	local hitInstance = ray.Instance
	local targetParent = target
	while targetParent do
		if hitInstance:IsDescendantOf(targetParent) then
			return true
		end
		targetParent = targetParent.Parent
	end

	return false
end

local function predictTargetPosition(targetModel)
	if not AIMBOT_PREDICTION then
		return targetModel:FindFirstChild("Head").Position
	end

	local head = targetModel:FindFirstChild("Head")
	if not head then
		return targetModel.Position
	end

	local humanoidRootPart = targetModel:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return head.Position
	end

	local velocity = humanoidRootPart.AssemblyLinearVelocity
	local predictedPos = head.Position + (velocity * AIMBOT_PREDICTION_STRENGTH * 0.016)
	return predictedPos
end

local function getClosestFromCacheImproved(cache, validator)
	local closest = nil
	local shortestDistance = AIMBOT_LOCK_RANGE
	local mousePos = UIS:GetMouseLocation()
	local viewportSize = Camera.ViewportSize

	for _, model in ipairs(cache) do
		if validator(model) then
			local head = model:FindFirstChild("Head")
			if head then
				local pos, visible = Camera:WorldToViewportPoint(head.Position)
				if visible and isTargetVisible(model) then
					local distToMouse = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
					local fovAdjust = FOV_RADIUS * AIMBOT_FOV_STRICTNESS

					if distToMouse < fovAdjust then
						local distToTarget = (head.Position - Camera.CFrame.Position).Magnitude
						if distToTarget < shortestDistance then
							shortestDistance = distToTarget
							closest = model
						end
					end
				end
			end
		end
	end

	return closest
end

local function updateESPFor(cache, map, enabled, validator, showNickname)
	if not enabled then
		setAllESPVisible(map, false)
		return
	end

	local root = getCharacterRoot()
	if not root then
		setAllESPVisible(map, false)
		return
	end

	local rootScreen, rootVisible = Camera:WorldToViewportPoint(root.Position)
	local lineFrom
	if rootVisible then
		lineFrom = Vector2.new(rootScreen.X, rootScreen.Y)
	else
		local viewport = Camera.ViewportSize
		lineFrom = Vector2.new(viewport.X * 0.5, viewport.Y * 0.8)
	end

	for _, model in ipairs(cache) do
		local entry = map[model]
		if entry then
			local head = model:FindFirstChild("Head")
			local humanoid = model:FindFirstChild("Humanoid")
			if head and humanoid and humanoid.Health > 0 then
				local headScreen, visible = Camera:WorldToViewportPoint(head.Position)

				entry.line.Visible = true
				entry.text.Visible = true
				entry.line.From = lineFrom
				entry.line.To = Vector2.new(headScreen.X, headScreen.Y)

				local distance = (head.Position - root.Position).Magnitude

				if showNickname then
					local targetPlayer = Players:GetPlayerFromCharacter(model)
					local nickname = targetPlayer and targetPlayer.Name or "Player"

					local prefix = ""
					if targetPlayer then
						if isPlayerIgnored(targetPlayer) then
							prefix = "[IGNORADO] "
							entry.line.Color = Color3.fromRGB(128, 128, 128)
							entry.text.Color = Color3.fromRGB(128, 128, 128)
						elseif isPlayerOnSameTeam(targetPlayer) then
							prefix = "[TIME] "
							entry.line.Color = Color3.fromRGB(0, 255, 0)
							entry.text.Color = Color3.fromRGB(0, 255, 0)
						else
							entry.line.Color = Color3.fromRGB(255, 255, 255)
							entry.text.Color = Color3.fromRGB(255, 255, 255)
						end
					end

					entry.text.Text = string.format("%s%s | %dm | HP: %d", prefix, nickname, math.floor(distance), math.floor(humanoid.Health))
				else
					entry.text.Text = string.format("%dm | HP: %d", math.floor(distance), math.floor(humanoid.Health))
				end

				entry.text.Position = Vector2.new(headScreen.X, headScreen.Y - 18)
			else
				entry.line.Visible = false
				entry.text.Visible = false
			end
		end
	end
end

local function updateAllESP()
	updateESPFor(npcCache, npcEspMap, ESP_NPC_ENABLED, isValidNPC, false)
	updateESPFor(playerCache, playerEspMap, ESP_PLAYER_ENABLED, function(model)
		return model ~= nil
	end, true)
end

local function getBestAimbotTargetImproved()
	local playerTarget = nil
	local npcTarget = nil

	if AIM_PLAYER_ENABLED and RIGHT_MOUSE_PRESSED then
		playerTarget = getClosestFromCacheImproved(playerCache, isValidPlayerCharacter)
	end
	if AIM_NPC_ENABLED then
		npcTarget = getClosestFromCacheImproved(npcCache, isValidNPC)
	end

	return playerTarget or npcTarget
end

local function clearList(scroll)
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
end

local function teleportToPlayer(targetPlayer)
	if not targetPlayer then
		return
	end

	local targetChar = targetPlayer.Character
	local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	local myRoot = getCharacterRoot()
	if not targetRoot or not myRoot then
		return
	end

	myRoot.CFrame = targetRoot.CFrame
end

local function teleportToPosition(position)
	local myRoot = getCharacterRoot()
	if not myRoot then
		return
	end

	myRoot.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
end

local function handleTeleportToClick(mousePos)
	if not TELEPORT_TO_CLICK_ENABLED then
		return
	end

	local myRoot = getCharacterRoot()
	if not myRoot then
		return
	end

	local unitRay = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {player.Character}

	local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)

	if raycastResult then
		myRoot.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 3, 0))
	end
end

local function applyScaryMode()
	local myChar = player.Character
	local myHumanoid = getCharacterHumanoid()
	if not myChar or not myHumanoid then
		return
	end

	scaryBackup = {}

	for _, child in ipairs(myChar:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
			table.insert(scaryBackup, child:Clone())
			child:Destroy()
		end
	end

	local parts = {"Head", "Torso", "UpperTorso", "LowerTorso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftFoot", "RightFoot", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"}
	for _, partName in ipairs(parts) do
		local part = myChar:FindFirstChild(partName)
		if part and part:IsA("BasePart") then
			if not scaryBackup[partName] then
				scaryBackup[partName] = {Color = part.Color, Material = part.Material}
			end
			part.Color = Color3.fromRGB(0, 0, 0)
			part.Material = Enum.Material.ForceField
		end
	end

	local head = myChar:FindFirstChild("Head")
	if head then
		for _, child in ipairs(head:GetChildren()) do
			if child:IsA("Decal") then
				if not scaryBackup.Face then
					scaryBackup.Face = child:Clone()
				end
				child.Texture = "rbxasset://textures/face.png"
			end
		end
	end

	local scaleValues = {"BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale"}
	for _, valueName in ipairs(scaleValues) do
		local valueObj = myHumanoid:FindFirstChild(valueName)
		if valueObj and valueObj:IsA("NumberValue") then
			if not scaryBackup[valueName] then
				scaryBackup[valueName] = valueObj.Value
			end
			if valueName == "BodyHeightScale" then
				valueObj.Value = 1.3
			elseif valueName == "HeadScale" then
				valueObj.Value = 1.5
			end
		end
	end

	local root = getCharacterRoot()
	if root then
		local smoke = Instance.new("ParticleEmitter")
		smoke.Name = "ScarySmoke"
		smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
		smoke.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
		smoke.Size = NumberSequence.new(2, 4)
		smoke.Transparency = NumberSequence.new(0.3, 1)
		smoke.Lifetime = NumberRange.new(1, 2)
		smoke.Rate = 30
		smoke.Rotation = NumberRange.new(0, 360)
		smoke.Speed = NumberRange.new(2, 5)
		smoke.SpreadAngle = Vector2.new(30, 30)
		smoke.Parent = root

		local glow = Instance.new("PointLight")
		glow.Name = "ScaryGlow"
		glow.Color = Color3.fromRGB(255, 0, 0)
		glow.Brightness = 3
		glow.Range = 20
		glow.Parent = head or root
	end
end

local function removeScaryMode()
	local myChar = player.Character
	local myHumanoid = getCharacterHumanoid()
	if not myChar or not myHumanoid then
		return
	end

	for _, item in ipairs(scaryBackup) do
		if typeof(item) == "Instance" then
			item:Clone().Parent = myChar
		end
	end

	local parts = {"Head", "Torso", "UpperTorso", "LowerTorso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftFoot", "RightFoot", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"}
	for _, partName in ipairs(parts) do
		local part = myChar:FindFirstChild(partName)
		if part and part:IsA("BasePart") and scaryBackup[partName] then
			part.Color = scaryBackup[partName].Color
			part.Material = scaryBackup[partName].Material
		end
	end

	local head = myChar:FindFirstChild("Head")
	if head and scaryBackup.Face then
		for _, child in ipairs(head:GetChildren()) do
			if child:IsA("Decal") then
				child:Destroy()
			end
		end
		scaryBackup.Face:Clone().Parent = head
	end

	local scaleValues = {"BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale"}
	for _, valueName in ipairs(scaleValues) do
		local valueObj = myHumanoid:FindFirstChild(valueName)
		if valueObj and valueObj:IsA("NumberValue") and scaryBackup[valueName] then
			valueObj.Value = scaryBackup[valueName]
		end
	end

	local root = getCharacterRoot()
	if root then
		for _, child in ipairs(root:GetChildren()) do
			if child.Name == "ScarySmoke" or child.Name == "ScaryGlow" then
				child:Destroy()
			end
		end
	end

	if head then
		for _, child in ipairs(head:GetChildren()) do
			if child.Name == "ScaryGlow" then
				child:Destroy()
			end
		end
	end

	scaryBackup = {}
end

local function copyHeadFace(targetChar, myChar)
	local targetHead = targetChar:FindFirstChild("Head")
	local myHead = myChar:FindFirstChild("Head")
	if not targetHead or not myHead then
		return
	end

	for _, child in ipairs(myHead:GetChildren()) do
		if child:IsA("Decal") then
			child:Destroy()
		end
	end

	for _, child in ipairs(targetHead:GetChildren()) do
		if child:IsA("Decal") then
			child:Clone().Parent = myHead
		end
	end
end

local function copyAnimateScript(targetChar, myChar)
	local targetAnimate = targetChar:FindFirstChild("Animate")
	if not targetAnimate then
		return
	end

	local myAnimate = myChar:FindFirstChild("Animate")
	if myAnimate then
		myAnimate:Destroy()
	end

	targetAnimate:Clone().Parent = myChar
end

local function copyBodyScaleValues(targetHumanoid, myHumanoid)
	local scaleNames = {
		"BodyDepthScale",
		"BodyHeightScale",
		"BodyWidthScale",
		"HeadScale",
		"BodyProportionScale",
		"BodyTypeScale",
	}

	for _, name in ipairs(scaleNames) do
		local src = targetHumanoid:FindFirstChild(name)
		local dst = myHumanoid:FindFirstChild(name)
		if src and dst and dst:IsA("NumberValue") and src:IsA("NumberValue") then
			dst.Value = src.Value
		end
	end
end

local function applyBodyShapeFromDescription(desc, myHumanoid)
	if not desc or not myHumanoid then
		return false
	end

	local okApply = pcall(function()
		myHumanoid:ApplyDescriptionReset(desc)
	end)
	if not okApply then
		return false
	end

	local targets = {
		BodyDepthScale = desc.DepthScale,
		BodyHeightScale = desc.HeightScale,
		BodyWidthScale = desc.WidthScale,
		HeadScale = desc.HeadScale,
		BodyProportionScale = desc.ProportionScale,
		BodyTypeScale = desc.BodyTypeScale,
	}

	task.defer(function()
		for _ = 1, 3 do
			for valueName, scaleValue in pairs(targets) do
				local valueObj = myHumanoid:FindFirstChild(valueName)
				if valueObj and valueObj:IsA("NumberValue") then
					valueObj.Value = scaleValue
				end
			end
			task.wait()
		end
	end)

	return true
end

local function copyCharacterMeshes(targetChar, myChar)
	for _, child in ipairs(myChar:GetChildren()) do
		if child:IsA("CharacterMesh") then
			child:Destroy()
		end
	end

	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("CharacterMesh") then
			child:Clone().Parent = myChar
		end
	end
end

local function copyBodyPartColors(targetChar, myChar)
	local parts = {"Head", "Torso", "UpperTorso", "LowerTorso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftFoot", "RightFoot", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"}
	for _, partName in ipairs(parts) do
		local src = targetChar:FindFirstChild(partName)
		local dst = myChar:FindFirstChild(partName)
		if src and dst and src:IsA("BasePart") and dst:IsA("BasePart") then
			dst.Color = src.Color
			dst.Material = src.Material
		end
	end
end

local function copyOutfitFromPlayer(targetPlayer)
	if not targetPlayer then
		return
	end

	local myChar = player.Character
	local myHumanoid = getCharacterHumanoid()
	local targetChar = targetPlayer.Character
	local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
	if not myChar or not myHumanoid or not targetChar or not targetHumanoid then
		return
	end

	local applied = false

	local okUser, userDesc = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(targetPlayer.UserId)
	end)
	if okUser and userDesc then
		applied = applyBodyShapeFromDescription(userDesc, myHumanoid) or applied
	end

	if not applied then
		local okDesc, desc = pcall(function()
			return targetHumanoid:GetAppliedDescription()
		end)
		if okDesc and desc then
			applied = applyBodyShapeFromDescription(desc, myHumanoid) or applied
		end
	end

	for _, child in ipairs(myChar:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") then
			child:Destroy()
		end
	end

	for _, child in ipairs(targetChar:GetChildren()) do
		if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") then
			child:Clone().Parent = myChar
		end
	end

	copyHeadFace(targetChar, myChar)
	copyAnimateScript(targetChar, myChar)
	copyBodyScaleValues(targetHumanoid, myHumanoid)
	copyCharacterMeshes(targetChar, myChar)
	copyBodyPartColors(targetChar, myChar)
end

local function createPlayerRow(scroll, text, onClick)
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, -4, 0, 34)
	row.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	row.BorderSizePixel = 0
	row.TextColor3 = Color3.new(1, 1, 1)
	row.Font = Enum.Font.Gotham
	row.TextSize = 12
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.Text = text
	row.Parent = scroll
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
	row.MouseButton1Click:Connect(onClick)
end

local function rebuildTeleportList()
	if not TELEPORT_PANEL_VISIBLE then
		return
	end

	clearList(tpScroll)
	local myRoot = getCharacterRoot()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local distance = 0
			if myRoot and targetRoot then
				distance = math.floor((targetRoot.Position - myRoot.Position).Magnitude)
			end

			createPlayerRow(tpScroll, string.format("  %s  |  %dm", plr.Name, distance), function()
				teleportToPlayer(plr)
			end)
		end
	end

	tpScroll.CanvasSize = UDim2.new(0, 0, 0, tpListLayout.AbsoluteContentSize.Y + 8)
end

local function rebuildCopyList()
	if not COPY_PANEL_VISIBLE then
		return
	end

	clearList(copyScroll)
	local myRoot = getCharacterRoot()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local distance = 0
			if myRoot and targetRoot then
				distance = math.floor((targetRoot.Position - myRoot.Position).Magnitude)
			end

			createPlayerRow(copyScroll, string.format("  %s  |  %dm", plr.Name, distance), function()
				copyOutfitFromPlayer(plr)
			end)
		end
	end

	copyScroll.CanvasSize = UDim2.new(0, 0, 0, copyListLayout.AbsoluteContentSize.Y + 8)
end

local function rebuildCustomTpList()
	if not CUSTOM_TP_PANEL_VISIBLE then
		return
	end

	clearList(customTpScroll)

	for name, position in pairs(customTeleports) do
		createPlayerRow(customTpScroll, "  " .. name, function()
			teleportToPosition(position)
		end)
	end

	customTpScroll.CanvasSize = UDim2.new(0, 0, 0, customTpListLayout.AbsoluteContentSize.Y + 8)
end

local function rebuildFollowList()
	if not FOLLOW_PANEL_VISIBLE then
		return
	end

	clearList(followScroll)
	local myRoot = getCharacterRoot()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local distance = 0
			if myRoot and targetRoot then
				distance = math.floor((targetRoot.Position - myRoot.Position).Magnitude)
			end

			local isFollowing = FOLLOW_ENABLED and followTargetPlayer == plr
			local displayText = isFollowing
				and string.format("  [SEGUINDO] %s  |  %dm", plr.Name, distance)
				or string.format("  %s  |  %dm", plr.Name, distance)

			local row = Instance.new("TextButton")
			row.Size = UDim2.new(1, -4, 0, 34)
			row.BackgroundColor3 = isFollowing and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 40)
			row.BorderSizePixel = 0
			row.TextColor3 = Color3.new(1, 1, 1)
			row.Font = Enum.Font.Gotham
			row.TextSize = 12
			row.TextXAlignment = Enum.TextXAlignment.Left
			row.Text = displayText
			row.Parent = followScroll
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

			row.MouseButton1Click:Connect(function()
				if isFollowing then
					FOLLOW_ENABLED = false
					followTargetPlayer = nil
					btnFollowPlayer.Text = "SEGUIR PLAYER: OFF"
				else
					FOLLOW_ENABLED = true
					followTargetPlayer = plr
					btnFollowPlayer.Text = "SEGUIR PLAYER: ON"
				end
				rebuildFollowList()
			end)
		end
	end

	followScroll.CanvasSize = UDim2.new(0, 0, 0, followListLayout.AbsoluteContentSize.Y + 8)
end

local function setFlyEnabled(enabled)
	FLY_ENABLED = enabled
	btnFly.Text = FLY_ENABLED and "FLY: ON" or "FLY: OFF"

	if not FLY_ENABLED then
		local humanoid = getCharacterHumanoid()
		if humanoid then
			humanoid.AutoRotate = true
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end

		local root = getCharacterRoot()
		if root then
			root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		end
	end
end

local function setSpeedEnabled(enabled)
	SPEED_ENABLED = enabled
	btnSpeed.Text = SPEED_ENABLED and "SPEED: ON" or "SPEED: OFF"

	local humanoid = getCharacterHumanoid()
	if SPEED_ENABLED then
		if humanoid then
			speedBaseWalk = humanoid.WalkSpeed
			humanoid.WalkSpeed = SPEED_VALUE
		end
	else
		if humanoid then
			humanoid.WalkSpeed = speedBaseWalk or 16
		end
	end
end

local function updateFly(dt)
	if not FLY_ENABLED then
		return
	end

	local root = getCharacterRoot()
	local humanoid = getCharacterHumanoid()
	if not root or not humanoid then
		return
	end

	humanoid.AutoRotate = false
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	local forward = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
	local right = Vector3.new(Camera.CFrame.RightVector.X, 0, Camera.CFrame.RightVector.Z)

	if forward.Magnitude > 0 then
		forward = forward.Unit
	end
	if right.Magnitude > 0 then
		right = right.Unit
	end

	local direction = Vector3.new(0, 0, 0)
	if flyInput.W then direction += forward end
	if flyInput.S then direction -= forward end
	if flyInput.D then direction += right end
	if flyInput.A then direction -= right end
	if flyInput.Space then direction += Vector3.new(0, 1, 0) end
	if flyInput.Ctrl then direction -= Vector3.new(0, 1, 0) end

	if direction.Magnitude > 0 then
		direction = direction.Unit
		root.CFrame = root.CFrame + direction * (FLY_SPEED * dt)
	end

	root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end

local function updateSpin(dt)
	if not SPIN_ENABLED then
		return
	end

	local root = getCharacterRoot()
	if not root then
		return
	end

	root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(SPIN_SPEED * dt), 0)
end

local function updateRun(dt)
	if not RUN_ENABLED then
		return
	end

	local root = getCharacterRoot()
	local humanoid = getCharacterHumanoid()
	if not root or not humanoid then
		return
	end

	local forward = root.CFrame.LookVector
	root.CFrame = root.CFrame + forward * (humanoid.WalkSpeed * dt)
end

local function updateNoClip()
	if not NOCLIP_ENABLED then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end

local function updateSpeed()
	if not SPEED_ENABLED then
		return
	end
	local humanoid = getCharacterHumanoid()
	if humanoid then
		humanoid.WalkSpeed = SPEED_VALUE
	end
end

local function updateGodMode()
	if not GODMODE_ENABLED then
		return
	end

	local humanoid = getCharacterHumanoid()
	if humanoid then
		humanoid.Health = humanoid.MaxHealth
	end
end

local function updateFollowPlayer()
	if not FOLLOW_ENABLED or not followTargetPlayer then
		return
	end

	local myRoot = getCharacterRoot()
	if not myRoot then
		return
	end

	local targetChar = followTargetPlayer.Character
	local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	if not targetRoot then
		FOLLOW_ENABLED = false
		followTargetPlayer = nil
		btnFollowPlayer.Text = "SEGUIR PLAYER: OFF"
		return
	end

	myRoot.CFrame = targetRoot.CFrame
end

local function updateAimbotCamera()
	if not hasAimbotEnabled() or not currentTarget then
		return
	end

	if not (isValidNPC(currentTarget) or isValidPlayerCharacter(currentTarget)) then
		currentTarget = nil
		return
	end

	local head = currentTarget:FindFirstChild("Head")
	if not head then
		currentTarget = nil
		return
	end

	local predictedPos = predictTargetPosition(currentTarget)
	local targetCFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
	Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, AIMBOT_SMOOTHNESS)
end

panelListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	panelScroll.CanvasSize = UDim2.new(0, 0, 0, panelListLayout.AbsoluteContentSize.Y + 8)
end)

tpListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	tpScroll.CanvasSize = UDim2.new(0, 0, 0, tpListLayout.AbsoluteContentSize.Y + 8)
end)

copyListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	copyScroll.CanvasSize = UDim2.new(0, 0, 0, copyListLayout.AbsoluteContentSize.Y + 8)
end)

customTpListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	customTpScroll.CanvasSize = UDim2.new(0, 0, 0, customTpListLayout.AbsoluteContentSize.Y + 8)
end)

followListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	followScroll.CanvasSize = UDim2.new(0, 0, 0, followListLayout.AbsoluteContentSize.Y + 8)
end)

--// Inputs globais
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.F2 then
		togglePanel()
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		RIGHT_MOUSE_PRESSED = true
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 and TELEPORT_TO_CLICK_ENABLED then
		handleTeleportToClick(input.Position)
		return
	end

	if input.KeyCode == Enum.KeyCode.W then
		flyInput.W = true
	elseif input.KeyCode == Enum.KeyCode.A then
		flyInput.A = true
	elseif input.KeyCode == Enum.KeyCode.S then
		flyInput.S = true
	elseif input.KeyCode == Enum.KeyCode.D then
		flyInput.D = true
	elseif input.KeyCode == Enum.KeyCode.Space then
		flyInput.Space = true
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		flyInput.Ctrl = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		RIGHT_MOUSE_PRESSED = false
		currentTarget = nil
		return
	end

	if input.KeyCode == Enum.KeyCode.W then
		flyInput.W = false
	elseif input.KeyCode == Enum.KeyCode.A then
		flyInput.A = false
	elseif input.KeyCode == Enum.KeyCode.S then
		flyInput.S = false
	elseif input.KeyCode == Enum.KeyCode.D then
		flyInput.D = false
	elseif input.KeyCode == Enum.KeyCode.Space then
		flyInput.Space = false
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		flyInput.Ctrl = false
	end
end)

UIS.JumpRequest:Connect(function()
	if not DOUBLE_JUMP_ENABLED then
		return
	end

	local now = os.clock()
	if now - lastJumpRequest < 0.05 then
		return
	end
	lastJumpRequest = now

	local humanoid = getCharacterHumanoid()
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

--// TOGGLES
btnAimbotNPC.MouseButton1Click:Connect(function()
	AIM_NPC_ENABLED = not AIM_NPC_ENABLED
	btnAimbotNPC.Text = AIM_NPC_ENABLED and "AIMBOT (NPC): ON" or "AIMBOT (NPC): OFF"
	fov.Visible = hasAimbotEnabled()
	if AIM_NPC_ENABLED then
		refreshNPCCache()
		lastNPCScan = os.clock()
	end
end)

btnESPNPC.MouseButton1Click:Connect(function()
	ESP_NPC_ENABLED = not ESP_NPC_ENABLED
	btnESPNPC.Text = ESP_NPC_ENABLED and "ESP (NPC): ON" or "ESP (NPC): OFF"
	if ESP_NPC_ENABLED then
		refreshNPCCache()
		lastNPCScan = os.clock()
	else
		setAllESPVisible(npcEspMap, false)
	end
end)

btnAimbotPlayer.MouseButton1Click:Connect(function()
	AIM_PLAYER_ENABLED = not AIM_PLAYER_ENABLED
	btnAimbotPlayer.Text = AIM_PLAYER_ENABLED and "AIMBOT (PLAYER): ON" or "AIMBOT (PLAYER): OFF"
	fov.Visible = hasAimbotEnabled()
	if AIM_PLAYER_ENABLED then
		refreshPlayerCache()
		lastPlayerScan = os.clock()
	end
end)

btnESPPlayer.MouseButton1Click:Connect(function()
	ESP_PLAYER_ENABLED = not ESP_PLAYER_ENABLED
	btnESPPlayer.Text = ESP_PLAYER_ENABLED and "ESP (PLAYER): ON" or "ESP (PLAYER): OFF"
	if ESP_PLAYER_ENABLED then
		refreshPlayerCache()
		lastPlayerScan = os.clock()
	else
		setAllESPVisible(playerEspMap, false)
	end
end)

btnTeleportPlayer.MouseButton1Click:Connect(function()
	setTeleportPanelVisible(not TELEPORT_PANEL_VISIBLE)
	if TELEPORT_PANEL_VISIBLE then
		rebuildTeleportList()
		lastPlayerListUpdate = os.clock()
	end
end)

btnCopyOutfitPlayer.MouseButton1Click:Connect(function()
	setCopyPanelVisible(not COPY_PANEL_VISIBLE)
	if COPY_PANEL_VISIBLE then
		rebuildCopyList()
		lastCopyListUpdate = os.clock()
	end
end)

btnCustomTeleport.MouseButton1Click:Connect(function()
	setCustomTpPanelVisible(not CUSTOM_TP_PANEL_VISIBLE)
	if CUSTOM_TP_PANEL_VISIBLE then
		rebuildCustomTpList()
		lastCustomTpListUpdate = os.clock()
	end
end)

customTpSaveBtn.MouseButton1Click:Connect(function()
	local tpName = customTpInput.Text:gsub("^%s+", ""):gsub("%s+$", "")

	if tpName == "" then
		return
	end

	local myRoot = getCharacterRoot()
	if not myRoot then
		return
	end

	customTeleports[tpName] = myRoot.Position
	customTpInput.Text = ""
	rebuildCustomTpList()
end)

btnFollowPlayer.MouseButton1Click:Connect(function()
	setFollowPanelVisible(not FOLLOW_PANEL_VISIBLE)
	if FOLLOW_PANEL_VISIBLE then
		rebuildFollowList()
		lastFollowListUpdate = os.clock()
	else
		FOLLOW_ENABLED = false
		followTargetPlayer = nil
		btnFollowPlayer.Text = "SEGUIR PLAYER: OFF"
	end
end)

btnTeleportToClick.MouseButton1Click:Connect(function()
	TELEPORT_TO_CLICK_ENABLED = not TELEPORT_TO_CLICK_ENABLED
	btnTeleportToClick.Text = TELEPORT_TO_CLICK_ENABLED and "TELEPORT TO CLICK: ON" or "TELEPORT TO CLICK: OFF"
end)

btnScary.MouseButton1Click:Connect(function()
	SCARY_ENABLED = not SCARY_ENABLED
	btnScary.Text = SCARY_ENABLED and "ASSUSTAR: ON" or "ASSUSTAR: OFF"

	if SCARY_ENABLED then
		applyScaryMode()
	else
		removeScaryMode()
	end
end)

btnSpin.MouseButton1Click:Connect(function()
	SPIN_ENABLED = not SPIN_ENABLED
	btnSpin.Text = SPIN_ENABLED and "GIRAR: ON" or "GIRAR: OFF"
end)

btnRun.MouseButton1Click:Connect(function()
	RUN_ENABLED = not RUN_ENABLED
	btnRun.Text = RUN_ENABLED and "CORRER: ON" or "CORRER: OFF"
end)

btnFly.MouseButton1Click:Connect(function()
	setFlyEnabled(not FLY_ENABLED)
end)

btnNoClip.MouseButton1Click:Connect(function()
	NOCLIP_ENABLED = not NOCLIP_ENABLED
	btnNoClip.Text = NOCLIP_ENABLED and "NOCLIP: ON" or "NOCLIP: OFF"
end)

btnSpeed.MouseButton1Click:Connect(function()
	setSpeedEnabled(not SPEED_ENABLED)
end)

btnDoubleJump.MouseButton1Click:Connect(function()
	DOUBLE_JUMP_ENABLED = not DOUBLE_JUMP_ENABLED
	btnDoubleJump.Text = DOUBLE_JUMP_ENABLED and "PULO DUPLO: ON" or "PULO DUPLO: OFF"
end)

btnGodMode.MouseButton1Click:Connect(function()
	GODMODE_ENABLED = not GODMODE_ENABLED
	btnGodMode.Text = GODMODE_ENABLED and "GODMODE: ON" or "GODMODE: OFF"

	if GODMODE_ENABLED then
		local humanoid = getCharacterHumanoid()
		if humanoid then
			humanoid.Health = humanoid.MaxHealth
		end
	end
end)

player.CharacterAdded:Connect(function()
	if FLY_ENABLED then
		task.wait(0.2)
		setFlyEnabled(true)
	end
	if SPEED_ENABLED then
		task.wait(0.2)
		setSpeedEnabled(true)
	end
	if GODMODE_ENABLED then
		task.wait(0.2)
		local humanoid = getCharacterHumanoid()
		if humanoid then
			humanoid.Health = humanoid.MaxHealth
		end
	end
	if FOLLOW_ENABLED then
		task.wait(0.2)
	end
	if SCARY_ENABLED then
		task.wait(0.2)
		applyScaryMode()
	end
end)

--// LOOP PRINCIPAL
RunService.RenderStepped:Connect(function(dt)
	local now = os.clock()
	fov.Position = UIS:GetMouseLocation()

	if FLY_ENABLED then
		updateFly(dt)
	end
	if SPIN_ENABLED then
		updateSpin(dt)
	end
	if RUN_ENABLED then
		updateRun(dt)
	end
	if NOCLIP_ENABLED then
		updateNoClip()
	end
	if SPEED_ENABLED then
		updateSpeed()
	end
	if GODMODE_ENABLED then
		updateGodMode()
	end

	if not isAnyFeatureEnabled() then
		currentTarget = nil
		return
	end

	if (AIM_NPC_ENABLED or ESP_NPC_ENABLED) and (now - lastNPCScan >= NPC_SCAN_INTERVAL) then
		lastNPCScan = now
		refreshNPCCache()
	end

	if (AIM_PLAYER_ENABLED or ESP_PLAYER_ENABLED or TELEPORT_PANEL_VISIBLE or COPY_PANEL_VISIBLE or CUSTOM_TP_PANEL_VISIBLE or FOLLOW_PANEL_VISIBLE) and (now - lastPlayerScan >= PLAYER_SCAN_INTERVAL) then
		lastPlayerScan = now
		refreshPlayerCache()
	end

	if hasESPEnabled() and (now - lastESPUpdate >= ESP_UPDATE_INTERVAL) then
		lastESPUpdate = now
		updateAllESP()
	end

	if TELEPORT_PANEL_VISIBLE and (now - lastPlayerListUpdate >= PLAYER_LIST_REFRESH_INTERVAL) then
		lastPlayerListUpdate = now
		rebuildTeleportList()
	end

	if COPY_PANEL_VISIBLE and (now - lastCopyListUpdate >= COPY_LIST_REFRESH_INTERVAL) then
		lastCopyListUpdate = now
		rebuildCopyList()
	end

	if CUSTOM_TP_PANEL_VISIBLE and (now - lastCustomTpListUpdate >= CUSTOM_TP_LIST_REFRESH_INTERVAL) then
		lastCustomTpListUpdate = now
		rebuildCustomTpList()
	end

	if FOLLOW_PANEL_VISIBLE and (now - lastFollowListUpdate >= FOLLOW_LIST_REFRESH_INTERVAL) then
		lastFollowListUpdate = now
		rebuildFollowList()
	end

	if FOLLOW_ENABLED then
		updateFollowPlayer()
	end

	if hasAimbotEnabled() then
		if now - lastTargetUpdate >= TARGET_UPDATE_INTERVAL then
			lastTargetUpdate = now
			currentTarget = getBestAimbotTargetImproved()
		end

		if now - lastAimbotCameraUpdate >= (1 / 60) then
			lastAimbotCameraUpdate = now
			updateAimbotCamera()
		end
	else
		currentTarget = nil
	end
end)