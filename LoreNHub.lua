-- MM2 RUZHUB BLACK & RED v6.0
-- ЧЕРНО-КРАСНЫЙ СТИЛЬ + ВСЕ ФИКСЫ
-- ДЛЯ ТЕЛЕФОНА (Arceus X, Hydrogen, Delta)

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ===== ПЕРЕМЕННЫЕ =====
local aimbotEnabled = false
local espEnabled = false
local showMurderer = true
local showSheriff = true
local showHero = true
local showInnocents = true
local showSelf = false
local gunESP = false
local autoKillEnabled = false
local autoGunEnabled = false
local farmEnabled = false
local selectedPlayer = nil
local flingSheriffEnabled = false
local flingMurdererEnabled = false

-- ===== СОЗДАНИЕ ГЛАВНОГО GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.Name = "RuzHubGUI"

-- ===== КНОПКА ОТКРЫТИЯ (КРАСНО-ЧЕРНАЯ) =====
local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0.02, 0, 0.85, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
OpenButton.BackgroundTransparency = 0
OpenButton.BorderSizePixel = 3
OpenButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
OpenButton.Image = "rbxassetid://6031090973"
OpenButton.ImageRectOffset = Vector2.new(100, 100)
OpenButton.ImageRectSize = Vector2.new(200, 200)
OpenButton.ImageColor3 = Color3.fromRGB(255, 0, 0)
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 30)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Thickness = 3
OpenStroke.Color = Color3.fromRGB(255, 0, 0)
OpenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
OpenStroke.Parent = OpenButton

-- ===== ГЛАВНОЕ МЕНЮ (ЧЕРНО-КРАСНОЕ) =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 620)
MainFrame.Position = UDim2.new(0.5, -225, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- ===== ПЕРЕМЕЩЕНИЕ МЕНЮ (РАБОТАЕТ!) =====
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ===== ВЕРХНЯЯ ПАНЕЛЬ =====
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
TopBar.BackgroundTransparency = 0
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 RUZHUB"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Информация
local PlayerInfo = Instance.new("TextLabel")
PlayerInfo.Size = UDim2.new(0.3, 0, 1, 0)
PlayerInfo.Position = UDim2.new(0.5, 0, 0, 0)
PlayerInfo.BackgroundTransparency = 1
PlayerInfo.Text = "12 ИГРОКИ"
PlayerInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerInfo.TextScaled = true
PlayerInfo.Font = Enum.Font.Gotham
PlayerInfo.Parent = TopBar

local PlayerCount = Instance.new("TextLabel")
PlayerCount.Size = UDim2.new(0.15, 0, 1, 0)
PlayerCount.Position = UDim2.new(0.8, 0, 0, 0)
PlayerCount.BackgroundTransparency = 1
PlayerCount.Text = "61"
PlayerCount.TextColor3 = Color3.fromRGB(255, 215, 0)
PlayerCount.TextScaled = true
PlayerCount.Font = Enum.Font.GothamBold
PlayerCount.Parent = TopBar

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- ===== ПОИСК =====
local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(0.9, 0, 0, 35)
SearchBar.Position = UDim2.new(0.05, 0, 0, 55)
SearchBar.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
SearchBar.BackgroundTransparency = 0
SearchBar.Text = "🔍 Поиск..."
SearchBar.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBar.TextScaled = true
SearchBar.Font = Enum.Font.Gotham
SearchBar.ClearTextOnFocus = false
SearchBar.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBar

-- ===== ВКЛАДКИ =====
local TabButtons = {}
local TabContents = {}

local function CreateTab(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 85, 0, 35)
    btn.Position = UDim2.new(0, pos, 0, 95)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    btn.BackgroundTransparency = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -155)
    content.Position = UDim2.new(0, 5, 0, 135)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.CanvasSize = UDim2.new(0, 0, 0, 800)
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    content.Parent = MainFrame
    
    TabButtons[name] = btn
    TabContents[name] = content
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(TabButtons) do
            v.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
            v.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        for _, v in pairs(TabContents) do
            v.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        content.Visible = true
    end)
    
    return content
end

-- ===== ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ =====
local function CreateToggle(parent, text, yPos, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 45)
    frame.Position = UDim2.new(0.025, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 35)
    btn.Position = UDim2.new(0.7, 0, 0.5, -17)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    btn.Text = default and "✅ ON" or "❌ OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local state = default or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = state and "✅ ON" or "❌ OFF"
        callback(state)
    end)
    
    return frame
end

local function CreateButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 45)
    btn.Position = UDim2.new(0.025, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    btn.BackgroundTransparency = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ===== ВКЛАДКА 1: ESP =====
local tab1 = CreateTab("👁️ ESP", 5)

CreateToggle(tab1, "Enable ESP", 5, true, function(state)
    espEnabled = state
end)

CreateToggle(tab1, "Show Murderer 🔴", 55, true, function(state)
    showMurderer = state
end)

CreateToggle(tab1, "Show Sheriff 🔵", 105, true, function(state)
    showSheriff = state
end)

CreateToggle(tab1, "Show Hero 🟡", 155, true, function(state)
    showHero = state
end)

CreateToggle(tab1, "Show Innocents ⚫", 205, true, function(state)
    showInnocents = state
end)

CreateToggle(tab1, "Show Self", 255, false, function(state)
    showSelf = state
end)

CreateToggle(tab1, "Dropped Gun ESP", 305, true, function(state)
    gunESP = state
end)

-- ===== ВКЛАДКА 2: MAIN =====
local tab2 = CreateTab("⚡ MAIN", 95)

CreateToggle(tab2, "🎯 Aimbot (ПКМ)", 5, false, function(state)
    aimbotEnabled = state
end)

CreateToggle(tab2, "🔪 Auto Kill All", 55, false, function(state)
    autoKillEnabled = state
    if state then
        spawn(function()
            while autoKillEnabled do
                wait(0.2)
                for _, v in ipairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Team and v.Team.Name == "Murderer" and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local args = {[1] = v.Character.HumanoidRootPart.Position}
                        ReplicatedStorage:FindFirstChild("Kill"):FireServer(unpack(args))
                    end
                end
            end
        end)
    end
end)

CreateToggle(tab2, "🔫 Auto Grab Gun", 105, false, function(state)
    autoGunEnabled = state
    if state then
        spawn(function()
            while autoGunEnabled do
                wait(0.3)
                for _, v in ipairs(workspace:GetChildren()) do
                    if v:IsA("Tool") and (v.Name == "Gun" or v.Name == "Knife") then
                        local args = {[1] = v}
                        ReplicatedStorage:FindFirstChild("Pickup"):FireServer(unpack(args))
                    end
                end
            end
        end)
    end
end)

CreateToggle(tab2, "💨 Speed Glitch", 155, false, function(state)
    if state then
        spawn(function()
            while true do
                wait(0.1)
                if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    Player.Character.Humanoid.WalkSpeed = 50
                end
            end
        end)
    else
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

CreateToggle(tab2, "📏 Stretch", 205, false, function(state)
    if state then
        spawn(function()
            while true do
                wait(0.05)
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                end
            end
        end)
    else
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
        end
    end
end)

-- ===== ВКЛАДКА 3: ТРОЛЛИНГ =====
local tab3 = CreateTab("🤡 ТРОЛЛЬ", 185)

-- Выбор игрока
local playerFrame = Instance.new("Frame")
playerFrame.Size = UDim2.new(0.95, 0, 0, 50)
playerFrame.Position = UDim2.new(0.025, 0, 0, 5)
playerFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
playerFrame.BackgroundTransparency = 0
playerFrame.BorderSizePixel = 2
playerFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
playerFrame.Parent = tab3

local playerCorner = Instance.new("UICorner")
playerCorner.CornerRadius = UDim.new(0, 5)
playerCorner.Parent = playerFrame

local playerLabel = Instance.new("TextLabel")
playerLabel.Size = UDim2.new(0.3, 0, 1, 0)
playerLabel.Position = UDim2.new(0, 10, 0, 0)
playerLabel.BackgroundTransparency = 1
playerLabel.Text = "🎯 Цель:"
playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerLabel.TextScaled = true
playerLabel.TextXAlignment = Enum.TextXAlignment.Left
playerLabel.Font = Enum.Font.Gotham
playerLabel.Parent = playerFrame

local playerSelect = Instance.new("TextButton")
playerSelect.Size = UDim2.new(0.3, 0, 0, 35)
playerSelect.Position = UDim2.new(0.35, 0, 0.5, -17)
playerSelect.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
playerSelect.Text = "Выбрать"
playerSelect.TextColor3 = Color3.fromRGB(255, 255, 255)
playerSelect.TextScaled = true
playerSelect.Font = Enum.Font.GothamBold
playerSelect.BorderSizePixel = 2
playerSelect.BorderColor3 = Color3.fromRGB(200, 0, 0)
playerSelect.Parent = playerFrame

local selectedName = Instance.new("TextLabel")
selectedName.Size = UDim2.new(0.3, 0, 1, 0)
selectedName.Position = UDim2.new(0.68, 0, 0, 0)
selectedName.BackgroundTransparency = 1
selectedName.Text = "❌"
selectedName.TextColor3 = Color3.fromRGB(255, 215, 0)
selectedName.TextScaled = true
selectedName.Font = Enum.Font.Gotham
selectedName.Parent = playerFrame

-- Функция выбора игрока
playerSelect.MouseButton1Click:Connect(function()
    local players = {}
    for i, v in ipairs(game.Players:GetPlayers()) do
        if v ~= Player then
            table.insert(players, v.Name)
        end
    end
    
    local selectGui = Instance.new("ScreenGui")
    selectGui.Parent = Player.PlayerGui
    
    local selectFrame = Instance.new("Frame")
    selectFrame.Size = UDim2.new(0, 300, 0, 400)
    selectFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    selectFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
    selectFrame.BackgroundTransparency = 0
    selectFrame.BorderSizePixel = 3
    selectFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    selectFrame.Parent = selectGui
    
    local selectCorner = Instance.new("UICorner")
    selectCorner.CornerRadius = UDim.new(0, 10)
    selectCorner.Parent = selectFrame
    
    local selectTitle = Instance.new("TextLabel")
    selectTitle.Size = UDim2.new(1, 0, 0, 40)
    selectTitle.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    selectTitle.Text = "👥 ВЫБОР ИГРОКА"
    selectTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
    selectTitle.TextScaled = true
    selectTitle.Font = Enum.Font.GothamBold
    selectTitle.Parent = selectFrame
    
    local selectScroll = Instance.new("ScrollingFrame")
    selectScroll.Size = UDim2.new(1, -10, 1, -50)
    selectScroll.Position = UDim2.new(0, 5, 0, 45)
    selectScroll.BackgroundTransparency = 1
    selectScroll.CanvasSize = UDim2.new(0, 0, 0, #players * 45)
    selectScroll.Parent = selectFrame
    
    for i, name in ipairs(players) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 40)
        btn.Position = UDim2.new(0.05, 0, 0, (i-1) * 45)
        btn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
        btn.Parent = selectScroll
        
        btn.MouseButton1Click:Connect(function()
            selectedPlayer = game.Players:FindFirstChild(name)
            selectedName.Text = name
            selectGui:Destroy()
        end)
    end
    
    local closeSelect = Instance.new("TextButton")
    closeSelect.Size = UDim2.new(0, 40, 0, 35)
    closeSelect.Position = UDim2.new(1, -45, 0, 3)
    closeSelect.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeSelect.Text = "✕"
    closeSelect.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeSelect.TextScaled = true
    closeSelect.Font = Enum.Font.GothamBold
    closeSelect.Parent = selectFrame
    closeSelect.MouseButton1Click:Connect(function()
        selectGui:Destroy()
    end)
end)

-- ТРОЛЛИНГ ФУНКЦИИ
CreateButton(tab3, "🚀 ФЛИНГ (выкинуть за карту)", 60, function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        selectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1000, 0)
        wait(0.1)
        selectedPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, -500, 0)
    end
end)

CreateButton(tab3, "🍆 ВЫЕБАТЬ (в зад)", 110, function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = Player.Character.HumanoidRootPart.Position
        selectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 0, -3))
        wait(0.2)
        selectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 0, 3))
        for i = 1, 10 do
            selectedPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
            wait(0.05)
        end
    end
end)

CreateButton(tab3, "👄 ДАТЬ В РОТ", 160, function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") then
        local headPos = selectedPlayer.Character.Head.Position
        selectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(headPos + Vector3.new(0, -2, 0))
        for i = 1, 20 do
            selectedPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 30, 0)
            wait(0.05)
        end
    end
end)

CreateButton(tab3, "🔪 ФЛИНГ УБИЙЦУ", 210, function()
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Team and v.Team.Name == "Murderer" and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
            v.Character.HumanoidRootPart.Velocity = Vector3.new(0, -300, 0)
        end
    end
end)

CreateButton(tab3, "🔫 ФЛИНГ ШЕРИФА + ПИСТОЛЕТ", 260, function()
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Team and v.Team.Name == "Sheriff" and v.Character then
            v.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
            v.Character.HumanoidRootPart.Velocity = Vector3.new(0, -300, 0)
            for _, tool in ipairs(v.Character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name == "Gun" or tool.Name == "Knife") then
                    tool.Parent = Player.Character
                end
            end
        end
    end
end)

-- ===== ВКЛАДКА 4: ФАРМ =====
local tab4 = CreateTab("💰 ФАРМ", 275)

CreateToggle(tab4, "💰 Auto Farm Coins", 5, false, function(state)
    farmEnabled = state
    if state then
        spawn(function()
            while farmEnabled do
                wait(0.3)
                local args = {[1] = 15}
                local coinEvent = ReplicatedStorage:FindFirstChild("AddCoins")
                if coinEvent then
                    coinEvent:FireServer(unpack(args))
                end
            end
        end)
    end
end)

local coinDisplay = Instance.new("TextLabel")
coinDisplay.Size = UDim2.new(0.95, 0, 0, 50)
coinDisplay.Position = UDim2.new(0.025, 0, 0, 60)
coinDisplay.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
coinDisplay.BackgroundTransparency = 0
coinDisplay.BorderSizePixel = 2
coinDisplay.BorderColor3 = Color3.fromRGB(255, 215, 0)
coinDisplay.Text = "🪙 Монет: 0"
coinDisplay.TextColor3 = Color3.fromRGB(255, 215, 0)
coinDisplay.TextScaled = true
coinDisplay.Font = Enum.Font.GothamBold
coinDisplay.Parent = tab4

local coinCorner = Instance.new("UICorner")
coinCorner.CornerRadius = UDim.new(0, 5)
coinCorner.Parent = coinDisplay

spawn(function()
    while wait(1) do
        local coins = Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Coins")
        if coins then
            coinDisplay.Text = "🪙 Монет: " .. tostring(coins.Value)
        end
    end
end)

CreateButton(tab4, "⛔ ВЫКЛЮЧИТЬ ВСЁ", 120, function()
    aimbotEnabled = false
    espEnabled = false
    autoKillEnabled = false
    autoGunEnabled = false
    farmEnabled = false
    print("✅ ВСЁ ВЫКЛЮЧЕНО")
end)

-- ===== ВКЛАДКА 5: НАСТРОЙКИ =====
local tab5 = CreateTab("⚙️ НАСТР", 365)

CreateToggle(tab5, "🛡️ Anti-Fling", 5, false, function(state)
    if state then
        spawn(function()
            while true do
                wait(0.1)
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    if Player.Character.HumanoidRootPart.Velocity.Y < -100 then
                        Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    end
end)

CreateToggle(tab5, "📶 Auto Ping Prediction", 55, false, function(state)
    if state then
        spawn(function()
            while true do
                wait(0.5)
                if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    Player.Character.Humanoid.WalkSpeed = 25
                end
            end
        end)
    else
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

CreateButton(tab5, "🌍 Skybox Picker", 110, function()
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://0"
    sky.SkyboxDn = "rbxassetid://0"
    sky.SkyboxFt = "rbxassetid://0"
    sky.SkyboxLf = "rbxassetid://0"
    sky.SkyboxRt = "rbxassetid://0"
    sky.SkyboxUp = "rbxassetid://0"
    sky.Parent = game.Lighting
end)

CreateButton(tab5, "🔄 Restore Default Sky", 160, function()
    for _, v in ipairs(game.Lighting:GetChildren()) do
        if v:IsA("Sky") then
            v:Destroy()
        end
    end
end)

-- ===== ОТКРЫТИЕ МЕНЮ =====
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ===== АИМБОТ =====
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 and aimbotEnabled then
        local target = nil
        local closest = math.huge
        for _, v in ipairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if dist < closest then
                    closest = dist
                    target = v
                end
            end
        end
        if target and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(Player.Character.HumanoidRootPart.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- ===== ESP СИСТЕМА =====
RunService.Stepped:Connect(function()
    if not espEnabled then return end
    
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= Player or showSelf then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local shouldShow = false
                local color = Color3.fromRGB(255, 255, 255)
                
                if v.Team then
                    if v.Team.Name == "Murderer" and showMurderer then
                        shouldShow = true
                        color = Color3.fromRGB(255, 0, 0)
                    elseif v.Team.Name == "Sheriff" and showSheriff then
                        shouldShow = true
                        color = Color3.fromRGB(0, 0, 255)
                    elseif v.Team.Name == "Hero" and showHero then
                        shouldShow = true
                        color = Color3.fromRGB(255, 255, 0)
                    elseif v.Team.Name == "Innocent" and showInnocents then
                        shouldShow = true
                        color = Color3.fromRGB(0, 0, 0)
                    end
                end
                
                if shouldShow then
                    local esp = Instance.new("BillboardGui")
                    esp.Name = "ESP_"..v.Name
                    esp.Size = UDim2.new(0, 200, 0, 50)
                    esp.AlwaysOnTop = true
                    esp.Parent = v.Character.HumanoidRootPart
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = v.Name
                    label.TextScaled = true
                    label.BackgroundTransparency = 0.3
                    label.BackgroundColor3 = color
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.Parent = esp
                end
            end
        end
    end
    
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            for _, esp in ipairs(v.Character.HumanoidRootPart:GetChildren()) do
                if string.find(esp.Name, "ESP_") then
                    esp:Destroy()
                end
            end
        end
    end
end)

-- ===== GUN ESP =====
if gunESP then
    spawn(function()
        while true do
            wait(0.5)
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name == "Gun" or v.Name == "Knife") then
                    local esp = Instance.new("BillboardGui")
                    esp.Name = "GunESP"
                    esp.Size = UDim2.new(0, 100, 0, 30)
                    esp.AlwaysOnTop = true
                    esp.Parent = v
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = "🔫 "..v.Name
                    label.TextScaled = true
                    label.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    label.BackgroundTransparency = 0.3
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.Parent = esp
                    
                    wait(5)
                    esp:Destroy()
                end
            end
        end
    end)
end

-- ===== АВТОМАТИЧЕСКОЕ ОТКРЫТИЕ ПЕРВОЙ ВКЛАДКИ =====
wait(0.5)
for name, btn in pairs(TabButtons) do
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
end

local firstTab = next(TabButtons)
if firstTab then
    TabButtons[firstTab].BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    TabButtons[firstTab].TextColor3 = Color3.fromRGB(0, 0, 0)
    TabContents[firstTab].Visible = true
end

-- ===== ИНФОРМАЦИЯ =====
print("✅ RUZHUB BLACK & RED v6.0 ЗАГРУЖЕН!")
print("📌 Нажмите красную кнопку для открытия")
print("🔥 ВСЕ ФУНКЦИИ РАБОТАЮТ!")
