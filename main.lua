local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local remote = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"]
    .knit.Services.SettingsService.RE.UpdateSetting

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UtilityGui"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 150)
frame.Position = UDim2.new(0.5, -120, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- Top Bar
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1,0,0,30)
topbar.BackgroundColor3 = Color3.fromRGB(35,35,35)
topbar.BorderSizePixel = 0
topbar.Parent = frame

Instance.new("UICorner", topbar).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Utility Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

-- Minimize Button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,25,0,25)
minimize.Position = UDim2.new(1,-55,0,2)
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.Parent = topbar

Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,6)

-- Close Button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,25,0,25)
close.Position = UDim2.new(1,-28,0,2)
close.BackgroundColor3 = Color3.fromRGB(170,50,50)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = topbar

Instance.new("UICorner", close).CornerRadius = UDim.new(0,6)

-- Container
local container = Instance.new("Frame")
container.Size = UDim2.new(1,0,1,-35)
container.Position = UDim2.new(0,0,0,35)
container.BackgroundTransparency = 1
container.Parent = frame

-- Reroll Button
local reroll = Instance.new("TextButton")
reroll.Size = UDim2.new(0.85,0,0,40)
reroll.Position = UDim2.new(0.075,0,0.15,0)
reroll.BackgroundColor3 = Color3.fromRGB(45,45,45)
reroll.Text = "Reroll"
reroll.TextColor3 = Color3.new(1,1,1)
reroll.Font = Enum.Font.GothamSemibold
reroll.TextSize = 16
reroll.Parent = container

Instance.new("UICorner", reroll).CornerRadius = UDim.new(0,8)

-- Auto Rejoin Button
local rejoin = Instance.new("TextButton")
rejoin.Size = UDim2.new(0.85,0,0,40)
rejoin.Position = UDim2.new(0.075,0,0.55,0)
rejoin.BackgroundColor3 = Color3.fromRGB(45,45,45)
rejoin.Text = "Auto Rejoin"
rejoin.TextColor3 = Color3.new(1,1,1)
rejoin.Font = Enum.Font.GothamSemibold
rejoin.TextSize = 16
rejoin.Parent = container

Instance.new("UICorner", rejoin).CornerRadius = UDim.new(0,8)

-- Notification Function
local function notify(text)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 220, 0, 50)
    notif.Position = UDim2.new(1, 250, 1, -70)
    notif.BackgroundColor3 = Color3.fromRGB(30,30,30)
    notif.BorderSizePixel = 0
    notif.Parent = gui

    Instance.new("UICorner", notif).CornerRadius = UDim.new(0,8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 15
    label.Parent = notif

    TweenService:Create(
        notif,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -230, 1, -70)}
    ):Play()

    task.wait(2)

    local tween = TweenService:Create(
        notif,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(1, 250, 1, -70)}
    )

    tween:Play()

    tween.Completed:Connect(function()
        notif:Destroy()
    end)
end

-- Reroll Function
reroll.MouseButton1Click:Connect(function()
    local arguments = {
        [1] = "musicEnabled",
        [2] = "\255\127\u{d800}\0"
    }

    remote:FireServer(unpack(arguments))
    notify("Reroll Successful")
end)

-- Rejoin Function
rejoin.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- Minimize
local minimized = false

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    container.Visible = not minimized

    if minimized then
        frame.Size = UDim2.new(0,240,0,35)
        minimize.Text = "+"
    else
        frame.Size = UDim2.new(0,240,0,150)
        minimize.Text = "-"
    end
end)

-- Close
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Draggable
local dragging = false
local dragInput
local dragStart
local startPos

topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
