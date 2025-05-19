task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    local player = game.Players.LocalPlayer
    if not player.Character then player.CharacterAdded:Wait() end
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    hrp.Anchored = true
    task.wait(0.1)
    hrp.CFrame = CFrame.new(323.47, 22.33, -9112.45)

    -- Đợi MaximGun xuất hiện
    repeat task.wait() until workspace:FindFirstChild("RuntimeItems") and workspace.RuntimeItems:FindFirstChild("MaximGun")
    task.wait(0.3)

    -- Bật ghế
    for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
        if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
            v.VehicleSeat.Disabled = false
        end
    end

    -- Tìm MaximGun gần nhất
    local closestGun, closestDist = nil, 400
    for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
        if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
            local dist = (hrp.Position - v.VehicleSeat.Position).Magnitude
            if dist < closestDist then
                closestGun = v
                closestDist = dist
            end
        end
    end

    if closestGun then
        local seat = closestGun:FindFirstChild("VehicleSeat")
        if seat then
            -- Dịch chuyển đến ghế
            hrp.CFrame = seat.CFrame
            hrp.Anchored = false

            -- Đợi ngồi vào ghế
            repeat task.wait(0.1) until seat.Occupant == humanoid

            -- Đứng lên (hủy trạng thái ngồi + dịch chuyển ra ngoài)
            humanoid.Sit = false
            task.wait(0.2)
            hrp.CFrame = hrp.CFrame * CFrame.new(3, 0, 0)

            -- Chờ 1 giây rồi ngồi lại
            task.wait(0.2)
            
            -- Dịch chuyển lại đúng ghế
            hrp.CFrame = seat.CFrame
            task.wait(0.1)

            -- Ngồi lại, lặp cho đến khi chắc chắn đã ngồi
            repeat
                seat:Sit(humanoid)
                task.wait(0.2)
            until seat.Occupant == humanoid
        end
    end
end)
