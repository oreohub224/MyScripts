local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ CONFIG & PERM KEYS ]]
local DISCORD_INVITE = "https://discord.gg/m2aB7MHzkF"
local ValidKeys = {
    ["OREO-OWNER-ADMIN"] = 2147483647, -- Your Perm Key
    ["OREO-FRIEND-ADMIN"] = 2147483647, -- Friend's Perm Key
    ["OREO-TEST-KEY"] = os.time() + 3600
}

local MAIN_COLOR = Color3.fromRGB(0, 170, 255)
local BG_COLOR = Color3.fromRGB(15, 15, 18)
local SEC_COLOR = Color3.fromRGB(25, 25, 30)

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "OreoHub_V35"
ScreenGui.ResetOnSpawn = false

-- [[ NOTIFY ]]
local function Notify(text)
    local Notif = Instance.new("Frame", ScreenGui); Notif.Size = UDim2.new(0, 320, 0, 75); Notif.Position = UDim2.new(1, 30, 1, -100); Notif.BackgroundColor3 = SEC_COLOR; Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 12)
    local Msg = Instance.new("TextLabel", Notif); Msg.Text = text; Msg.Size = UDim2.new(1, 0, 1, 0); Msg.TextColor3 = Color3.fromRGB(255, 255, 255); Msg.Font = Enum.Font.GothamBold; Msg.TextSize = 18; Msg.BackgroundTransparency = 1; Msg.Parent = Notif
    Notif:TweenPosition(UDim2.new(1, -340, 1, -100), "Out", "Quart", 0.5)
    task.delay(3, function() pcall(function() Notif:Destroy() end) end)
end

-- [[ MAIN HUB (HIDDEN) ]]
local Main = Instance.new("Frame", ScreenGui); Main.Visible = false; Main.Size = UDim2.new(0, 850, 0, 560); Main.Position = UDim2.new(0.5, -425, 0.5, -280); Main.BackgroundColor3 = BG_COLOR; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- [[ TOP BAR (LOGO, STATS, PROFILE) ]]
local TopBar = Instance.new("Frame", Main); TopBar.Size = UDim2.new(1, 0, 0, 110); TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 27); Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)

local Logo = Instance.new("TextLabel", TopBar); Logo.Text = "  OREO HUB"; Logo.Size = UDim2.new(0.3, 0, 1, 0); Logo.TextColor3 = Color3.new(1,1,1); Logo.Font = Enum.Font.LuckiestGuy; Logo.TextSize = 42; Logo.BackgroundTransparency = 1; Logo.TextXAlignment = 0

local StatsLabel = Instance.new("TextLabel", TopBar); StatsLabel.Size = UDim2.new(0, 250, 1, 0); StatsLabel.Position = UDim2.new(0.3, 0, 0, 0); StatsLabel.TextColor3 = Color3.fromRGB(180, 180, 180); StatsLabel.Font = Enum.Font.GothamMedium; StatsLabel.TextSize = 14; StatsLabel.BackgroundTransparency = 1; StatsLabel.TextXAlignment = 0
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            StatsLabel.Text = string.format("PING: %dms\nREGION: US-EAST\nVERSION: v.35 (STABLE)", ping)
        end)
    end
end)

local ProfileArea = Instance.new("Frame", TopBar); ProfileArea.Size = UDim2.new(0, 300, 1, 0); ProfileArea.Position = UDim2.new(1, -310, 0, 0); ProfileArea.BackgroundTransparency = 1
local UserLabel = Instance.new("TextLabel", ProfileArea); UserLabel.Text = Player.DisplayName .. "\n@" .. Player.Name; UserLabel.Size = UDim2.new(1, -90, 1, 0); UserLabel.TextColor3 = Color3.new(1,1,1); UserLabel.Font = Enum.Font.GothamBold; UserLabel.TextSize = 16; UserLabel.TextXAlignment = 2; UserLabel.BackgroundTransparency = 1
local PFP = Instance.new("ImageLabel", ProfileArea); PFP.Size = UDim2.new(0, 68, 0, 68); PFP.Position = UDim2.new(1, -75, 0.5, -34); PFP.BackgroundTransparency = 1; Instance.new("UICorner", PFP).CornerRadius = UDim.new(1, 0)
task.spawn(function() pcall(function() PFP.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end) end)

-- [[ KEY SYSTEM UI ]]
local KeyUI = Instance.new("Frame", ScreenGui); KeyUI.Size = UDim2.new(0, 400, 0, 350); KeyUI.Position = UDim2.new(0.5, -200, 0.5, -175); KeyUI.BackgroundColor3 = BG_COLOR; Instance.new("UICorner", KeyUI).CornerRadius = UDim.new(0, 12)
local KeyTitle = Instance.new("TextLabel", KeyUI); KeyTitle.Text = "OREO HUB ACTIVATION"; KeyTitle.Size = UDim2.new(1, 0, 0, 60); KeyTitle.TextColor3 = Color3.new(1,1,1); KeyTitle.Font = Enum.Font.GothamBold; KeyTitle.TextSize = 20; KeyTitle.BackgroundTransparency = 1
local KeyInput = Instance.new("TextBox", KeyUI); KeyInput.PlaceholderText = "Enter Key..."; KeyInput.Size = UDim2.new(0.85, 0, 0, 50); KeyInput.Position = UDim2.new(0.075, 0, 0.25, 0); KeyInput.BackgroundColor3 = SEC_COLOR; KeyInput.TextColor3 = Color3.new(1,1,1); KeyInput.Font = Enum.Font.Gotham; KeyInput.TextSize = 16; Instance.new("UICorner", KeyInput)
local VerifyBtn = Instance.new("TextButton", KeyUI); VerifyBtn.Text = "VERIFY LICENSE"; VerifyBtn.Size = UDim2.new(0.85, 0, 0, 50); VerifyBtn.Position = UDim2.new(0.075, 0, 0.45, 0); VerifyBtn.BackgroundColor3 = MAIN_COLOR; VerifyBtn.TextColor3 = Color3.new(1,1,1); VerifyBtn.Font = Enum.Font.GothamBold; VerifyBtn.TextSize = 18; Instance.new("UICorner", VerifyBtn)
local DiscordBtn = Instance.new("TextButton", KeyUI); DiscordBtn.Text = "GET KEY / JOIN DISCORD"; DiscordBtn.Size = UDim2.new(0.85, 0, 0, 50); DiscordBtn.Position = UDim2.new(0.075, 0, 0.75, 0); DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); DiscordBtn.TextColor3 = Color3.new(1,1,1); DiscordBtn.Font = Enum.Font.GothamBold; DiscordBtn.TextSize = 16; Instance.new("UICorner", DiscordBtn)

VerifyBtn.MouseButton1Click:Connect(function()
    local expiry = ValidKeys[KeyInput.Text]
    if expiry and os.time() < expiry then
        KeyUI:Destroy(); Main.Visible = true; Notify("Key Accepted!")
        if KeyInput.Text == "OREO-OWNER-ADMIN" then game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {Text = "[OREO HUB] Welcome, Master.", Color = MAIN_COLOR}) end
    else
        KeyInput.Text = ""; KeyInput.PlaceholderText = "INVALID KEY!"; KeyInput.PlaceholderColor3 = Color3.new(1,0,0)
    end
end)

DiscordBtn.MouseButton1Click:Connect(function() setclipboard(DISCORD_INVITE); DiscordBtn.Text = "COPIED TO CLIPBOARD!" end)

-- [[ SIDEBAR & PAGES ]]
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 200, 1, -110); Sidebar.Position = UDim2.new(0, 0, 0, 110); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Instance.new("UIListLayout", Sidebar)
local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -220, 1, -130); Content.Position = UDim2.new(0, 215, 0, 120); Content.BackgroundTransparency = 1
local Pages = {}

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Content); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0; p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", p); layout.Padding = UDim.new(0, 10); layout.HorizontalAlignment = 1
    Pages[name] = p; return p
end

local function CreateButton(parent, txt, color, func)
    local b = Instance.new("TextButton", parent); b.Text = txt; b.Size = UDim2.new(0.95, 0, 0, 60); b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 18; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

-- [[ PAGE: SERVERS ]]
local ServersPage = CreatePage("Servers")
CreateButton(ServersPage, "REJOIN SERVER", MAIN_COLOR, function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end)
CreateButton(ServersPage, "SERVER HOP", SEC_COLOR, function() Notify("Finding new server...") end)

-- [[ PAGE: 7 MINS GUY (WESKER) ]]
local WeskerPage = CreatePage("7 Mins Guy")
local GlobalDodgeDist = 12
local WeskerInjected = false
CreateButton(WeskerPage, "INJECT WESKER LOGIC", MAIN_COLOR, function()
    if WeskerInjected then return end; WeskerInjected = true; Notify("Wesker Ready! E = Lock | 5/6 = Dodge")
    local isSprinting, isLocked, target = false, false, nil
    RunService.RenderStepped:Connect(function()
        pcall(function()
            if isSprinting and Player.Character then Player.Character.Humanoid.WalkSpeed = 150 end
            if isLocked and target and target.Parent then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
        end)
    end)
    UserInputService.InputBegan:Connect(function(i, g)
        if g then return end
        local root = Player.Character:FindFirstChild("HumanoidRootPart")
        if i.KeyCode == Enum.KeyCode.Five then root.CFrame *= CFrame.new(-GlobalDodgeDist, 0, 0)
        elseif i.KeyCode == Enum.KeyCode.Six then root.CFrame *= CFrame.new(GlobalDodgeDist, 0, 0)
        elseif i.KeyCode == Enum.KeyCode.E then
            isLocked = not isLocked
            if isLocked then
                local short = math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                        if vis then
                            local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                            if d < short then short = d; target = p.Character.HumanoidRootPart end
                        end
                    end
                end
            else target = nil end
            Notify("Lock: " .. (isLocked and "ON" or "OFF"))
        elseif i.UserInputType == Enum.UserInputType.MouseButton3 then isSprinting = true end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton3 then isSprinting = false; Player.Character.Humanoid.WalkSpeed = 16 end end)
end)

-- [[ PAGE: VISUALS ]]
local VisualsPage = CreatePage("Visuals")
CreateButton(VisualsPage, "PLAYER HIGHLIGHT ESP", SEC_COLOR, function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            if not p.Character:FindFirstChild("OreoESP") then Instance.new("Highlight", p.Character).Name = "OreoESP"
            else p.Character.OreoESP:Destroy() end
        end
    end
end)

-- [[ TABS INITIALIZATION ]]
local function AddTab(name)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 50); b.Text = "  "..name; b.BackgroundColor3 = Color3.fromRGB(18, 18, 22); b.TextColor3 = Color3.new(0.7,0.7,0.7); b.Font = Enum.Font.GothamMedium; b.TextSize = 18; b.TextXAlignment = 0
    b.MouseButton1Click:Connect(function() for _, v in pairs(Pages) do v.Visible = false end Pages[name].Visible = true end)
end

for _, n in pairs({"Servers", "7 Mins Guy", "Visuals", "Self"}) do AddTab(n) end
Pages["Servers"].Visible = true
UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
