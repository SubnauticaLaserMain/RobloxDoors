shared.VapeIndependent = true
shared.CustomSaveVape = "name of file to save"
local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))()


local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local StarterGui = game:GetService('StarterGui')
local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')


local Combat = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api
local Blatant = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api
local Render = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api
local Utility = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api
local World = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api


function getEventsFolder()
    return ReplicatedStorage:WaitForChild('Events', 60);
end

function callForToolCollect()
    local Events = getEventsFolder();


    if Events then
        local Collect = Events:WaitForChild('ToolCollect', 60);

        if (Collect and typeof(Collect) == 'Instance' and Collect.ClassName == 'RemoteEvent') then
            Collect:FireServer()
        end
    end
end


local CallForToolLoopBool = false;
function ToggleCallForToolLoop()
    CallForToolLoopBool = not CallForToolLoopBool


    if CallForToolLoopBool == true then
        repeat
            task.wait(0.5)
            callForToolCollect()
        until (not CallForToolLoopBool)
    end
end

function getFlowerPads()
    
end


local AutoToolCollect = Utility.CreateOptionsButton({
    Name = 'AutoToolCollect',
    Function = function(callback)
        ToggleCallForToolLoop();
    end
})



local tableFlowerFeilds = {
    ['TopFlowerFeild'] = 'CloverFieldFloor',
}

function addESPForFlowerFields(fillColor, outlineColor, fillTransparency, outlineTransparency, enumDepthMode)
    local GroundFlower = game:GetService("Workspace").Map.Ground;

    for i,v in pairs(GroundFlower:GetChildren()) do
        if table.find(tableFlowerFeilds, v.Name) then
            if not v:FindFirstChild('ESP-Part') then
                local espPart = Instance.new('Highlight', v)
                espPart.Adornee = v;
                espPart.DepthMode = enumDepthMode;
                espPart.FillColor = fillColor;
                espPart.OutlineColor = outlineColor;
                espPart.FillTransparency = fillTransparency;
                espPart.OutlineTransparency = outlineTransparency;
                espPart.Name = 'ESP-Part';
            end
        end
    end
end


function getPlayerWorkoutSpace()
    return game:GetService("Workspace").Map.Ground.CloverFieldFloor;
end

function tp(posVector3)
    local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait();


    if Character then
        Character:MoveTo(posVector3)
    end
end

function removeESPForFlowerFields()
    local GroundFlower = game:GetService("Workspace").Map.Ground;

    for i,v in pairs(GroundFlower:GetChildren()) do
        if v:FindFirstChild('ESP-Part') then
            v:FindFirstChild('ESP-Part'):Destroy()
        end
    end
end




local ESPFlowerPadsSettings = {
    ['FillColor'] = Color3.fromRGB(255, 255, 0);
    ['FillTransparency'] = 0.5;
    ['OutlineColor'] = Color3.fromRGB(255, 255, 0);
}


local ESP_FlowerPads = Utility.CreateOptionsButton({
    Name = 'ESP-FlowerPads',
    Function = function(callback)
        if callback then
            removeESPForFlowerFields()
            addESPForFlowerFields(ESPFlowerPadsSettings['FillColor'])
        end
    end
})



function getIfPlayerHasMaxPollen()
    local CoreStats = Players.LocalPlayer:WaitForChild('CoreStats', 60);


    if CoreStats then
        local Cap = CoreStats:WaitForChild('Capacity', 10);
        local Pollen = CoreStats:WaitForChild('Pollen', 10);


        if Cap and Pollen then
            if Pollen.Value >= Cap.Value then
                return true
            else
                return false
            end
        end
    end
end

function getIfPlayerHasNoPollen()
    local CoreStats = Players.LocalPlayer:WaitForChild('CoreStats', 60);


    if CoreStats then
        local Pollen = CoreStats:WaitForChild('Pollen', 10);


        if Pollen then
            if Pollen.Value == 0 then
                return true
            else
                return false
            end
        end
    end
end


function getLPLRHiveCore()
    local Hive = Players.LocalPlayer:WaitForChild('Honeycomb', 60);

    if Hive then
        return Hive.Value
    end
end



function callBeeMakeHoneyCommand()
    local args = {
        [1] = "ToggleHoneyMaking"
    }
    
    game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer(unpack(args))    
end


function isReadyByCalculateScreen(r)
    if r then
        if r.Position.Y.Offset >= 4 then
            return true
        else
            return false
        end
    else
        warn('Missing Instance : isReadyByCalculateScreen!')
    end
end


function toggle(r)
    r = not r

    return r
end



function getPlayerHive(name)
    local honeycombs = game:GetService("Workspace"):FindFirstChild("Honeycombs")
    if honeycombs then
        local hive = honeycombs:FindFirstChild(name)
        if hive then
            return hive
        else
            warn("Hive '" .. tostring(name) .. "' not found in Honeycombs")
        end
    else
        warn("Honeycombs not found in Workspace")
    end
    return nil
end



function getLPLRHivePosition()
    local hiveName = getLPLRHiveCore();
    local Hive = getPlayerHive(tostring(hiveName));


    print('HiveName is: ' .. tostring(hiveName))
    print('Hive is: ' .. tostring(Hive))

    if Hive then
        local Base = Hive:WaitForChild('patharrow', 30):WaitForChild('Base', 60);

        print('Base is: ' .. tostring(Base))

        if Base then
            return Base.Position
        end
    end
end


local autoFarmToggled = false;

function toggleAutoFarm()
    autoFarmToggled = toggle(autoFarmToggled);


    if autoFarmToggled then
        repeat
            local isPlayerCapped = getIfPlayerHasMaxPollen();

            repeat
                if isPlayerCapped == false then
                    callForToolCollect()
                    isPlayerCapped = getIfPlayerHasMaxPollen()
                    tp(Vector3.new(-51.473960876464844, 4.447190761566162, 221.47222900390625));
                    task.wait(0.2)
                    continue
                else
                    break
                end
            -- this will never stop, since 1 never will be 2
            until (1 == 2);


            local HivePosition = getLPLRHivePosition();
            local isPlayerInventoryEmpty = getIfPlayerHasNoPollen();


            print(HivePosition)
            tp(HivePosition);
            local waited = isReadyByCalculateScreen(Players.LocalPlayer.PlayerGui:WaitForChild('ScreenGui'):WaitForChild('ActivateButton'));

            repeat
                task.wait(0.2)
                waited = isReadyByCalculateScreen(Players.LocalPlayer.PlayerGui:WaitForChild('ScreenGui'):WaitForChild('ActivateButton'));
            until (waited)

            task.wait(0.2)


            callBeeMakeHoneyCommand();

            repeat
                if isPlayerInventoryEmpty == true then
                    break
                else
                    isPlayerInventoryEmpty = getIfPlayerHasNoPollen();
                    task.wait(0.4)
                    continue
                end
            until (1 == 3);
        until (not autoFarmToggled)
    end
end


local PlayerAutoFarm = World.CreateOptionsButton({
    Name = 'AutoFarm',
    Function = function(callback)
        toggleAutoFarm();
    end
})
