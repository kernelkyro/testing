local Players = game:GetService("Players")

local MAX_LUCK = 999999999

Players.PlayerAdded:Connect(function(player)
	local luck = player:WaitForChild("Luck", 10)

	if luck and (luck:IsA("IntValue") or luck:IsA("NumberValue")) then
		luck.Value = MAX_LUCK
	end
end)
