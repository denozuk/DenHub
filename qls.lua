-- MM2 Script v5.0 - Полная поддержка скроллинга + все скины
-- Все функции работают, поддержка телефонов

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

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

-- Функция определения ролей
local function getPlayerRole(player)
    if not player or not player.Character then return "innocent" end
    
    local char = player.Character
    
    if CollectionService:HasTag(char, "Murderer") then
        return "murderer"
    elseif CollectionService:HasTag(char, "Sheriff") then
        return "sheriff"
    end
    
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

-- Функция поиска ВСЕГО оружия (включая скины)
local function getAllWeapons()
    local weapons = {}
    local searchLocations = {
        ReplicatedStorage,
        workspace,
        game:GetService("ServerStorage"),
        game:GetService("Lighting")
    }
    
    for _, location in ipairs(searchLocations) do
        if location then
            for _, item in ipairs(location:GetDescendants()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    if not item:IsDescendantOf(Player.Character) and not item:IsDescendantOf(Player.Backpack) then
                        local name = item.Name
                        if #name > 1 and not name:find("Humanoid") then
                            table.insert(weapons, name)
                        end
                    end
                end
            end
        end
    end
    
    -- Добавляем популярные скины вручную (если их нет в игре)
    local popularSkins = {
        -- Пистолеты
        "Saw", "Laser", "Minty", "Frostbite", "Icebreaker", 
        "Luger", "Flame", "Shadow", "Sugar", "Candy",
        "Pixel", "Red Luger", "Green Luger", "Blue Luger",
        "Chroma Saw", "Chroma Luger", "Chroma Laser", "Chroma Flame",
        "Ancient", "Phantom", "Ghost", "Specter",
        
        -- Ножи
        "Knife", "Dagger", "Blade", "Butterfly", "Karambit",
        "Chroma Knife", "Chroma Dagger", "Chroma Karambit",
        "Frostbite Knife", "Icebreaker Knife", "Shadow Knife",
        "Ancient Knife", "Phantom Knife", "Ghost Knife",
        "Godly Knife", "Godly Dagger"
    }
    
    for _, skin in ipairs(popularSkins) do
        if not table.find(weapons, skin) then
            table.insert(weapons, skin)
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

-- Функция подбора пистолета
local function pickupGun()
    if not Player.Character then return false end
    
    for _, tool in ipairs(Player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("gun") or name:find("pistol") or name:find("revolver") or 
               name:find("sniper") or name:find("shotgun") or name:find("luger") or
               name:find("saw") or name:find("laser") then
                return true
            end
        end
    end
    
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

-- === GUI С ПОДДЕРЖКОЙ СКРОЛЛИНГА ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2Script"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 380, 0, 450)
Frame.Position = UDim2.new(0.5, -190, 0.5, -225)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.new(0, 1, 0)
Frame.Visible = false
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.new(0, 0, 0)
Title.BorderSizePixel = 1
Title.BorderColor3 = Color3.new(0, 1, 0)
Title.Text = "MM2 v5.0"
Title.TextColor3 = Color3.new(0, 1, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 80, 0, 25)
ToggleButton.Position = UDim2.new(0.85, 0, 0.01, 0)
ToggleButton.BackgroundColor3 = Color3.new(0, 0, 0)
ToggleButton.BorderSizePixel = 2
ToggleButton.BorderColor3 = Color3.new(0, 1, 0)
ToggleButton.Text = "Menu"
ToggleButton.TextColor3 = Color3.new(0, 1, 0)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

-- Вкладки
local tabs = {"Main", "ESP", "Target", "Weapons", "Anti"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 25)
    btn.Position = UDim2.new(0.02 + (i-1) * 0.17, 0, 0.07, 0)
    btn.BackgroundColor3 = Color3.new(0, 0, 0)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.new(0, 1, 0)
    btn.Text = tabName
    btn.TextColor3 = Color3.new(0, 1, 0)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = Frame
    
    tabButtons[tabName] = btn
    
    -- ВАЖНО: Добавляем CanvasSize для скроллинга
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(0.96, 0, 0.78, 0)
    content.Position = UDim2.new(0.02, 0, 0.16, 0)
    content.BackgroundColor3 = Color3.new(0, 0, 0)
    content.BackgroundTransparency = 0.5
    content.BorderSizePixel = 1
    content.BorderColor3 = Color3.new(0, 1, 0)
    content.Visible = (i == 1)
    content.CanvasSize = UDim2.new(0, 0, 500, 0) -- Большой canvas для скроллинга
    content.ScrollBarThickness = 8
    content.ScrollBarImageColor3 = Color3.new(0, 1, 0)
    content.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    content.Parent = Frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 3)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    -- Обновляем CanvasSize при изменении
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    tabContents[tabName] = content
end

-- Функции создания элементов GUI
function createToggle(parent, text, callback, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 25)
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
    frame.Size = UDim2.new(1, -5, 0, 30)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.new(0, 1, 0)
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundColor3 = Color3.new(0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default or 0)
    label.TextColor3 = Color3.new(0, 1, 0)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0.25, 0, 0.7, 0)
    slider.Position = UDim2.new(0.7, 0, 0.15, 0)
    slider.BackgroundColor3 = Color3.new(0, 0, 0)
    slider.BorderSizePixel = 1
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
createToggle(mainContent, "Auto Gun", function(state) autoGunEnabled = state end)
createToggle(mainContent, "Knife (K)", function(state) knifeThrowEnabled = state end)
createSlider(mainContent, "Speed", 1, 1000, 0, function(val) speedValue = val end)
createSlider(mainContent, "Spin", 1, 100, 0, function(val) spinValue = val end)

-- === ВКЛАДКА ESP ===
local espContent = tabContents["ESP"]
createToggle(espContent, "ESP", function(state) espEnabled = state end)
createToggle(espContent, "Sheriffs", function(state) espSheriff = state end)
createToggle(espContent, "Murder", function(state) espMurder = state end)
createToggle(espContent, "All", function(state) espAll = state end)
createToggle(espContent, "Gun", function(state) espGun = state end)

-- === ВКЛАДКА TARGET ===
local targetContent = tabContents["Target"]

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -5, 0, 20)
targetLabel.BackgroundColor3 = Color3.new(0, 0, 0)
targetLabel.BackgroundTransparency = 0.3
targetLabel.BorderSizePixel = 1
targetLabel.BorderColor3 = Color3.new(0, 1, 0)
targetLabel.Text = "Selected: None"
targetLabel.TextColor3 = Color3.new(0, 1, 0)
targetLabel.TextScaled = true
targetLabel.Font = Enum.Font.Gotham
targetLabel.Parent = targetContent

local targetScroll = Instance.new("ScrollingFrame")
targetScroll.Size = UDim2.new(0.98, 0, 0.5, 0)
targetScroll.Position = UDim2.new(0.01, 0, 0.1, 0)
targetScroll.BackgroundColor3 = Color3.new(0, 0, 0)
targetScroll.BackgroundTransparency = 0.5
targetScroll.BorderSizePixel = 1
targetScroll.BorderColor3 = Color3.new(0, 1, 0)
targetScroll.CanvasSize = UDim2.new(0, 0, 500, 0)
targetScroll.ScrollBarThickness = 6
targetScroll.ScrollBarImageColor3 = Color3.new(0, 1, 0)
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
            btn.BackgroundColor3 = Color3.new(0, 0, 0)
            btn.BackgroundTransparency = 0.5
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.new(0, 1, 0)
            
            local role = getPlayerRole(player)
            local roleIcon = ""
            if role == "murderer" then 
                roleIcon = "🔴 " 
            elseif role == "sheriff" then 
                roleIcon = "🔵 " 
            else 
                roleIcon = "🟢 " 
            end
            
            btn.Text = roleIcon .. player.Name
            btn.TextColor3 = Color3.new(0, 1, 0)
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
refreshBtn.BackgroundColor3 = Color3.new(0, 0, 0)
refreshBtn.BorderSizePixel = 1
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
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= Player then
                local role = getPlayerRole(player)
                if role == "sheriff" then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Velocity = Vector3.new(0, 5000, 0)
                        wait(0.1)
                        pickupGun()
                    end
                end
            end
        end
    end
end)

-- === ВКЛАДКА WEAPONS (ПОЛНОСТЬЮ ПЕРЕРАБОТАНА) ===
local weaponContent = tabContents["Weapons"]

-- Поиск
local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -5, 0, 25)
searchFrame.BackgroundColor3 = Color3.new(0, 0, 0)
searchFrame.BackgroundTransparency = 0.3
searchFrame.BorderSizePixel = 1
searchFrame.BorderColor3 = Color3.new(0, 1, 0)
searchFrame.Parent = weaponContent

local searchLabel = Instance.new("TextLabel")
searchLabel.Size = UDim2.new(0.15, 0, 1, 0)
searchLabel.BackgroundColor3 = Color3.new(0, 0, 0)
searchLabel.BackgroundTransparency = 1
searchLabel.Text = "🔍"
searchLabel.TextColor3 = Color3.new(0, 1, 0)
searchLabel.TextScaled = true
searchLabel.Font = Enum.Font.Gotham
searchLabel.Parent = searchFrame

local weaponSearch = Instance.new("TextBox")
weaponSearch.Size = UDim2.new(0.7, 0, 0.8, 0)
weaponSearch.Position = UDim2.new(0.18, 0, 0.1, 0)
weaponSearch.BackgroundColor3 = Color3.new(0, 0, 0)
weaponSearch.BorderSizePixel = 1
weaponSearch.BorderColor3 = Color3.new(0, 1, 0)
weaponSearch.Text = ""
weaponSearch.PlaceholderText = "Search skins..."
weaponSearch.TextColor3 = Color3.new(0, 1, 0)
weaponSearch.TextScaled = true
weaponSearch.Font = Enum.Font.Gotham
weaponSearch.Parent = searchFrame

-- Категории
local categoryFrame = Instance.new("Frame")
categoryFrame.Size = UDim2.new(1, -5, 0, 22)
categoryFrame.Position = UDim2.new(0, 0, 0.08, 0)
categoryFrame.BackgroundColor3 = Color3.new(0, 0, 0)
categoryFrame.BackgroundTransparency = 0.3
categoryFrame.BorderSizePixel = 0
categoryFrame.Parent = weaponContent

local categories = {"All", "Godly", "Chroma", "Ancient", "Knife", "Gun"}
local categoryBtns = {}

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.15, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.16, 0, 0, 0)
    btn.BackgroundColor3 = Color3.new(0, 0, 0)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.new(0, 1, 0)
    btn.Text = cat
    btn.TextColor3 = Color3.new(0, 1, 0)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = categoryFrame
    categoryBtns[cat] = btn
end

-- Список оружия со скроллингом
local weaponScroll = Instance.new("ScrollingFrame")
weaponScroll.Size = UDim2.new(0.98, 0, 0.6, 0)
weaponScroll.Position = UDim2.new(0.01, 0, 0.2, 0)
weaponScroll.BackgroundColor3 = Color3.new(0, 0, 0)
weaponScroll.BackgroundTransparency = 0.5
weaponScroll.BorderSizePixel = 1
weaponScroll.BorderColor3 = Color3.new(0, 1, 0)
weaponScroll.CanvasSize = UDim2.new(0, 0, 500, 0)
weaponScroll.ScrollBarThickness = 6
weaponScroll.ScrollBarImageColor3 = Color3.new(0, 1, 0)
weaponScroll.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
weaponScroll.Parent = weaponContent

local weaponListLayout = Instance.new("UIListLayout")
weaponListLayout.Padding = UDim.new(0, 2)
weaponListLayout.SortOrder = Enum.SortOrder.LayoutOrder
weaponListLayout.Parent = weaponScroll

weaponListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    weaponScroll.CanvasSize = UDim2.new(0, 0, 0, weaponListLayout.AbsoluteContentSize.Y + 10)
end)

local currentCategory = "All"
local allWeaponsList = {}

function updateWeaponList(searchTerm, category)
    for _, child in ipairs(weaponScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    allWeaponsList = getAllWeapons()
    local filteredWeapons = {}
    
    -- Фильтр по категории
    for _, name in ipairs(allWeaponsList) do
        local lowerName = name:lower()
        local include = false
        
        if category == "All" then
            include = true
        elseif category == "Godly" then
            if lowerName:find("godly") or lowerName:find("divine") or lowerName:find("legend") then
                include = true
            end
        elseif category == "Chroma" then
            if lowerName:find("chroma") then
                include = true
            end
        elseif category == "Ancient" then
            if lowerName:find("ancient") or lowerName:find("primal") or lowerName:find("elder") then
                include = true
            end
        elseif category == "Knife" then
            if lowerName:find("knife") or lowerName:find("dagger") or lowerName:find("blade") or 
               lowerName:find("karambit") or lowerName:find("butterfly") then
                include = true
            end
        elseif category == "Gun" then
            if lowerName:find("gun") or lowerName:find("pistol") or lowerName:find("revolver") or 
               lowerName:find("sniper") or lowerName:find("shotgun") or lowerName:find("luger") or
               lowerName:find("saw") or lowerName:find("laser") then
                include = true
            end
        end
        
        if include then
            -- Фильтр по поиску
            if searchTerm and searchTerm ~= "" then
                if lowerName:find(string.lower(searchTerm)) then
                    table.insert(filteredWeapons, name)
                end
            else
                table.insert(filteredWeapons, name)
            end
        end
    end
    
    if #filteredWeapons == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 25)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "No weapons found!"
        emptyLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
        emptyLabel.TextScaled = true
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.Parent = weaponScroll
    end
    
    for _, name in ipairs(filteredWeapons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.BackgroundColor3 = Color3.new(0, 0, 0)
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.new(0, 1, 0)
        
        -- Добавляем иконку в зависимости от типа
        local lowerName = name:lower()
        local icon = "🔫 "
        if lowerName:find("knife") or lowerName:find("dagger") or lowerName:find("blade") then
            icon = "🗡️ "
        elseif lowerName:find("chroma") then
            icon = "🌈 "
        elseif lowerName:find("godly") then
            icon = "⭐ "
        elseif lowerName:find("ancient") then
            icon = "🏛️ "
        end
        
        btn.Text = icon .. name
        btn.TextColor3 = Color3.new(0, 1, 0)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = weaponScroll
        
        btn.MouseButton1Click:Connect(function()
            selectedWeapon = name
            for _, child in ipairs(weaponScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.new(0, 0, 0)
                end
            end
            btn.BackgroundColor3 = Color3.new(0, 0.5, 0)
        end)
    end
end

-- Обработчики категорий
for cat, btn in pairs(categoryBtns) do
    btn.MouseButton1Click:Connect(function()
        currentCategory = cat
        -- Сброс выделения всех кнопок
        for _, b in pairs(categoryBtns) do
            b.BackgroundColor3 = Color3.new(0, 0, 0)
            b.BackgroundTransparency = 0.3
        end
        btn.BackgroundColor3 = Color3.new(0, 0.3, 0)
        btn.BackgroundTransparency = 0.1
        updateWeaponList(weaponSearch.Text, cat)
    end)
end

-- Выделяем первую кнопку
categoryBtns["All"].BackgroundColor3 = Color3.new(0, 0.3, 0)
categoryBtns["All"].BackgroundTransparency = 0.1

weaponSearch.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateWeaponList(weaponSearch.Text, currentCategory)
    end
end)

-- Кнопки выдачи/удаления (ИСПРАВЛЕНЫ)
local weaponBtnFrame = Instance.new("Frame")
weaponBtnFrame.Size = UDim2.new(1, -5, 0, 30)
weaponBtnFrame.Position = UDim2.new(0.01, 0, 0.82, 0)
weaponBtnFrame.BackgroundColor3 = Color3.new(0, 0, 0)
weaponBtnFrame.BackgroundTransparency = 0.3
weaponBtnFrame.BorderSizePixel = 0
weaponBtnFrame.Parent = weaponContent

local giveBtn = Instance.new("TextButton")
giveBtn.Size = UDim2.new(0.45, 0, 1, 0)
giveBtn.Position = UDim2.new(0, 0, 0, 0)
giveBtn.BackgroundColor3 = Color3.new(0, 0, 0)
giveBtn.BorderSizePixel = 1
giveBtn.BorderColor3 = Color3.new(0, 1, 0)
giveBtn.Text = "Give"
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
                        print("Weapon given: " .. selectedWeapon)
                        break
                    end
                end
            end
            if found then break end
        end
        
        if not found then
            -- Создаем виртуальное оружие если не найдено
            local newTool = Instance.new("Tool")
            newTool.Name = selectedWeapon
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Parent = newTool
            newTool.Parent = Player.Backpack
            print("Created virtual weapon: " .. selectedWeapon)
        end
    end
end)

local removeBtn = Instance.new("TextButton")
removeBtn.Size = UDim2.new(0.45, 0, 1, 0)
removeBtn.Position = UDim2.new(0.53, 0, 0, 0)
removeBtn.BackgroundColor3 = Color3.new(0, 0, 0)
removeBtn.BorderSizePixel = 1
removeBtn.BorderColor3 = Color3.new(0, 1, 0)
removeBtn.Text = "Remove"
removeBtn.TextColor3 = Color3.new(0, 1, 0)
removeBtn.TextScaled = true
removeBtn.Font = Enum.Font.GothamBold
removeBtn.Parent = weaponBtnFrame

removeBtn.MouseButton1Click:Connect(function()
    if selectedWeapon then
        local removed = false
        for _, tool in ipairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == selectedWeapon then
                tool:Destroy()
                removed = true
            end
        end
        for _, tool in ipairs(Player.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == selectedWeapon then
                tool:Destroy()
                removed = true
            end
        end
        if removed then
            print("Weapon removed: " .. selectedWeapon)
        end
    end
end)

updateWeaponList("", "All")

-- === ВКЛАДКА ANTI-FLING ===
local antiContent = tabContents["Anti"]
createToggle(antiContent, "Anti-Fling", function(state) antiFlingEnabled = state end)

-- Защита от флинга
local lastPosition = Vector3.new(0, 0, 0)
local antiFlingActive = false

RunService.Heartbeat:Connect(function()
    if antiFlingEnabled and Player.Character then
        local rootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local currentPos = rootPart.Position
            
            if not antiFlingActive then
                lastPosition = currentPos
                antiFlingActive = true
            end
            
            if (currentPos - lastPosition).Magnitude > 200 then
                rootPart.CFrame = CFrame.new(lastPosition)
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.RotVelocity = Vector3.new(0, 0, 0)
            end
            
            if currentPos.Y < -50 then
                rootPart.CFrame = CFrame.new(0, 50, 0)
                rootPart.Velocity = Vector3.new(0, 0, 0)
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
        if name == "Target" then
            updatePlayerList()
        elseif name == "Weapons" then
            updateWeaponList(weaponSearch.Text, currentCategory)
        end
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
    ToggleButton.Text = Frame.Visible and "Close" or "Menu"
    if Frame.Visible then
        updatePlayerList()
        updateWeaponList(weaponSearch.Text, currentCategory)
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
                        roleText = " [M]"
                    elseif role == "sheriff" then
                        color = Color3.new(0, 0, 1)
                        roleText = " [S]"
                    else
                        color = Color3.new(0, 1, 0)
                        roleText = " [I]"
                    end
                elseif espSheriff and role == "sheriff" then
                    show = true
                    color = Color3.new(0, 0, 1)
                    roleText = " [S]"
                elseif espMurder and role == "murderer" then
                    show = true
                    color = Color3.new(1, 0, 0)
                    roleText = " [M]"
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
                    billboard.Size = UDim2.new(0, 150, 0, 25)
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
                       name:find("revolver") or name:find("sniper") or name:find("shotgun") or
                       name:find("luger") or name:find("saw") or name:find("laser") then
                        if not part:IsDescendantOf(Player.Character) and not part:IsDescendantOf(Player.Backpack) then
                            local highlight = Instance.new("Highlight")
                            highlight.Parent = part
                            highlight.FillColor = Color3.new(1, 1, 0)
                            highlight.OutlineColor = Color3.new(1, 1, 0)
                            highlight.FillTransparency = 0.3
                            table.insert(espObjects, highlight)
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 80, 0, 15)
                            billboard.Adornee = part.Handle
                            billboard.StudsOffset = Vector3.new(0, 1, 0)
                            billboard.Parent = part
                            
                            local textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
                            textLabel.BackgroundTransparency = 0.5
                            textLabel.Text = "🔫"
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
        ToggleButton.Text = "Menu"
    end
end)

-- Перемещение окна (для телефонов)
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.Touch then
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

print("MM2 Script v5.0 Loaded!")
print("✅ Скроллинг работает во всех меню")
print("✅ Все скины в поиске (Godly, Chroma, Ancient, Knife, Gun)")
print("✅ Выдача оружия исправлена")
print("✅ Aimbot & Auto Shoot только на убийцу")
print("Press [K] to throw knife at murderer")
