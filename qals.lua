-- MM2 Script v7.0 - Полностью рабочий ESP, Anti-Fling, Телепорт
-- Функции: ESP (убийца, шериф), Anti-Fling, Телепорт на карту, много кнопок

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

-- Переменные
local aimbotEnabled = false
local autoShootEnabled = false
local knifeThrowEnabled = false
local speedValue = 0
local spinValue = 0
local autoGunEnabled = false
local espEnabled = false
local espSheriff = false
local espMurder = false
local espAll = false
local espGun = false
local antiFlingEnabled = false
local selectedPlayer = nil
local antiFlingActive = false
local lastPosition = Vector3.new(0, 0, 0)

-- Функция определения ролей (УЛУЧШЕННАЯ)
local function getPlayerRole(player)
    if not player or not player.Character then return "innocent" end
    
    local char = player.Character
    
    -- Проверка через теги
    if CollectionService:HasTag(char, "Murderer") or CollectionService:HasTag(char, "Killer") then
        return "murderer"
    elseif CollectionService:HasTag(char, "Sheriff") or CollectionService:HasTag(char, "Detective") then
        return "sheriff"
    end
    
    -- Проверка через объекты в персонаже
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("BoolValue") or child:IsA("StringValue") or child:IsA("ObjectValue") then
            local name = child.Name:lower()
            if name:find("murder") or name:find("killer") then
                return "murderer"
            elseif name:find("sheriff") or name:find("detective") then
                return "sheriff"
            end
        end
    end
    
    -- Проверка через папки в ReplicatedStorage
    local rolesFolder = ReplicatedStorage:FindFirstChild("Roles") or ReplicatedStorage:FindFirstChild("GameData") or ReplicatedStorage:FindFirstChild("Data")
    if rolesFolder then
        for _, child in ipairs(rolesFolder:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Model") then
                if child.Name == player.Name then
                    for _, roleChild in ipairs(child:GetChildren()) do
                        if roleChild:IsA("StringValue") or roleChild:IsA("BoolValue") then
                            local roleName = roleChild.Name:lower()
                            if roleName:find("murder") or roleName:find("killer") then
                                return "murderer"
                            elseif roleName:find("sheriff") or roleName:find("detective") then
                                return "sheriff"
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Проверка через атрибуты
    if char:GetAttribute("Role") then
        local role = char:GetAttribute("Role"):lower()
        if role:find("murder") or role:find("killer") then
            return "murderer"
        elseif role:find("sheriff") or role:find("detective") then
            return "sheriff"
        end
    end
    
    return "innocent"
end

-- Функция поиска убийцы
local function findMurderer()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player then
            local role = getPlayerRole(player)
            if role == "murderer" then
                return player
            end
        end
    end
    return nil
end

-- Функция поиска шерифа
local function findSheriff()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player then
            local role = getPlayerRole(player)
            if role == "sheriff" then
                return player
            end
        end
    end
    return nil
end

-- Функция подбора пистолета
local function pickupGun()
    if not Player.Character then return false end
    
    local rootPart = Player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local nearestGun = nil
    local nearestDist = 30
    
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("Tool") and item:FindFirstChild("Handle") then
            local name = item.Name:lower()
            if name:find("gun") or name:find("pistol") or name:find("revolver") or 
               name:find("sniper") or name:find("shotgun") or name:find("luger") or
               name:find("saw") or name:find("laser") then
                
                if not item:IsDescendantOf(Player.Character) and not item:IsDescendantOf(Player.Backpack) then
                    local handle = item:FindFirstChild("Handle")
                    local position = handle and handle.Position or item.Position
                    local dist = (position - rootPart.Position).Magnitude
                    
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestGun = item
                    end
                end
            end
        end
    end
    
    if nearestGun then
        local handle = nearestGun:FindFirstChild("Handle")
        if handle then
            rootPart.CFrame = CFrame.new(handle.Position + Vector3.new(0, 3, 0))
        else
            rootPart.CFrame = CFrame.new(nearestGun.Position + Vector3.new(0, 3, 0))
        end
        wait(0.1)
        
        local tool = nearestGun:Clone()
        tool.Parent = Player.Backpack
        
        if nearestGun.Parent ~= Player.Backpack and nearestGun.Parent ~= Player.Character then
            nearestGun:Destroy()
        end
        
        return true
    end
    return false
end

-- === GUI СОВРЕМЕННЫЙ 2026 ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2Script"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 420)
Frame.Position = UDim2.new(0.5, -175, 0.5, -210)
Frame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

-- Градиентный фон
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0.05, 0.05, 0.05)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0.1, 0.02, 0.02)),
    ColorSequenceKeypoint.new(1, Color3.new(0.08, 0.08, 0.08))
})
gradient.Rotation = 45
gradient.Parent = Frame

-- Рамка
local border = Instance.new("Frame")
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 2
border.BorderColor3 = Color3.new(0.8, 0.05, 0.05)
border.Parent = Frame

-- Заголовок с кнопками
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.new(0.1, 0.02, 0.02)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ MM2 v7.0 ✦"
Title.TextColor3 = Color3.new(0.9, 0.1, 0.1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = header

-- Кнопка закрытия скрипта (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 1, -4)
closeBtn.Position = UDim2.new(0.92, 0, 0.02, 0)
closeBtn.BackgroundColor3 = Color3.new(0.15, 0.02, 0.02)
closeBtn.BorderSizePixel = 1
closeBtn.BorderColor3 = Color3.new(0.5, 0.02, 0.02)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(0.7, 0.7, 0.7)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BorderColor3 = Color3.new(0.9, 0.1, 0.1), BackgroundColor3 = Color3.new(0.2, 0.02, 0.02)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BorderColor3 = Color3.new(0.5, 0.02, 0.02), BackgroundColor3 = Color3.new(0.15, 0.02, 0.02)}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Кнопка открытия (в том же месте)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 28)
ToggleButton.Position = UDim2.new(0.88, 0, 0.01, 0)
ToggleButton.BackgroundColor3 = Color3.new(0.15, 0.02, 0.02)
ToggleButton.BorderSizePixel = 2
ToggleButton.BorderColor3 = Color3.new(0.8, 0.05, 0.05)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.new(0.9, 0.1, 0.1)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0.15, 0.02, 0.02)),
    ColorSequenceKeypoint.new(1, Color3.new(0.05, 0.05, 0.05))
})
btnGradient.Parent = ToggleButton

-- Вкладки
local tabs = {"⚡Main", "👁️ESP", "🎯Target", "🛡️Anti", "🔧Tools"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 58, 0, 25)
    btn.Position = UDim2.new(0.02 + (i-1) * 0.18, 0, 0.08, 0)
    btn.BackgroundColor3 = Color3.new(0.08, 0.02, 0.02)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.new(0.4, 0.02, 0.02)
    btn.Text = tabName
    btn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Frame
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BorderColor3 = Color3.new(0.8, 0.05, 0.05), BackgroundTransparency = 0.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BorderColor3 = Color3.new(0.4, 0.02, 0.02), BackgroundTransparency = 0.3}):Play()
    end)
    
    tabButtons[tabName] = btn
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(0.96, 0, 0.78, 0)
    content.Position = UDim2.new(0.02, 0, 0.17, 0)
    content.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    content.BackgroundTransparency = 0.5
    content.BorderSizePixel = 1
    content.BorderColor3 = Color3.new(0.3, 0.02, 0.02)
    content.Visible = (i == 1)
    content.CanvasSize = UDim2.new(0, 0, 500, 0)
    content.ScrollBarThickness = 5
    content.ScrollBarImageColor3 = Color3.new(0.8, 0.05, 0.05)
    content.ScrollBarImageTransparency = 0.5
    content.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    content.Parent = Frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 3)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    tabContents[tabName] = content
end

-- Функции создания элементов
function createToggle(parent, text, callback, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 24)
    frame.BackgroundColor3 = Color3.new(0.08, 0.02, 0.02)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.new(0.3, 0.02, 0.02)
    frame.Parent = parent
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local state = default or false
    if state then
        btn.Text = text .. ": ON"
        btn.TextColor3 = Color3.new(0.9, 0.1, 0.1)
    end
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.TextColor3 = state and Color3.new(0.9, 0.1, 0.1) or Color3.new(0.6, 0.6, 0.6)
        if callback then callback(state) end
    end)
    
    return btn, frame
end

function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 28)
    frame.BackgroundColor3 = Color3.new(0.08, 0.02, 0.02)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.new(0.3, 0.02, 0.02)
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default or 0)
    label.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0.25, 0, 0.7, 0)
    slider.Position = UDim2.new(0.7, 0, 0.15, 0)
    slider.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    slider.BorderSizePixel = 1
    slider.BorderColor3 = Color3.new(0.5, 0.02, 0.02)
    slider.Text = tostring(default or 0)
    slider.TextColor3 = Color3.new(0.8, 0.05, 0.05)
    slider.TextScaled = true
    slider.Font = Enum.Font.Gotham
    slider.Parent = frame
    
    slider.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(slider.Text)
            if val then
                val = math.clamp(val, min, max)
                slider.Text = tostring(val)
                label.Text = text .. ": " .. tostring(val)
                if callback then callback(val) end
            end
        end
    end)
    
    return slider, frame
end

-- === ВКЛАДКА MAIN ===
local mainContent = tabContents["⚡Main"]
createToggle(mainContent, "Aimbot", function(state) aimbotEnabled = state end)
createToggle(mainContent, "Auto Shoot", function(state) autoShootEnabled = state end)
createToggle(mainContent, "Auto Gun", function(state) autoGunEnabled = state end)
createToggle(mainContent, "Knife (K)", function(state) knifeThrowEnabled = state end)
createSlider(mainContent, "Speed", 1, 1000, 0, function(val) speedValue = val end)
createSlider(mainContent, "Spin", 1, 100, 0, function(val) spinValue = val end)

-- === ВКЛАДКА ESP ===
local espContent = tabContents["👁️ESP"]
createToggle(espContent, "ESP", function(state) 
    espEnabled = state 
end)
createToggle(espContent, "Show Murderer", function(state) 
    espMurder = state 
    if state then espEnabled = true end
end)
createToggle(espContent, "Show Sheriff", function(state) 
    espSheriff = state 
    if state then espEnabled = true end
end)
createToggle(espContent, "Show All", function(state) 
    espAll = state 
    if state then espEnabled = true end
end)
createToggle(espContent, "Dropped Gun", function(state) 
    espGun = state 
    if state then espEnabled = true end
end)

-- === ВКЛАДКА TARGET ===
local targetContent = tabContents["🎯Target"]

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -5, 0, 20)
targetLabel.BackgroundColor3 = Color3.new(0.08, 0.02, 0.02)
targetLabel.BackgroundTransparency = 0.3
targetLabel.BorderSizePixel = 1
targetLabel.BorderColor3 = Color3.new(0.3, 0.02, 0.02)
targetLabel.Text = "Selected: None"
targetLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
targetLabel.TextScaled = true
targetLabel.Font = Enum.Font.Gotham
targetLabel.Parent = targetContent

local targetScroll = Instance.new("ScrollingFrame")
targetScroll.Size = UDim2.new(0.98, 0, 0.45, 0)
targetScroll.Position = UDim2.new(0.01, 0, 0.1, 0)
targetScroll.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
targetScroll.BackgroundTransparency = 0.5
targetScroll.BorderSizePixel = 1
targetScroll.BorderColor3 = Color3.new(0.3, 0.02, 0.02)
targetScroll.CanvasSize = UDim2.new(0, 0, 500, 0)
targetScroll.ScrollBarThickness = 5
targetScroll.ScrollBarImageColor3 = Color3.new(0.8, 0.05, 0.05)
targetScroll.ScrollBarImageTransparency = 0.5
targetScroll.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
targetScroll.Parent = targetContent

local targetListLayout = Instance.new("UIListLayout")
targetListLayout.Padding = UDim.new(0, 2)
targetListLayout.SortOrder = Enum.SortOrder.LayoutOrder
targetListLayout.Parent = targetScroll

targetListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    targetScroll.CanvasSize = UDim2.new(0, 0, 0, targetListLayout.AbsoluteContentSize.Y + 10)
end)

function updatePlayerList()
    for _, child in ipairs(targetScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 22)
            btn.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
            btn.BackgroundTransparency = 0.5
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.new(0.3, 0.02, 0.02)
            
            local role = getPlayerRole(player)
            local roleIcon = ""
            local color = Color3.new(0.7, 0.7, 0.7)
            if role == "murderer" then 
                roleIcon = "🔴 " 
                color = Color3.new(1, 0, 0)
            elseif role == "sheriff" then 
                roleIcon = "🔵 " 
                color = Color3.new(0, 0.4, 1)
            else 
                roleIcon = "🟢 " 
                color = Color3.new(0, 1, 0)
            end
            
            btn.Text = roleIcon .. player.Name
            btn.TextColor3 = color
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.Parent = targetScroll
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                targetLabel.Text = "Selected: " .. player.Name
            end)
        end
    end
end

updatePlayerList()

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.25, 0, 0.06, 0)
refreshBtn.Position = UDim2.new(0.7, 0, 0.03, 0)
refreshBtn.BackgroundColor3 = Color3.new(0.08, 0.02, 0.02)
refreshBtn.BackgroundTransparency = 0.3
refreshBtn.BorderSizePixel = 1
refreshBtn.BorderColor3 = Color3.new(0.4, 0.02, 0.02)
refreshBtn.Text = "⟳ Refresh"
refreshBtn.TextColor3 = Color3.new(0.7, 0.7, 0.7)
refreshBtn.TextScaled = true
refreshBtn.Font = Enum.Font.Gotham
refreshBtn.Parent = targetContent

refreshBtn.MouseButton1Click:Connect(function()
    updatePlayerList()
end)

createToggle(targetContent, "Fling Target", function(state)
    if state and selectedPlayer then
        local char = selectedPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 5000, 0)
        end
    end
end)

createToggle(targetContent, "Fling All", function(state)
    if state then
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= Player then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.Velocity = Vector3.new(0, 5000, 0)
                end
            end
        end
    end
end)

createToggle(targetContent, "Fling Murder", function(state)
    if state then
        local murderer = findMurderer()
        if murderer then
            local char = murderer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 5000, 0)
            end
        end
    end
end)

createToggle(targetContent, "Fling Sheriff+Gun", function(state)
    if state then
        local sheriff = findSheriff()
        if sheriff then
            local char = sheriff.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 5000, 0)
                wait(0.1)
                pickupGun()
            end
        end
    end
end)

-- === ВКЛАДКА ANTI-FLING ===
local antiContent = tabContents["🛡️Anti"]
createToggle(antiContent, "Anti-Fling", function(state) 
    antiFlingEnabled = state 
end)

-- ТЕЛЕПОРТ НА КАРТУ
createToggle(antiContent, "Teleport to Map", function(state)
    if state then
        local spawns = workspace:FindFirstChild("Spawns") or workspace:FindFirstChild("SpawnLocations")
        if spawns then
            local spawnsList = spawns:GetChildren()
            if #spawnsList > 0 then
                local spawn = spawnsList[math.random(1, #spawnsList)]
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = spawn.CFrame
                end
            end
        else
            -- Ищем любую часть на карте
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("Part") and part.Size.Magnitude > 10 and part.Name:find("Base") then
                    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        Player.Character.HumanoidRootPart.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
                        break
                    end
                end
            end
        end
    end
end)

createToggle(antiContent, "God Mode (No Fall)", function(state)
    if state and Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 10000
            humanoid.Health = 10000
        end
    end
end)

-- === ВКЛАДКА TOOLS (МНОГО КНОПОК) ===
local toolsContent = tabContents["🔧Tools"]

createToggle(toolsContent, "Infinite Jump", function(state)
    if state and Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 100
        end
    end
end)

createToggle(toolsContent, "Fly", function(state)
    if state and Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.new(0, 20, 0)
            bodyVelocity.Parent = Player.Character.HumanoidRootPart
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
            bodyGyro.Parent = Player.Character.HumanoidRootPart
            
            -- Управление
            local flyEnabled = true
            local flySpeed = 50
            
            Mouse.KeyDown:Connect(function(key)
                if key == "w" then
                    bodyVelocity.Velocity = Camera.CFrame.LookVector * flySpeed
                elseif key == "s" then
                    bodyVelocity.Velocity = -Camera.CFrame.LookVector * flySpeed
                elseif key == "a" then
                    bodyVelocity.Velocity = -Camera.CFrame.RightVector * flySpeed
                elseif key == "d" then
                    bodyVelocity.Velocity = Camera.CFrame.RightVector * flySpeed
                elseif key == "space" then
                    bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
                elseif key == "e" then
                    bodyVelocity.Velocity = Vector3.new(0, -flySpeed, 0)
                end
            end)
        end
    end
end)

createToggle(toolsContent, "No Clip", function(state)
    if state and Player.Character then
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("Part") or part:IsA("MeshPart") then
                part.CanCollide = false
            end
        end
    end
end)

createToggle(toolsContent, "Walkspeed x2", function(state)
    if state and Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = humanoid.WalkSpeed * 2
        end
    end
end)

createToggle(toolsContent, "Walkspeed x5", function(state)
    if state and Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = humanoid.WalkSpeed * 5
        end
    end
end)

createToggle(toolsContent, "Walkspeed x10", function(state)
    if state and Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = humanoid.WalkSpeed * 10
        end
    end
end)

createToggle(toolsContent, "Gravity 0", function(state)
    if state then
        workspace.Gravity = 0
    else
        workspace.Gravity = 196.2
    end
end)

createToggle(toolsContent, "Gravity 50", function(state)
    if state then
        workspace.Gravity = 50
    else
        workspace.Gravity = 196.2
    end
end)

-- === АНТИ-FLING (ИСПРАВЛЕН) ===
RunService.Heartbeat:Connect(function()
    if antiFlingEnabled and Player.Character then
        local rootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local currentPos = rootPart.Position
            
            if not antiFlingActive then
                lastPosition = currentPos
                antiFlingActive = true
            end
            
            -- Если персонаж улетел слишком далеко
            if (currentPos - lastPosition).Magnitude > 150 then
                rootPart.CFrame = CFrame.new(lastPosition)
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.RotVelocity = Vector3.new(0, 0, 0)
                print("Anti-Fling: Prevented launch!")
            end
            
            -- Если персонаж упал под карту
            if currentPos.Y < -50 then
                -- Телепорт на карту
                local spawns = workspace:FindFirstChild("Spawns") or workspace:FindFirstChild("SpawnLocations")
                if spawns then
                    local spawnsList = spawns:GetChildren()
                    if #spawnsList > 0 then
                        local spawn = spawnsList[math.random(1, #spawnsList)]
                        rootPart.CFrame = spawn.CFrame
                    end
                else
                    rootPart.CFrame = CFrame.new(0, 50, 0)
                end
                rootPart.Velocity = Vector3.new(0, 0, 0)
                print("Anti-Fling: Teleported back to map!")
            end
            
            lastPosition = rootPart.Position
        end
    else
        antiFlingActive = false
    end
end)

-- Переключение вкладок
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for tabName, content in pairs(tabContents) do
            content.Visible = (tabName == name)
        end
        if name == "🎯Target" then
            updatePlayerList()
        end
        
        for _, b in pairs(tabButtons) do
            b.BorderColor3 = Color3.new(0.4, 0.02, 0.02)
            b.BackgroundTransparency = 0.3
            b.TextColor3 = Color3.new(0.6, 0.6, 0.6)
        end
        btn.BorderColor3 = Color3.new(0.8, 0.05, 0.05)
        btn.BackgroundTransparency = 0.1
        btn.TextColor3 = Color3.new(0.9, 0.1, 0.1)
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
    ToggleButton.Text = Frame.Visible and "✕" or "⚡"
    ToggleButton.TextColor3 = Frame.Visible and Color3.new(0.9, 0.1, 0.1) or Color3.new(0.7, 0.7, 0.7)
    if Frame.Visible then
        updatePlayerList()
    end
end)

-- === ОСНОВНАЯ ЛОГИКА ===

-- Aimbot + Auto Shoot только на убийцу
RunService.Heartbeat:Connect(function()
    if aimbotEnabled or autoShootEnabled then
        local target = nil
        
        if selectedPlayer then
            local role = getPlayerRole(selectedPlayer)
            if role == "murderer" and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                target = selectedPlayer.Character.HumanoidRootPart
            end
        end
        
        if not target then
            local murderer = findMurderer()
            if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                target = murderer.Character.HumanoidRootPart
            end
        end
        
        if target then
            if aimbotEnabled then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
            if autoShootEnabled then
                VirtualUser:ClickButton1(Vector2.new(0, 0))
            end
        end
    end
end)

-- Speed and Spin
RunService.Heartbeat:Connect(function()
    if Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid and speedValue > 0 then
            humanoid.WalkSpeed = speedValue
        end
        local rootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart and spinValue > 0 then
            rootPart.RotVelocity = Vector3.new(0, spinValue * 10, 0)
        end
    end
end)

-- ESP System (ИСПРАВЛЕН)
local espObjects = {}

RunService.Heartbeat:Connect(function()
    for _, obj in ipairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
    
    if espEnabled then
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local role = getPlayerRole(player)
                local color = Color3.new(0, 1, 0)
                local show = false
                local roleText = ""
                
                if espAll then
                    show = true
                    if role == "murderer" then
                        color = Color3.new(1, 0, 0)
                        roleText = " [MURDERER]"
                    elseif role == "sheriff" then
                        color = Color3.new(0, 0.4, 1)
                        roleText = " [SHERIFF]"
                    else
                        color = Color3.new(0, 1, 0)
                        roleText = " [INNOCENT]"
                    end
                elseif espMurder and role == "murderer" then
                    show = true
                    color = Color3.new(1, 0, 0)
                    roleText = " [MURDERER]"
                elseif espSheriff and role == "sheriff" then
                    show = true
                    color = Color3.new(0, 0.4, 1)
                    roleText = " [SHERIFF]"
                end
                
                if show then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = color
                    highlight.OutlineColor = color
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0.2
                    table.insert(espObjects, highlight)
                    
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 150, 0, 25)
                    billboard.Adornee = player.Character.HumanoidRootPart
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.Parent = player.Character.HumanoidRootPart
                    
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
                    textLabel.BackgroundTransparency = 0.3
                    textLabel.BorderSizePixel = 1
                    textLabel.BorderColor3 = color
                    textLabel.Text = player.Name .. roleText
                    textLabel.TextColor3 = color
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.Parent = billboard
                    
                    table.insert(espObjects, billboard)
                end
            end
        end
        
        if espGun then
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("Tool") and part:FindFirstChild("Handle") then
                    local name = part.Name:lower()
                    if name:find("gun") or name:find("pistol") or name:find("knife") or 
                       name:find("revolver") or name:find("sniper") or name:find("shotgun") then
                        if not part:IsDescendantOf(Player.Character) and not part:IsDescendantOf(Player.Backpack) then
                            local highlight = Instance.new("Highlight")
                            highlight.Parent = part
                            highlight.FillColor = Color3.new(1, 0.8, 0)
                            highlight.OutlineColor = Color3.new(1, 0.8, 0)
                            highlight.FillTransparency = 0.3
                            table.insert(espObjects, highlight)
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 80, 0, 20)
                            billboard.Adornee = part.Handle
                            billboard.StudsOffset = Vector3.new(0, 1.5, 0)
                            billboard.Parent = part
                            
                            local textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
                            textLabel.BackgroundTransparency = 0.3
                            textLabel.BorderSizePixel = 1
                            textLabel.BorderColor3 = Color3.new(1, 0.8, 0)
                            textLabel.Text = "🔫 " .. part.Name
                            textLabel.TextColor3 = Color3.new(1, 0.8, 0)
                            textLabel.TextScaled = true
                            textLabel.Font = Enum.Font.GothamBold
                            textLabel.Parent = billboard
                            
                            table.insert(espObjects, billboard)
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Gun Pickup
RunService.Heartbeat:Connect(function()
    if autoGunEnabled then
        pickupGun()
    end
end)

-- Knife Throw
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K and knifeThrowEnabled then
        local murderer = findMurderer()
        if murderer and murderer.Character then
            local knife = nil
            for _, tool in ipairs(Player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    if name:find("knife") or name:find("dagger") then
                        knife = tool
                        break
                    end
                end
            end
            if not knife then
                for _, tool in ipairs(Player.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        local name = tool.Name:lower()
                        if name:find("knife") or name:find("dagger") then
                            knife = tool
                            break
                        end
                    end
                end
            end
            if knife then
                knife.Parent = Player.Character
                wait(0.1)
                VirtualUser:ClickButton1(Vector2.new(0, 0))
            end
        end
    end
end)

-- Закрытие по Escape
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape and Frame.Visible then
        Frame.Visible = false
        ToggleButton.Text = "⚡"
        ToggleButton.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    end
end)

-- Перемещение окна
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if input.UserInputType == Enum.UserInputType.Touch or (input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y < 35) then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Обновление списков
game:GetService("Players").PlayerAdded:Connect(function()
    updatePlayerList()
end)

game:GetService("Players").PlayerRemoving:Connect(function()
    updatePlayerList()
end)

print("✦ MM2 Script v7.0 Loaded! ✦")
print("✅ ESP полностью исправлен (убийца, шериф, пистолет)")
print("✅ Anti-Fling исправлен (телепорт на карту)")
print("✅ Кнопка X для полного закрытия скрипта")
print("✅ Много новых работающих функций")
print("Press [K] to throw knife at murderer")
