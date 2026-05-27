-- config

if not isfolder("OpposedMenu") then
    makefolder("OpposedMenu")
end
if not isfile("OpposedMenu/Default.lua") then
    writefile("OpposedMenu/Default.lua", [[
_G.OMConfig = {
-- Laser
{"Right Hand Laser",false},
{"Left Hand Laser",false},

-- Silent Aim
{"Right Arm Silent Aim",false},
{"Left Arm Silent Aim",false},
{"Silent Aim (Performant)",true},
{"Target Head",true},
{"Target Torso",false},
{"Silent Aim FOV",10},
{"Aim Randomization",true},
{"Randomization Multiplier",1},

-- Regular Aimbot
{"Right Hand Aimbot (A)",false},
{"Left Hand Aimbot (X)",false},

-- Blatant (Combat)
{"Arm Kill All (A)",false},

-- Movement
{"Override Gravity",false},
{"Jetpack (X)",false},
{"Override Speed",false},
{"Gravity",16},
{"Jetpack Speed",50},
{"Movement Speed",15},

-- Rendering (Player)
{"Player Chams (Occluded)",false},
{"Player Chams",false},
{"Player Boxes",false},
{"Player Names",false},
{"Player Outline Opacity",0},
{"Player Fill Opacity",0.5},
{"Player Outline Color",0,0,1},
{"Player Fill Color",0,0,1},

-- Rendering (Items)
{"Item Names",false},

-- Miscellaneous
{"Override Strength",false},
{"Positional Strength",750},
{"Rotational Strength",750},
}
]])
end

loadstring(readfile("OpposedMenu/Default.lua"))()

print(_G.OMConfig)

-- services, regularly used variables, etc.

local runs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local vrs = game:GetService("VRService")
local lighting = game:GetService("Lighting")

local versiontext = "nightly-2_040925"

local players = game:GetService("Players")
local player = players.LocalPlayer

local lchar = player.Character

local larm = lchar:WaitForChild("Left Arm")
local rarm = lchar:WaitForChild("Right Arm")

local root = lchar:FindFirstChild("Root")

local camera = workspace.CurrentCamera
local handorbs = camera:FindFirstChild("VirtualHands")

local jpvel = Instance.new("LinearVelocity",root)
local rootatt = Instance.new("Attachment",root)
jpvel.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
jpvel.MaxForce = math.huge

-- armpart for the main menu

local truearmpart = Instance.new("Part",workspace)
truearmpart.Transparency = 1
truearmpart.CanCollide = false
truearmpart.CanTouch = false
truearmpart.Size = Vector3.new(0.005,0.005,0.005)
truearmpart.Massless = true
truearmpart.PivotOffset = CFrame.new(0,0.2,0)

local apweld = Instance.new("Weld",truearmpart)
apweld.Part0 = larm
apweld.Part1 = truearmpart
apweld.C1 = CFrame.new(0,-0.1,0) * CFrame.Angles(math.rad(-90),math.rad(90),math.rad(90))

local armpart = Instance.new("Part",workspace)
armpart.Transparency = 1
armpart.CanCollide = false
armpart.Size = Vector3.new(0.75,0.75,0.005)
armpart.Massless = true

local weld = Instance.new("Weld",armpart)
weld.Part0 = truearmpart
weld.Part1 = armpart
weld.C1 = CFrame.new(0,-0.625,0.15) * CFrame.Angles(math.rad(-90),0,math.rad(-90))

local refresh = 0

-- gui popup button

local showgui = false
local showguipart = Instance.new("Part",workspace)
showguipart.Transparency = 1
showguipart.CanCollide = false
showguipart.Size = Vector3.new(0.075,0.075,0.005)
showguipart.Massless = true

local weld2 = Instance.new("Weld",showguipart)
weld2.Part0 = truearmpart
weld2.Part1 = showguipart
weld2.C1 = CFrame.new(0.125, 0.13, 0.2) * CFrame.Angles(math.rad(-90),0,math.rad(-90))

local showguisg = Instance.new("SurfaceGui",player.PlayerGui)
showguisg.Adornee = showguipart
showguisg.AlwaysOnTop = true

showguisg.CanvasSize = Vector2.new(256,256)

local showguiobj = Instance.new("ImageButton",showguisg)
showguiobj.Visible = true
showguiobj.Size = UDim2.new(1,0,1,0)

-- surface gui
local menuGUI = Instance.new("SurfaceGui",player.PlayerGui)
menuGUI.Adornee = armpart
menuGUI.AlwaysOnTop = true

menuGUI.CanvasSize = Vector2.new(512,512)

-- menu bg

local menubg = Instance.new("Frame",menuGUI)
menubg.Size = UDim2.new(1,0,1,0)
menubg.BackgroundColor3 = Color3.new(1,1,1)
menubg.BackgroundTransparency = 0.25

local bguig = Instance.new("UIGradient",menubg)
bguig.Rotation = 90
bguig.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.new(0.25,0.25,0.25)),
    ColorSequenceKeypoint.new(1,Color3.new(0.15,0.15,0.15))
})

local bguis = Instance.new("UIStroke",menubg)
bguis.Color = Color3.new(1,1,1)

local bguisg = Instance.new("UIGradient",bguis)
bguisg.Rotation = 45

local bguic = Instance.new("UICorner",menubg)
bguic.CornerRadius = UDim.new(0,15)

-- menu title

local menutitle = Instance.new("TextLabel",menubg)
menutitle.BackgroundTransparency = 1

menutitle.TextXAlignment = Enum.TextXAlignment.Left
menutitle.TextScaled = true
menutitle.Font = Enum.Font.Oswald
menutitle.Text = "Opposed - ("..versiontext..")"

menutitle.TextColor3 = Color3.new(1,1,1)

menutitle.AnchorPoint = Vector2.new(0.5,0)
menutitle.Position = UDim2.new(0.5,0,0,0)
menutitle.Size = UDim2.new(0.9,0,0,50)

-- menu scroll frame

local menuscrbf = Instance.new("Frame",menubg)
menuscrbf.AnchorPoint = Vector2.new(0.5,0)
menuscrbf.Position = UDim2.new(0.3,0,0.125,0)
menuscrbf.Size = UDim2.new(0.5,0,0.8125,0)

menuscrbf.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

local scruic = Instance.new("UICorner",menuscrbf)
scruic.CornerRadius = UDim.new(0,15)

local menuscr = Instance.new("ScrollingFrame",menuscrbf)
menuscr.Size = UDim2.new(1,0,1,0)
menuscr.AutomaticCanvasSize = Enum.AutomaticSize.Y

menuscr.BorderSizePixel = 0
menuscr.ScrollBarThickness = 10
menuscr.ScrollBarImageColor3 = Color3.new(0.2,0.2,0.2)

local scruip = Instance.new("UIPadding",menuscr)
scruip.PaddingLeft = UDim.new(0,15)
scruip.PaddingTop = UDim.new(0,15)
scruip.PaddingBottom = UDim.new(0,15)

local scrpgl = Instance.new("UIListLayout",menuscr)
scrpgl.Padding = UDim.new(0,8)
scrpgl.SortOrder = Enum.SortOrder.LayoutOrder

menuscr.BackgroundTransparency = 1

-- update log
local menuudl = Instance.new("TextLabel",menubg)
menuudl.AnchorPoint = Vector2.new(0.5,0)
menuudl.Position = UDim2.new(0.775,0,0.125,0)
menuudl.Size = UDim2.new(0.35,0,0.8125,0)
menuudl.Font = Enum.Font.Oswald
menuudl.TextColor3 = Color3.new(1,1,1)
menuudl.TextWrapped = true
menuudl.TextSize = 30
menuudl.TextXAlignment = Enum.TextXAlignment.Center
menuudl.TextYAlignment = Enum.TextYAlignment.Top

menuudl.Text = [[Thanks for using Opposed!

Made by OpposedDev on Github.

https://github.com/
OpposedDev/Opposed/]]

menuudl.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

local scruic = Instance.new("UICorner",menuudl)
scruic.CornerRadius = UDim.new(0,15)

-- lasers

local rlaserpart = Instance.new("Part",workspace)
rlaserpart.Transparency = 1
rlaserpart.CanCollide = false
rlaserpart.CanTouch = false
rlaserpart.CanQuery = false
rlaserpart.Size = Vector3.new(1000, 0.01, 0.01)
rlaserpart.Massless = true
rlaserpart.Shape = Enum.PartType.Cylinder
rlaserpart.Material = Enum.Material.Neon
rlaserpart.Color = Color3.new(1,0,0)

local att3 = Instance.new("Attachment",rlaserpart)
att3.CFrame = CFrame.new(500.5, 0.3, 0.005) * CFrame.Angles(math.rad(-90),0,math.rad(-90))

local weld3 = Instance.new("Weld",rlaserpart)
weld3.Part0 = player.Character:WaitForChild("Right Arm")
weld3.Part1 = rlaserpart
weld3.C1 = att3.CFrame

local llaserpart = Instance.new("Part",workspace)
llaserpart.Transparency = 1
llaserpart.CanCollide = false
llaserpart.CanTouch = false
llaserpart.CanQuery = false
llaserpart.Size = Vector3.new(1000, 0.01, 0.01)
llaserpart.Massless = true
llaserpart.Shape = Enum.PartType.Cylinder
llaserpart.Material = Enum.Material.Neon
llaserpart.Color = Color3.new(1,0,0)

local att4 = Instance.new("Attachment",llaserpart)
att4.CFrame = CFrame.new(500.5, 0.3, 0.005) * CFrame.Angles(math.rad(-90),0,math.rad(-90))

local weld4 = Instance.new("Weld",llaserpart)
weld4.Part0 = player.Character:WaitForChild("Left Arm")
weld4.Part1 = llaserpart
weld4.C1 = att4.CFrame

-- silent aim fov
local rsafov = Instance.new("Part",workspace)
rsafov.Transparency = 1
rsafov.CanCollide = false
rsafov.CanTouch = false
rsafov.CanQuery = false
rsafov.Size = Vector3.new(1000, 0.01, 0.01)
rsafov.Massless = true
rsafov.Shape = Enum.PartType.Cylinder

local att4 = Instance.new("Attachment",rsafov)
att4.CFrame = CFrame.new(500.5, 0.3, 0.005) * CFrame.Angles(math.rad(-90),0,math.rad(-90))

local weld4 = Instance.new("Weld",rsafov)
weld4.Part0 = player.Character:WaitForChild("Right Arm")
weld4.Part1 = rsafov
weld4.C1 = att4.CFrame

local lsafov = Instance.new("Part",workspace)
lsafov.Transparency = 1
lsafov.CanCollide = false
lsafov.CanTouch = false
lsafov.CanQuery = false
lsafov.Size = Vector3.new(1000, 0.01, 0.01)
lsafov.Massless = true
lsafov.Shape = Enum.PartType.Cylinder

local att5 = Instance.new("Attachment",lsafov)
att5.CFrame = CFrame.new(500.5, 0.3, 0.005) * CFrame.Angles(math.rad(-90),0,math.rad(-90))

local weld5 = Instance.new("Weld",lsafov)
weld5.Part0 = player.Character:WaitForChild("Left Arm")
weld5.Part1 = lsafov
weld5.C1 = att5.CFrame

-- functions
local distance, position = math.huge, nil
local tspos = Vector2.new(0,0)

local menutoggles = {}
local menunftoggles = {}
local menuranges = {}
local menucranges = {}
local menucolors = {}

local fc = 0

function plroccchamsesp()
    for _,v in pairs(players:GetChildren()) do
            local char = v.Character

            if char and v.Name ~= players.LocalPlayer.Name then
                    if not char:FindFirstChild("hl") then
                            local hl = Instance.new("Highlight",char)

                            hl.Name = "hl"
                            hl.FillTransparency = 0
                            hl.FillColor = Color3.new(1,1,1)
                            hl.OutlineTransparency = 1
                    else
                            local fill = 0.5
                            local outline = 1

                            local fc = Color3.new(1,1,1)
                            local oc = Color3.new(1,1,1)

                            for _,v in pairs(menucranges) do
                                    if v[1] == "Player Fill Opacity" then
                                            fill = 1-v[2]
                                    end

                                    if v[1] == "Player Outline Opacity" then
                                            outline = 1-v[2]
                                    end
                            end

                            for _,v in pairs(menucolors) do
                                    if v[1] == "Player Fill Color" then
                                            fc = v[5]
                                    end

                                    if v[1] == "Player Outline Color" then
                                            oc = v[5]
                                    end
                            end

                            char.hl.DepthMode = Enum.HighlightDepthMode.Occluded

                            char.hl.Enabled = true
                            char.hl.Adornee = char

                            char.hl.FillTransparency = fill
                            char.hl.OutlineTransparency = outline

                            char.hl.FillColor = fc
                            char.hl.OutlineColor = oc

                            if char:FindFirstChild("Humanoid") then
                                    if char.Humanoid.Health < 0.1 then
                                            char.hl.Enabled = false
                                    end
                            end

                            if char:FindFirstChild("VRHealth") then
                                    if char.VRHealth.Value < 0.1 then
                                            char.hl.Enabled = false
                                    end
                            end
                    end
            end
    end
end

function plrchamsesp()
    for _,v in pairs(players:GetChildren()) do
            local char = v.Character

            if char and v.Name ~= players.LocalPlayer.Name then
                    if not char:FindFirstChild("hl") then
                            local hl = Instance.new("Highlight",char)

                            hl.Name = "hl"
                            hl.FillTransparency = 0
                            hl.FillColor = Color3.new(1,1,1)
                            hl.OutlineTransparency = 1
                    else
                            local fill = 0.5
                            local outline = 1

                            local fc = Color3.new(1,1,1)
                            local oc = Color3.new(1,1,1)

                            for _,v in pairs(menucranges) do
                                    if v[1] == "Player Fill Opacity" then
                                            fill = 1-v[2]
                                    end

                                    if v[1] == "Player Outline Opacity" then
                                            outline = 1-v[2]
                                    end
                            end

                            for _,v in pairs(menucolors) do
                                    if v[1] == "Player Fill Color" then
                                            fc = v[5]
                                    end

                                    if v[1] == "Player Outline Color" then
                                            oc = v[5]
                                    end
                            end

                            char.hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                            char.hl.Enabled = true
                            char.hl.Adornee = char

                            char.hl.FillTransparency = fill
                            char.hl.OutlineTransparency = outline

                            char.hl.FillColor = fc
                            char.hl.OutlineColor = oc

                            if char:FindFirstChild("Humanoid") then
                                    if char.Humanoid.Health < 0.1 then
                                            char.hl.Enabled = false
                                    end
                            end

                            if char:FindFirstChild("VRHealth") then
                                    if char.VRHealth.Value < 0.1 then
                                            char.hl.Enabled = false
                                    end
                            end
                    end
            end
    end
end

function plrboxesp()
    for _,v in pairs(players:GetChildren()) do
            local char = v.Character

            if char and v.Name ~= players.LocalPlayer.Name then
                    if not char:FindFirstChild("box") then
                            local box = Instance.new("BillboardGui",char)
                            box.Adornee = char

                            box.Name = "box"
                            box.Enabled = true
                            box.AlwaysOnTop = true
                            box.Size = UDim2.new(4,0,6,0)

                            local boxf = Instance.new("Frame",box)
                            boxf.Size = UDim2.new(1,0,1,0)
                            boxf.BorderSizePixel = 0
                            boxf.BackgroundTransparency = 1

                            local uist = Instance.new("UIStroke",boxf)
                            uist.Color = Color3.new(1,1,1)
                    else
                            char.box.Enabled = true

                            if char:FindFirstChild("Humanoid") then
                                    if char.Humanoid.Health < 0.1 then
                                            char.box.Enabled = false
                                    end
                            end

                            if char:FindFirstChild("VRHealth") then
                                    if char.VRHealth.Value < 0.1 then
                                            char.box.Enabled = false
                                    end
                            end
                    end
            end
    end
end

function plrnameesp()
    for _,v in pairs(players:GetChildren()) do
            local char = v.Character

            if char and v.Name ~= players.LocalPlayer.Name then
                    if not char:FindFirstChild("name") then
                            local box = Instance.new("BillboardGui",char)
                            box.Adornee = char

                            box.Name = "name"
                            box.Enabled = true
                            box.AlwaysOnTop = true
                            box.StudsOffset = Vector3.new(0,3,0)
                            box.Size = UDim2.new(0,200,0,20)

                            local text = Instance.new("TextLabel",box)
                            text.Size = UDim2.new(1,0,1,0)
                            text.BackgroundTransparency = 1
                            text.Font = Enum.Font.Oswald
                            text.TextSize = 12
                            text.TextColor3 = Color3.new(1,1,1)
                            text.Text = v.Name
                            text.TextStrokeTransparency = 0
                    else
                            char.name.Enabled = true

                            if char:FindFirstChild("Humanoid") then
                                    if char.Humanoid.Health < 0.1 then
                                            char.name.Enabled = false
                                    end
                            end

                            if char:FindFirstChild("VRHealth") then
                                    if char.VRHealth.Value < 0.1 then
                                            char.name.Enabled = false
                                    end
                            end
                    end
            end
    end
end

function itemnameesp()
    for _,v in pairs(workspace.Items:GetChildren()) do
            if not v:FindFirstChild("name") then
                    local box = Instance.new("BillboardGui",v)
                    box.Adornee = v

                    box.Name = "name"
                    box.Enabled = true
                    box.AlwaysOnTop = true
                    box.Size = UDim2.new(0,100,0,20)

                    local text = Instance.new("TextLabel",box)
                    text.Size = UDim2.new(1,0,1,0)
                    text.BackgroundTransparency = 1
                    text.Font = Enum.Font.Oswald
                    text.TextSize = 12
                    text.TextColor3 = Color3.new(1,0.15,0.3)
                    text.Text = v.Name
                    text.TextStrokeTransparency = 0
            else
                    v.name.Enabled = true
            end
    end
end

function aimright()
    if uis:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,Enum.KeyCode.ButtonA) then
            distance, position = math.huge,nil

            for _,v in pairs(players:GetChildren()) do
                    local char = v.Character

                    if char and v.Name ~= players.LocalPlayer.Name then
                            if char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and not char:FindFirstChild("ProtectionHighlight")  then
                                    local head = char.Head

                                    if (rarm.Position - head.Position).Magnitude < distance and char.Humanoid.Health > 0 then
                                            position = head.Position

                                            distance = (rarm.Position - head.Position).Magnitude
                                    end
                            end
                    end
            end

            if position then
                    rarm.CFrame = CFrame.new(rarm.Position,position) * CFrame.Angles(math.rad(90),0,0)
            end
    end
end

function aimleft()
    if uis:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,Enum.KeyCode.ButtonX) then
            distance, position = math.huge,nil

            for _,v in pairs(players:GetChildren()) do
                    local char = v.Character

                    if char and v.Name ~= players.LocalPlayer.Name then
                            if char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and not char:FindFirstChild("ProtectionHighlight") then
                                    local head = char.Head

                                    if (larm.Position - head.Position).Magnitude < distance and char.Humanoid.Health > 0 then
                                            position = head.Position

                                            distance = (larm.Position - head.Position).Magnitude
                                    end
                            end
                    end
            end

            if position then
                    larm.CFrame = CFrame.new(larm.Position,position) * CFrame.Angles(math.rad(90),0,0)
            end
    end
end

function lograv()
    local val = 0

    for _,v in pairs(menuranges) do
            if v[1] == "Gravity" then
                    val = v[2]
                    break
            end
    end

    workspace.Gravity = val
end

function jpack()
    if uis:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,Enum.KeyCode.ButtonX) then
            local mult = 50

            for _,v in pairs(menuranges) do
                    if v[1] == "Jetpack Speed" then
                            mult = v[2]
                            break
                    end
            end

            local jparm = player.Character:WaitForChild("Left Arm")

            local rotation = jparm.CFrame * CFrame.Angles(math.rad(-90),0,0)

            jpvel.Attachment0 = rootatt
            jpvel.VectorVelocity = rotation.LookVector * mult

            task.wait(0)

            jpvel.Attachment0 = nil
    end
end

function movementspeed()
    local speed = 50

    for _,v in pairs(menuranges) do
            if v[1] == "Movement Speed" then
                    speed = v[2]
                    break
            end
    end

    local rx,ry,rz = lchar.Head.CFrame:ToOrientation()

    root:ApplyImpulse(((CFrame.Angles(0,ry,0).LookVector*speed)*tspos.Y) + ((CFrame.Angles(0,ry,0).RightVector*speed)*tspos.X))
end

function llaser()
    llaserpart.Transparency = 0
end

function rlaser()
    rlaserpart.Transparency = 0
end

function bringallguns()
    local torso = lchar:WaitForChild("Torso")
    local warm = lchar:WaitForChild("Left Arm")

    for _,v in pairs(workspace.Items:GetChildren()) do
            local weld = Instance.new("Weld",torso)

            weld.Part0 = torso
            if v:FindFirstChild("Parts") then
                    warm.CFrame = v.Parts.Grip.CFrame

                    weld.Part1 = v.Parts.Grip
            end

            task.wait(0.01)

            weld:Destroy()
    end
end

function bringallsecretguns()
    local torso = lchar:WaitForChild("Torso")
    local warm = lchar:WaitForChild("Left Arm")

    for _,v in pairs(workspace.Items:GetChildren()) do
            if v.Name == "Balloon Gun" or v.Name == "Streamliner" or v.Name == "Flight Pistol" or v.Name == "Explosive Pistol" or v.Name == "Nuke Pistol" or v.Name == "Super Pistol" or v.Name == "Health Pistol" then
                    local weld = Instance.new("Weld",torso)

                    weld.Part0 = torso

                    if v:FindFirstChild("Parts") then
                            warm.CFrame = v.Parts.Grip.CFrame

                            weld.Part1 = v.Parts.Grip
                    end

                    task.wait(0.01)

                    weld:Destroy()
            end
    end
end

function tparmright()
    if uis:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,Enum.KeyCode.ButtonA) then

            distance, position = math.huge,nil

            for _,v in pairs(players:GetChildren()) do
                    local char = v.Character

                    if char and v.Name ~= players.LocalPlayer.Name then
                            if char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and not char:FindFirstChild("ProtectionHighlight") then
                                    local head = char.Head

                                    if (rarm.Position - head.Position).Magnitude < distance and char.Humanoid.Health > 0 then
                                            position = head.Position

                                            distance = (rarm.Position - head.Position).Magnitude
                                    end
                            end
                    end
            end

            if position then
                    local head = lchar.Head

                    head.CFrame = CFrame.new(position + Vector3.new(0,-1.5,0))
                    rarm.CFrame = CFrame.new(position + Vector3.new(-0.2,1.25,0),position+Vector3.new(-0.2,0,0)) * CFrame.Angles(math.rad(90),0,0)
            end
    end
end

function rasilent()
    if uis:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,Enum.KeyCode.ButtonR2) then
            local size = 10
            local thead = true
            local ttorso = false
            local randomization = true

            for _,v in pairs(menucranges) do
                    if v[1] == "Silent Aim FOV" then
                            size = v[2]
                            break
                    end
            end

            for _,v in pairs(menunftoggles) do
                    if v[2] == "Target Head" then
                            thead = v[1]
                    end

                    if v[2] == "Target Torso" then
                            ttorso = v[1]
                    end

                    if v[2] == "Aim Randomization" then
                            randomization = v[1]
                    end
            end

            rsafov.Size = Vector3.new(1000,size,size)

            distance, position = math.huge,nil

            for _,v in pairs(workspace:GetPartsInPart(rsafov)) do
                    if thead then
                            if v.Name == "Head" and v.Parent:IsA("Model") and v.Parent.Name ~= player.Name then
                                    local head = v
                                    local char = v.Parent

                                    if (rarm.Position - head.Position).Magnitude < distance and char.Humanoid.Health > 0 then
                                            position = head.Position

                                            local r1,r2,r3 = math.random(-30,30)/100,math.random(-30,30)/100,math.random(-30,30)/100

                                            if randomization then
                                                    position += (head.CFrame.RightVector * (r1 * head.Size.X/2)) + (head.CFrame.UpVector * (r2 * head.Size.Y/2)) + (head.CFrame.LookVector * (r3 * head.Size.Z/2))
                                            end

                                            distance = (rarm.Position - head.Position).Magnitude
                                    end
                            end
                    end

                    if ttorso then
                            if v.Name == "Torso" and v.Parent:IsA("Model") and v.Parent.Name ~= player.Name then
                                    local head = v
                                    local char = v.Parent

                                    if (rarm.Position - head.Position).Magnitude < distance and char.Humanoid.Health > 0 then
                                            position = head.Position

                                            local r1,r2,r3 = math.random(-30,30)/100,math.random(-30,30)/100,math.random(-30,30)/100

                                            if randomization then
                                                    position += (head.CFrame.RightVector * (r1 * head.Size.X/2)) + (head.CFrame.UpVector * (r2 * head.Size.Y/2)) + (head.CFrame.LookVector * (r3 * head.Size.Z/2))
                                            end

                                            distance = (rarm.Position - head.Position).Magnitude
                                    end
                            end
                    end
            end

            if position then
                    rarm.CFrame = CFrame.new(rarm.Position,position) * CFrame.Angles(math.rad(90),0,0)
            end
    end
end

function saperftest()
    if uis:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,Enum.KeyCode.ButtonR2) then
            local size = 10
            local randommult = 0.3
            local thead = true
            local ttorso = false
            local randomization = true

            for _,v in pairs(menucranges) do
                    if v[1] == "Silent Aim FOV" then
                            size = v[2]
                            break
                    end

                    if v[1] == "Randomization Multiplier" then
                            randommult = v[2]
                    end
            end

            for _,v in pairs(menunftoggles) do
                    if v[2] == "Target Head" then
                            thead = v[1]
                    end

                    if v[2] == "Target Torso" then
                            ttorso = v[1]
                    end

                    if v[2] == "Aim Randomization" then
                            randomization = v[1]
                    end
            end

            rsafov.Size = Vector3.new(1000,0.005,0.005)

            local p1 = (rsafov.CFrame.RightVector*(500-size/2))+rsafov.Position
            local p2 = (rsafov.CFrame.RightVector*(-500-size/2))+rsafov.Position

            local lcp = RaycastParams.new()
            lcp.FilterType = Enum.RaycastFilterType.Exclude

            lcp:AddToFilter(lchar)
            lcp:AddToFilter(rsafov)
            lcp:AddToFilter(lsafov)
            lcp:AddToFilter(rlaserpart)
            lcp:AddToFilter(llaserpart)

            local rcp = RaycastParams.new()
            rcp.FilterType = Enum.RaycastFilterType.Include

            for _,v in pairs(players:GetChildren()) do
                    if v.Character and v.Name ~= player.Name then
                            local char = v.Character
                            if char:FindFirstChild("Humanoid") then
                                    if char.Humanoid.Health > 0 then
                                            if thead then
                                                    if char:FindFirstChild("Head") then
                                                            rcp:AddToFilter(char.Head)
                                                    end
                                            end

                                            if ttorso then
                                                    if char:FindFirstChild("Torso") then
                                                            rcp:AddToFilter(char.Torso)
                                                    end
                                            end
                                    end
                            end
                    end
            end

            local dir = p2-p1

            local lengthc = workspace:Raycast(p1,dir,lcp)

            if lengthc then
                    dir = dir.Unit * lengthc.Distance
            end

            local sc = workspace:Spherecast(p1,size/2,dir,rcp)

            position = nil

            if sc then
                    position = sc.Instance.Position

                    if randomization then
                            local r1,r2,r3 = math.random(-randommult*100,randommult*100)/100,math.random(-randommult*100,randommult*100)/100,math.random(-randommult*100,randommult*100)/100

                            position += (sc.Instance.CFrame.RightVector * (r1 * sc.Instance.Size.X)) + (sc.Instance.CFrame.UpVector * (r2 * sc.Instance.Size.Y)) + (sc.Instance.CFrame.LookVector * (r3 * sc.Instance.Size.Z))
                    end

                    rarm.CFrame = CFrame.new(rarm.Position,position) * CFrame.Angles(math.rad(90),0,0)
            end
    end
end

function lasilent()
    if uis:IsGamepadButtonDown(Enum.UserInputType.Gamepad1,Enum.KeyCode.ButtonL2) then
            local size = 10
            local thead = true
            local ttorso = false
            local randomization = true

            for _,v in pairs(menucranges) do
                    if v[1] == "Silent Aim FOV" then
                            size = v[2]
                            break
                    end
            end

            for _,v in pairs(menunftoggles) do
                    if v[2] == "Target Head" then
                            thead = v[1]
                    end

                    if v[2] == "Target Torso" then
                            ttorso = v[1]
                    end

                    if v[2] == "Aim Randomization" then
                            randomization = v[1]
                    end
            end

            lsafov.Size = Vector3.new(1000,size,size)

            distance, position = math.huge,nil

            for _,v in pairs(workspace:GetPartsInPart(lsafov)) do
                    if thead then
                            if v.Name == "Head" and v.Parent:IsA("Model") and v.Parent.Name ~= player.Name then
                                    local head = v
                                    local char = v.Parent

                                    if (larm.Position - head.Position).Magnitude < distance and char.Humanoid.Health > 0 then
                                            position = head.Position

                                            local r1,r2,r3 = math.random(-30,30)/100,math.random(-30,30)/100,math.random(-30,30)/100

                                            if randomization then
                                                    position += (head.CFrame.RightVector * (r1 * head.Size.X/2)) + (head.CFrame.UpVector * (r2 * head.Size.Y/2)) + (head.CFrame.LookVector * (r3 * head.Size.Z/2))
                                            end

                                            distance = (larm.Position - head.Position).Magnitude
                                    end
                            end
                    end

                    if ttorso then
                            if v.Name == "Torso" and v.Parent:IsA("Model") and v.Parent.Name ~= player.Name then
                                    local head = v
                                    local char = v.Parent

                                    if (larm.Position - head.Position).Magnitude < distance and char.Humanoid.Health > 0 then
                                            position = head.Position

                                            local r1,r2,r3 = math.random(-30,30)/100,math.random(-30,30)/100,math.random(-30,30)/100

                                            if randomization then
                                                    position += (head.CFrame.RightVector * (r1 * head.Size.X/2)) + (head.CFrame.UpVector * (r2 * head.Size.Y/2)) + (head.CFrame.LookVector * (r3 * head.Size.Z/2))
                                            end

                                            distance = (larm.Position - head.Position).Magnitude
                                    end
                            end
                    end
            end

            if position then
                    larm.CFrame = CFrame.new(larm.Position,position) * CFrame.Angles(math.rad(90),0,0)
            end
    end
end

function fullbright()
    lighting.FogEnd = 999999
    lighting.FogStart = 0
    lighting.ClockTime = 14
    lighting.Brightness = 2
    lighting.GlobalShadows = false
    if lighting:FindFirstChild("Atmosphere") then
            lighting.Atmosphere.Density = 0
    end
end

function strength()
    local pos = 750
    local rot = 750

    for _,v in pairs(menucranges) do
            if v[1] == "Positional Strength" then
                    pos = v[2]
                    break
            end

            if v[1] == "Rotational Strength" then
                    rot = v[2]
                    break
            end
    end

    larm.AlignPosition.MaxForce = pos
    larm.AlignOrientation.MaxTorque = rot
    rarm.AlignPosition.MaxForce = pos
    rarm.AlignOrientation.MaxTorque = rot
end

-- menu setup

local objcount = 0
local togglecount = 1
local nftogglecount = 1
local rangecount = 1
local crangecount = 1
local colorcount = 1

local menuOp = {
    {"Combat",
            {
                    {"Laser","spacer"},
                    {"Right Hand Laser","toggle",rlaser},
                    {"Left Hand Laser","toggle",llaser},

                    {"Silent Aim","spacer"},
                    {"Right Arm Silent Aim","toggle",rasilent},
                    {"Left Arm Silent Aim","toggle",lasilent},
                    {"Silent Aim (Performant)","toggle",saperftest},

                    {"Silent Aim Options","spacer"},
                    {"Target Head","nftoggle",true},
                    {"Target Torso","nftoggle",false},
                    {"Silent Aim FOV","crange",10,1,1,40},
                    {"Aim Randomization","nftoggle",false},
                    {"Randomization Multiplier","crange",1,0.1,0.1,1},

                    {"Regular Aimbot","spacer"},
                    {"Right Hand Aimbot (A)","toggle",aimright},
                    {"Left Hand Aimbot (X)","toggle",aimleft},

                    {"Blatant","spacer"},
                    {"Arm Kill All (A)","toggle",tparmright},
            }
    },

    {"Movement",
            {
                    {"Override Gravity","toggle",lograv},
                    {"Jetpack (X)","toggle",jpack},
                    {"Override Speed","toggle",movementspeed},

                    {"Movement Options","spacer"},
                    {"Gravity","range",16,2},
                    {"Jetpack Speed","range",50,5},
                    {"Movement Speed","range",15,5},
            }
    },

    {"Rendering",
            {
                    {"Player ESP","spacer"},
                    {"Player Chams (Occluded)","toggle",plroccchamsesp},
                    {"Player Chams","toggle",plrchamsesp},
                    {"Player Boxes","toggle",plrboxesp},
                    {"Player Names","toggle",plrnameesp},

                    {"Player ESP Options","spacer"},
                    {"Player Outline Opacity","crange",0,0.1,0,1},
                    {"Player Fill Opacity","crange",0.5,0.1,0,1},
                    {"Player Outline Color","color",0,0,1},
                    {"Player Fill Color","color",0,0,1},

                    {"Item ESP","spacer"},
                    {"Item Names","toggle",itemnameesp},

                    {"Other","spacer"},
                    {"Fullbright","toggle",fullbright},
            }
    },

    {"Miscellaneous",
            {
                    {"Override Strength","toggle",strength},
                    {"Positional Strength","crange",750,50,0,7500},
                    {"Rotational Strength","crange",750,50,0,7500},
                    {"Bring All Guns (Buggy)","button",bringallguns},
                    {"Bring All Secret Guns","button",bringallsecretguns},
            }
    },
}

local pressed = false

function togglehandler(togglenum, toggle)
    menutoggles[togglenum][1] = not menutoggles[togglenum][1]

    if menutoggles[togglenum][1] then
            toggle.BackgroundColor3 = Color3.new(1,1,1)
    else
            toggle.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
    end
end

function nftogglehandler(togglenum, toggle)
    menunftoggles[togglenum][1] = not menunftoggles[togglenum][1]

    if menunftoggles[togglenum][1] then
            toggle.BackgroundColor3 = Color3.new(1,1,1)
    else
            toggle.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
    end
end

function rangehandler(rangenum, amount)
    menuranges[rangenum][2] += amount
end

function crangehandler(rangenum, amount, min, max)
    menucranges[rangenum][2] += amount
    if menucranges[rangenum][2] > max then
            menucranges[rangenum][2] = max
    end

    if menucranges[rangenum][2] < min then
            menucranges[rangenum][2] = min
    end
end

function colorhandler(colornum, value, amount)
    menucolors[colornum][value+1] += amount

    if math.round(menucolors[colornum][value+1]) > 1 then
            menucolors[colornum][value+1] = 0
    end

    if math.round(menucolors[colornum][value+1]) < 0 then
            menucolors[colornum][value+1] = 1
    end

    menucolors[colornum][5] = Color3.fromHSV(menucolors[colornum][2],menucolors[colornum][3],menucolors[colornum][4])
end

function resolvesectops(optable)
    for i,op in ipairs(optable) do
            local menuopbg = Instance.new("Frame",menuscr)
            menuopbg.Name = objcount

            menuopbg.Size = UDim2.new(0.9,-15,0,40)
            menuopbg.BackgroundColor3 = Color3.new(0.15,0.15,0.15)
            menuopbg.AnchorPoint = Vector2.new(0.5,0)

            local msuig = Instance.new("UIGradient",menuopbg)
            msuig.Rotation = 90
            msuig.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
                    ColorSequenceKeypoint.new(1,Color3.new(0.8,0.8,0.8))
            })

            local msuic = Instance.new("UICorner",menuopbg)
            msuic.CornerRadius = UDim.new(0,15)

            local menuop = Instance.new("TextLabel",menuopbg)
            menuop.Size = UDim2.new(1,-45,1,0)
            menuop.BackgroundTransparency = 1

            menuop.TextXAlignment = Enum.TextXAlignment.Left
            menuop.TextSize = 24
            menuop.Font = Enum.Font.Oswald
            menuop.Text = "  "..op[1]

            menuop.TextColor3 = Color3.new(1,1,1)

            local configvalue = nil

            -- types
            if op[2] == "spacer" then
                    menuopbg.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
                    menuopbg.Size = UDim2.new(0.9,0,0,30)
            end

            if op[2] == "toggle" then
                    for _,cv in pairs(_G.OMConfig) do
                            if cv[1] == op[1] then
                                    configvalue = cv[2]
                                    break
                            end
                    end

                    local toggle = Instance.new("TextButton",menuopbg)
                    toggle.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
                    if configvalue == true then
                            toggle.BackgroundColor3 = Color3.new(1,1,1)
                    end

                    toggle.AnchorPoint = Vector2.new(1,0.5)
                    toggle.Position = UDim2.new(1,-5,0.5,0)
                    toggle.Size = UDim2.new(0,35,0,35)

                    toggle.Text = ""

                    local tuic = Instance.new("UICorner",toggle)
                    tuic.CornerRadius = UDim.new(0,15)

                    local tuig = Instance.new("UIGradient",toggle)
                    tuig.Rotation = 90
                    tuig.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
                            ColorSequenceKeypoint.new(1,Color3.new(0.8,0.8,0.8))
                    })

                    if configvalue == nil then
                            table.insert(menutoggles,{false,op[3]})
                    else
                            table.insert(menutoggles,{configvalue,op[3]})
                    end

                    local temp = togglecount

                    toggle.MouseButton1Down:Connect(function()
                            if not pressed then
                                    togglehandler(temp,toggle)
                                    pressed = true
                            end
                    end)

                    togglecount += 1
            end

            if op[2] == "nftoggle" then
                    for _,cv in pairs(_G.OMConfig) do
                            if cv[1] == op[1] then
                                    configvalue = cv[2]
                                    break
                            end
                    end

                    local toggle = Instance.new("TextButton",menuopbg)
                    toggle.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
                    if op[3] or configvalue == true then
                            toggle.BackgroundColor3 = Color3.new(1,1,1)
                    end

                    toggle.AnchorPoint = Vector2.new(1,0.5)
                    toggle.Position = UDim2.new(1,-5,0.5,0)
                    toggle.Size = UDim2.new(0,35,0,35)

                    toggle.Text = ""

                    local tuic = Instance.new("UICorner",toggle)
                    tuic.CornerRadius = UDim.new(0,15)

                    local tuig = Instance.new("UIGradient",toggle)
                    tuig.Rotation = 90
                    tuig.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
                            ColorSequenceKeypoint.new(1,Color3.new(0.8,0.8,0.8))
                    })

                    if configvalue == nil then
                            table.insert(menunftoggles,{op[3],op[1]})
                    else
                            table.insert(menunftoggles,{configvalue,op[1]})
                    end

                    local temp = nftogglecount

                    toggle.MouseButton1Down:Connect(function()
                            if not pressed then
                                    nftogglehandler(temp,toggle)
                                    pressed = true
                            end
                    end)

                    nftogglecount += 1
            end

            if op[2] == "button" then
                    local toggle = Instance.new("TextButton",menuopbg)
                    toggle.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    toggle.AnchorPoint = Vector2.new(1,0.5)
                    toggle.Position = UDim2.new(1,-5,0.5,0)
                    toggle.Size = UDim2.new(0,35,0,35)

                    toggle.Text = "Press"
                    toggle.TextColor3 = Color3.new(1,1,1)
                    toggle.Font = Enum.Font.Oswald
                    toggle.TextScaled = true

                    local tuic = Instance.new("UICorner",toggle)
                    tuic.CornerRadius = UDim.new(0,15)

                    local temp = op[3]

                    toggle.MouseButton1Down:Connect(function()
                            if not pressed then
                                    temp()
                                    pressed = true
                            end
                    end)
            end

            if op[2] == "range" then
                    for _,cv in pairs(_G.OMConfig) do
                            if cv[1] == op[1] then
                                    configvalue = cv[2]
                                    break
                            end
                    end

                    local text = Instance.new("TextLabel",menuopbg)
                    text.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    text.AnchorPoint = Vector2.new(1,1)
                    text.Position = UDim2.new(1,-5,0.5,-2.5)
                    text.Size = UDim2.new(0,35,0,15)
                    text.TextScaled = true

                    text.Text = op[3]
                    text.TextColor3 = Color3.new(1,1,1)
                    text.Font = Enum.Font.Oswald

                    local minus = Instance.new("TextButton",menuopbg)
                    minus.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    minus.AnchorPoint = Vector2.new(1,1)
                    minus.Position = UDim2.new(1,-25,1,-2.5)
                    minus.Size = UDim2.new(0,15,0,15)
                    minus.TextScaled = true

                    minus.Text = "<"
                    minus.TextColor3 = Color3.new(1,1,1)
                    minus.Font = Enum.Font.Oswald

                    local plus = Instance.new("TextButton",menuopbg)
                    plus.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    plus.AnchorPoint = Vector2.new(1,1)
                    plus.Position = UDim2.new(1,-5,1,-2.5)
                    plus.Size = UDim2.new(0,15,0,15)
                    plus.TextScaled = true

                    plus.Text = ">"
                    plus.TextColor3 = Color3.new(1,1,1)
                    plus.Font = Enum.Font.Oswald

                    local tuic = Instance.new("UICorner",text)
                    tuic.CornerRadius = UDim.new(0,15)

                    local muic = Instance.new("UICorner",minus)
                    muic.CornerRadius = UDim.new(0,15)

                    local puic = Instance.new("UICorner",plus)
                    puic.CornerRadius = UDim.new(0,15)

                    if configvalue == nil then
                            table.insert(menuranges,{op[1],op[3]})
                    else
                            table.insert(menuranges,{op[1],configvalue})
                            text.Text = configvalue
                    end

                    local temp = rangecount
                    local temp2 = op[4]

                    minus.MouseButton1Down:Connect(function()
                            if not pressed then
                                    rangehandler(temp, -temp2)

                                    text.Text = math.round(menuranges[temp][2]*10)/10

                                    pressed = true
                            end
                    end)

                    plus.MouseButton1Down:Connect(function()
                            if not pressed then
                                    rangehandler(temp, temp2)

                                    text.Text = math.round(menuranges[temp][2]*10)/10

                                    pressed = true
                            end
                    end)

                    rangecount += 1
            end

            if op[2] == "crange" then
                    for _,cv in pairs(_G.OMConfig) do
                            if cv[1] == op[1] then
                                    configvalue = cv[2]
                                    break
                            end
                    end

                    local text = Instance.new("TextLabel",menuopbg)
                    text.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    text.AnchorPoint = Vector2.new(1,1)
                    text.Position = UDim2.new(1,-5,0.5,-2.5)
                    text.Size = UDim2.new(0,35,0,15)
                    text.TextScaled = true

                    text.Text = op[3]
                    text.TextColor3 = Color3.new(1,1,1)
                    text.Font = Enum.Font.Oswald

                    local minus = Instance.new("TextButton",menuopbg)
                    minus.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    minus.AnchorPoint = Vector2.new(1,1)
                    minus.Position = UDim2.new(1,-25,1,-2.5)
                    minus.Size = UDim2.new(0,15,0,15)
                    minus.TextScaled = true

                    minus.Text = "<"
                    minus.TextColor3 = Color3.new(1,1,1)
                    minus.Font = Enum.Font.Oswald

                    local plus = Instance.new("TextButton",menuopbg)
                    plus.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    plus.AnchorPoint = Vector2.new(1,1)
                    plus.Position = UDim2.new(1,-5,1,-2.5)
                    plus.Size = UDim2.new(0,15,0,15)
                    plus.TextScaled = true

                    plus.Text = ">"
                    plus.TextColor3 = Color3.new(1,1,1)
                    plus.Font = Enum.Font.Oswald

                    local tuic = Instance.new("UICorner",text)
                    tuic.CornerRadius = UDim.new(0,15)

                    local muic = Instance.new("UICorner",minus)
                    muic.CornerRadius = UDim.new(0,15)

                    local puic = Instance.new("UICorner",plus)
                    puic.CornerRadius = UDim.new(0,15)

                    if configvalue == nil then
                            table.insert(menucranges,{op[1],op[3]})
                    else
                            table.insert(menucranges,{op[1],configvalue})
                            text.Text = configvalue
                    end

                    local temp = crangecount
                    local temp2 = op[4]

                    local min = op[5]
                    local max = op[6]

                    minus.MouseButton1Down:Connect(function()
                            if not pressed then
                                    crangehandler(temp, -temp2, min, max)

                                    text.Text = math.round(menucranges[temp][2]*10)/10

                                    pressed = true
                            end
                    end)

                    plus.MouseButton1Down:Connect(function()
                            if not pressed then
                                    crangehandler(temp, temp2, min, max)

                                    text.Text = math.round(menucranges[temp][2]*10)/10

                                    pressed = true
                            end
                    end)

                    crangecount += 1
            end

            if op[2] == "color" then
                    menuopbg.Size = UDim2.new(0.9,-15,0,160)
                    menuop.Size = UDim2.new(1,-45,0.25,0)

                    local huelabel = Instance.new("TextLabel",menuopbg)

                    huelabel.Position = UDim2.new(0,0,0.25,0)

                    huelabel.Size = UDim2.new(1,-45,0.25,0)
                    huelabel.BackgroundTransparency = 1

                    huelabel.TextXAlignment = Enum.TextXAlignment.Left
                    huelabel.TextSize = 24
                    huelabel.Font = Enum.Font.Oswald
                    huelabel.Text = "  Hue"

                    huelabel.TextColor3 = Color3.new(1,1,1)

                    local satlabel = Instance.new("TextLabel",menuopbg)

                    satlabel.Position = UDim2.new(0,0,0.5,0)

                    satlabel.Size = UDim2.new(1,-45,0.25,0)
                    satlabel.BackgroundTransparency = 1

                    satlabel.TextXAlignment = Enum.TextXAlignment.Left
                    satlabel.TextSize = 24
                    satlabel.Font = Enum.Font.Oswald
                    satlabel.Text = "  Satuation"

                    satlabel.TextColor3 = Color3.new(1,1,1)

                    local vallabel = Instance.new("TextLabel",menuopbg)

                    vallabel.Position = UDim2.new(0,0,0.75,0)

                    vallabel.Size = UDim2.new(1,-45,0.25,0)
                    vallabel.BackgroundTransparency = 1

                    vallabel.TextXAlignment = Enum.TextXAlignment.Left
                    vallabel.TextSize = 24
                    vallabel.Font = Enum.Font.Oswald
                    vallabel.Text = "  Value"

                    vallabel.TextColor3 = Color3.new(1,1,1)

                    local colorframe = Instance.new("Frame",menuopbg)

                    colorframe.AnchorPoint = Vector2.new(1,0)
                    colorframe.Position = UDim2.new(1,-5,0,5)
                    colorframe.Size = UDim2.new(0,35,0,35)

                    colorframe.BackgroundColor3 = Color3.fromHSV(op[3],op[4],op[5])

                    local cuic = Instance.new("UICorner",colorframe)
                    cuic.CornerRadius = UDim.new(0,15)

                    local cuig = Instance.new("UIGradient",colorframe)
                    cuig.Rotation = 90
                    cuig.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
                            ColorSequenceKeypoint.new(1,Color3.new(0.8,0.8,0.8))
                    })

                    local text1 = Instance.new("TextLabel",menuopbg)
                    text1.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    text1.AnchorPoint = Vector2.new(1,0)
                    text1.Position = UDim2.new(1,-5,0.25,2.5)
                    text1.Size = UDim2.new(0,35,0,15)
                    text1.TextScaled = true

                    text1.Text = op[3]
                    text1.TextColor3 = Color3.new(1,1,1)
                    text1.Font = Enum.Font.Oswald

                    local minus1 = Instance.new("TextButton",menuopbg)
                    minus1.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    minus1.AnchorPoint = Vector2.new(1,0)
                    minus1.Position = UDim2.new(1,-25,0.25,20)
                    minus1.Size = UDim2.new(0,15,0,15)
                    minus1.TextScaled = true

                    minus1.Text = "<"
                    minus1.TextColor3 = Color3.new(1,1,1)
                    minus1.Font = Enum.Font.Oswald

                    local plus1 = Instance.new("TextButton",menuopbg)
                    plus1.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    plus1.AnchorPoint = Vector2.new(1,0)
                    plus1.Position = UDim2.new(1,-5,0.25,20)
                    plus1.Size = UDim2.new(0,15,0,15)
                    plus1.TextScaled = true

                    plus1.Text = ">"
                    plus1.TextColor3 = Color3.new(1,1,1)
                    plus1.Font = Enum.Font.Oswald

                    local tuic = Instance.new("UICorner",text1)
                    tuic.CornerRadius = UDim.new(0,15)

                    local muic = Instance.new("UICorner",minus1)
                    muic.CornerRadius = UDim.new(0,15)

                    local puic = Instance.new("UICorner",plus1)
                    puic.CornerRadius = UDim.new(0,15)

                    local text2 = Instance.new("TextLabel",menuopbg)
                    text2.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    text2.AnchorPoint = Vector2.new(1,0)
                    text2.Position = UDim2.new(1,-5,0.5,2.5)
                    text2.Size = UDim2.new(0,35,0,15)
                    text2.TextScaled = true

                    text2.Text = op[4]
                    text2.TextColor3 = Color3.new(1,1,1)
                    text2.Font = Enum.Font.Oswald

                    local minus2 = Instance.new("TextButton",menuopbg)
                    minus2.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    minus2.AnchorPoint = Vector2.new(1,0)
                    minus2.Position = UDim2.new(1,-25,0.5,20)
                    minus2.Size = UDim2.new(0,15,0,15)
                    minus2.TextScaled = true

                    minus2.Text = "<"
                    minus2.TextColor3 = Color3.new(1,1,1)
                    minus2.Font = Enum.Font.Oswald

                    local plus2 = Instance.new("TextButton",menuopbg)
                    plus2.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    plus2.AnchorPoint = Vector2.new(1,0)
                    plus2.Position = UDim2.new(1,-5,0.5,20)
                    plus2.Size = UDim2.new(0,15,0,15)
                    plus2.TextScaled = true

                    plus2.Text = ">"
                    plus2.TextColor3 = Color3.new(1,1,1)
                    plus2.Font = Enum.Font.Oswald

                    local tuic = Instance.new("UICorner",text2)
                    tuic.CornerRadius = UDim.new(0,15)

                    local muic = Instance.new("UICorner",minus2)
                    muic.CornerRadius = UDim.new(0,15)

                    local puic = Instance.new("UICorner",plus2)
                    puic.CornerRadius = UDim.new(0,15)

                    local text3 = Instance.new("TextLabel",menuopbg)
                    text3.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    text3.AnchorPoint = Vector2.new(1,0)
                    text3.Position = UDim2.new(1,-5,0.75,2.5)
                    text3.Size = UDim2.new(0,35,0,15)
                    text3.TextScaled = true

                    text3.Text = op[5]
                    text3.TextColor3 = Color3.new(1,1,1)
                    text3.Font = Enum.Font.Oswald

                    local minus3 = Instance.new("TextButton",menuopbg)
                    minus3.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    minus3.AnchorPoint = Vector2.new(1,0)
                    minus3.Position = UDim2.new(1,-25,0.75,20)
                    minus3.Size = UDim2.new(0,15,0,15)
                    minus3.TextScaled = true

                    minus3.Text = "<"
                    minus3.TextColor3 = Color3.new(1,1,1)
                    minus3.Font = Enum.Font.Oswald

                    local plus3 = Instance.new("TextButton",menuopbg)
                    plus3.BackgroundColor3 = Color3.new(0.1,0.1,0.1)

                    plus3.AnchorPoint = Vector2.new(1,0)
                    plus3.Position = UDim2.new(1,-5,0.75,20)
                    plus3.Size = UDim2.new(0,15,0,15)
                    plus3.TextScaled = true

                    plus3.Text = ">"
                    plus3.TextColor3 = Color3.new(1,1,1)
                    plus3.Font = Enum.Font.Oswald

                    local tuic = Instance.new("UICorner",text3)
                    tuic.CornerRadius = UDim.new(0,15)

                    local muic = Instance.new("UICorner",minus3)
                    muic.CornerRadius = UDim.new(0,15)

                    local puic = Instance.new("UICorner",plus3)
                    puic.CornerRadius = UDim.new(0,15)

                    table.insert(menucolors,{op[1],op[3],op[4],op[5],Color3.fromHSV(op[3],op[4],op[5])})

                    local temp = colorcount

                    minus1.MouseButton1Down:Connect(function()
                            if not pressed then
                                    colorhandler(temp, 1, -0.05)

                                    text1.Text = math.round(menucolors[temp][2]*100)/100
                                    colorframe.BackgroundColor3 = menucolors[temp][5]

                                    pressed = true
                            end
                    end)

                    plus1.MouseButton1Down:Connect(function()
                            if not pressed then
                                    colorhandler(temp, 1, 0.05)

                                    text1.Text = math.round(menucolors[temp][2]*100)/100
                                    colorframe.BackgroundColor3 = menucolors[temp][5]

                                    pressed = true
                            end
                    end)

                    minus2.MouseButton1Down:Connect(function()
                            if not pressed then
                                    colorhandler(temp, 2, -0.05)

                                    text2.Text = math.round(menucolors[temp][3]*100)/100
                                    colorframe.BackgroundColor3 = menucolors[temp][5]

                                    pressed = true
                            end
                    end)

                    plus2.MouseButton1Down:Connect(function()
                            if not pressed then
                                    colorhandler(temp, 2, 0.05)

                                    text2.Text = math.round(menucolors[temp][3]*100)/100
                                    colorframe.BackgroundColor3 = menucolors[temp][5]

                                    pressed = true
                            end
                    end)

                    minus3.MouseButton1Down:Connect(function()
                            if not pressed then
                                    colorhandler(temp, 3, -0.05)

                                    text3.Text = math.round(menucolors[temp][4]*100)/100
                                    colorframe.BackgroundColor3 = menucolors[temp][5]

                                    pressed = true
                            end
                    end)

                    plus3.MouseButton1Down:Connect(function()
                            if not pressed then
                                    colorhandler(temp, 3, 0.05)

                                    text3.Text = math.round(menucolors[temp][4]*100)/100
                                    colorframe.BackgroundColor3 = menucolors[temp][5]

                                    pressed = true
                            end
                    end)

                    colorcount += 1
            end

            -- insert obj
            objcount += 1
    end
end

for i,sect in ipairs(menuOp) do
    local menusect = Instance.new("TextLabel",menuscr)
    menusect.Name = objcount

    menusect.TextXAlignment = Enum.TextXAlignment.Center
    menusect.TextScaled = true
    menusect.Font = Enum.Font.Oswald
    menusect.Text = "  "..sect[1]

    menusect.TextColor3 = Color3.new(1,1,1)

    menusect.Size = UDim2.new(1,-15,0,37.5)
    menusect.BackgroundColor3 = Color3.new(0.2,0.2,0.2)

    local msuic = Instance.new("UICorner",menusect)
    msuic.CornerRadius = UDim.new(0,15)

    local msuig = Instance.new("UIGradient",menusect)
    msuig.Rotation = 90
    msuig.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(1,Color3.new(0.8,0.8,0.8))
    })

    -- insert obj
    objcount += 1

    resolvesectops(sect[2])
end

-- framehandler
function refreshesp()
    for _,v in pairs(players:GetChildren()) do
            local char = v.Character

            if char then
                    if char:FindFirstChild("hl") then
                            char.hl.Enabled = false
                    end

                    if char:FindFirstChild("box") then
                            char.box.Enabled = false
                    end

                    if char:FindFirstChild("name") then
                            char.name.Enabled = false
                    end
            end
    end

    for _,v in pairs(workspace.Items:GetChildren()) do
            if v:FindFirstChild("hl") then
                    v.hl.Enabled = false
            end

            if v:FindFirstChild("name") then
                    v.name.Enabled = false
            end
    end
end


function checktogglestatus()
    for i,stat in ipairs(menutoggles) do
            if stat[1] then
                    stat[2]()
            end
    end
end

showguiobj.MouseButton1Down:Connect(function()
    if not pressed then
            showgui = not showgui
            pressed = true
    end
end)

uis.InputChanged:Connect(function(input: InputObject)
    if input.KeyCode == Enum.KeyCode.Thumbstick1 then
            tspos = Vector2.new(input.Position.X,input.Position.Y)
    end
end)

uis.InputEnded:Connect(function(input: InputObject)
    if input.KeyCode == Enum.KeyCode.ButtonR2 then
            pressed = false
    end

    if input.KeyCode == Enum.KeyCode.Thumbstick1 then
            tspos = Vector2.new(0,0)
    end
end)

task.spawn(function()
    runs.Heartbeat:Connect(function()
            -- gui

            if showgui then
                    menuGUI.Enabled = true
            else
                    menuGUI.Enabled = false
            end

            bguisg.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,Color3.fromHSV(fc,0.8,1)),
                    ColorSequenceKeypoint.new(.1,Color3.fromHSV((fc+.1)%1,0.8,1)),
                    ColorSequenceKeypoint.new(.2,Color3.fromHSV((fc+.2)%1,0.8,1)),
                    ColorSequenceKeypoint.new(.3,Color3.fromHSV((fc+.3)%1,0.8,1)),
                    ColorSequenceKeypoint.new(.4,Color3.fromHSV((fc+.4)%1,0.8,1)),
                    ColorSequenceKeypoint.new(.5,Color3.fromHSV((fc+.5)%1,0.8,1)),
                    ColorSequenceKeypoint.new(.6,Color3.fromHSV((fc+.6)%1,0.8,1)),
                    ColorSequenceKeypoint.new(.7,Color3.fromHSV((fc+.7)%1,0.8,1)),
                    ColorSequenceKeypoint.new(.8,Color3.fromHSV((fc+.8)%1,0.8,1)),
                    ColorSequenceKeypoint.new(.9,Color3.fromHSV((fc+.9)%1,0.8,1)),
                    ColorSequenceKeypoint.new(1,Color3.fromHSV(fc,0.8,1)),
            })

            -- other
            fc += 0.005
            fc %= 1

            refresh += 1
            if refresh == 60 then
                    refresh = 0
                    refreshesp()

                    llaserpart.Transparency = 1
                    rlaserpart.Transparency = 1
            end

            workspace.Gravity = 32

            checktogglestatus()
    end)
end)
