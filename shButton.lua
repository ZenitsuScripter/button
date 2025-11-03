task.delay(10, function()
    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")

    -- Procura o Hub principal
    local HubGUI
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "ScreenGui" then
            HubGUI = gui
            break
        end
    end

    if not HubGUI then
        warn("Hub ScreenGui não encontrado!")
        return
    end

    if CoreGui:FindFirstChild("HubToggle") then
        return
    end

    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "HubToggle"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Parent = CoreGui

    local Button = Instance.new("ImageButton")
    Button.Name = "ToggleButton"
    Button.Size = UDim2.new(0, 60, 0, 60)
    Button.Position = UDim2.new(0, 20, 0, 200)
    Button.BackgroundTransparency = 1
    Button.Image = "rbxassetid://12232793816" -- mesma imagem do seu
    Button.ScaleType = Enum.ScaleType.Fit
    Button.BorderSizePixel = 0
    Button.Parent = ToggleGui

    -- mover botão (arrastar)
    local dragging = false
    local dragInput, dragStart, startPos

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Button.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- animação de esconder/mostrar o Hub
    local MainFrame = HubGUI:FindFirstChildWhichIsA("Frame", true)
    if not MainFrame then
        warn("MainFrame do Hub não encontrado!")
        return
    end

    local minimized = false
    local visiblePos = MainFrame.Position
    local hiddenPos = UDim2.new(2, 0, visiblePos.Y.Scale, visiblePos.Y.Offset)

    Button.MouseButton1Click:Connect(function()
        minimized = not minimized
        MainFrame:TweenPosition(
            minimized and hiddenPos or visiblePos,
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Sine,
            0.4,
            true
        )
    end)
end)
