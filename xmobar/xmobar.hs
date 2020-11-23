
Config { 
    -- appearance
        font =         "xft:Mononoki Nerd Font Mono:size=11:bold:antialias=true:autohint=true"
        , bgColor =      "black"
        , fgColor =      "#646464"
        , position =     Top
        , border =       BottomB
        , borderColor =  "#646464"

        -- layout
        , sepChar =  "%"   -- delineator between plugin names and straight text
        , alignSep = "}{"  -- separator between left-right alignment
        , template = "%StdinReader% }{ %date% | %battery% | %dynnetwork% | %cpu% | %coretemp% | %memory%"

        -- general behavior
        , lowerOnStart =     False    -- send to bottom of window stack on start
        , hideOnStart =      False   -- start with window unmapped (hidden)
        , allDesktops =      True    -- show on all desktops
        , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
        , pickBroadest =     False   -- choose widest display (multi-monitor)
        , persistent =       True    -- enable/disable hiding (True = disabled)

        -- plugins
        --   Numbers can be automatically colored according to their value. xmobar
        --   decides color based on a three-tier/two-cutoff system, controlled by
        --   command options:
        --     --Low sets the low cutoff
        --     --High sets the high cutoff
        --
        --     --low sets the color below --Low cutoff
        --     --normal sets the color between --Low and --High cutoffs
        --     --High sets the color above --High cutoff
        --
        --   The --template option controls how the plugin is displayed. Text
        --   color can be set by enclosing in <fc></fc> tags. For more details
        --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
        , commands = 
        [
              -- Run Com ".config/xmobar/volume.sh" [] "amixer" 
              Run StdinReader
            -- network activity monitor (dynamic interface resolution)
            , Run DynNetwork     [ "--template" , "<dev>: <tx>kB/s <rx>kB/s"
            , "--Low"      , "15000"       -- units: B/s
            , "--High"     , "50"       -- units: B/s
            , "--low"      , "darkgreen"
            , "--normal"   , "darkorange"
            , "--high"     , "red"
            ] 20

            -- cpu activity monitor
            , Run Cpu       [ "--template" , "Cpu: <total>%"
            , "--Low"      , "50"         -- units: %
            , "--High"     , "85"         -- units: %
            , "--low"      , "darkgreen"
            , "--normal"   , "darkorange"
            , "--high"     , "red"
            ] 10

            -- cpu core temperature monitor
            , Run CoreTemp       [ "--template" , "Temp: <core0>°C"
            , "--Low"      , "70"        -- units: °C
            , "--High"     , "80"        -- units: °C
            , "--low"      , "darkgreen"
            , "--normal"   , "darkorange"
            , "--high"     , "red"
            ] 50

            -- memory usage monitor
            , Run Memory         [ "--template" ,"Mem: <usedratio>%"
            , "--Low"      , "20"        -- units: %
            , "--High"     , "90"        -- units: %
            , "--low"      , "darkgreen"
            , "--normal"   , "darkorange"
            , "--high"     , "red"
            ] 10

            -- battery monitor
            , Run Battery
            [ "--template" , "<acstatus>"
            , "--Low"      , "30"        -- units: %
                , "--High"     , "80"        -- units: %
                , "--low"      , "#BF616A"
                , "--normal"   , "#EBCB8B"
                , "--high"     , "#A3BE8C"
                , "--" -- battery specific options
                -- discharging status - use icons
                , "-l"   ,  "#BF616A"
                , "-m"   ,  "#EBCB8B"
                , "-h"   ,  "#A3BE8C"
                , "-o"   , ""
                , "--lows"     , ": <left>%"
                , "--mediums"  , ": <left>%"
                , "--highs"    , ": <left>%"
                -- AC "on" status
                , "-O"  , "<fc=cyan>:</fc> <left>%"
                -- charged status
                , "-i"  , ""
                , "-a", "notify-send -u critical 'Battery running out!!'"
                , "-A", "20"
                ] 50

                -- time and date indicator 
                --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
                , Run Date           "<fc=#ABABAB>%F W.%W %H:%M</fc>" "date" 10







                -- , Run Alsa "default" "Master" [
                --          "--template" , "<status>"
                    --          , "--"
                    --          , "-C" , "#A3BE8C"
                    --          , "-c" , "#BF616A"
                    --          , "-O", "<volume>%"
                    --          , "-o", ""
                    --          , "--highs", ""
                    --          , "--mediums", ""
                    --          , "--lows", ""
                    --        ] 50



                    ]
}
