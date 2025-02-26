local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local UILibrary = {}
UILibrary.__index = UILibrary

function UILibrary.new()
    local self = setmetatable({}, UILibrary)
    self.Windows = {}
    return self
end

function UILibrary:CreateWindow(settings)
    local window = {}
    window.Name = settings.Name or "Window"
    window.Tabs = {}

    -- Create the main window GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
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

        -- Function to create a toggle in the tab
        function tab:CreateToggle(toggleSettings)
            local toggle = Instance.new("TextButton")
            toggle.Text = toggleSettings.Name
            toggle.Size = UDim2.new(0, 150, 0, 30)
            toggle.Position = UDim2.new(0, 10, 0, 10 + (#tab:GetChildren() * 40))
            toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            toggle.TextColor3 = Color3.fromRGB(240, 240, 240)
            toggle.Parent = tabFrame

            local toggleState = toggleSettings.CurrentValue or false

            toggle.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                toggleSettings.Callback(toggleState)
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

return UILibrary
