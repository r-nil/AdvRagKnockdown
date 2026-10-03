local cvPrefix = "savee_advragknockdown_"

function ulx.enable_arkd(calling_ply, state)
    RunConsoleCommand(cvPrefix .. "allowed",state and 1 or 0)
	ulx.fancyLogAdmin(calling_ply, state and "#A enabled ARKD" or "#A disabled ARKD")
end

local enable_arkd = ulx.command("ARKD", "ulx arkd", ulx.enable_arkd, "!arkd")
enable_arkd:addParam{
	type = ULib.cmds.BoolArg,
	hint = "Enabled"
}

enable_arkd:defaultAccess(ULib.ACCESS_ADMIN)
enable_arkd:help("Enable ARKD")

function ulx.arkd_knockdown(caller, targets)
    for i = 1, #targets do
        local ply = targets[i]
        local oldCtrl = Savee_AdvRagKnockdown_GetController(ply)
        if IsValid(oldCtrl) then
            oldCtrl:CancelGetUp()
        end

        if ply:IsPlayer() and ply:InVehicle() then
            local can = hook.Run("CanExitVehicle", ply:GetVehicle(), ply)
            if not can then continue end
            ply:ExitVehicle()
        end

        local ctrl = IsValid(oldCtrl) and oldCtrl or ents.Create("ent_savee_advragknockdown_ctrl")
        if not IsValid(oldCtrl) then
            ctrl:SetOwner(ply)
            ctrl:SetPos(ply:GetPos())
            ctrl:Spawn()
            ctrl.PreventPhysAttackTill = CurTime() + 0.05
            ctrl.NextGetUp = CurTime() + 0.5
        end

		ctrl.NoGetUp = true
    end

    ulx.fancyLogAdmin(caller, "#A ARKnockDowned #T", targets)
end

local arkd_knockdown = ulx.command("ARKD", "ulx arkd_kd", ulx.arkd_knockdown, "!arkd_kd")
arkd_knockdown:defaultAccess(ULib.ACCESS_ADMIN)
arkd_knockdown:addParam{
    type = ULib.cmds.PlayersArg
}

function ulx.arkd_getup(caller, targets)
    for i = 1, #targets do
        local ply = targets[i]
        local ctrl = Savee_AdvRagKnockdown_GetController(ply)
		if IsValid(ctrl) then
			ctrl.NoGetUp = false
			ctrl:RemoveSelf()
		end
    end

    ulx.fancyLogAdmin(caller, "#A unARKnockDowned #T", targets)
end

local arkd_getup = ulx.command("ARKD", "ulx arkd_unkd", ulx.arkd_getup, "!arkd_unkd")
arkd_getup:defaultAccess(ULib.ACCESS_ADMIN)
arkd_getup:addParam{
    type = ULib.cmds.PlayersArg
}