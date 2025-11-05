-- NexHub - Marseille RP
-- Script combiné par NexHub

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- DÉTECTION MOBILE
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

if isMobile then
    warn("Mode mobile détecté - Adaptation automatique de l'interface")
end

-- Chargement de Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NexHub - Marseille RP",
   LoadingTitle = "Chargement du Hub...",
   LoadingSubtitle = "by NexHub",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "MarseilleRP",
      FileName = "Config"
   },
   Discord = {
      Enabled = true,
      Invite = "RyQFfVrbWR",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "NexHub - Marseille RP",
      Subtitle = "Système de Clé",
      Note = "Entrez la clé pour accéder",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Metroman"}
   },
   Theme = "Amethyst"
})

-- SETTINGS
local modSettings = {
    Aimbot = false,
    AimbotDistance = 500,
    AimbotTeamCheck = true,
    AimbotPart = "Head",
    HeadHitboxEnabled = false,
    HeadHitboxSize = 5
}

local isRightClickDown = false
local currentTarget = nil

-- TABS
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local TrollTab = Window:CreateTab("Troll", nil)
local MovementTab = Window:CreateTab("Mouvement", nil)
local GiveToolTab = Window:CreateTab("Give Tool", nil)

-- ========================================
-- AIMBOT TAB
-- ========================================

local AimbotSection = AimbotTab:CreateSection("Aimbot")

local AimbotToggle = AimbotTab:CreateToggle({
   Name = "Aimbot (Vise Tete)",
   CurrentValue = false,
   Flag = "Aimbot",
   Callback = function(Value)
       modSettings.Aimbot = Value
   end,
})

local AimbotDistanceSlider = AimbotTab:CreateSlider({
   Name = "Rayon de Distance (studs)",
   Range = {50, 2000},
   Increment = 50,
   CurrentValue = 500,
   Flag = "AimbotDistance",
   Callback = function(Value)
       modSettings.AimbotDistance = Value
   end,
})

local AimbotPartDropdown = AimbotTab:CreateDropdown({
   Name = "Partie du Corps a Viser",
   Options = {"Head", "Torso", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "AimbotPart",
   Callback = function(Value)
       modSettings.AimbotPart = Value[1]
   end,
})

-- Section Hitbox
local HitboxSection = AimbotTab:CreateSection("Agrandissement Hitbox")

local hitboxConnection = nil

local function enableHeadHitbox()
    if hitboxConnection then
        hitboxConnection:Disconnect()
    end

    hitboxConnection = RunService.RenderStepped:Connect(function()
        if modSettings.HeadHitboxEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v.Name ~= player.Name then
                    pcall(function()
                        v.Character.HumanoidRootPart.Size = Vector3.new(modSettings.HeadHitboxSize, modSettings.HeadHitboxSize, modSettings.HeadHitboxSize)
                        v.Character.HumanoidRootPart.Transparency = 0.95
                        v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                        v.Character.HumanoidRootPart.Material = Enum.Material.Neon
                        v.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
    end)
end

local function disableHeadHitbox()
    if hitboxConnection then
        hitboxConnection:Disconnect()
        hitboxConnection = nil
    end

    for _, v in pairs(Players:GetPlayers()) do
        if v.Name ~= player.Name and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = v.Character.HumanoidRootPart
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
                hrp.CanCollide = false
                hrp.Material = Enum.Material.Plastic
            end)
        end
    end
end

local HeadHitboxToggle = AimbotTab:CreateToggle({
   Name = "Agrandir Hitbox Tete",
   CurrentValue = false,
   Flag = "HeadHitboxEnabled",
   Callback = function(Value)
       modSettings.HeadHitboxEnabled = Value
       if Value then
           enableHeadHitbox()
           Rayfield:Notify({
               Title = "Hitbox Active",
               Content = "Hitbox agrandie pour tous",
               Duration = 3,
               Image = 4483362458,
           })
       else
           disableHeadHitbox()
       end
   end,
})

local HeadHitboxSizeSlider = AimbotTab:CreateSlider({
   Name = "Taille Hitbox Tete",
   Range = {0.5, 1500},
   Increment = 1,
   CurrentValue = 5,
   Flag = "HeadHitboxSize",
   Callback = function(Value)
       modSettings.HeadHitboxSize = Value
   end,
})

-- ========================================
-- TROLL TAB (ACS 2.0.1 Features)
-- ========================================

local ServerSection = TrollTab:CreateSection("Server")

local LagServerButton = TrollTab:CreateButton({
    Name = "Lag Server",
    Callback = function()
        pcall(function()
            local cFrame = CFrame.new(0,0,0)
            local Size = {
                X = 1,
                Y = 1,
                Z = 1
            }

            -- Fonction pour chercher récursivement
            local function findBreachEvent(parent)
                for _, child in pairs(parent:GetDescendants()) do
                    if child.Name == "Breach" and (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) then
                        return child
                    end
                end
                return nil
            end

            -- Chercher Breach dans ReplicatedStorage
            local breachEvent = findBreachEvent(ReplicatedStorage)

            if breachEvent then
                if breachEvent:IsA("RemoteFunction") then
                    breachEvent:InvokeServer(
                        3,
                        {Fortified={}, Destroyable=workspace},
                        CFrame.new(),
                        CFrame.new(),
                        {CFrame=player.Character.HumanoidRootPart.CFrame*cFrame, Size=Size}
                    )
                elseif breachEvent:IsA("RemoteEvent") then
                    breachEvent:FireServer(
                        3,
                        {Fortified={}, Destroyable=workspace},
                        CFrame.new(),
                        CFrame.new(),
                        {CFrame=player.Character.HumanoidRootPart.CFrame*cFrame, Size=Size}
                    )
                end
            end
        end)

        Rayfield:Notify({
            Title = "Lag Server",
            Content = "plus tu spam plus sa lag",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local EarRapeButton = TrollTab:CreateButton({
    Name = "Bruit Aigue (Nique les Oreilles)",
    Callback = function()
        pcall(function()
            -- Fonction pour chercher Suppression partout
            local function findSuppressionEvent(parent)
                for _, child in pairs(parent:GetDescendants()) do
                    if child.Name == "Suppression" and child:IsA("RemoteEvent") then
                        return child
                    end
                end
                return nil
            end

            local suppressionEvent = findSuppressionEvent(ReplicatedStorage)

            if suppressionEvent then
                for i = 1, 50 do
                    for _, plr in next, game.Players:GetPlayers() do
                        suppressionEvent:FireServer(plr, 666, 666, 666)
                    end
                end
            end
        end)

        Rayfield:Notify({
            Title = "Bruit Aigue",
            Content = "Plus tu cliques moins t'aura d'oreille",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local whizzEnabled = false

local WhizzToggle = TrollTab:CreateToggle({
    Name = "Weapon Sound Everywhere / Whizz",
    CurrentValue = false,
    Flag = "WhizzToggle",
    Callback = function(Value)
        whizzEnabled = Value

        if Value then
            Rayfield:Notify({
                Title = "Whizz",
                Content = "gg bg",
                Duration = 3,
                Image = 4483362458,
            })

            task.spawn(function()
                while task.wait() do
                    if not whizzEnabled then break end
                    for _, player in next, game.Players:GetPlayers() do
                        game:GetService('ReplicatedStorage')['ACS_Engine'].Events.Whizz:FireServer(player)
                    end
                end
            end)
        else
            Rayfield:Notify({
                Title = "Whizz",
                Content = "Whizz désactivé",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Section Building
local BuildingSection = TrollTab:CreateSection("Building")

local buildSettings = {
    SizeX = 10,
    SizeY = 10,
    SizeZ = 10
}

local BuildSizeXSlider = TrollTab:CreateSlider({
   Name = "Taille X",
   Range = {1, 1000000},
   Increment = 1,
   CurrentValue = 10,
   Flag = "BuildSizeX",
   Callback = function(Value)
       buildSettings.SizeX = Value
   end,
})

local BuildSizeYSlider = TrollTab:CreateSlider({
   Name = "Taille Y",
   Range = {1, 1000000},
   Increment = 1,
   CurrentValue = 10,
   Flag = "BuildSizeY",
   Callback = function(Value)
       buildSettings.SizeY = Value
   end,
})

local BuildSizeZSlider = TrollTab:CreateSlider({
   Name = "Taille Z",
   Range = {1, 1000000},
   Increment = 1,
   CurrentValue = 10,
   Flag = "BuildSizeZ",
   Callback = function(Value)
       buildSettings.SizeZ = Value
   end,
})

local SpawnBuildButton = TrollTab:CreateButton({
    Name = "Spawn Build",
    Callback = function()
        pcall(function()
            local cFrame = CFrame.new(0, 0, 0)
            local Size = {
                X = buildSettings.SizeX,
                Y = buildSettings.SizeY,
                Z = buildSettings.SizeZ
            }

            -- Fonction pour chercher récursivement
            local function findBreachEvent(parent)
                for _, child in pairs(parent:GetDescendants()) do
                    if child.Name == "Breach" and (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) then
                        return child
                    end
                end
                return nil
            end

            -- Chercher Breach dans ReplicatedStorage
            local breachEvent = findBreachEvent(ReplicatedStorage)

            if breachEvent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if breachEvent:IsA("RemoteFunction") then
                    breachEvent:InvokeServer(
                        3,
                        {Fortified={}, Destroyable=workspace},
                        CFrame.new(),
                        CFrame.new(),
                        {CFrame=player.Character.HumanoidRootPart.CFrame*cFrame, Size=Size}
                    )
                elseif breachEvent:IsA("RemoteEvent") then
                    breachEvent:FireServer(
                        3,
                        {Fortified={}, Destroyable=workspace},
                        CFrame.new(),
                        CFrame.new(),
                        {CFrame=player.Character.HumanoidRootPart.CFrame*cFrame, Size=Size}
                    )
                end

                Rayfield:Notify({
                    Title = "Build Spawned",
                    Content = string.format("Taille: %dx%dx%d", Size.X, Size.Y, Size.Z),
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        end)
    end,
})

-- FLING ALL
local FlingSection = TrollTab:CreateSection("Fling")

local FlingAllButton = TrollTab:CreateButton({
    Name = "Fling All",
    Callback = function()
        pcall(function()
            local Targets = {"All"}
            local AllBool = false

            local GetPlayer = function(Name)
                Name = Name:lower()
                if Name == "all" or Name == "others" then
                    AllBool = true
                    return
                elseif Name == "random" then
                    local GetPlayers = Players:GetPlayers()
                    if table.find(GetPlayers,player) then table.remove(GetPlayers,table.find(GetPlayers,player)) end
                    return GetPlayers[math.random(#GetPlayers)]
                elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
                    for _,x in next, Players:GetPlayers() do
                        if x ~= player then
                            if x.Name:lower():match("^"..Name) then
                                return x;
                            elseif x.DisplayName:lower():match("^"..Name) then
                                return x;
                            end
                        end
                    end
                else
                    return
                end
            end

            local SkidFling = function(TargetPlayer)
                local Character = player.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                local RootPart = Humanoid and Humanoid.RootPart

                local TCharacter = TargetPlayer.Character
                local THumanoid
                local TRootPart
                local THead
                local Accessory
                local Handle

                if TCharacter:FindFirstChildOfClass("Humanoid") then
                    THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
                end
                if THumanoid and THumanoid.RootPart then
                    TRootPart = THumanoid.RootPart
                end
                if TCharacter:FindFirstChild("Head") then
                    THead = TCharacter.Head
                end
                if TCharacter:FindFirstChildOfClass("Accessory") then
                    Accessory = TCharacter:FindFirstChildOfClass("Accessory")
                end
                if Accessory and Accessory:FindFirstChild("Handle") then
                    Handle = Accessory.Handle
                end

                if Character and Humanoid and RootPart then
                    if RootPart.Velocity.Magnitude < 50 then
                        getgenv().OldPos = RootPart.CFrame
                    end
                    if THumanoid and THumanoid.Sit and not AllBool then
                        return
                    end
                    if THead then
                        workspace.CurrentCamera.CameraSubject = THead
                    elseif not THead and Handle then
                        workspace.CurrentCamera.CameraSubject = Handle
                    elseif THumanoid and TRootPart then
                        workspace.CurrentCamera.CameraSubject = THumanoid
                    end
                    if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                        return
                    end

                    local FPos = function(BasePart, Pos, Ang)
                        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                    end

                    local SFBasePart = function(BasePart)
                        local TimeToWait = 2
                        local Time = tick()
                        local Angle = 0

                        repeat
                            if RootPart and THumanoid then
                                if BasePart.Velocity.Magnitude < 50 then
                                    Angle = Angle + 100

                                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()
                                else
                                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                                    task.wait()

                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                    task.wait()
                                end
                            else
                                break
                            end
                        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
                    end

                    workspace.FallenPartsDestroyHeight = 0/0

                    local BV = Instance.new("BodyVelocity")
                    BV.Name = "EpixVel"
                    BV.Parent = RootPart
                    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

                    if TRootPart and THead then
                        if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                            SFBasePart(THead)
                        else
                            SFBasePart(TRootPart)
                        end
                    elseif TRootPart and not THead then
                        SFBasePart(TRootPart)
                    elseif not TRootPart and THead then
                        SFBasePart(THead)
                    elseif not TRootPart and not THead and Accessory and Handle then
                        SFBasePart(Handle)
                    else
                        return
                    end

                    BV:Destroy()
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                    workspace.CurrentCamera.CameraSubject = Humanoid

                    repeat
                        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                        Humanoid:ChangeState("GettingUp")
                        table.foreach(Character:GetChildren(), function(_, x)
                            if x:IsA("BasePart") then
                                x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                            end
                        end)
                        task.wait()
                    until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
                    workspace.FallenPartsDestroyHeight = getgenv().FPDH
                else
                    return
                end
            end

            if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end

            if AllBool then
                for _,x in next, Players:GetPlayers() do
                    if x ~= player then
                        SkidFling(x)
                    end
                end
            end

            for _,x in next, Targets do
                if GetPlayer(x) and GetPlayer(x) ~= player then
                    local TPlayer = GetPlayer(x)
                    if TPlayer then
                        SkidFling(TPlayer)
                    end
                elseif not GetPlayer(x) and not AllBool then
                    -- Erreur ignorée
                end
            end
        end)

        Rayfield:Notify({
            Title = "Fling All",
            Content = "Tous les joueurs ont été fling!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- ========================================
-- AIMBOT FUNCTIONS
-- ========================================

local function getClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge

    local camera = workspace.CurrentCamera
    local mouse = UserInputService:GetMouseLocation()

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local otherHumanoid = otherChar:FindFirstChildOfClass("Humanoid")

            local targetPart = otherChar:FindFirstChild(modSettings.AimbotPart)

            if not targetPart then
                targetPart = otherChar:FindFirstChild("Head")
            end

            if not targetPart then
                targetPart = otherChar:FindFirstChild("UpperTorso") or otherChar:FindFirstChild("Torso")
            end

            if targetPart and otherHumanoid and otherHumanoid.Health > 0 then
                local realPosition = targetPart.Position

                local screenPos, onScreen = camera:WorldToViewportPoint(realPosition)

                if onScreen then
                    local screenDistance = math.sqrt((mouse.X - screenPos.X)^2 + (mouse.Y - screenPos.Y)^2)

                    local worldDistance = (character.HumanoidRootPart.Position - realPosition).Magnitude

                    if screenDistance < shortestDistance and worldDistance < modSettings.AimbotDistance then
                        closestPlayer = otherChar
                        shortestDistance = screenDistance
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function aimAtTarget(target)
    if not target then return end

    local targetPart = target:FindFirstChild(modSettings.AimbotPart)

    if not targetPart then
        targetPart = target:FindFirstChild("Head")
    end

    if not targetPart then
        targetPart = target:FindFirstChild("UpperTorso") or target:FindFirstChild("Torso")
    end

    if not targetPart then return end

    local camera = workspace.CurrentCamera
    if not camera then return end

    local targetPosition = targetPart.Position
    local cameraPosition = camera.CFrame.Position

    local newCFrame = CFrame.new(cameraPosition, targetPosition)
    camera.CFrame = newCFrame
end

-- ========================================
-- INPUT HANDLING
-- ========================================

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightClickDown = true
    end

    if isMobile then
        if input.UserInputType == Enum.UserInputType.Touch then
            local touches = UserInputService:GetTouchesInUse()
            if #touches >= 2 then
                isRightClickDown = true
            end
        end
        if input.KeyCode == Enum.KeyCode.ButtonL2 then
            isRightClickDown = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightClickDown = false
    end

    if isMobile then
        if input.UserInputType == Enum.UserInputType.Touch then
            local touches = UserInputService:GetTouchesInUse()
            if #touches < 2 then
                isRightClickDown = false
            end
        end
        if input.KeyCode == Enum.KeyCode.ButtonL2 then
            isRightClickDown = false
        end
    end
end)

-- ========================================
-- MAIN LOOP
-- ========================================

RunService.Heartbeat:Connect(function()
    local equippedTool = character:FindFirstChildOfClass("Tool")

    if modSettings.Aimbot and isRightClickDown and equippedTool then
        currentTarget = getClosestEnemy()
        if currentTarget then
            aimAtTarget(currentTarget)
        end
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

-- ========================================
-- MOVEMENT TAB
-- ========================================

local MovementSection = MovementTab:CreateSection("Contrôles de Mouvement")

-- INFINITE JUMP
local infiniteJumpEnabled = false

local InfiniteJumpToggle = MovementTab:CreateToggle({
   Name = "Saut Infini",
   CurrentValue = false,
   Flag = "InfiniteJump",
   Callback = function(Value)
       infiniteJumpEnabled = Value
   end,
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and character and character:FindFirstChildOfClass("Humanoid") then
        character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- NOCLIP
local noclipEnabled = false
local noclipConnection = nil

local function enableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
    end

    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

local NoclipToggle = MovementTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
       noclipEnabled = Value
       if Value then
           enableNoclip()
           Rayfield:Notify({
               Title = "NoClip Activé",
               Content = "Vous pouvez traverser les murs",
               Duration = 3,
               Image = 4483362458,
           })
       else
           disableNoclip()
           Rayfield:Notify({
               Title = "NoClip Désactivé",
               Content = "Collisions rétablies",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

-- FLY
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

local function enableFly()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyGyro.Parent = hrp

    if flyConnection then
        flyConnection:Disconnect()
    end

    flyConnection = RunService.Heartbeat:Connect(function()
        if flyEnabled and character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local camera = workspace.CurrentCamera

            if humanoid then
                humanoid.PlatformStand = true
            end

            if bodyGyro then
                bodyGyro.CFrame = camera.CFrame
            end

            local moveDirection = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + (camera.CFrame.LookVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - (camera.CFrame.LookVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - (camera.CFrame.RightVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + (camera.CFrame.RightVector * flySpeed)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + (Vector3.new(0, flySpeed, 0))
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - (Vector3.new(0, flySpeed, 0))
            end

            if bodyVelocity then
                bodyVelocity.Velocity = moveDirection
            end
        end
    end)
end

local function disableFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end

    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end

    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

local FlyToggle = MovementTab:CreateToggle({
   Name = "Fly (WASD + Space/Shift)",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
       flyEnabled = Value
       if Value then
           enableFly()
           Rayfield:Notify({
               Title = "Fly Activé",
               Content = "Utilisez WASD + Space/Shift pour voler",
               Duration = 3,
               Image = 4483362458,
           })
       else
           disableFly()
           Rayfield:Notify({
               Title = "Fly Désactivé",
               Content = "Mode de vol désactivé",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

local FlySpeedSlider = MovementTab:CreateSlider({
   Name = "Vitesse de Vol",
   Range = {10, 500},
   Increment = 5,
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
       flySpeed = Value
   end,
})

-- Mise à jour lors du respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    task.wait(0.5)

    if noclipEnabled then
        enableNoclip()
    end

    if flyEnabled then
        disableFly()
        task.wait(0.5)
        enableFly()
    end
end)

-- GIVE TOOL SYSTEM
local GiveToolSection = GiveToolTab:CreateSection("Prendre des Outils")

local selectedToolData = nil
local allToolsList = {}

-- Fonction pour obtenir tous les outils de tous les joueurs
local function getAllAvailableTools()
    allToolsList = {}
    local toolsMap = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            -- Outils dans le backpack
            local backpack = plr:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        local displayName = plr.Name .. " - " .. tool.Name
                        table.insert(allToolsList, displayName)
                        toolsMap[displayName] = {player = plr, tool = tool}
                    end
                end
            end

            -- Outils équipés
            if plr.Character then
                for _, tool in pairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        local displayName = plr.Name .. " - " .. tool.Name .. " (Équipé)"
                        table.insert(allToolsList, displayName)
                        toolsMap[displayName] = {player = plr, tool = tool}
                    end
                end
            end
        end
    end

    return allToolsList, toolsMap
end

local toolsMapGlobal = {}

-- Dropdown pour sélectionner un outil
local ToolDropdown = GiveToolTab:CreateDropdown({
   Name = "Selectionner un Outil",
   Options = {},
   CurrentOption = {},
   MultipleOptions = false,
   Flag = "SelectedTool",
   Callback = function(Value)
       if Value and Value[1] then
           selectedToolData = toolsMapGlobal[Value[1]]
       end
   end,
})

-- Bouton pour charger tous les outils
local LoadToolsButton = GiveToolTab:CreateButton({
   Name = "Recharger la Liste",
   Callback = function()
       local tools, toolsMap = getAllAvailableTools()
       toolsMapGlobal = toolsMap

       if #tools > 0 then
           ToolDropdown:Refresh(tools, {}, true)
           Rayfield:Notify({
               Title = "Outils Chargés",
               Content = #tools .. " outil(s) disponible(s)",
               Duration = 3,
               Image = 4483362458,
           })
       else
           ToolDropdown:Refresh({}, {}, true)
           Rayfield:Notify({
               Title = "Aucun Outil",
               Content = "Aucun outil trouvé",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

-- Bouton pour prendre l'outil sélectionné
local GetToolButton = GiveToolTab:CreateButton({
   Name = "Prendre l'Outil",
   Callback = function()
       if not selectedToolData then
           Rayfield:Notify({
               Title = "Erreur",
               Content = "Sélectionnez d'abord un outil",
               Duration = 3,
               Image = 4483362458,
           })
           return
       end

       local tool = selectedToolData.tool
       local toolOwner = selectedToolData.player

       if tool and tool.Parent then
           tool.Parent = player.Backpack
           Rayfield:Notify({
               Title = "Outil Obtenu",
               Content = "Vous avez pris: " .. tool.Name,
               Duration = 3,
               Image = 4483362458,
           })
       else
           Rayfield:Notify({
               Title = "Échec",
               Content = "Outil non disponible",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

local GiveToolWarning = GiveToolTab:CreateLabel("Tous les objets ne peuvent pas être pris")

warn("NexHub - Marseille RP ")
