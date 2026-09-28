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