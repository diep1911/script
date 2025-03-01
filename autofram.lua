getgenv().Team = "Pirates"
getgenv().AutoLoad = false -- Will Load Script On Server Hop

getgenv().CheckItems = true
getgenv().AutoHop = true
getgenv().AntiBan = true

local function hasItem(itemName)
    local player = game.Players.LocalPlayer
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
    for _, item in pairs(player.Character:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
    return false
end

local function serverHop()
    wait(math.random(3, 7)) -- Thêm delay ngẫu nhiên để tránh bị phát hiện spam
    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    TeleportService:Teleport(placeId)
end

local function findAndFightBoss(bossName)
    for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
        if enemy.Name == bossName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            repeat
                wait(math.random(1, 3) / 10) -- Thêm delay ngẫu nhiên để tránh spam
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    wait(math.random(1, 2)) -- Delay sau mỗi đòn đánh
                end
            until enemy.Humanoid.Health <= 0
            return true
        end
    end
    return false
end

local function antiBan()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end

local function checkAndFarm()
    if not hasItem("Mirror Fractal") then
        print("Chưa có Mirror Fractal, tìm Dough King...")
        if not findAndFightBoss("Dough King") then
            print("Không tìm thấy Dough King, đổi server...")
            serverHop()
        end
    elseif not hasItem("Valkyrie Helm") then
        print("Chưa có Valkyrie Helm, tìm Rip Indra...")
        if not findAndFightBoss("rip_indra") then
            print("Không tìm thấy Rip Indra, đổi server...")
            serverHop()
        end
    else
        print("Đã có đủ item, không cần farm nữa!")
    end
end

if getgenv().AntiBan then
    spawn(antiBan)
end

if getgenv().CheckItems then
    checkAndFarm()
end
