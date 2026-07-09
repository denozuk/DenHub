-- MM2 Script: Исправленная версия
-- Убраны "выебать" функции, починен поиск оружия, ролей и подбор пистолета

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

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
local selectedWeapon = nil

-- Функция определения ролей (УЛУЧШЕННАЯ)
local function getPlayerRole(player)
    if not player or not player.Character then return "innocent" end
    
    local char = player.Character
    
    -- Проверка через теги
    if CollectionService:HasTag(char, "Murderer") then
        return "murderer"
    elseif CollectionService:HasTag(char, "Sheriff") then
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
    
    -- Проверка через папки в ReplicatedStorage (если роли там)
    local rolesFolder = ReplicatedStorage:FindFirstChild("Roles") or ReplicatedStorage:FindFirstChild("GameData")
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
    
    -- Проверка через RemoteEvents (продвинутый метод)
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child:IsA("RemoteEvent") and child.Name:lower():find("role") then
            -- Пытаемся получить роль через удаленное событие (если есть)
            -- Это сложно реализовать без знания конкретного события
        end
    end
    
    return "innocent"
end

-- Функция поиска оружия (УЛУЧШЕННАЯ)
local function getAllWeapons()
    local weapons = {}
    local searchLocations = {
        ReplicatedStorage,
        workspace,
        game:GetService("ServerStorage"),
        game:GetService("Lighting"),
        Player.Backpack,
        Player.Character
    }
    
    for _, location in ipairs(searchLocations) do
        if location then
            for _, item in ipairs(location:GetDescendants()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    -- Проверяем, что это не оружие игрока (если в инвентаре)
                    if not item:IsDescendantOf(Player.Character) and not item:IsDescendantOf(Player.Backpack) then
                        local name = item.Name
                        -- Фильтруем мусор
                        if not name:find("Humanoid") and not name:find("Part") and #name > 1 then
                            table.insert(weapons, name)
                        end
                    end
                end
            end
        end
    end
    
    -- Удаляем дубликаты
    local uniqueWeapons = {}
    for _, name in ipairs(weapons) do
        if not uniqueWeapons[name] then
            uniqueWeapons[name] = true
        end
    end
    
    local result = {}
    for name, _ in pairs(uniqueWeapons) do
        table.insert(result, name)
    end
    table.sort(result)
    return result
end

-- Функция подбора пистолета (УЛУЧШЕННАЯ)
local function pickupGun()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = Player.Character.HumanoidRootPart
    local nearestGun = nil
    local nearestDist = 50 -- Максимальное расстояние поиска
    
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            -- Проверяем, что это пистолет/оружие
            if name:find("gun") or name:find("pistol") or name:find("revolver") or 
               name:find("sniper") or name:find("shotgun") or name:find("rifle") or
               item:FindFirstChild("Handle") then
                
                -- Проверяем, что оружие не в инвентаре игрока
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
        -- Телепортируемся к оружию и подбираем
        local handle = nearestGun:FindFirstChild("Handle")
        local targetPos = handle and handle.Position or nearestGun.Position
        
        -- Телепорт к оружию
        rootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
        wait(0.1)
        
        -- Пытаемся подобрать через клик
        local tool = nearestGun:Clone()
        tool.Parent = Player.Backpack
        
        -- Удаляем оригинал
        if nearestGun.Parent ~= Player.Backpack and nearestGun.Parent ~= Player.Character then
            nearestGun:Destroy()
        end
        
        return true
    end
    return false
end

-- Создание GUI (ТА ЖЕ ЧАСТЬ)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2Script"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 600, 0, 500)
Frame.Position = UDim2.new(0.5, -300, 0.5, -250)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 3
Frame.BorderColor3 = Color3.new(0, 1, 0)
Frame.Visible = false
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.new(0, 0, 0)
Title.BorderSizePixel = 2
Title.BorderColor3 = Color3.new(0, 1, 0)
Title.Text = "MM2 SCRIPT v3.0"
Title.TextColor3 = Color3.new(0, 1, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 35)
ToggleButton.Position = UDim2.new(0.85, 0, 0.02, 0)
ToggleButton.BackgroundColor3 = Color3.new(0, 0, 0)
ToggleButton.BorderSizePixel = 3
ToggleButton.BorderColor3 = Color3.new(0, 1, 0)
ToggleButton.Text = "Open Menu"
ToggleButton.TextColor3 = Color3.new(0, 1, 0)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

-- Вкладки
local tabs = {"Main", "ESP", "Target", "Weapons", "Anti-Fling"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.Position = UDim2.new(0.02 + (i-1) * 0.17, 0, 0.085, 0)
    btn.BackgroundColor3 = Color3.new(0, 0, 0)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.new(0, 1, 0)
    btn.Text = tabName
    btn.TextColor3 = Color3.new(0, 1, 0)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Frame
    
    tabButtons[tabName] = btn
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(0.96, 0, 0.78, 0)
    content.Position = UDim2.new(0.02, 0, 0.18, 0)
    content.BackgroundColor3 = Color3.new(0, 0, 0)
    content.BackgroundTransparency = 0.5
    content.BorderSizePixel = 2
    content.BorderColor3 = Color3.new(0, 1, 0)
    content.Visible = (i == 1)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Parent = Frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    tabContents[tabName] = content
end

-- Функции создания элементов GUI (ТЕ ЖЕ)
function createToggle(parent, text, callback, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.new(0, 1, 0)
    frame.Parent = parent
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = Color3.new(0, 0, 0)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(0, 1, 0)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local state = default or false
    if state then
        btn.Text = text .. ": ON"
        btn.TextColor3 = Color3.new(0, 1, 0)
    end
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        if callback then callback(state) end
    end)
    
    return btn, frame
end

function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.new(0, 1, 0)
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundColor3 = Color3.new(0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default or 0)
    label.TextColor3 = Color3.new(0, 1, 0)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0.3, 0, 0.7, 0)
    slider.Position = UDim2.new(0.65, 0, 0.15, 0)
    slider.BackgroundColor3 = Color3.new(0, 0, 0)
    slider.BorderSizePixel = 2
    slider.BorderColor3 = Color3.new(0, 1, 0)
    slider.Text = tostring(default or 0)
    slider.TextColor3 = Color3.new(0, 1, 0)
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
local mainContent = tabContents["Main"]
createToggle(mainContent, "Aimbot", function(state) aimbotEnabled = state end)
createToggle(mainContent, "Auto Shoot", function(state) autoShootEnabled = state end)
createToggle(mainContent, "Auto Gun Pickup", function(state) autoGunEnabled = state end)
createToggle(mainContent, "Knife Throw (K)", function(state) knifeThrowEnabled = state end)
createSlider(mainContent, "Speed", 1, 1000, 0, function(val) speedValue = val end)
createSlider(mainContent, "Spin", 1, 100, 0, function(val) spinValue = val end)

-- === ВКЛАДКА ESP ===
local espContent = tabContents["ESP"]
createToggle(espContent, "ESP", function(state) espEnabled = state end)
createToggle(espContent, "ESP Sheriffs", function(state) espSheriff = state end)
createToggle(espContent, "ESP Murder", function(state) espMurder = state end)
createToggle(espContent, "ESP All", function(state) espAll = state end)
createToggle(espContent, "ESP Gun", function(state) espGun = state end)

-- === ВКЛАДКА TARGET ===
local targetContent = tabContents["Target"]

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -10, 0, 30)
targetLabel.BackgroundColor3 = Color3.new(0, 0, 0)
targetLabel.BackgroundTransparency = 0.3
targetLabel.BorderSizePixel = 2
targetLabel.BorderColor3 = Color3.new(0, 1, 0)
targetLabel.Text = "Selected: None"
targetLabel.TextColor3 = Color3.new(0, 1, 0)
targetLabel.TextScaled = true
targetLabel.Font = Enum.Font.Gotham
targetLabel.Parent = targetContent

local targetScroll = Instance.new("ScrollingFrame")
targetScroll.Size = UDim2.new(0.98, 0, 0.6, 0)
targetScroll.Position = UDim2.new(0.01, 0, 0.12, 0)
targetScroll.BackgroundColor3 = Color3.new(0, 0, 0)
targetScroll.BackgroundTransparency = 0.5
targetScroll.BorderSizePixel = 2
targetScroll.BorderColor3 = Color3.new(0, 1, 0)
targetScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
targetScroll.Parent = targetContent

local targetListLayout = Instance.new("UIListLayout")
targetListLayout.Padding = UDim.new(0, 2)
targetListLayout.SortOrder = Enum.SortOrder.LayoutOrder
targetListLayout.Parent = targetScroll

function updatePlayerList()
    for _, child in ipairs(targetScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= Player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.new(0, 0, 0)
            btn.BackgroundTransparency = 0.5
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.new(0, 1, 0)
            
            local role = getPlayerRole(player)
            local roleIcon = ""
            if role == "murderer" then 
                roleIcon = "🔴 " 
                btn.TextColor3 = Color3.new(1, 0, 0)
            elseif role == "sheriff" then 
                roleIcon = "🔵 " 
                btn.TextColor3 = Color3.new(0, 0, 1)
            else 
                roleIcon = "🟢 " 
                btn.TextColor3 = Color3.new(0, 1, 0)
            end
            
            btn.Text = roleIcon .. player.Name
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.Parent = targetScroll
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                local role = getPlayerRole(player)
                local roleText = role == "murderer" and "MURDERER" or (role == "sheriff" and "SHERIFF" or "INNOCENT")
                targetLabel.Text = "Selected: " .. player.Name .. " [" .. roleText .. "]"
            end)
        end
    end
end

updatePlayerList()

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.3, 0, 0.06, 0)
refreshBtn.Position = UDim2.new(0.7, 0, 0.04, 0)
refreshBtn.BackgroundColor3 = Color3.new(0, 0, 0)
refreshBtn.BorderSizePixel = 2
refreshBtn.BorderColor3 = Color3.new(0, 1, 0)
refreshBtn.Text = "Refresh"
refreshBtn.TextColor3 = Color3.new(0, 1, 0)
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
            wait(0.1)
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
                    wait(0.05)
                end
            end
        end
    end
end)

createToggle(targetContent, "Fling Murder", function(state)
    if state then
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= Player then
                local role = getPlayerRole(player)
                if role == "murderer" then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Velocity = Vector3.new(0, 5000, 0)
                    end
                end
            end
        end
    end
end)

createToggle(targetContent, "Fling Sheriff + Auto Gun", function(state)
    if state then
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= Player then
                local role = getPlayerRole(player)
                if role == "sheriff" then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Velocity = Vector3.new(0, 5000, 0)
                        -- Подбираем пистолет
                        if autoGunEnabled then
                            pickupGun()
                        end
                    end
                end
            end
        end
    end
end)

-- === ВКЛАДКА WEAPONS ===
local weaponContent = tabContents["Weapons"]

local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -10, 0, 35)
searchFrame.BackgroundColor3 = Color3.new(0, 0, 0)
searchFrame.BackgroundTransparency = 0.3
searchFrame.BorderSizePixel = 2
searchFrame.BorderColor3 = Color3.new(0, 1, 0)
searchFrame.Parent = weaponContent

local searchLabel = Instance.new("TextLabel")
searchLabel.Size = UDim2.new(0.2, 0, 1, 0)
searchLabel.BackgroundColor3 = Color3.new(0, 0, 0)
searchLabel.BackgroundTransparency = 1
searchLabel.Text = "Search:"
searchLabel.TextColor3 = Color3.new(0, 1, 0)
searchLabel.TextScaled = true
searchLabel.Font = Enum.Font.Gotham
searchLabel.Parent = searchFrame

local weaponSearch = Instance.new("TextBox")
weaponSearch.Size = UDim2.new(0.75, 0, 0.8, 0)
weaponSearch.Position = UDim2.new(0.22, 0, 0.1, 0)
weaponSearch.BackgroundColor3 = Color3.new(0, 0, 0)
weaponSearch.BorderSizePixel = 2
weaponSearch.BorderColor3 = Color3.new(0, 1, 0)
weaponSearch.Text = ""
weaponSearch.PlaceholderText = "Type weapon name..."
weaponSearch.TextColor3 = Color3.new(0, 1, 0)
weaponSearch.TextScaled = true
weaponSearch.Font = Enum.Font.Gotham
weaponSearch.Parent = searchFrame

local weaponScroll = Instance.new("ScrollingFrame")
weaponScroll.Size = UDim2.new(0.98, 0, 0.7, 0)
weaponScroll.Position = UDim2.new(0.01, 0, 0.12, 0)
weaponScroll.BackgroundColor3 = Color3.new(0, 0, 0)
weaponScroll.BackgroundTransparency = 0.5
weaponScroll.BorderSizePixel = 2
weaponScroll.BorderColor3 = Color3.new(0, 1, 0)
weaponScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
weaponScroll.Parent = weaponContent

local weaponListLayout = Instance.new("UIListLayout")
weaponListLayout.Padding = UDim.new(0, 2)
weaponListLayout.SortOrder = Enum.SortOrder.LayoutOrder
weaponListLayout.Parent = weaponScroll

local allWeapons = {}

function updateWeaponList(searchTerm)
    for _, child in ipairs(weaponScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    allWeapons = getAllWeapons()
    local filteredWeapons = {}
    
    if searchTerm and searchTerm ~= "" then
        for _, name in ipairs(allWeapons) do
            if string.lower(name):find(string.lower(searchTerm)) then
                table.insert(filteredWeapons, name)
            end
        end
    else
        filteredWeapons = allWeapons
    end
    
    if #filteredWeapons == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "No weapons found!"
        emptyLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        emptyLabel.TextScaled = true
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.Parent = weaponScroll
    end
    
    for _, name in ipairs(filteredWeapons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Color3.new(0, 0, 0)
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.new(0, 1, 0)
        btn.Text = name
        btn.TextColor3 = Color3.new(0, 1, 0)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = weaponScroll
        
        btn.MouseButton1Click:Connect(function()
            selectedWeapon = name
            -- Визуальное выделение
            for _, child in ipairs(weaponScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.new(0, 0, 0)
                end
            end
            btn.BackgroundColor3 = Color3.new(0, 0.5, 0)
        end)
    end
end

weaponSearch.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateWeaponList(weaponSearch.Text)
    end
end)

-- Кнопки выдачи/удаления оружия
local weaponBtnFrame = Instance.new("Frame")
weaponBtnFrame.Size = UDim2.new(1, -10, 0, 40)
weaponBtnFrame.Position = UDim2.new(0.01, 0, 0.85, 0)
weaponBtnFrame.BackgroundColor3 = Color3.new(0, 0, 0)
weaponBtnFrame.BackgroundTransparency = 0.3
weaponBtnFrame.BorderSizePixel = 0
weaponBtnFrame.Parent = weaponContent

local giveBtn = Instance.new("TextButton")
giveBtn.Size = UDim2.new(0.45, 0, 1, 0)
giveBtn.Position = UDim2.new(0, 0, 0, 0)
giveBtn.BackgroundColor3 = Color3.new(0, 0, 0)
giveBtn.BorderSizePixel = 2
giveBtn.BorderColor3 = Color3.new(0, 1, 0)
giveBtn.Text = "Give Weapon"
giveBtn.TextColor3 = Color3.new(0, 1, 0)
giveBtn.TextScaled = true
giveBtn.Font = Enum.Font.GothamBold
giveBtn.Parent = weaponBtnFrame

giveBtn.MouseButton1Click:Connect(function()
    if selectedWeapon then
        local found = false
        local searchLocations = {ReplicatedStorage, workspace, game:GetService("ServerStorage")}
        
        for _, location in ipairs(searchLocations) do
            if location then
                for _, item in ipairs(location:GetDescendants()) do
                    if item:IsA("Tool") and item.Name == selectedWeapon then
                        local newTool = item:Clone()
                        newTool.Parent = Player.Backpack
                        found = true
                        break
                    end
                end
            end
            if found then break end
        end
        
        if not found then
            print("Weapon not found: " .. selectedWeapon)
        end
    end
end)

local removeBtn = Instance.new("TextButton")
removeBtn.Size = UDim2.new(0.45, 0, 1, 0)
removeBtn.Position = UDim2.new(0.53, 0, 0, 0)
removeBtn.BackgroundColor3 = Color3.new(0, 0, 0)
removeBtn.BorderSizePixel = 2
removeBtn.BorderColor3 = Color3.new(0, 1, 0)
removeBtn.Text = "Remove Weapon"
removeBtn.TextColor3 = Color3.new(0, 1, 0)
removeBtn.TextScaled = true
removeBtn.Font = Enum.Font.GothamBold
removeBtn.Parent = weaponBtnFrame

removeBtn.MouseButton1Click:Connect(function()
    if selectedWeapon then
        for _, tool in ipairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == selectedWeapon then
                tool:Destroy()
            end
        end
        for _, tool in ipairs(Player.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == selectedWeapon then
                tool:Destroy()
            end
        end
    end
end)

updateWeaponList("")

-- === ВКЛАДКА ANTI-FLING ===
local antiContent = tabContents["Anti-Fling"]
createToggle(antiContent, "Anti-Fling", function(state) antiFlingEnabled = state end)

-- Защита от флинга
local lastPosition = Vector3.new(0, 0, 0)
local antiFlingActive = false

RunService.Heartbeat:Connect(function()
    if antiFlingEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = Player.Character.HumanoidRootPart
        local currentPos = rootPart.Position
        
        if not antiFlingActive then
            lastPosition = currentPos
            antiFlingActive = true
        end
        
        if (currentPos - lastPosition).Magnitude > 300 then
            rootPart.CFrame = CFrame.new(lastPosition)
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.RotVelocity = Vector3.new(0, 0, 0)
        end
        
        if currentPos.Y < -50 then
            rootPart.CFrame = CFrame.new(0, 50, 0)
            rootPart.Velocity = Vector3.new(0, 0, 0)
        end
        
        lastPosition = rootPart.Position
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
        if name == "Target" then
            updatePlayerList()
        elseif name == "Weapons" then
            updateWeaponList(weaponSearch.Text)
        end
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
    ToggleButton.Text = Frame.Visible and "Close Menu" or "Open Menu"
    if Frame.Visible then
        updatePlayerList()
        updateWeaponList(weaponSearch.Text)
    end
end)

-- === ОСНОВНАЯ ЛОГИКА ===

-- Aimbot + Auto Shoot
RunService.Heartbeat:Connect(function()
    if aimbotEnabled or autoShootEnabled then
        local target = nil
        
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            target = selectedPlayer.Character.HumanoidRootPart
        else
            local nearest = nil
            local nearestDist = math.huge
            
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    local dist = (root.Position - Camera.CFrame.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = root
                    end
                end
            end
            target = nearest
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
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local humanoid = Player.Character.Humanoid
        if speedValue > 0 then
            humanoid.WalkSpeed = speedValue
        end
        if spinValue > 0 and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, spinValue * 10, 0)
        end
    end
end)

-- ESP System
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
                        color = Color3.new(0, 0, 1)
                        roleText = " [SHERIFF]"
                    else
                        color = Color3.new(0, 1, 0)
                        roleText = " [INNOCENT]"
                    end
                elseif espSheriff and role == "sheriff" then
                    show = true
                    color = Color3.new(0, 0, 1)
                    roleText = " [SHERIFF]"
                elseif espMurder and role == "murderer" then
                    show = true
                    color = Color3.new(1, 0, 0)
                    roleText = " [MURDERER]"
                end
                
                if show then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = color
                    highlight.OutlineColor = color
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0.3
                    table.insert(espObjects, highlight)
                    
                    local billboard = Instance.new("BillboardGui")
                    billboard.Size = UDim2.new(0, 200, 0, 30)
                    billboard.Adornee = player.Character.HumanoidRootPart
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.Parent = player.Character.HumanoidRootPart
                    
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
                    textLabel.BackgroundTransparency = 0.5
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
                            highlight.FillColor = Color3.new(1, 1, 0)
                            highlight.OutlineColor = Color3.new(1, 1, 0)
                            highlight.FillTransparency = 0.3
                            table.insert(espObjects, highlight)
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 100, 0, 20)
                            billboard.Adornee = part.Handle
                            billboard.StudsOffset = Vector3.new(0, 1, 0)
                            billboard.Parent = part
                            
                            local textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
                            textLabel.BackgroundTransparency = 0.5
                            textLabel.Text = "🔫 " .. part.Name
                            textLabel.TextColor3 = Color3.new(1, 1, 0)
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

-- Auto Gun Pickup (УЛУЧШЕННЫЙ)
RunService.Heartbeat:Connect(function()
    if autoGunEnabled then
        pickupGun()
    end
end)

-- Knife Throw
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K and knifeThrowEnabled then
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local knife = nil
            for _, tool in ipairs(Player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    if name:find("knife") or name:find("dagger") or name:find("blade") then
                        knife = tool
                        break
                    end
                end
            end
            if not knife then
                for _, tool in ipairs(Player.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        local name = tool.Name:lower()
                        if name:find("knife") or name:find("dagger") or name:find("blade") then
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
        ToggleButton.Text = "Open Menu"
    end
end)

-- Перемещение окна
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
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

print("MM2 Script v3.0 Loaded Successfully!")
print("Все функции исправлены и улучшены!")
print("Press [K] to throw knife at target")
print("Press [Esc] to close menu")
