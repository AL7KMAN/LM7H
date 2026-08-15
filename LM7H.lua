local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

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
TracerColor = Color3.fromRGB(255, 30, 30)
SpeedEnabled = false
SpeedVal = 16
JumpEnabled = false
JumpVal = 50
InfJumpEnabled = false
ESPEnabled = false
SkeletonEnabled = false
BoxEnabled = false
NeonEnabled = false
TracerESPEnabled = false
NameEnabled = false

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

local RedLine = Instance.new("Frame")
RedLine.AnchorPoint = Vector2.new(0.5, 0.5)
RedLine.BackgroundColor3 = TracerColor
RedLine.BorderSizePixel = 0
RedLine.Visible = false
RedLine.Parent = FOVGui

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if SpeedEnabled then LocalPlayer.Character.Humanoid.WalkSpeed = SpeedVal end
        if JumpEnabled then LocalPlayer.Character.Humanoid.JumpPower = JumpVal end
    end
    local Camera = workspace.CurrentCamera
    if not Camera then return end
    FOVFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
    FOVFrame.Visible = FOVEnabled
    FOVStroke.Color = FOVColor
    if not FOVEnabled then RedLine.Visible = false return end
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestTarget = nil
    local shortestDistance = FOVRadius
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Center).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestTarget = Vector2.new(screenPos.X, screenPos.Y)
                end
            end
        end
    end
    if closestTarget then
        local length = (closestTarget - Center).Magnitude
        local angle = math.deg(math.atan2(closestTarget.Y - Center.Y, closestTarget.X - Center.X))
        local mid = (Center + closestTarget) / 2
        RedLine.Position = UDim2.new(0, mid.X, 0, mid.Y)
        RedLine.Size = UDim2.new(0, length, 0, 1.2)
        RedLine.Rotation = angle
        RedLine.BackgroundColor3 = TracerColor
        RedLine.Visible = true
    else
        RedLine.Visible = false
    end
end)
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({Title = "LM7H", Icon = "bird", Author = "by LM7H", OpenButton = {Title = "Open LM7H", Icon = "monitor", Enabled = true, Draggable = true, Color = ColorSequence.new(Color3.fromRGB(168, 85, 247), Color3.fromRGB(216, 180, 254))}})

local PvPTab = Window:Tab({Title = "PvP", Icon = "swords", Locked = false})
PvPTab:Toggle({Title = "Fov", Value = false, Callback = function(Value) FOVEnabled = Value end})
PvPTab:Slider({Title = "Fov Radius", Value = {Min = 50, Max = 500, Default = 150}, Callback = function(Value) FOVRadius = (type(Value) == "table" and Value.Value) or Value end})
PvPTab:Colorpicker({Title = "Fov Color", Default = Color3.fromRGB(168, 85, 247), Callback = function(Value) FOVColor = Value end})
PvPTab:Colorpicker({Title = "Tracer Color", Default = Color3.fromRGB(255, 30, 30), Callback = function(Value) TracerColor = Value end})

local CharTab = Window:Tab({Title = "Character", Icon = "user", Locked = false})
CharTab:Toggle({Title = "Enable Speed", Value = false, Callback = function(Value) SpeedEnabled = Value end})
CharTab:Slider({Title = "Speed Player", Value = {Min = 16, Max = 400, Default = 16}, Callback = function(Value) SpeedVal = (type(Value) == "table" and Value.Value) or Value end})
CharTab:Toggle({Title = "Enable Jump Power", Value = false, Callback = function(Value) 
    JumpEnabled = Value 
    if Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        h.UseJumpPower = true
        h.JumpPower = JumpVal
        h.JumpHeight = JumpVal / 3
    end
end})
CharTab:Slider({Title = "Jump Power", Value = {Min = 50, Max = 300, Default = 50}, Callback = function(Value) 
    JumpVal = (type(Value) == "table" and Value.Value) or Value 
    if JumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        h.UseJumpPower = true
        h.JumpPower = JumpVal
        h.JumpHeight = JumpVal / 3
    end
end})
CharTab:Toggle({Title = "Inf Jump", Value = false, Callback = function(Value) InfJumpEnabled = Value end})

CharTab:Divider()

CharTab:Toggle({Title = "Noclip", Value = false, Callback = function(Value)
    if not Value then
        if Nclipping then
            Nclipping:Disconnect()
            Nclipping = nil
        end
    else
        Nclipping = RunService.Stepped:Connect(function()
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end})
