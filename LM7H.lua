-- BY LM7H
--[[
 _     __  __ _____ _   _ 
| |   |  \/  |___  | | | |
| |   | |\/| |  / /| |_| |
| |___| |  | | / / |  _  |
|_____|_|  |_|/_/  |_| |_|
--]]

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().SnapEnabled = false
getgenv().SnapVal = 0
getgenv().SnapMode = "Above"
getgenv().BaseY = nil

pcall(function()
    if CoreGui:FindFirstChild("LM7H") then CoreGui.LM7H:Destroy() end
    if CoreGui:FindFirstChild("LM7H_FOV") then CoreGui.LM7H_FOV:Destroy() end
end)

local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "LM7H"
IntroGui.IgnoreGuiInset = true
IntroGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
IntroGui.Parent = CoreGui

local DarkOverlay = Instance.new("Frame")
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
DarkOverlay.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
DarkOverlay.BorderSizePixel = 0
DarkOverlay.ZIndex = 99999
DarkOverlay.Parent = IntroGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 60)
TitleLabel.Position = UDim2.new(0, 0, 0.4, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "BY LM7H"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 42
TitleLabel.ZIndex = 100000
TitleLabel.Parent = DarkOverlay

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(216, 180, 254))
})
TitleGradient.Parent = TitleLabel

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Thickness = 2
TitleStroke.Color = Color3.fromRGB(147, 51, 234)
TitleStroke.Transparency = 0.2
TitleStroke.Parent = TitleLabel

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(1, 0, 0, 30)
LoadingLabel.Position = UDim2.new(0, 0, 0.55, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "Loaded 0%"
LoadingLabel.TextColor3 = Color3.fromRGB(216, 180, 254)
LoadingLabel.Font = Enum.Font.GothamMedium
LoadingLabel.TextSize = 18
LoadingLabel.ZIndex = 100000
LoadingLabel.Parent = DarkOverlay

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Thickness = 1.5
LoadStroke.Color = Color3.fromRGB(147, 51, 234)
LoadStroke.Transparency = 0.3
LoadStroke.Parent = LoadingLabel

task.spawn(function()
    task.wait(0.30)
    for i = 0, 100 do
        LoadingLabel.Text = "Loaded " .. i .. "%"
        task.wait(0.016)
    end
    task.wait(0.20)
    local fadeOut = TweenInfo.new(0.2)
    TweenService:Create(DarkOverlay, fadeOut, {BackgroundTransparency = 1}):Play()
    TweenService:Create(TitleLabel, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(TitleStroke, fadeOut, {Transparency = 1}):Play()
    TweenService:Create(LoadingLabel, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(LoadStroke, fadeOut, {Transparency = 1}):Play()
    task.wait(0.2)
    IntroGui:Destroy()
end)

FOVEnabled = false
FOVRadius = 150
FOVColor = Color3.fromRGB(168, 85, 247)
AimSpeedVal = 5
WhitelistedFriends = {}
SpeedEnabled = false
SpeedVal = 16
JumpEnabled = false
JumpVal = 50
InfJumpEnabled = false

ESP_Settings = {
    Loot = false,
    Health = false,
    Name = false,
    Neon = false
}

local ESP_Storage = {}

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "LM7H_FOV"
FOVGui.ResetOnSpawn = false
FOVGui.IgnoreGuiInset = true
FOVGui.Parent = CoreGui

local FOVFrame = Instance.new("Frame")
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = FOVGui

local UICornerFOV = Instance.new("UICorner")
UICornerFOV.CornerRadius = UDim.new(1, 0)
UICornerFOV.Parent = FOVFrame

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 2
FOVStroke.Color = FOVColor
FOVStroke.Transparency = 0
FOVStroke.Parent = FOVFrame

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local function GetGroupedTools(player)
    local grouped = {}
    local indexMap = {}

    local function addTool(tool)
        if not tool:IsA("Tool") then return end
        local nameKey = tool.Name
        if indexMap[nameKey] then
            indexMap[nameKey].count = indexMap[nameKey].count + 1
            if indexMap[nameKey].texture == "" and tool.TextureId ~= "" then
                indexMap[nameKey].texture = tool.TextureId
            end
        else
            local data = {
                name = tool.Name,
                texture = tool.TextureId,
                count = 1
            }
            table.insert(grouped, data)
            indexMap[nameKey] = data
        end
    end

    if player and player.Character then
        for _, item in ipairs(player.Character:GetChildren()) do addTool(item) end
    end
    if player and player:FindFirstChild("Backpack") then
        for _, item in ipairs(player.Backpack:GetChildren()) do addTool(item) end
    end

    return grouped
end

local function RemoveESP(player)
    if ESP_Storage[player] then
        if ESP_Storage[player].Highlight then ESP_Storage[player].Highlight:Destroy() end
        if ESP_Storage[player].MainBB then ESP_Storage[player].MainBB:Destroy() end
        ESP_Storage[player] = nil
    end
end

local function ApplyESP(player)
    if player == LocalPlayer or not player.Character then return end
    RemoveESP(player)

    local char = player.Character
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0.2
    hl.Adornee = char
    hl.Enabled = ESP_Settings.Neon
    hl.Parent = char

    local mainBB = Instance.new("BillboardGui")
    mainBB.Adornee = head
    mainBB.Size = UDim2.new(0, 200, 0, 60)
    mainBB.StudsOffset = Vector3.new(0, 2.5, 0)
    mainBB.AlwaysOnTop = true
    mainBB.Parent = head

    local mainLayout = Instance.new("UIListLayout")
    mainLayout.FillDirection = Enum.FillDirection.Vertical
    mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    mainLayout.Padding = UDim.new(0, 3)
    mainLayout.Parent = mainBB

    local nameTxt = Instance.new("TextLabel")
    nameTxt.Size = UDim2.new(1, 0, 0, 11)
    nameTxt.BackgroundTransparency = 1
    nameTxt.Text = player.Name
    nameTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameTxt.TextSize = 10
    nameTxt.Font = Enum.Font.GothamBold
    nameTxt.TextStrokeTransparency = 0
    nameTxt.Visible = ESP_Settings.Name
    nameTxt.LayoutOrder = 1
    nameTxt.Parent = mainBB

    local hpBg = Instance.new("Frame")
    hpBg.Size = UDim2.new(0, 60, 0, 3)
    hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    hpBg.BorderSizePixel = 0
    hpBg.Visible = ESP_Settings.Health
    hpBg.LayoutOrder = 2
    hpBg.Parent = mainBB

    local hpCorner = Instance.new("UICorner")
    hpCorner.CornerRadius = UDim.new(1, 0)
    hpCorner.Parent = hpBg

    local hpFill = Instance.new("Frame")
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBg

    local hpFillCorner = Instance.new("UICorner")
    hpFillCorner.CornerRadius = UDim.new(1, 0)
    hpFillCorner.Parent = hpFill

    local containerFrame = Instance.new("Frame")
    containerFrame.Size = UDim2.new(1, 0, 0, 30)
    containerFrame.BackgroundTransparency = 1
    containerFrame.Visible = ESP_Settings.Loot
    containerFrame.LayoutOrder = 3
    containerFrame.Parent = mainBB

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = containerFrame

    ESP_Storage[player] = {
        Highlight = hl,
        MainBB = mainBB,
        NameTxt = nameTxt,
        HpBg = hpBg,
        HpFill = hpFill,
        Container = containerFrame,
        Humanoid = hum,
        Head = head,
        Character = char,
        LastSignature = ""
    }
end

local function UpdatePlayerTools(player)
    local data = ESP_Storage[player]
    if not data or not ESP_Settings.Loot then return end

    local groupedTools = GetGroupedTools(player)
    
    local sigTable = {}
    for _, item in ipairs(groupedTools) do
        table.insert(sigTable, item.name .. ":" .. item.count)
    end
    local currentSig = table.concat(sigTable, "|")

    local dist = (Camera.CFrame.Position - data.Head.Position).Magnitude
    local iconSize = math.clamp(math.floor(300 / dist), 16, 26)

    if data.LastSignature ~= currentSig then
        data.LastSignature = currentSig
        
        for _, child in pairs(data.Container:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        if #groupedTools > 0 then
            data.Container.Size = UDim2.new(1, 0, 0, iconSize + 4)
            for _, item in ipairs(groupedTools) do
                local itemFrame = Instance.new("Frame")
                itemFrame.Size = UDim2.new(0, iconSize, 0, iconSize)
                itemFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                itemFrame.BackgroundTransparency = 0.2
                itemFrame.BorderSizePixel = 0
                itemFrame.Parent = data.Container

                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 4)
                frameCorner.Parent = itemFrame

                local frameStroke = Instance.new("UIStroke")
                frameStroke.Color = Color3.fromRGB(255, 255, 255)
                frameStroke.Thickness = 1
                frameStroke.Parent = itemFrame

                if item.texture ~= "" then
                    local imgLabel = Instance.new("ImageLabel")
                    imgLabel.Size = UDim2.new(1, -2, 1, -2)
                    imgLabel.Position = UDim2.new(0, 1, 0, 1)
                    imgLabel.BackgroundTransparency = 1
                    imgLabel.Image = item.texture
                    imgLabel.Parent = itemFrame
                else
                    local txtLabel = Instance.new("TextLabel")
                    txtLabel.Size = UDim2.new(1, 0, 1, 0)
                    txtLabel.BackgroundTransparency = 1
                    txtLabel.Text = item.name:sub(1, 4)
                    txtLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    txtLabel.TextSize = 8
                    txtLabel.Font = Enum.Font.GothamBold
                    txtLabel.Parent = itemFrame
                end

                if item.count > 1 then
                    local countTxt = Instance.new("TextLabel")
                    countTxt.Size = UDim2.new(1, 0, 0.4, 0)
                    countTxt.Position = UDim2.new(0, -1, 0.6, 0)
                    countTxt.BackgroundTransparency = 1
                    countTxt.Text = "x" .. tostring(item.count)
                    countTxt.TextColor3 = Color3.fromRGB(255, 220, 0)
                    countTxt.TextSize = 8
                    countTxt.Font = Enum.Font.GothamBold
                    countTxt.TextStrokeTransparency = 0
                    countTxt.TextXAlignment = Enum.TextXAlignment.Right
                    countTxt.Parent = itemFrame
                end
            end
        end
    else
        if #groupedTools > 0 then
            data.Container.Size = UDim2.new(1, 0, 0, iconSize + 4)
        end
    end
end

local function updateFriendHighlights()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local isFriend = WhitelistedFriends[player.Name] == true
            if isFriend and player.Character then
                local hl = player.Character:FindFirstChild("LM7H_FriendHL")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "LM7H_FriendHL"
                    hl.FillColor = Color3.fromRGB(0, 255, 122)
                    hl.FillTransparency = 0.6
                    hl.OutlineColor = Color3.fromRGB(0, 255, 122)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = player.Character
                end
            else
                if player.Character and player.Character:FindFirstChild("LM7H_FriendHL") then
                    player.Character.LM7H_FriendHL:Destroy()
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if getgenv().SnapEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if not getgenv().BaseY then getgenv().BaseY = hrp.Position.Y end
        local offset = (getgenv().SnapMode == "Above" and getgenv().SnapVal) or -getgenv().SnapVal
        local targetY = getgenv().BaseY + offset
        hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z) * (hrp.CFrame - hrp.CFrame.Position)
        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
    else
        getgenv().BaseY = nil
    end
end)

RunService.RenderStepped:Connect(function()
    updateFriendHighlights()
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if SpeedEnabled then LocalPlayer.Character.Humanoid.WalkSpeed = SpeedVal end
        if JumpEnabled then LocalPlayer.Character.Humanoid.JumpPower = JumpVal end
    end
    
    FOVFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
    FOVFrame.Visible = FOVEnabled
    FOVStroke.Color = FOVColor
    
    if FOVEnabled then
        local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local closestTarget = nil
        local shortestDistance = FOVRadius
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not WhitelistedFriends[player.Name] and player.Character then
                local character = player.Character
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local head = character:FindFirstChild("Head")
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if humanoid and head and hrp then
                    local isStateAlive = humanoid.Health > 1 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead and humanoid:GetState() ~= Enum.HumanoidStateType.Physics and humanoid:GetState() ~= Enum.HumanoidStateType.Ragdoll
                    local isDowned = character:FindFirstChild("KO") or character:FindFirstChild("Knocked") or character:FindFirstChild("Downed") or (character:FindFirstChild("BodyEffects") and character.BodyEffects:FindFirstChild("K.O") and character.BodyEffects["K.O"].Value == true)
                    if isStateAlive and not isDowned then
                        local isTeamValid = true
                        if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then isTeamValid = false end
                        if isTeamValid then
                            local screenPos, onScale = Camera:WorldToViewportPoint(head.Position)
                            if onScale and screenPos.Z > 0 then
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Center).Magnitude
                                if dist < shortestDistance then
                                    local origin = Camera.CFrame.Position
                                    local direction = (head.Position - origin)
                                    local ignoreList = {character}
                                    if LocalPlayer.Character then table.insert(ignoreList, LocalPlayer.Character) end
                                    local raycastParams = RaycastParams.new()
                                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                                    raycastParams.FilterDescendantsInstances = ignoreList
                                    raycastParams.IgnoreWater = true
                                    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
                                    local isValidTarget = false
                                    if not raycastResult then
                                        isValidTarget = true
                                    else
                                        local hitPart = raycastResult.Instance
                                        if hitPart and (not hitPart.CanCollide) and hitPart.Transparency >= 0.95 then isValidTarget = true end
                                    end
                                    if isValidTarget then
                                        shortestDistance = dist
                                        closestTarget = {Head = head, HRP = hrp}
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if closestTarget and closestTarget.Head then
            local targetPos = closestTarget.Head.Position
            if AimSpeedVal > 0 and closestTarget.HRP then
                local velocityPrediction = closestTarget.HRP.Velocity * (AimSpeedVal / 18) * 0.22
                targetPos = targetPos + velocityPrediction
            end
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            local smoothFactor = 0.12 + (AimSpeedVal * 0.005)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, math.clamp(smoothFactor, 0.1, 0.25))
        end
    end

    local anyEspActive = ESP_Settings.Loot or ESP_Settings.Health or ESP_Settings.Name or ESP_Settings.Neon
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if anyEspActive and char and char:FindFirstChild("Head") and char:FindFirstChildOfClass("Humanoid") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum.Health > 0 then
                    if not ESP_Storage[player] or ESP_Storage[player].Character ~= char or not ESP_Storage[player].MainBB.Parent then
                        ApplyESP(player)
                    else
                        local data = ESP_Storage[player]
                        data.NameTxt.Visible = ESP_Settings.Name
                        data.HpBg.Visible = ESP_Settings.Health
                        data.Container.Visible = ESP_Settings.Loot
                        data.Highlight.Enabled = ESP_Settings.Neon

                        if ESP_Settings.Health then
                            local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            data.HpFill.Size = UDim2.new(hpPct, 0, 1, 0)
                            data.HpFill.BackgroundColor3 = Color3.fromRGB(255 * (1 - hpPct), 255 * hpPct, 0)
                        end

                        if ESP_Settings.Loot then
                            UpdatePlayerTools(player)
                        end
                    end
                else
                    RemoveESP(player)
                end
            else
                RemoveESP(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(RemoveESP)
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "LM7H - Purple Edition", 
    Icon = "bird", 
    Author = "by LM7H", 
    OpenButton = {
        Title = "Open LM7H", 
        Icon = "monitor", 
        Enabled = true, 
        Draggable = true, 
        Color = ColorSequence.new(Color3.fromRGB(88, 28, 135), Color3.fromRGB(168, 85, 247))
    }
})

local function notifyWindUI(title, message)
    pcall(function()
        if WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = title or "LM7H",
                Content = message,
                Description = message,
                Duration = 3,
                Icon = "check"
            })
        elseif Window and Window.Notify then
            Window:Notify({
                Title = title or "LM7H",
                Content = message,
                Description = message,
                Duration = 3
            })
        end
    end)
end

local PvPTab = Window:Tab({Title = "PvP", Icon = "swords", Locked = false})
local FovToggle = PvPTab:Toggle({Title = "Fov", Value = false, Callback = function(Value) FOVEnabled = Value end})
local FovRadiusSlider = PvPTab:Slider({Title = "Fov Radius", Value = {Min = 50, Max = 500, Default = 150}, Callback = function(Value) FOVRadius = (type(Value) == "table" and Value.Value) or Value end})
local AimSpeedSlider = PvPTab:Slider({Title = "Aim Speed", Value = {Min = 1, Max = 20, Default = 5}, Callback = function(Value) AimSpeedVal = (type(Value) == "table" and Value.Value) or Value end})
local FovColorPicker = PvPTab:Colorpicker({Title = "Fov Color", Default = Color3.fromRGB(168, 85, 247), Callback = function(Value) FOVColor = Value end})

local function getPlayerNames()
    local list = {}
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= game:GetService("Players").LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

local FriendDropdown = PvPTab:Dropdown({
    Title = "Whitelisted Friends",
    Multi = true,
    Values = getPlayerNames(),
    Value = {},
    Callback = function(SelectedTable)
        WhitelistedFriends = {}
        if type(SelectedTable) == "table" then
            for k, v in pairs(SelectedTable) do
                if type(v) == "string" then
                    WhitelistedFriends[v] = true
                elseif type(k) == "string" and v == true then
                    WhitelistedFriends[k] = true
                end
            end
        elseif type(SelectedTable) == "string" and SelectedTable ~= "" then
            WhitelistedFriends[SelectedTable] = true
        end
    end
})

PvPTab:Button({Title = "Refresh Players List", Callback = function() if FriendDropdown and FriendDropdown.SetValues then FriendDropdown:SetValues(getPlayerNames()) end end})

PvPTab:Button({
    Title = "Reset Friends List", 
    Callback = function() 
        WhitelistedFriends = {}
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("LM7H_FriendHL") then
                p.Character.LM7H_FriendHL:Destroy()
            end
        end
        pcall(function()
            if FriendDropdown.Select then FriendDropdown:Select({}) end
            if FriendDropdown.Set then FriendDropdown:Set({}) end
            if FriendDropdown.SetValue then FriendDropdown:SetValue({}) end
            if FriendDropdown.Value then FriendDropdown.Value = {} end
            if FriendDropdown.SetValues then FriendDropdown:SetValues(getPlayerNames()) end
        end)
        notifyWindUI("LM7H", "تم تصفير القائمة وإلغاء التحديد بالكامل")
    end
})

local ESPTab = Window:Tab({Title = "ESP", Icon = "eye", Locked = false})
local LootToggle = ESPTab:Toggle({Title = "Loot", Value = false, Callback = function(Value) ESP_Settings.Loot = Value end})
local HealthToggle = ESPTab:Toggle({Title = "Health", Value = false, Callback = function(Value) ESP_Settings.Health = Value end})
local NameToggle = ESPTab:Toggle({Title = "Name", Value = false, Callback = function(Value) ESP_Settings.Name = Value end})
local NeonToggle = ESPTab:Toggle({Title = "Neon", Value = false, Callback = function(Value) ESP_Settings.Neon = Value end})

local CharTab = Window:Tab({Title = "Character", Icon = "user", Locked = false})
local SpeedToggle = CharTab:Toggle({Title = "Enable Speed", Value = false, Callback = function(Value) 
    SpeedEnabled = Value 
    local LocalPlayer = game:GetService("Players").LocalPlayer
    if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end})
local SpeedSlider = CharTab:Slider({Title = "Speed Player", Value = {Min = 16, Max = 400, Default = 16}, Callback = function(Value) SpeedVal = (type(Value) == "table" and Value.Value) or Value end})

local JumpToggle = CharTab:Toggle({Title = "Enable Jump Power", Value = false, Callback = function(Value) 
    JumpEnabled = Value 
    local LocalPlayer = game:GetService("Players").LocalPlayer
    if Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        h.UseJumpPower = true
        h.JumpPower = JumpVal
        h.JumpHeight = JumpVal / 3
    elseif not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        h.UseJumpPower = true
        h.JumpPower = 50
        h.JumpHeight = 50 / 3
    end
end})
local JumpSlider = CharTab:Slider({Title = "Jump Power", Value = {Min = 50, Max = 300, Default = 50}, Callback = function(Value) 
    JumpVal = (type(Value) == "table" and Value.Value) or Value 
    local LocalPlayer = game:GetService("Players").LocalPlayer
    if JumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        h.UseJumpPower = true
        h.JumpPower = JumpVal
        h.JumpHeight = JumpVal / 3
    end
end})
local InfJumpToggle = CharTab:Toggle({Title = "Inf Jump", Value = false, Callback = function(Value) InfJumpEnabled = Value end})

CharTab:Divider()

local SnapToggle = CharTab:Toggle({
    Title = "Enable Snap", 
    Value = false, 
    Callback = function(Value) 
        getgenv().SnapEnabled = Value 
        if not Value then getgenv().BaseY = nil end
    end
})

local SnapModeDropdown = CharTab:Dropdown({
    Title = "Snap Mode",
    Values = {"Above", "Under"},
    Value = "Above",
    Callback = function(Value) 
        getgenv().SnapMode = Value 
    end
})

local SnapHeightSlider = CharTab:Slider({
    Title = "Snap Height", 
    Value = {Min = 0, Max = 50, Default = 0}, 
    Callback = function(Value) 
        getgenv().SnapVal = (type(Value) == "table" and Value.Value) or Value
    end
})

CharTab:Divider()

local NoclipToggle = CharTab:Toggle({Title = "Noclip", Value = false, Callback = function(Value)
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    if not Value then
        if Nclipping then Nclipping:Disconnect() Nclipping = nil end
    else
        Nclipping = RunService.Stepped:Connect(function()
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end})

local SettingsTab = Window:Tab({Title = "Settings", Icon = "settings", Locked = false})
local HttpService = game:GetService("HttpService")

local function updateUIElem(elem, val)
    if not elem then return end
    pcall(function()
        if elem.Set then
            elem:Set(val)
        elseif elem.SetValue then
            elem:SetValue(val)
        end
    end)
end

SettingsTab:Button({Title = "Save Config", Callback = function()
    local Config = {
        FOV = FOVEnabled,
        FOVRadius = FOVRadius,
        AimSpeed = AimSpeedVal,
        Speed = SpeedEnabled,
        SpeedVal = SpeedVal,
        Jump = JumpEnabled,
        JumpVal = JumpVal,
        InfJump = InfJumpEnabled,
        SnapEnabled = getgenv().SnapEnabled,
        SnapMode = getgenv().SnapMode,
        SnapVal = getgenv().SnapVal,
        ESP_Loot = ESP_Settings.Loot,
        ESP_Health = ESP_Settings.Health,
        ESP_Name = ESP_Settings.Name,
        ESP_Neon = ESP_Settings.Neon
    }
    writefile("LM7H_Config.json", HttpService:JSONEncode(Config))
    notifyWindUI("LM7H", "تم حفظ الاعدادات")
end})

SettingsTab:Button({Title = "Load Config", Callback = function()
    if isfile and isfile("LM7H_Config.json") then
        local success, Data = pcall(function()
            return HttpService:JSONDecode(readfile("LM7H_Config.json"))
        end)
        if success and Data then
            FOVEnabled = Data.FOV or false
            FOVRadius = Data.FOVRadius or 150
            AimSpeedVal = Data.AimSpeed or 5
            SpeedEnabled = Data.Speed or false
            SpeedVal = Data.SpeedVal or 16
            JumpEnabled = Data.Jump or false
            JumpVal = Data.JumpVal or 50
            InfJumpEnabled = Data.InfJump or false
            getgenv().SnapEnabled = Data.SnapEnabled or false
            getgenv().SnapMode = Data.SnapMode or "Above"
            getgenv().SnapVal = Data.SnapVal or 0

            ESP_Settings.Loot = Data.ESP_Loot or false
            ESP_Settings.Health = Data.ESP_Health or false
            ESP_Settings.Name = Data.ESP_Name or false
            ESP_Settings.Neon = Data.ESP_Neon or false

            updateUIElem(FovToggle, FOVEnabled)
            updateUIElem(FovRadiusSlider, FOVRadius)
            updateUIElem(AimSpeedSlider, AimSpeedVal)
            updateUIElem(SpeedToggle, SpeedEnabled)
            updateUIElem(SpeedSlider, SpeedVal)
            updateUIElem(JumpToggle, JumpEnabled)
            updateUIElem(JumpSlider, JumpVal)
            updateUIElem(InfJumpToggle, InfJumpEnabled)
            updateUIElem(SnapToggle, getgenv().SnapEnabled)
            updateUIElem(SnapModeDropdown, getgenv().SnapMode)
            updateUIElem(SnapHeightSlider, getgenv().SnapVal)

            updateUIElem(LootToggle, ESP_Settings.Loot)
            updateUIElem(HealthToggle, ESP_Settings.Health)
            updateUIElem(NameToggle, ESP_Settings.Name)
            updateUIElem(NeonToggle, ESP_Settings.Neon)

            local LocalPlayer = game:GetService("Players").LocalPlayer
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                hum.WalkSpeed = SpeedEnabled and SpeedVal or 16
                hum.UseJumpPower = true
                hum.JumpPower = JumpEnabled and JumpVal or 50
                hum.JumpHeight = (JumpEnabled and JumpVal or 50) / 3
            end

            notifyWindUI("LM7H", "تم تحديث السكربت")
        else
            notifyWindUI("LM7H", "فشل في قراءة ملف الإعدادات")
        end
    else
        notifyWindUI("LM7H", "لا يوجد ملف إعدادات محفوظ")
    end
end})
