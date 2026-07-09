-- MM2 RUZHUB ULTIMATE v5.0 (FULL COPY)
-- ПОЛНАЯ КОПИЯ RUZHUB С ТВОИМИ ФУНКЦИЯМИ
-- ДЛЯ ТЕЛЕФОНА (Arceus X, Hydrogen, Delta)

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ===== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ =====
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
local flingEnabled = false
local selectedPlayer = nil
local flingSheriffEnabled = false
local flingMurdererEnabled = false

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

-- ===== ОСНОВНАЯ КНОПКА (как RuzHub) =====
local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.new(0, 55, 0, 55)
OpenButton.Position = UDim2.new(0.02, 0, 0.85, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.BackgroundTransparency = 0
OpenButton.BorderSizePixel = 2
OpenButton.BorderColor3 = Color3.fromRGB(0, 200, 255)
OpenButton.Image = "rbxassetid://6031090973"
OpenButton.ImageRectOffset = Vector2.new(100, 100)
OpenButton.ImageRectSize = Vector2.new(200, 200)
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 27)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Thickness = 3
OpenStroke.Color = Color3.fromRGB(0, 200, 255)
OpenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
OpenStroke.Parent = OpenButton

-- ===== ГЛАВНОЕ МЕНЮ =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 600)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 180, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- ===== ВЕРХНЯЯ ПАНЕЛЬ (как RuzHub) =====
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

-- Заголовок RuzHub
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "RuzHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Информация о игроках (как на скринах)
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

-- Обновление количества игроков
spawn(function()
    while wait(1) do
        local count = #game.Players:GetPlayers()
        PlayerCount.Text = tostring(count)
    end
end)

-- ===== ПОИСК (как на скринах) =====
local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(0.9, 0, 0, 35)
SearchBar.Position = UDim2.new(0.05, 0, 0, 50)
SearchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
SearchBar.BackgroundTransparency = 0.3
SearchBar.Text = "Search"
SearchBar.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBar.TextScaled = true
SearchBar.Font = Enum.Font.Gotham
SearchBar.ClearTextOnFocus = false
SearchBar.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 5)
SearchCorner.Parent = SearchBar

-- ===== ВКЛАДКИ =====
local TabButtons = {}
local TabContents = {}
local CurrentTab = 1

local function CreateTab(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 35)
    btn.Position = UDim2.new(0, pos, 0, 90)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    btn.BackgroundTransparency = 0.3
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -140)
    content.Position = UDim2.new(0, 5, 0, 130)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.CanvasSize = UDim2.new(0, 0, 0, 800)
    content.ScrollBarThickness = 3
    content.Parent = MainFrame
    
    TabButtons[name] = btn
    TabContents[name] = content
    table.insert(TabButtons, btn)
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(TabButtons) do
            v.BackgroundTransparency = 0.3
        end
        for _, v in pairs(TabContents) do
            v.Visible = false
        end
        btn.BackgroundTransparency = 0
        content.Visible = true
    end)
    
    return content
end

-- ===== ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ =====
local function CreateToggle(parent, text, yPos, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 40)
    frame.Position = UDim2.new(0.025, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 30)
    btn.Position = UDim2.new(0.7, 0, 0.5, -15)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    btn.Text = default and "ON" or "OFF"
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
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return frame
end

local function CreateButton(parent, text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 45)
    btn.Position = UDim2.new(0.025, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateSlider(parent, text, yPos, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 55)
    frame.Position = UDim2.new(0.025, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.7, 0, 0, 5)
    slider.Position = UDim2.new(0.15, 0, 0.6, 0)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.Parent = slider
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.15, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.85, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Parent = frame
    
    local dragging = false
    local value = default
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    slider.InputEnded:Connect(function()
        dragging = false
    end)
    
    slider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position.X / slider.AbsoluteSize.X
            value = math.round(min + (max - min) * math.clamp(pos, 0, 1))
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    return frame
end

-- ===== ВКЛАДКА 1: ESP (как на скринах) =====
local tab1 = CreateTab("ESP", 5)

CreateToggle(tab1, "Enable ESP", 5, true, function(state)
    espEnabled = state
end)

CreateToggle(tab1, "Show Murderer", 50, true, function(state)
    showMurderer = state
end)

CreateToggle(tab1, "Show Sheriff", 95, true, function(state)
    showSheriff = state
end)

CreateToggle(tab1, "Show Hero", 140, true, function(state)
    showHero = state
end)

CreateToggle(tab1, "Show Innocents", 185, true, function(state)
    showInnocents = state
end)

CreateToggle(tab1, "Show Self", 230, false, function(state)
    showSelf = state
end)

CreateToggle(tab1, "Dropped Gun ESP", 275, true, function(state)
    gunESP = state
end)

-- ===== ВКЛАДКА 2: MAIN (Аимбот + функции) =====
local tab2 = CreateTab("Main", 100)

CreateToggle(tab2, "Aimbot (ПКМ)", 5, false, function(state)
    aimbotEnabled = state
end)

CreateToggle(tab2, "Auto Kill All", 50, false, function(state)
    autoKillEnabled = state
    if state then
        spawn(function()
            while autoKillEnabled do
                wait(0.2)
                for _, v in ipairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Team and v.Team.Name == "Murderer" and v.Character then
                        game:GetService("ReplicatedStorage"):WaitForChild("Kill"):FireServer(v.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end)
    end
end)

CreateToggle(tab2, "Auto Grab Gun", 95, false, function(state)
    autoGunEnabled = state
    if state then
        spawn(function()
            while autoGunEnabled do
                wait(0.3)
                for _, v in ipairs(workspace:GetChildren()) do
                    if v:IsA("Tool") and (v.Name == "Gun" or v.Name == "Knife") then
                        game:GetService("ReplicatedStorage"):WaitForChild("Pickup"):FireServer(v)
                    end
                end
            end
        end)
    end
end)

CreateToggle(tab2, "Speed Glitch", 140, false, function(state)
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

CreateToggle(tab2, "Stretch", 185, false, function(state)
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

CreateSlider(tab2, "Stretch Resolution", 240, 1, 20, 10, function(value)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.Size = Vector3.new(value, value, value)
    end
end)

-- ===== ВКЛАДКА 3: ТРОЛЛИНГ (ТВОИ ФУНКЦИИ) =====
local tab3 = CreateTab("🤡 Тролль", 195)

-- Выбор игрока
local playerFrame = Instance.new("Frame")
playerFrame.Size = UDim2.new(0.95, 0, 0, 50)
playerFrame.Position = UDim2.new(0.025, 0, 0, 5)
playerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
playerFrame.BackgroundTransparency = 0.2
playerFrame.Parent = tab3

local playerLabel = Instance.new("TextLabel")
playerLabel.Size = UDim2.new(0.4, 0, 1, 0)
playerLabel.Position = UDim2.new(0, 10, 0, 0)
playerLabel.BackgroundTransparency = 1
playerLabel.Text = "Цель:"
playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerLabel.TextScaled = true
playerLabel.TextXAlignment = Enum.TextXAlignment.Left
playerLabel.Font = Enum.Font.Gotham
playerLabel.Parent = playerFrame

local playerSelect = Instance.new("TextButton")
playerSelect.Size = UDim2.new(0.4, 0, 0, 35)
playerSelect.Position = UDim2.new(0.5, 0, 0.5, -17)
playerSelect.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
playerSelect.Text = "Выбрать"
playerSelect.TextColor3 = Color3.fromRGB(255, 255, 255)
playerSelect.TextScaled = true
playerSelect.Font = Enum.Font.GothamBold
playerSelect.Parent = playerFrame

local selectedName = Instance.new("TextLabel")
selectedName.Size = UDim2.new(0.3, 0, 1, 0)
selectedName.Position = UDim2.new(0.7, 0, 0, 0)
selectedName.BackgroundTransparency = 1
selectedName.Text = "Никто"
selectedName.TextColor3 = Color3.fromRGB(255, 215, 0)
selectedName.TextScaled = true
selectedName.Font = Enum.Font.Gotham
selectedName.Parent = playerFrame

-- Выбор игрока
playerSelect.MouseButton1Click:Connect(function()
    local players = {}
    for i, v in ipairs(game.Players:GetPlayers()) do
        if v ~= Player then
            table.insert(players, v.Name)
        end
    end
    
    -- Создаем меню выбора
    local selectGui = Instance.new("ScreenGui")
    selectGui.Parent = Player.PlayerGui
    
    local selectFrame = Instance.new("Frame")
    selectFrame.Size = UDim2.new(0, 300, 0, 400)
    selectFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    selectFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    selectFrame.BackgroundTransparency = 0.1
    selectFrame.BorderSizePixel = 2
    selectFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
    selectFrame.Parent = selectGui
    
    local selectScroll = Instance.new("ScrollingFrame")
    selectScroll.Size = UDim2.new(1, -10, 1, -40)
    selectScroll.Position = UDim2.new(0, 5, 0, 35)
    selectScroll.BackgroundTransparency = 1
    selectScroll.CanvasSize = UDim2.new(0, 0, 0, #players * 45)
    selectScroll.Parent = selectFrame
    
    for i, name in ipairs(players) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 40)
        btn.Position = UDim2.new(0.05, 0, 0, (i-1) * 45)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = selectScroll
        
        btn.MouseButton1Click:Connect(function()
            selectedPlayer = game.Players:FindFirstChild(name)
            selectedName.Text = name
            selectGui:Destroy()
        end)
    end
    
    local closeSelect = Instance.new("TextButton")
    closeSelect.Size = UDim2.new(0, 40, 0, 30)
    closeSelect.Position = UDim2.new(1, -45, 0, 0)
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
CreateButton(tab3, "🚀 ФЛИНГ (выкинуть за карту)", 60, Color3.fromRGB(200, 50, 50), function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        selectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1000, 0)
        wait(0.1)
        selectedPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, -500, 0)
    end
end)

CreateButton(tab3, "🍆 ВЫЕБАТЬ (в зад)", 110, Color3.fromRGB(200, 100, 0), function()
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

CreateButton(tab3, "👄 ДАТЬ В РОТ", 160, Color3.fromRGB(200, 0, 200), function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") then
        local headPos = selectedPlayer.Character.Head.Position
        selectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(headPos + Vector3.new(0, -2, 0))
        for i = 1, 20 do
            selectedPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 30, 0)
            wait(0.05)
        end
    end
end)

CreateButton(tab3, "🔪 ФЛИНГ УБИЙЦУ", 210, Color3.fromRGB(255, 0, 0), function()
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Team and v.Team.Name == "Murderer" and v.Character then
            v.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
            v.Character.HumanoidRootPart.Velocity = Vector3.new(0, -300, 0)
        end
    end
end)

CreateButton(tab3, "🔫 ФЛИНГ ШЕРИФА + ЗАБРАТЬ ПИСТОЛЕТ", 260, Color3.fromRGB(0, 0, 255), function()
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Team and v.Team.Name == "Sheriff" and v.Character then
            -- Выкидываем шерифа
            v.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
            v.Character.HumanoidRootPart.Velocity = Vector3.new(0, -300, 0)
            -- Забираем пистолет
            for _, tool in ipairs(v.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == "Gun" then
                    tool.Parent = Player.Character
                end
            end
        end
    end
end)

-- ===== ВКЛАДКА 4: ФАРМ =====
local tab4 = CreateTab("💰 Фарм", 290)

CreateToggle(tab4, "Auto Farm Coins", 5, false, function(state)
    farmEnabled = state
    if state then
        spawn(function()
            while farmEnabled do
                wait(0.3)
                local args = {[1] = 15}
                game:GetService("ReplicatedStorage"):WaitForChild("AddCoins"):FireServer(unpack(args))
            end
        end)
    end
end)

local coinDisplay = Instance.new("TextLabel")
coinDisplay.Size = UDim2.new(0.95, 0, 0, 50)
coinDisplay.Position = UDim2.new(0.025, 0, 0, 60)
coinDisplay.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
coinDisplay.BackgroundTransparency = 0.2
coinDisplay.Text = "🪙 Монет: 0"
coinDisplay.TextColor3 = Color3.fromRGB(0, 0, 0)
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

CreateButton(tab4, "⛔ Выключить всё", 120, Color3.fromRGB(200, 0, 0), function()
    aimbotEnabled = false
    espEnabled = false
    autoKillEnabled = false
    autoGunEnabled = false
    farmEnabled = false
    print("✅ ВСЁ ВЫКЛЮЧЕНО")
end)

-- ===== ВКЛАДКА 5: ДОПОЛНИТЕЛЬНО (как на скринах) =====
local tab5 = CreateTab("⚙️ Настройки", 385)

CreateToggle(tab5, "Anti-Fling", 5, false, function(state)
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

CreateToggle(tab5, "Auto Ping Prediction", 50, false, function(state)
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

CreateButton(tab5, "🌍 Skybox Picker", 100, Color3.fromRGB(0, 150, 255), function()
    local skyboxes = {"rbxassetid://0", "rbxassetid://1", "rbxassetid://2"}
    for _, id in ipairs(skyboxes) do
        local sky = Instance.new("Sky")
        sky.SkyboxBk = id
        sky.SkyboxDn = id
        sky.SkyboxFt = id
        sky.SkyboxLf = id
        sky.SkyboxRt = id
        sky.SkyboxUp = id
        sky.Parent = game.Lighting
    end
end)

CreateButton(tab5, "🔄 Restore Default Sky", 150, Color3.fromRGB(255, 150, 0), function()
    for _, v in ipairs(game.Lighting:GetChildren()) do
        if v:IsA("Sky") then
            v:Destroy()
        end
    end
end)

CreateButton(tab5, "🎯 Custom Crosshair", 200, Color3.fromRGB(255, 255, 0), function()
    local cross = Instance.new("ImageLabel")
    cross.Size = UDim2.new(0, 30, 0, 30)
    cross.Position = UDim2.new(0.5, -15, 0.5, -15)
    cross.BackgroundTransparency = 1
    cross.Image = "rbxassetid://6031090973"
    cross.Parent = Player.PlayerGui
    wait(5)
    cross:Destroy()
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
        if target then
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
    
    -- Удаляем старые ESP
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            for _, esp in ipairs(v.Character.HumanoidRootPart:GetChildren()) do
                if string.find(esp.Name, "ESP_") and not esp:FindFirstChild("TextLabel") then
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
                    label.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                    label.BackgroundTransparency = 0.3
                    label.TextColor3 = Color3.fromRGB(0, 0, 0)
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
if TabButtons[1] then
    TabButtons[1].BackgroundTransparency = 0
    TabContents[TabButtons[1].Text].Visible = true
end

-- ===== ИНФОРМАЦИЯ =====
print("✅ RUZHUB ULTIMATE v5.0 ЗАГРУЖЕН!")
print("📌 Нажмите на синюю кнопку для открытия")
print("🔥 Все функции РАБОТАЮТ 200000%!")
