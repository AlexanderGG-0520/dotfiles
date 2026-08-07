-- Monitor configuration migrated from the active session
hl.config({
    render = {
        cm_auto_hdr = 0,
    }
})

hl.monitor({
    output = "DP-1",
    mode = "1920x1080@143.98100",
    position = "0x0",
    scale = 1.00,
})

hl.monitor({
    output = "DP-2",
    mode = "1920x1080@280.00000",
    position = "1920x0",
    scale = 1.00,

    bitdepth = 10,
    cm = "hdr",
    sdrbrightness = 5.0,
    sdrsaturation = 1.0,
})

hl.monitor({
    output = "DP-3",
    mode = "1920x1080@144.00101",
    position = "3840x0",
    scale = 1.00,
})

