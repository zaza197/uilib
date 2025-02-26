-- NeverLose Style UI Library with Moveable Window
local UI = {}

-- Utility function for creating rounded corners
local function createRoundRect(parent, size, position, cornerRadius, bgColor)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = bgColor
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = parent

    -- Creating rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = frame

    return frame
end

-- Create a window with NeverLose style
function UI:CreateWindow(title, size, position)
    -- Create a ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Create main frame (window background)
    local window = createRoundRect(screenGui, size, position, 10, Color3.fromRGB(20, 20, 20))
    
    -- Create title bar
    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1
    titleBar.Text = title
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.TextSize = 20
    titleBar.TextAlign = Enum.TextAlign.Center
    titleBar.Parent = window
    
    -- Create a corner for the title bar
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = titleBar

    -- Implement drag functionality
    local dragging = false
    local dragStart = Vector3.new()
    local startPos = window.Position

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return window, screenGui
end

-- Create a button with NeverLose style
function UI:CreateButton(parent, text, position, size, callback)
    -- Create a button with rounded corners
    local button = createRoundRect(parent, size, position, 8, Color3.fromRGB(40, 40, 40))

    -- Button text
    local buttonText = Instance.new("TextButton")
    buttonText.Size = UDim2.new(1, 0, 1, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = text
    buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonText.TextSize = 18
    buttonText.TextAlign = Enum.TextAlign.Center
    buttonText.Parent = button

    -- Add a hover effect
    buttonText.MouseEnter:Connect(function()
        buttonText.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)

    buttonText.MouseLeave:Connect(function()
        buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    -- Add the callback for button click
    buttonText.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

-- Create a tab button for navigation
function UI:CreateTabButton(parent, text, position, size, callback)
    local tabButton = createRoundRect(parent, size, position, 8, Color3.fromRGB(30, 30, 30))
    
    local tabText = Instance.new("TextButton")
    tabText.Size = UDim2.new(1, 0, 1, 0)
    tabText.BackgroundTransparency = 1
    tabText.Text = text
    tabText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabText.TextSize = 18
    tabText.TextAlign = Enum.TextAlign.Center
    tabText.Parent = tabButton

    -- Hover effect for the tab
    tabText.MouseEnter:Connect(function()
        tabText.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)

    tabText.MouseLeave:Connect(function()
        tabText.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    -- Tab button click
    tabText.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return tabButton
end

-- Create a slider
function UI:CreateSlider(parent, label, position, size, minValue, maxValue, callback)
    -- Create the slider container
    local sliderFrame = createRoundRect(parent, size, position, 8, Color3.fromRGB(50, 50, 50))
    
    -- Slider label
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(0, 200, 0, 30)
    sliderLabel.Position = UDim2.new(0, 0, 0, -35)
    sliderLabel.Text = label
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 18
    sliderLabel.TextAlign = Enum.TextAlign.Center
    sliderLabel.Parent = sliderFrame

    -- The actual slider bar
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 4)
    sliderBar.Position = UDim2.new(0, 0, 0, 20)
    sliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame

    -- Slider knob
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 10, 0, 10)
    sliderKnob.Position = UDim2.new(0, 0, 0, -3)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderBar

    -- Draggable slider logic
    local dragging = false
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderKnob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging then
            local xPos = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
            sliderKnob.Position = UDim2.new(0, xPos, 0, -3)

            -- Calculate the value based on the knob's position
            local value = math.round((xPos / sliderBar.AbsoluteSize.X) * (maxValue - minValue) + minValue)
            if callback then
                callback(value)
            end
        end
    end)

    return sliderFrame
end

return UI
