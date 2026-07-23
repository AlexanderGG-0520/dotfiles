-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Add your workspace rules here. Increment the workspace number as you go. Do not have duplicate workspaces.
-- -- Three persistent workspaces per monitor.
--
-- MONITOR1: 1, 2, 3
-- MONITOR2: 4, 5, 6
-- MONITOR3: 7, 8, 9

-- Monitor 1
hl.workspace_rule({
    workspace = "1",
    monitor = MONITOR1,
    default = true,
    persistent = true,
})

hl.workspace_rule({
    workspace = "2",
    monitor = MONITOR1,
    persistent = true,
})

hl.workspace_rule({
    workspace = "3",
    monitor = MONITOR1,
    persistent = true,
})

-- Monitor 2
hl.workspace_rule({
    workspace = "4",
    monitor = MONITOR2,
    default = true,
    persistent = true,
})

hl.workspace_rule({
    workspace = "5",
    monitor = MONITOR2,
    persistent = true,
})

hl.workspace_rule({
    workspace = "6",
    monitor = MONITOR2,
    persistent = true,
})

-- Monitor 3
hl.workspace_rule({
    workspace = "7",
    monitor = MONITOR3,
    default = true,
    persistent = true,
})

hl.workspace_rule({
    workspace = "8",
    monitor = MONITOR3,
    persistent = true,
})

hl.workspace_rule({
    workspace = "9",
    monitor = MONITOR3,
    persistent = true,
})
-- hl.workspace_rule({ workspace = "4", monitor = MONITOR2, default = true, persistent = true })
-- hl.workspace_rule({ workspace = "5", monitor = MONITOR2, default = true, persistent = true })
-- hl.workspace_rule({ workspace = "6", monitor = MONITOR2, default = true, persistent = true })
