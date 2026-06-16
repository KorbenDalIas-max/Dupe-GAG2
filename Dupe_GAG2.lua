local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KorbenDuplicator"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Korben Dupe"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local ToolNameBox = Instance.new("TextBox")
ToolNameBox.Name = "ToolNameBox"
ToolNameBox.Size = UDim2.new(0.92, 0, 0, 35)
ToolNameBox.Position = UDim2.new(0.04, 0, 0, 50)
ToolNameBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
ToolNameBox.BorderSizePixel = 0
ToolNameBox.Text = "67"
ToolNameBox.PlaceholderText = "Tool Name (e.g. 'Sword' or 'swo' for partial)"
ToolNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolNameBox.TextScaled = true
ToolNameBox.Font = Enum.Font.Gotham
ToolNameBox.ClearTextOnFocus = false
ToolNameBox.Parent = MainFrame

local ToolCorner = Instance.new("UICorner")
ToolCorner.CornerRadius = UDim.new(0, 8)
ToolCorner.Parent = ToolNameBox

local AmountBox = Instance.new("TextBox")
AmountBox.Name = "AmountBox"
AmountBox.Size = UDim2.new(0.92, 0, 0, 35)
AmountBox.Position = UDim2.new(0.04, 0, 0, 95)
AmountBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
AmountBox.BorderSizePixel = 0
AmountBox.PlaceholderText = "Amount"
AmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountBox.TextScaled = true
AmountBox.Font = Enum.Font.Gotham
AmountBox.ClearTextOnFocus = false
AmountBox.Parent = MainFrame

local AmountCorner = Instance.new("UICorner")
AmountCorner.CornerRadius = UDim.new(0, 8)
AmountCorner.Parent = AmountBox

local DupeButton = Instance.new("TextButton")
DupeButton.Name = "DupeButton"
DupeButton.Size = UDim2.new(0.92, 0, 0, 40)
DupeButton.Position = UDim2.new(0.04, 0, 0, 140)
DupeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
DupeButton.BorderSizePixel = 0
DupeButton.Text = "Dupe to backpack"
DupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeButton.TextScaled = true
DupeButton.Font = Enum.Font.GothamBold
DupeButton.Parent = MainFrame

local DupeCorner = Instance.new("UICorner")
DupeCorner.CornerRadius = UDim.new(0, 8)
DupeCorner.Parent = DupeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Dragging Functionality
local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateInput(input)
    end
end)

-- DUPE FUNCTION
local function performDupe()
    local toolQuery = ToolNameBox.Text:lower()
    if toolQuery == "" then
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "❌ Enter a tool name!";
            Color3 = Color3.fromRGB(255, 100, 100);
            Font = Enum.Font.GothamBold;
            FontSize = Enum.FontSize.Size18;
        })
        return
    end
    
    local amount = math.max(1, tonumber(AmountBox.Text) or 1)
    
    local originalTool = nil
    -- Scan ReplicatedStorage first (best originals)
    for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("Tool") and obj.Name:lower():find(toolQuery) then
            originalTool = obj
            break
        end
    end
    -- Then Workspace
    if not originalTool then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name:lower():find(toolQuery) and obj.Parent ~= Backpack and obj.Parent ~= LocalPlayer.Character then
                originalTool = obj
                break
            end
        end
    end
    -- Fallback: entire game
    if not originalTool then
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name:lower():find(toolQuery) and obj.Parent ~= Backpack and obj.Parent ~= LocalPlayer.Character then
                originalTool = obj
                break
            end
        end
    end
    
    if originalTool then
        for i = 1, amount do
            pcall(function()
                local clone = originalTool:Clone()
                clone.Parent = Backpack
            end)
            task.wait(0.01)  -- Prevent lag/crash
        end
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "✅ Duped " .. amount .. "x " .. originalTool.Name .. "!";
            Color3 = Color3.fromRGB(0, 255, 0);
            Font = Enum.Font.GothamBold;
            FontSize = Enum.FontSize.Size18;
        })
    else
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "❌ No tool found matching '" .. ToolNameBox.Text .. "'!";
            Color3 = Color3.fromRGB(255, 100, 100);
            Font = Enum.Font.GothamBold;
            FontSize = Enum.FontSize.Size18;
        })
    end
end

DupeButton.MouseButton1Click:Connect(performDupe)
DupeButton.MouseEnter:Connect(function() DupeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0) end)
DupeButton.MouseLeave:Connect(function() DupeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tips in chat
task.wait(1)
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "🎒 Dupe GUI Loaded! Drag to move, enter name & DUPE!";
    Color3 = Color3.fromRGB(0, 162, 255);
    Font = Enum.Font.GothamBold;
    FontSize = Enum.FontSize.Size18;
})
