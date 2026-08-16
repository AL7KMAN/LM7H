local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

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

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FOVFrame

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
        if not getgenv().BaseY then
            getgenv().BaseY = hrp.Position.Y
        end
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
    local Camera = workspace.CurrentCamera
    if not Camera then return end
    FOVFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
    FOVFrame.Visible = FOVEnabled
    FOVStroke.Color = FOVColor
    if not FOVEnabled then return end
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
                    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                        isTeamValid = false
                    end
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
end)
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
        SnapVal = getgenv().SnapVal
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

