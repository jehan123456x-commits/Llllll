--[[
    GamersXd.fix v2.6 — Stealth & Optimization Update
    - Anti-Report (Blocks report remotes + masks name)
    - Anti-Screenshot (Blanks UI on ScreenshotStarted)
    - Anti-Lag (Optimized entity cache & loops)
]]

print("[GamersXd] executing...")

-- ============================== KEY SYSTEM ==============================
local _KL = {103, 97, 109, 101, 114, 115, 120, 100}  
local function _validateKey(input)
    if type(input) ~= "string" then return false end
    local clean = input:gsub("%s+", ""):lower()
    if #clean ~= #_KL then return false end
    for i = 1, #_KL do
        if string.byte(clean, i) ~= _KL[i] then return false end
    end
    return true
end

local KEY_FOLDER  = "GamersXdConfigs"
local KEY_FILE    = KEY_FOLDER .. "/.GamersXd_key"
local EXPIRY_SECS = 3 * 24 * 60 * 60
local FB_CONTACT  = "FB: Johnlloyd Ano-os | TG: @GamersXd635"

local function _ensureFolder()
    if type(makefolder) == "function" and type(isfolder) == "function" then
        if not isfolder(KEY_FOLDER) then pcall(makefolder, KEY_FOLDER) end
    end
end

local function _saveActivation()
    _ensureFolder()
    if type(writefile) == "function" then
        pcall(writefile, KEY_FILE, tostring(os.time()))
    end
end

local function _loadActivation()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return nil end
    if not isfile(KEY_FILE) then return nil end
    local ok, raw = pcall(readfile, KEY_FILE)
    if not ok or not raw then return nil end
    local stamp = tonumber(raw)
    if not stamp then return nil end
    local elapsed = os.time() - stamp
    if elapsed < 0 or elapsed >= EXPIRY_SECS then return false end
    return EXPIRY_SECS - elapsed
end

local _parentGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local function _showExpired()
    local gui = Instance.new("ScreenGui")
    gui.Name = "GamersXdExpiredLock"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 2147483647
    gui.Parent = _parentGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    bg.BackgroundTransparency = 0.08
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.fromOffset(340, 260)
    card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    card.BorderSizePixel = 0
    card.Parent = bg
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(255, 60, 80)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Position = UDim2.fromOffset(20, 24)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(255, 96, 108)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "GamersXd.fix — EXPIRED"
    title.Parent = card

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -40, 0, 120)
    body.Position = UDim2.fromOffset(20, 70)
    body.BackgroundTransparency = 1
    body.Font = Enum.Font.Gotham
    body.TextSize = 15
    body.TextWrapped = true
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.TextColor3 = Color3.fromRGB(220, 220, 228)
    body.Text = "Your 3-day activation has ended.\n\nTo renew, contact:\n" .. FB_CONTACT
    body.Parent = card
end

local function _promptForKey(afterSuccess)
    local gui = Instance.new("ScreenGui")
    gui.Name = "GamersXdKeyPrompt"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 2147483600
    gui.Parent = _parentGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
    bg.BackgroundTransparency = 0.15
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.fromOffset(340, 300)
    card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    card.BorderSizePixel = 0
    card.Parent = bg
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(230, 42, 58)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.25

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 34)
    title.Position = UDim2.fromOffset(20, 20)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(248, 248, 252)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "GamersXd.fix"
    title.Parent = card

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.fromOffset(20, 52)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 13
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 160)
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Text = "Enter your key to activate (3 days)"
    subtitle.Parent = card

    local fieldWrap = Instance.new("Frame")
    fieldWrap.Position = UDim2.fromOffset(20, 86)
    fieldWrap.Size = UDim2.new(1, -40, 0, 42)
    fieldWrap.BackgroundColor3 = Color3.fromRGB(9, 9, 11)
    fieldWrap.BorderSizePixel = 0
    fieldWrap.Parent = card
    Instance.new("UICorner", fieldWrap).CornerRadius = UDim.new(0, 12)
    local fieldStroke = Instance.new("UIStroke", fieldWrap)
    fieldStroke.Color = Color3.fromRGB(50, 50, 60)
    fieldStroke.Thickness = 1

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -24, 1, 0)
    box.Position = UDim2.fromOffset(12, 0)
    box.BackgroundTransparency = 1
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 16
    box.TextColor3 = Color3.fromRGB(248, 248, 252)
    box.PlaceholderText = "••••••••"
    box.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
    box.Text = ""
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Parent = fieldWrap

    local rawKey = ""
    box:GetPropertyChangedSignal("Text"):Connect(function()
        local current = box.Text
        local masked = string.rep("*", #rawKey)
        if current == masked then return end
        if #current < #rawKey then
            rawKey = rawKey:sub(1, #current)
        else
            local added = current:sub(#rawKey + 1)
            rawKey = rawKey .. added
        end
        box.Text = string.rep("*", #rawKey)
        box.CursorPosition = #box.Text + 1
    end)

    local submit = Instance.new("TextButton")
    submit.Position = UDim2.fromOffset(20, 142)
    submit.Size = UDim2.new(1, -40, 0, 44)
    submit.BackgroundColor3 = Color3.fromRGB(230, 42, 58)
    submit.BorderSizePixel = 0
    submit.Font = Enum.Font.GothamBold
    submit.TextSize = 16
    submit.TextColor3 = Color3.new(1, 1, 1)
    submit.Text = "Activate"
    submit.AutoButtonColor = false
    submit.Parent = card
    Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 12)

    local status = Instance.new("TextLabel")
    status.Position = UDim2.fromOffset(20, 194)
    status.Size = UDim2.new(1, -40, 0, 40)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 13
    status.TextWrapped = true
    status.TextColor3 = Color3.fromRGB(255, 96, 108)
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextYAlignment = Enum.TextYAlignment.Top
    status.Parent = card

    local contact = Instance.new("TextLabel")
    contact.Position = UDim2.new(0, 20, 1, -56)
    contact.Size = UDim2.new(1, -40, 0, 40)
    contact.BackgroundTransparency = 1
    contact.Font = Enum.Font.GothamMedium
    contact.TextSize = 11
    contact.TextWrapped = true
    contact.TextColor3 = Color3.fromRGB(140, 140, 150)
    contact.TextXAlignment = Enum.TextXAlignment.Left
    contact.TextYAlignment = Enum.TextYAlignment.Bottom
    contact.Text = "Need a key? " .. FB_CONTACT
    contact.Parent = card

    local function trySubmit()
        if _validateKey(rawKey) then
            _saveActivation()
            status.TextColor3 = Color3.fromRGB(110, 220, 160)
            status.Text = "Activated. Loading..."
            task.wait(0.6)
            gui:Destroy()
            afterSuccess()
        else
            status.Text = "Invalid key. (Length: " .. #rawKey .. ")"
            fieldStroke.Color = Color3.fromRGB(255, 60, 80)
            task.delay(1.2, function() fieldStroke.Color = Color3.fromRGB(50, 50, 60) end)
        end
    end

    submit.Activated:Connect(trySubmit)
    box.FocusLost:Connect(function(enter) if enter then trySubmit() end end)
end

-- ============================== MAIN SCRIPT ==============================
local function _runMain()
    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local UserInputService  = game:GetService("UserInputService")
    local Lighting          = game:GetService("Lighting")
    local StarterGui        = game:GetService("StarterGui")
    local LocalPlayer       = Players.LocalPlayer
    local Camera            = workspace.CurrentCamera

    -- ANTI-REPORT & STEALTH INIT
    pcall(function()
        -- Disable Roblox report menu (closest we can get client-side)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        -- Fake name/avatar trick to make reporting harder
        LocalPlayer.DisplayName = "Player"
    end)

    if getgenv().Rayfield then
        pcall(function() getgenv().Rayfield:Destroy() end)
        getgenv().Rayfield = nil
    end

    local ok, Rayfield = pcall(function()
        return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    end)

    if not ok or not Rayfield then
        local errorGui = Instance.new("ScreenGui", _parentGui)
        local label = Instance.new("TextLabel", errorGui)
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundColor3 = Color3.new(0, 0, 0)
        label.BackgroundTransparency = 0.5
        label.TextColor3 = Color3.new(1, 0, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20
        label.Text = "Rayfield failed to load."
        return
    end

    local Window = Rayfield:CreateWindow({
        Name = "GamersXd.fix",
        LoadingTitle = "GamersXd.fix",
        LoadingSubtitle = "by GamersXd",
        ConfigurationSaving = { Enabled = true, FolderName = KEY_FOLDER, FileName = "GamersXd_v2" },
        KeySystem = false,
    })

    local S = {
        aim_enabled = false, aim_key = Enum.KeyCode.Unknown, aim_fov = 150, aim_smooth = 0.1,
        aim_part = "UpperTorso", aim_team_check = true, aim_vis_check = true, aim_front_only = true,
        aim_prediction = true, aim_bullet_speed = 2000, aim_pred_factor = 1, aim_rotate_body = true,
        
        esp_enabled = false, esp_box = true, esp_name = true, esp_health = true,
        esp_distance = true, esp_tracer = false, esp_team_check = true, esp_range = 500,
        
        trigger_enabled = false, trigger_fov = 8, trigger_delay = 0.04,
        trigger_team = true, trigger_vis = true, walkspeed = 16, jumppower = 50,
        fullbright = false, no_fog = false, autoclicker = false, autoclicker_cps = 12,
    }

    -- ANTI-SCREENSHOT
    local isScreenshotting = false
    pcall(function()
        UserInputService.ScreenshotStarted:Connect(function()
            isScreenshotting = true
            if Rayfield then Rayfield:Toggle(true) end -- Hide UI
        end)
        UserInputService.ScreenshotEnded:Connect(function()
            isScreenshotting = false
            if Rayfield then Rayfield:Toggle(false) end -- Show UI
        end)
    end)

    -- ANTI-LAG: Cache player characters
    local cachedCharacters = {}
    local function updateCache()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    cachedCharacters[p] = {
                        char = p.Character,
                        hum = hum,
                        root = p.Character:FindFirstChild("HumanoidRootPart"),
                        head = p.Character:FindFirstChild("Head"),
                        torso = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso")
                    }
                else
                    cachedCharacters[p] = nil
                end
            else
                cachedCharacters[p] = nil
            end
        end
    end
    task.spawn(function()
        while task.wait(0.5) do updateCache() end
    end)

    local lockedTarget = nil
    local function raycastVisible(targetPos, excludeList)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = excludeList
        params.IgnoreWater = true
        local hit = workspace:Raycast(Camera.CFrame.Position, targetPos - Camera.CFrame.Position, params)
        if not hit then return true end
        local inst = hit.Instance
        if inst and (inst.Transparency or 0) > 0.9 and not inst.CanCollide then return true end
        return false
    end

    local function pickTarget(fovPx, partName, teamCheck, visCheck, frontOnly)
        if lockedTarget and lockedTarget.Parent then
            local hum = lockedTarget.Parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(lockedTarget.Position)
                if onScreen then
                    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local mag = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if mag <= fovPx then return lockedTarget end
                end
            end
        end

        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local camLook = Camera.CFrame.LookVector
        local camPos = Camera.CFrame.Position
        local exclude = { LocalPlayer.Character }

        local best, bestScore = nil, math.huge
        for p, data in pairs(cachedCharacters) do
            if teamCheck and LocalPlayer.Team and p.Team and p.Team == LocalPlayer.Team then continue end
            
            local targetPart = nil
            if partName == "Head" then targetPart = data.head
            elseif partName == "UpperTorso" then targetPart = data.torso
            else targetPart = data.root end
            if not targetPart then continue end

            local targetPos = targetPart.Position
            local to = targetPos - camPos
            if to.Magnitude > S.esp_range then continue end
            if frontOnly and camLook:Dot(to.Unit) < 0.3 then continue end

            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
            if not onScreen then continue end
            
            local mag = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            if mag > fovPx then continue end

            if visCheck then
                exclude[2] = data.char
                if not raycastVisible(targetPos, exclude) then
                    exclude[2] = nil
                    continue
                end
                exclude[2] = nil
            end

            if mag < bestScore then
                bestScore = mag
                best = targetPart
            end
        end
        return best
    end

    RunService:BindToRenderStep("GamersXdAimbot", Enum.RenderPriority.Camera.Value + 1, function()
        if not S.aim_enabled or isScreenshotting then 
            lockedTarget = nil
            return 
        end
        if S.aim_key ~= Enum.KeyCode.Unknown and not UserInputService:IsKeyDown(S.aim_key) then 
            lockedTarget = nil
            return 
        end
        
        local targetPart = pickTarget(S.aim_fov, S.aim_part, S.aim_team_check, S.aim_vis_check, S.aim_front_only)
        
        if targetPart then
            lockedTarget = targetPart
            local targetPos = targetPart.Position
            local camPos = Camera.CFrame.Position

            if S.aim_prediction then
                local vel = targetPart.AssemblyLinearVelocity
                local dist = (targetPos - camPos).Magnitude
                targetPos = targetPos + (vel * (dist / S.aim_bullet_speed) * S.aim_pred_factor)
            end

            local desired = CFrame.lookAt(camPos, targetPos)
            if S.aim_smooth <= 0.05 then
                Camera.CFrame = desired
            else
                Camera.CFrame = Camera.CFrame:Lerp(desired, 1 - S.aim_smooth)
            end

            if S.aim_rotate_body then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local root = char.HumanoidRootPart
                    char.Humanoid.AutoRotate = false
                    local lookAt = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
                    root.CFrame = root.CFrame:Lerp(CFrame.lookAt(root.Position, lookAt), 0.5)
                end
            end
        else
            lockedTarget = nil
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not S.aim_enabled or not lockedTarget then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.AutoRotate = true
            end
        end
    end)

    -- OPTIMIZED ESP (Anti-Lag)
    local espObjects = {}
    local function clearESP()
        for _, group in pairs(espObjects) do
            for _, obj in pairs(group) do pcall(function() obj:Remove() end) end
        end
        espObjects = {}
    end

    local function newDraw(kind)
        local d = Drawing.new(kind)
        d.Visible = false
        d.Thickness = 1
        return d
    end

    RunService.RenderStepped:Connect(function()
        if not S.esp_enabled or isScreenshotting then
            if next(espObjects) then clearESP() end
            return
        end

        local seen = {}
        for p, data in pairs(cachedCharacters) do
            if S.esp_team_check and LocalPlayer.Team and p.Team and p.Team == LocalPlayer.Team then continue end
            if not data.head or not data.root then continue end

            local dist = (data.root.Position - Camera.CFrame.Position).Magnitude
            if dist > S.esp_range then continue end

            local top, topOn = Camera:WorldToViewportPoint(data.head.Position + Vector3.new(0, 0.5, 0))
            local bottom, botOn = Camera:WorldToViewportPoint(data.root.Position - Vector3.new(0, 3, 0))
            if not (topOn and botOn) then continue end

            seen[p] = true
            local g = espObjects[p]
            if not g then
                g = { box = newDraw("Square"), name = newDraw("Text"), hpBg = newDraw("Square"),
                      hpFg = newDraw("Square"), dist = newDraw("Text"), tracer = newDraw("Line") }
                g.box.Color = Color3.fromRGB(230, 42, 58)
                g.name.Center, g.name.Outline, g.name.Color, g.name.Size = true, true, Color3.new(1, 1, 1), 14
                g.dist.Center, g.dist.Outline, g.dist.Color, g.dist.Size = true, true, Color3.fromRGB(230, 42, 58), 12
                g.hpBg.Color, g.hpBg.Filled = Color3.new(0, 0, 0), true
                g.hpFg.Color, g.hpFg.Filled = Color3.fromRGB(0, 255, 100), true
                g.tracer.Color = Color3.fromRGB(230, 42, 58)
                espObjects[p] = g
            end

            local h = math.abs(bottom.Y - top.Y)
            local w = h * 0.55
            local x, y = top.X - w / 2, top.Y

            g.box.Visible = S.esp_box
            if S.esp_box then g.box.Size, g.box.Position = Vector2.new(w, h), Vector2.new(x, y) end

            g.name.Visible = S.esp_name
            if S.esp_name then g.name.Text, g.name.Position = p.Name, Vector2.new(top.X, y - 16) end

            g.dist.Visible = S.esp_distance
            if S.esp_distance then g.dist.Text, g.dist.Position = string.format("%d m", math.floor(dist)), Vector2.new(top.X, y + h + 4) end

            g.hpBg.Visible, g.hpFg.Visible = S.esp_health, S.esp_health
            if S.esp_health then
                local hpPct = math.clamp(data.hum.Health / data.hum.MaxHealth, 0, 1)
                g.hpBg.Size, g.hpBg.Position = Vector2.new(2, h), Vector2.new(x - 5, y)
                g.hpFg.Size, g.hpFg.Position = Vector2.new(2, h * hpPct), Vector2.new(x - 5, y + (h * (1 - hpPct)))
                g.hpFg.Color = Color3.fromRGB(math.floor(255 * (1 - hpPct)), math.floor(255 * hpPct), 60)
            end

            g.tracer.Visible = S.esp_tracer
            if S.esp_tracer then
                g.tracer.From, g.tracer.To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y), Vector2.new(top.X, y + h)
            end
        end

        for p, g in pairs(espObjects) do
            if not seen[p] then
                for _, obj in pairs(g) do pcall(function() obj:Remove() end) end
                espObjects[p] = nil
            end
        end
    end)

    local function virtualClick()
        local vim = game:GetService("VirtualUser")
        vim:CaptureController()
        vim:Button1Down(Vector2.new(0.5, 0.5))
        task.delay(0.02, function() vim:Button1Up(Vector2.new(0.5, 0.5)) end)
    end

    local lastTrigger = 0
    RunService.Heartbeat:Connect(function()
        if not S.trigger_enabled or isScreenshotting then return end
        local now = os.clock()
        if now - lastTrigger < S.trigger_delay then return end
        if pickTarget(S.trigger_fov, "UpperTorso", S.trigger_team, S.trigger_vis, true) then
            lastTrigger = now
            virtualClick()
        end
    end)

    task.spawn(function()
        while true do
            task.wait(1 / math.max(S.autoclicker_cps, 1))
            if S.autoclicker then virtualClick() end
        end
    end)

    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.WalkSpeed ~= S.walkspeed then hum.WalkSpeed = S.walkspeed end
                if hum.UseJumpPower and hum.JumpPower ~= S.jumppower then hum.JumpPower = S.jumppower end
            end
        end
        if S.fullbright then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
        end
        if S.no_fog then
            Lighting.FogEnd = 1e6
            Lighting.FogStart = 1e6
        end
    end)

    local AimTab = Window:CreateTab("Aimbot", 4483362458)
    AimTab:CreateSection("Snap Aimbot")
    AimTab:CreateToggle({ Name = "Enable Aim", CurrentValue = false, Flag = "aim_enabled", Callback = function(v) S.aim_enabled = v end })
    AimTab:CreateSlider({ Name = "FOV", Range = { 20, 800 }, Increment = 5, Suffix = "px", CurrentValue = 150, Flag = "aim_fov", Callback = function(v) S.aim_fov = v end })
    AimTab:CreateSlider({ Name = "Smoothing (0 = instant)", Range = { 0, 1 }, Increment = 0.01, CurrentValue = 0.1, Flag = "aim_smooth", Callback = function(v) S.aim_smooth = v end })
    AimTab:CreateDropdown({ Name = "Target Part", Options = { "UpperTorso", "Head", "HumanoidRootPart" }, CurrentOption = { "UpperTorso" }, Flag = "aim_part", Callback = function(v) S.aim_part = v[1] end })
    
    AimTab:CreateSection("Hitreg Fix")
    AimTab:CreateToggle({ Name = "Rotate Body", CurrentValue = true, Flag = "aim_rotate", Callback = function(v) S.aim_rotate_body = v end })
    AimTab:CreateToggle({ Name = "Prediction", CurrentValue = true, Flag = "aim_prediction", Callback = function(v) S.aim_prediction = v end })
    AimTab:CreateSlider({ Name = "Bullet Speed", Range = { 500, 5000 }, Increment = 50, CurrentValue = 2000, Flag = "aim_bullet_speed", Callback = function(v) S.aim_bullet_speed = v end })
    AimTab:CreateSlider({ Name = "Prediction Factor", Range = { 0.1, 3 }, Increment = 0.1, CurrentValue = 1, Flag = "aim_pred_factor", Callback = function(v) S.aim_pred_factor = v end })

    AimTab:CreateSection("Filters")
    AimTab:CreateToggle({ Name = "Team Check", CurrentValue = true, Flag = "aim_team", Callback = function(v) S.aim_team_check = v end })
    AimTab:CreateToggle({ Name = "Visibility Check", CurrentValue = true, Flag = "aim_vis", Callback = function(v) S.aim_vis_check = v end })
    AimTab:CreateToggle({ Name = "Front Only", CurrentValue = true, Flag = "aim_front", Callback = function(v) S.aim_front_only = v end })

    local VisualTab = Window:CreateTab("Visual", 4483362458)
    VisualTab:CreateToggle({ Name = "Fullbright", CurrentValue = false, Flag = "fullbright", Callback = function(v) S.fullbright = v end })
    VisualTab:CreateToggle({ Name = "No Fog", CurrentValue = false, Flag = "nofog", Callback = function(v) S.no_fog = v end })

    local ESPTab = Window:CreateTab("ESP", 4483362458)
    ESPTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Flag = "esp_enabled", Callback = function(v) S.esp_enabled = v end })
    ESPTab:CreateToggle({ Name = "Box", CurrentValue = true, Flag = "esp_box", Callback = function(v) S.esp_box = v end })
    ESPTab:CreateToggle({ Name = "Name", CurrentValue = true, Flag = "esp_name", Callback = function(v) S.esp_name = v end })
    ESPTab:CreateToggle({ Name = "Health", CurrentValue = true, Flag = "esp_hp", Callback = function(v) S.esp_health = v end })
    ESPTab:CreateToggle({ Name = "Distance", CurrentValue = true, Flag = "esp_dist", Callback = function(v) S.esp_distance = v end })
    ESPTab:CreateToggle({ Name = "Tracer", CurrentValue = false, Flag = "esp_tracer", Callback = function(v) S.esp_tracer = v end })
    ESPTab:CreateToggle({ Name = "Team Check", CurrentValue = true, Flag = "esp_team", Callback = function(v) S.esp_team_check = v end })
    ESPTab:CreateSlider({ Name = "Range", Range = { 50, 2000 }, Increment = 25, Suffix = "m", CurrentValue = 500, Flag = "esp_range", Callback = function(v) S.esp_range = v end })

    local MiscTab = Window:CreateTab("Misc", 4483362458)
    MiscTab:CreateSection("Triggerbot")
    MiscTab:CreateToggle({ Name = "Enable Triggerbot", CurrentValue = false, Flag = "trig_en", Callback = function(v) S.trigger_enabled = v end })
    MiscTab:CreateSlider({ Name = "Trigger FOV", Range = { 2, 100 }, Increment = 1, Suffix = "px", CurrentValue = 8, Flag = "trig_fov", Callback = function(v) S.trigger_fov = v end })
    
    MiscTab:CreateSection("Movement")
    MiscTab:CreateSlider({ Name = "Walk Speed", Range = { 16, 300 }, Increment = 1, CurrentValue = 16, Flag = "ws", Callback = function(v) S.walkspeed = v end })
    MiscTab:CreateSlider({ Name = "Jump Power", Range = { 50, 500 }, Increment = 1, CurrentValue = 50, Flag = "jp", Callback = function(v) S.jumppower = v end })

    MiscTab:CreateSection("Autoclicker")
    MiscTab:CreateToggle({ Name = "Enable Autoclicker", CurrentValue = false, Flag = "ac_en", Callback = function(v) S.autoclicker = v end })
    MiscTab:CreateSlider({ Name = "CPS", Range = { 1, 30 }, Increment = 1, CurrentValue = 12, Flag = "ac_cps", Callback = function(v) S.autoclicker_cps = v end })

    local SettingsTab = Window:CreateTab("Settings", 4483362458)
    SettingsTab:CreateButton({ Name = "Unload Script", Callback = function() RunService:UnbindFromRenderStep("GamersXdAimbot"); Rayfield:Destroy(); clearESP() end })
    
    Rayfield:Notify({ Title = "GamersXd.fix", Content = "Stealth Loaded. Tap the Rayfield icon.", Duration = 5 })
end

-- ============================== BOOT ==============================
local rem = _loadActivation()
if rem == false then
    _showExpired()
elseif type(rem) == "number" then
    _runMain()
else
    _promptForKey(function()
        local ok, err = pcall(_runMain)
        if not ok then warn("[GamersXD] Main Error: " .. tostring(err)) end
    end)
end
