local Splash = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")

--====================================================
-- INTERNAL FUNCTION: Create Dust Particle
--====================================================
local function CreateDust(folder)
    local dot = Instance.new("Frame")
    local size = math.random(2, 6)

    dot.Size = UDim2.new(0, size, 0, size)
    dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BackgroundTransparency = math.random(70, 90) / 100
    dot.BorderSizePixel = 0
    dot.ZIndex = 1
    dot.Parent = folder

    local offsetX = math.random(-120, 120)
    local offsetY = math.random(-120, 120)

    TweenService:Create(dot, TweenInfo.new(math.random(2, 5)), {
        Position = UDim2.new(dot.Position.X.Scale, offsetX, dot.Position.Y.Scale, offsetY),
        BackgroundTransparency = 1
    }):Play()

    Debris:AddItem(dot, 5)
end

--====================================================
-- PUBLIC FUNCTION: Start Splash Screen
--====================================================
function Splash.Start()
    -- BLUR
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = Lighting
    TweenService:Create(Blur, TweenInfo.new(1), {Size = 24}):Play()

    -- UI ROOT
    local gui = Instance.new("ScreenGui")
    gui.Name = "AAA_Splash"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
    frame.Parent = gui

    -- Fog
    local FogOverlay = Instance.new("Frame")
    FogOverlay.Size = UDim2.new(1,0,1,0)
    FogOverlay.BackgroundColor3 = Color3.fromRGB(255,255,255)
    FogOverlay.BackgroundTransparency = 0.97
    FogOverlay.ZIndex = 0
    FogOverlay.Parent = frame

    -- Dust
    local DustFolder = Instance.new("Folder")
    DustFolder.Name = "Dust"
    DustFolder.Parent = frame

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,80)
    Title.Position = UDim2.new(0,0,0.35,0)
    Title.BackgroundTransparency = 1
    Title.Text = "World Zero 🚀 Hub"
    Title.TextSize = 42
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Parent = frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Transparency = 0.6
    Stroke.Color = Color3.fromRGB(255,255,255)
    Stroke.Parent = Title

    -- Loading Text
    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1,0,0,40)
    Sub.Position = UDim2.new(0,0,0.45,0)
    Sub.BackgroundTransparency = 1
    Sub.Text = "Initializing..."
    Sub.TextSize = 18
    Sub.Font = Enum.Font.Gotham
    Sub.TextColor3 = Color3.fromRGB(180,180,180)
    Sub.Parent = frame

    -- Progress Bar
    local BarBack = Instance.new("Frame")
    BarBack.Size = UDim2.new(0.3,0,0,8)
    BarBack.Position = UDim2.new(0.35,0,0.55,0)
    BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
    BarBack.BorderSizePixel = 0
    BarBack.Parent = frame

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0,0,1,0)
    BarFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBack

    -- Fade in
    frame.BackgroundTransparency = 1
    TweenService:Create(frame, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()

    -- Pulse Title
    task.spawn(function()
        while gui.Parent do
            TweenService:Create(Stroke, TweenInfo.new(1), {Transparency = 0.2}):Play()
            task.wait(1)
            TweenService:Create(Stroke, TweenInfo.new(1), {Transparency = 0.7}):Play()
            task.wait(1)
        end
    end)

    -- Dust Loop
    task.spawn(function()
        while gui.Parent do
            for i = 1, 3 do
                CreateDust(DustFolder)
            end
            task.wait(0.03)
        end
    end)

    -- Fog Pulse
    task.spawn(function()
        while gui.Parent do
            TweenService:Create(FogOverlay, TweenInfo.new(2), {BackgroundTransparency = 0.95}):Play()
            task.wait(2)
            TweenService:Create(FogOverlay, TweenInfo.new(2), {BackgroundTransparency = 0.98}):Play()
            task.wait(2)
        end
    end)

    -- Return functions to update loading text + bar
    return {
        SetText = function(text)
            Sub.Text = text
        end,
        SetProgress = function(value)
            TweenService:Create(BarFill, TweenInfo.new(0.4), {
                Size = UDim2.new(value, 0, 1, 0)
            }):Play()
        end,
        Destroy = function()
            gui:Destroy()
            Blur:Destroy()
        end
    }
end

return Splash
