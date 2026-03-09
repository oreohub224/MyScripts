local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ SETTINGS & ADMIN KEYS ]]
local DISCORD_INVITE = "https://discord.gg/m2aB7MHzkF" -- CHANGE THIS TO YOUR LINK
local ValidKeys = {
    ["OREO-OWNER-ADMIN"] = 2147483647, 
    ["OREO-FRIEND-ADMIN"] = 2147483647,
    ["OREO-TEST-KEY"] = os.time() + 3600
}

local MAIN_COLOR = Color3.fromRGB(0, 170, 255)
local BG_COLOR = Color3.fromRGB(15, 15, 18)
local SEC_COLOR = Color3.fromRGB(25, 25, 30)

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "OreoHub_Final"
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

-- [[ KEY SYSTEM UI ]]
local KeyUI = Instance.new("Frame", ScreenGui); KeyUI.Size = UDim2.new(0, 400, 0, 350); KeyUI.Position = UDim2.new(0.5, -200, 0.5, -175); KeyUI.BackgroundColor3 = BG_COLOR; Instance.new("UICorner", KeyUI).CornerRadius = UDim.new(0, 12)
local KeyTitle = Instance.new("TextLabel", KeyUI); KeyTitle.Text = "OREO HUB ACTIVATION"; KeyTitle.Size = UDim2.new(1, 0, 0, 60); KeyTitle.TextColor3 = Color3.new(1,1,1); KeyTitle.Font = Enum.Font.GothamBold; KeyTitle.TextSize = 20; KeyTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyUI); KeyInput.PlaceholderText = "Enter Key..."; KeyInput.Size = UDim2.new(0.85, 0, 0, 50); KeyInput.Position = UDim2.new(0.075, 0, 0.25, 0); KeyInput.BackgroundColor3 = SEC_COLOR; KeyInput.TextColor3 = Color3.new(1,1,1); KeyInput.Font = Enum.Font.Gotham; KeyInput.TextSize = 16; Instance.new("UICorner", KeyInput)

local VerifyBtn = Instance.new("TextButton", KeyUI); VerifyBtn.Text = "VERIFY LICENSE"; VerifyBtn.Size = UDim2.new(0.85, 0, 0, 50); VerifyBtn.Position = UDim2.new(0.075, 0, 0.45, 0); VerifyBtn.BackgroundColor3 = MAIN_COLOR; VerifyBtn.TextColor3 = Color3.new(1,1,1); VerifyBtn.Font = Enum.Font.GothamBold; VerifyBtn.TextSize = 18; Instance.new("UICorner", VerifyBtn)

local DiscordBtn = Instance.new("TextButton", KeyUI); DiscordBtn.Text = "GET KEY / JOIN DISCORD"; DiscordBtn.Size = UDim2.new(0.85, 0, 0, 50); DiscordBtn.Position = UDim2.new(0.075, 0, 0.75, 0); DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); DiscordBtn.TextColor3 = Color3.new(1,1,1); DiscordBtn.Font = Enum.Font.GothamBold; DiscordBtn.TextSize = 16; Instance.new("UICorner", DiscordBtn)

-- [[ KEY SYSTEM LOGIC ]]
VerifyBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    local expiry = ValidKeys[input]
    if expiry and os.time() < expiry then
        KeyUI:Destroy()
        Main.Visible = true
        Notify("Key Accepted. Welcome!")
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "INVALID OR EXPIRED!"
        KeyInput.PlaceholderColor3 = Color3.new(1,0,0)
        TweenService:Create(KeyUI, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 3, true), {Position = UDim2.new(0.5, -195, 0.5, -175)}):Play()
    end
end)

DiscordBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_INVITE)
    DiscordBtn.Text = "COPIED TO CLIPBOARD!"
    task.wait(2)
    DiscordBtn.Text = "GET KEY / JOIN DISCORD"
end)

-- [[ HUB LOGIC - TOP BAR ]]
local TopBar = Instance.new("Frame", Main); TopBar.Size = UDim2.new(1, 0, 0, 110); TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 27); Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)
local Logo = Instance.new("TextLabel", TopBar); Logo.Text = "  OREO HUB"; Logo.Size = UDim2.new(0.35, 0, 1, 0); Logo.TextColor3 = Color3.fromRGB(255, 255, 255); Logo.Font = Enum.Font.LuckiestGuy; Logo.TextSize = 42; Logo.BackgroundTransparency = 1; Logo.TextXAlignment = 0

-- [[ WESKER / LOCK-ON SCRIPT ]]
local WeskerInjected = false
local GlobalDodgeDist = 12

-- Logic simplified for GitHub stability
local function RunWesker()
    if WeskerInjected then return end; WeskerInjected = true
    Notify("Wesker Injected! Key: E to Lock")
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
        if i.KeyCode == Enum.KeyCode.Five then root.CFrame = root.CFrame * CFrame.new(-GlobalDodgeDist, 0, 0)
        elseif i.KeyCode == Enum.KeyCode.Six then root.CFrame = root.CFrame * CFrame.new(GlobalDodgeDist, 0, 0)
        elseif i.KeyCode == Enum.KeyCode.E then 
            isLocked = not isLocked
            if isLocked then
                local closest, shortest = nil, math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                        if vis then
                            local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                            if d < shortest then shortest = d; closest = p.Character.HumanoidRootPart end
                        end
                    end
                end
                target = closest
            else target = nil end
            Notify("Lock: "..(isLocked and "ON" or "OFF"))
        elseif i.UserInputType == Enum.UserInputType.MouseButton3 then isSprinting = true end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton3 then isSprinting = false; Player.Character.Humanoid.WalkSpeed = 16 end end)
end

-- [[ TABS & PAGES ]]
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 200, 1, -110); Sidebar.Position = UDim2.new(0, 0, 0, 110); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Instance.new("UIListLayout", Sidebar)
local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -220, 1, -130); Content.Position = UDim2.new(0, 215, 0, 120); Content.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Content); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0; p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local l = Instance.new("UIListLayout", p); l.Padding = UDim.new(0, 10); l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Pages[name] = p; return p
end

local WeskerPage = CreatePage("7 Mins Guy")
local b = Instance.new("TextButton", WeskerPage); b.Text = "RUN WESKER SCRIPT"; b.Size = UDim2.new(0.9, 0, 0, 60); b.BackgroundColor3 = MAIN_COLOR; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
b.MouseButton1Click:Connect(RunWesker)

local function AddTab(name)
    local tb = Instance.new("TextButton", Sidebar); tb.Size = UDim2.new(1, 0, 0, 50); tb.Text = name; tb.BackgroundColor3 = SEC_COLOR; tb.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tb)
    tb.MouseButton1Click:Connect(function() for _, v in pairs(Pages) do v.Visible = false end Pages[name].Visible = true end)
end

AddTab("7 Mins Guy")
Pages["7 Mins Guy"].Visible = true
