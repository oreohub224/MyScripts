local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ CORE SETTINGS ]]
local MAIN_COLOR = Color3.fromRGB(0, 170, 255)
local CLICK_COLOR = Color3.fromRGB(0, 110, 190)
local BG_COLOR = Color3.fromRGB(15, 15, 18)
local SEC_COLOR = Color3.fromRGB(25, 25, 30)
local GlobalDodgeDist = 12 
local WeskerInjected = false

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "OreoHub_V32"
ScreenGui.ResetOnSpawn = false

-- [[ DRAGGABLE SYSTEM ]]
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ NOTIFY ]]
local function Notify(text)
    local Notif = Instance.new("Frame", ScreenGui); Notif.Size = UDim2.new(0, 320, 0, 75); Notif.Position = UDim2.new(1, 30, 1, -100); Notif.BackgroundColor3 = SEC_COLOR; Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 12)
    local Msg = Instance.new("TextLabel", Notif); Msg.Text = text; Msg.Size = UDim2.new(1, 0, 1, 0); Msg.TextColor3 = Color3.fromRGB(255, 255, 255); Msg.Font = Enum.Font.GothamBold; Msg.TextSize = 18; Msg.BackgroundTransparency = 1; Msg.Parent = Notif
    Notif:TweenPosition(UDim2.new(1, -340, 1, -100), "Out", "Quart", 0.5)
    task.delay(3, function() pcall(function() Notif:Destroy() end) end)
end

-- [[ MAIN WINDOW ]]
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 850, 0, 560); Main.Position = UDim2.new(0.5, -425, 0.5, -280); Main.BackgroundColor3 = BG_COLOR; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local TopBar = Instance.new("Frame", Main); TopBar.Size = UDim2.new(1, 0, 0, 110); TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 27); Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)
MakeDraggable(Main, TopBar)

-- [[ LOGO & STATS ]]
local Logo = Instance.new("TextLabel", TopBar); Logo.Text = "  OREO HUB"; Logo.Size = UDim2.new(0.35, 0, 1, 0); Logo.TextColor3 = Color3.fromRGB(255, 255, 255); Logo.Font = Enum.Font.LuckiestGuy; Logo.TextSize = 42; Logo.BackgroundTransparency = 1; Logo.TextXAlignment = 0
local StatsLabel = Instance.new("TextLabel", TopBar); StatsLabel.Size = UDim2.new(0, 250, 1, 0); StatsLabel.Position = UDim2.new(0.35, 0, 0, 0); StatsLabel.TextColor3 = Color3.fromRGB(180, 180, 180); StatsLabel.Font = Enum.Font.GothamMedium; StatsLabel.TextSize = 14; StatsLabel.BackgroundTransparency = 1; StatsLabel.TextXAlignment = 0
task.spawn(function() while task.wait(1) do pcall(function() local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) StatsLabel.Text = string.format("PING: %dms\nREGION: US-EAST\nVERSION: v.%s", ping, tostring(game.PlaceVersion)) end) end end)

-- [[ PROFILE AREA FIX ]]
local ProfileArea = Instance.new("Frame", TopBar); ProfileArea.Size = UDim2.new(0, 300, 1, 0); ProfileArea.Position = UDim2.new(1, -310, 0, 0); ProfileArea.BackgroundTransparency = 1
local UserLabel = Instance.new("TextLabel", ProfileArea); UserLabel.Text = Player.DisplayName .. "\n@" .. Player.Name; UserLabel.Size = UDim2.new(1, -90, 1, 0); UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255); UserLabel.Font = Enum.Font.GothamBold; UserLabel.TextSize = 16; UserLabel.TextXAlignment = Enum.TextXAlignment.Right; UserLabel.BackgroundTransparency = 1
local PFP = Instance.new("ImageLabel", ProfileArea); PFP.Size = UDim2.new(0, 68, 0, 68); PFP.Position = UDim2.new(1, -75, 0.5, -34); PFP.BackgroundTransparency = 1; Instance.new("UICorner", PFP).CornerRadius = UDim.new(1, 0)

-- ASYNC LOAD PFP TO PREVENT FREEZING
task.spawn(function()
    pcall(function()
        local content, isReady = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        if isReady then PFP.Image = content else PFP.Image = "rbxassetid://15116556133" end
    end)
end)

-- [[ PAGES SYSTEM ]]
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 200, 1, -110); Sidebar.Position = UDim2.new(0, 0, 0, 110); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Instance.new("UIListLayout", Sidebar)
local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -220, 1, -130); Content.Position = UDim2.new(0, 215, 0, 120); Content.BackgroundTransparency = 1
local Pages = {}

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Content); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 2; p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", p); layout.Padding = UDim.new(0, 10); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Pages[name] = p; return p
end

-- [[ BUILDERS ]]
local function CreateButton(parent, txt, color, func)
    local b = Instance.new("TextButton", parent); b.Text = txt; b.Size = UDim2.new(0.95, 0, 0, 65); b.BackgroundColor3 = color; b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = Enum.Font.GothamBold; b.TextSize = 20; b.AutoButtonColor = false; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = CLICK_COLOR}):Play()
        task.wait(0.1); TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = color}):Play(); func() 
    end)
end

local function CreateSlider(parent, text, min, max, callback)
    local sFrame = Instance.new("Frame", parent); sFrame.Size = UDim2.new(0.95, 0, 0, 80); sFrame.BackgroundColor3 = SEC_COLOR; Instance.new("UICorner", sFrame)
    local sTitle = Instance.new("TextLabel", sFrame); sTitle.Text = text .. " : " .. min; sTitle.Size = UDim2.new(1, 0, 0, 30); sTitle.TextColor3 = Color3.new(1,1,1); sTitle.Font = Enum.Font.GothamBold; sTitle.TextSize = 16; sTitle.BackgroundTransparency = 1
    local sBar = Instance.new("Frame", sFrame); sBar.Size = UDim2.new(0.85, 0, 0, 10); sBar.Position = UDim2.new(0.075, 0, 0.65, 0); sBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45); Instance.new("UICorner", sBar)
    local sFill = Instance.new("Frame", sBar); sFill.Size = UDim2.new(0, 0, 1, 0); sFill.BackgroundColor3 = MAIN_COLOR; Instance.new("UICorner", sFill)
    local sBtn = Instance.new("TextButton", sBar); sBtn.Size = UDim2.new(0, 20, 0, 20); sBtn.Position = UDim2.new(0, -10, 0.5, -10); sBtn.BackgroundColor3 = Color3.new(1,1,1); sBtn.Text = ""; Instance.new("UICorner", sBtn)
    local dragging = false
    local function update()
        local percent = math.clamp((UserInputService:GetMouseLocation().X - sBar.AbsolutePosition.X) / sBar.AbsoluteSize.X, 0, 1)
        sFill.Size = UDim2.new(percent, 0, 1, 0); sBtn.Position = UDim2.new(percent, -10, 0.5, -10)
        local val = math.floor(min + (max - min) * percent); sTitle.Text = text .. " : " .. val; callback(val)
    end
    sBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
end

-- [[ WESKER SCRIPT PAGE ]]
local WeskerPage = CreatePage("7 Mins Guy")
CreateSlider(WeskerPage, "Dodge Distance", 5, 50, function(v) GlobalDodgeDist = v end)
CreateButton(WeskerPage, "RUN WESKER SCRIPT", MAIN_COLOR, function()
    if WeskerInjected then return end; WeskerInjected = true; Notify("Wesker Injected! Dodge: 5/6 | Lock: E")
    local isSprinting, isLocked, target = false, false, nil
    local function getClosestPlayerToMouse()
        local closest, shortest = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, visible = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < shortest then shortest = dist; closest = p.Character.HumanoidRootPart end
                end
            end
        end
        return closest
    end
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if isSprinting and Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = 150 end
            if isLocked and target and target.Parent then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
        end)
    end)
    UserInputService.InputBegan:Connect(function(i, g)
        if g or not WeskerInjected then return end
        local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if i.KeyCode == Enum.KeyCode.Five and root then root.CFrame = root.CFrame * CFrame.new(-GlobalDodgeDist, 0, 0)
        elseif i.KeyCode == Enum.KeyCode.Six and root then root.CFrame = root.CFrame * CFrame.new(GlobalDodgeDist, 0, 0)
        elseif i.KeyCode == Enum.KeyCode.E then isLocked = not isLocked; target = isLocked and getClosestPlayerToMouse() or nil; Notify("Lock: "..(isLocked and "ON" or "OFF"))
        elseif i.UserInputType == Enum.UserInputType.MouseButton3 then isSprinting = true end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton3 then isSprinting = false; pcall(function() Player.Character.Humanoid.WalkSpeed = 16 end) end end)
end)

-- [[ OTHER PAGES ]]
local VisualsPage = CreatePage("Visuals")
CreateButton(VisualsPage, "PLAYER HIGHLIGHT ESP", SEC_COLOR, function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            if not p.Character:FindFirstChild("OreoESP") then Instance.new("Highlight", p.Character).Name = "OreoESP"
            else p.Character.OreoESP:Destroy() end
        end
    end
    Notify("ESP Toggled")
end)

local ServersPage = CreatePage("Servers")
CreateButton(ServersPage, "REJOIN SERVER", MAIN_COLOR, function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end)

local SelfPage = CreatePage("Self")

-- [[ TABS ]]
local function AddTab(name)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 60); b.BackgroundColor3 = Color3.fromRGB(18, 18, 22); b.Text = "  "..name; b.TextColor3 = Color3.fromRGB(180, 180, 180); b.Font = Enum.Font.GothamMedium; b.TextSize = 18; b.TextXAlignment = 0
    b.MouseButton1Click:Connect(function() for _, p in pairs(Pages) do p.Visible = false end Pages[name].Visible = true end)
end
for _, n in pairs({"Servers", "7 Mins Guy", "Visuals", "Self"}) do AddTab(n) end

Pages["Servers"].Visible = true
UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
Notify("Oreo Hub V32 Loaded.")
