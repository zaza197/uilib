local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function library:CreateWindow(settings)
    local window = {}
    window.Name = settings.Name or "Window"
    window.Tabs = {}

    -- Create the main window GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = settings.Size or UDim2.new(0, 500, 0, 400)
    mainFrame.Position = settings.Position or UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.Parent = screenGui

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    topBar.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Text = window.Name
    title.Size = UDim2.new(1, 0, 1, 0)
    title.TextColor3 = Color3.fromRGB(240, 240, 240)
    title.Font = Enum.Font.SourceSans
    title.TextSize = 18
    title.Parent = topBar

    -- Dragging functionality
    local dragging = false
    local dragStartPos
    local windowStartPos

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
            windowStartPos = mainFrame.Position
        end
    end)

    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = mousePos - dragStartPos
            mainFrame.Position = UDim2.new(
                windowStartPos.X.Scale,
                windowStartPos.X.Offset + delta.X,
                windowStartPos.Y.Scale,
                windowStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Function to create tabs
    function window:CreateTab(tabName)
        local tab = {}
        tab.Name = tabName

        -- Create a button for the tab
        local tabButton = Instance.new("TextButton")
        tabButton.Text = tabName
        tabButton.Size = UDim2.new(0, 100, 0, 30)
        tabButton.Position = UDim2.new(0, (#window.Tabs * 100), 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        tabButton.TextColor3 = Color3.fromRGB(240, 240, 240)
        tabButton.Parent = topBar

        -- Create a frame for the tab content
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 1, -30)
        tabFrame.Position = UDim2.new(0, 0, 0, 30)
        tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabFrame.Visible = false
        tabFrame.Parent = mainFrame

        -- Show the tab when the button is clicked
        tabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(window.Tabs) do
                otherTab.Frame.Visible = false
            end
            tabFrame.Visible = true
        end)

        -- Function to create a button in the tab
        function tab:CreateButton(buttonSettings)
            local button = Instance.new("TextButton")
            button.Text = buttonSettings.Name
            button.Size = UDim2.new(0, 150, 0, 30)
            button.Position = UDim2.new(0, 10, 0, 10 + (#tab:GetChildren() * 40))
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            button.TextColor3 = Color3.fromRGB(240, 240, 240)
            button.Parent = tabFrame

            button.MouseButton1Click:Connect(function()
                buttonSettings.Callback()
            end)
        end

        -- Add the tab to the window
        table.insert(window.Tabs, {Name = tabName, Frame = tabFrame})
        return tab
    end

    -- Add the window to the library
    table.insert(self.Windows, window)
    return window
end
