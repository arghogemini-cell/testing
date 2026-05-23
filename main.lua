local config = getgenv().RayVinzConfig
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local KnitServices = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")["sleitnick_knit@1.7.0"].knit.Services
local TimerService = KnitServices.TimerService.RF
local EggService = KnitServices.EggService.RF
local SettingsService = KnitServices.SettingsService.RE
local PickupRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("pickupRequest")
local function tableContains(tbl, value)
    if #tbl == 0 or (tbl[1] == "" and #tbl == 1) then return true end
    for _, v in pairs(tbl) do
        if v == value or (v == "" and (value == "Normal" or value == "None")) then return true end
    end
    return false
end
local function sendLog(petName, size, mutation)
    if config.webhook and config.webhook ~= "" then
        pcall(function()
            local requestFunc = syn and syn.request or http_request or request or (http and http.request)
            if not requestFunc then return end
            requestFunc({
                Url = config.webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    ["username"] = "RayVinzHub Tracker",
                    ["embeds"] = {{
                        ["title"] = "🎉 Target Pet Obtained!",
                        ["description"] = "Player: **"..lp.Name.."**\nPet: **"..petName.."**\nSize: **"..size.."**\nMutation: **"..mutation.."**",
                        ["color"] = 65280,
                        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                    }}
                })
            })
        end)
    end
end
local function getMyPen()
    for _, pen in pairs(workspace.PlayerPens:GetChildren()) do
        if pen:GetAttribute("Owner") == lp.Name then return pen end
    end
    return nil
end
local playerPen = getMyPen()
if not playerPen then return warn("❌ Pen not found") end
local existingPetUIDs = {}
for _, pet in pairs(playerPen.Pets:GetChildren()) do existingPetUIDs[pet.Name] = true end
local eggs = playerPen.Eggs:GetChildren()
if #eggs == 0 then return warn("❌ No eggs found") end

local eggPos = eggs[1].Root.Position
local targetFound = false
local newPetObj = nil

for _, targetEgg in pairs(eggs) do
    print("🥚 Hatching: "..targetEgg.Name)

    TimerService.RequestEggHatch:InvokeServer(targetEgg.Name)
    task.wait(2)

    for _, petObj in pairs(playerPen.Pets:GetChildren()) do
        if not existingPetUIDs[petObj.Name] then
            local nameAttr = petObj:GetAttribute("Name") or ""
            local sizeAttr = petObj:GetAttribute("SizeName") or "Normal" 
            local mutAttr = petObj:GetAttribute("Mutation") or "None"    

            print("🔍 Detected: "..tostring(nameAttr).." | "..tostring(sizeAttr).." | "..tostring(mutAttr))

            if tableContains(config.pet, nameAttr) and 
               tableContains(config.size, sizeAttr) and 
               tableContains(config.mutation, mutAttr) then
                targetFound = true
                newPetObj = petObj
                break
            end

            existingPetUIDs[petObj.Name] = true
        end
    end

    if targetFound then break end
end
    if not existingPetUIDs[petObj.Name] then
        local nameAttr = petObj:GetAttribute("Name") or ""
        local sizeAttr = petObj:GetAttribute("SizeName") or "Normal" 
        local mutAttr = petObj:GetAttribute("Mutation") or "None"    
        print("🔍 Detected: "..tostring(nameAttr).." | "..tostring(sizeAttr).." | "..tostring(mutAttr))
        if tableContains(config.pet, nameAttr) and 
           tableContains(config.size, sizeAttr) and 
           tableContains(config.mutation, mutAttr) then
            targetFound = true
            newPetObj = petObj
            break
        end
    end
end
if targetFound then
    print("✅ Success! Picking up & Replacing...")
    pcall(function() PickupRemote:InvokeServer("Pet", newPetObj.Name, playerPen.Pets) end)
    sendLog(newPetObj:GetAttribute("Name"), newPetObj:GetAttribute("SizeName") or "Normal", newPetObj:GetAttribute("Mutation") or "None")

    local foundEggInBackpack = nil
    for _, item in pairs(lp.Backpack:GetChildren()) do
        if item:FindFirstChild("eggID") then foundEggInBackpack = item break end
    end

    if foundEggInBackpack then
        local character = lp.Character or lp.CharacterAdded:Wait()
        character.Humanoid:EquipTool(foundEggInBackpack) 
        task.wait(0.5)
        pcall(function() EggService.placeRequest:InvokeServer(foundEggInBackpack, eggPos, 0) end)
    end
    
    task.wait(2)
    if #Players:GetPlayers() <= 5 then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
else
    print("⚠️ Initiating Rollback...")
    SettingsService.UpdateSetting:FireServer("musicEnabled", "\255\127\u{d800}\0")
    task.wait(1)
        if #Players:GetPlayers() <= 5 then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end
