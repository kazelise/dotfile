function _aerospace_56
    set 1 $argv[1]
    aerospace list-workspaces --monitor all --empty no
end

function _aerospace_54
    set 1 $argv[1]
    aerospace list-windows --all --format '%{window-id}%{tab}%{app-name} - %{window-title}'
end

function _aerospace_53
    set 1 $argv[1]
    true
end

function _aerospace_51
    set 1 $argv[1]
    aerospace list-apps --format '%{app-pid}%{tab}%{app-name}'
end

function _aerospace_27
    set 1 $argv[1]
    aerospace config --get mode --keys | xargs -I{} aerospace config --get mode.{}.binding --keys
end

function _aerospace_55
    set 1 $argv[1]
    aerospace config --major-keys
end

function _aerospace_40
    set 1 $argv[1]
    aerospace config --get mode --keys
end

function _aerospace_45
    set 1 $argv[1]
    aerospace list-apps --format '%{app-bundle-id}%{tab}%{app-name}'
end

function _aerospace_44
    set 1 $argv[1]
    aerospace list-monitors --format '%{monitor-id}%{tab}%{monitor-name}'
end

function _aerospace_subword_cmd_0
    true
end

function _aerospace_subword_1
    set mode $argv[1]
    set word $argv[2]

    set --local literals - "+"

    set --local descriptions

    set --local literal_transitions
    set literal_transitions[1] "set inputs 1 2; set tos 2 2"

    set --local match_anything_transitions_from 1 2
    set --local match_anything_transitions_to 3 3

    set --local state 1
    set --local char_index 1
    set --local matched 0
    while true
        if test $char_index -gt (string length -- "$word")
            set matched 1
            break
        end

        set --local subword (string sub --start=$char_index -- "$word")

        if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
            set --local --erase inputs
            set --local --erase tos
            eval $literal_transitions[$state]

            set --local literal_matched 0
            for literal_id in (seq 1 (count $literals))
                set --local literal $literals[$literal_id]
                set --local literal_len (string length -- "$literal")
                set --local subword_slice (string sub --end=$literal_len -- "$subword")
                if test $subword_slice = $literal
                    set --local index (contains --index -- $literal_id $inputs)
                    set state $tos[$index]
                    set char_index (math $char_index + $literal_len)
                    set literal_matched 1
                    break
                end
            end
            if test $literal_matched -ne 0
                continue
            end
        end

        if set --query match_anything_transitions_from[$state] && test -n $match_anything_transitions_from[$state]
            set --local index (contains --index -- $state $match_anything_transitions_from)
            set state $match_anything_transitions_to[$index]
            set --local matched 1
            break
        end

        break
    end

    if test $mode = matches
        return (math 1 - $matched)
    end

    set --local unmatched_suffix (string sub --start=$char_index -- $word)

    set --local matched_prefix
    if test $char_index -eq 1
        set matched_prefix ""
    else
        set matched_prefix (string sub --end=(math $char_index - 1) -- "$word")
    end
    if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
        set --local --erase inputs
        set --local --erase tos
        eval $literal_transitions[$state]
        for literal_id in $inputs
            set --local unmatched_suffix_len (string length -- $unmatched_suffix)
            if test $unmatched_suffix_len -gt 0
                set --local literal $literals[$literal_id]
                set --local slice (string sub --end=$unmatched_suffix_len -- $literal)
                if test "$slice" != "$unmatched_suffix"
                    continue
                end
            end
            if test -n $descriptions[$literal_id]
                printf '%s%s\t%s\n' $matched_prefix $literals[$literal_id] $descriptions[$literal_id]
            else
                printf '%s%s\n' $matched_prefix $literals[$literal_id]
            end
        end
    end

    set command_states 1 2
    set command_ids 0 0
    if contains $state $command_states
        set --local index (contains --index $state $command_states)
        set --local function_id $command_ids[$index]
        set --local function_name _aerospace_subword_cmd_$function_id
        set --local --erase inputs
        set --local --erase tos
        $function_name "$matched_prefix" | while read --local line
            printf '%s%s\n' $matched_prefix $line
        end
    end

    return 0
end

function _aerospace
    set COMP_LINE (commandline --cut-at-cursor)

    set COMP_WORDS
    echo $COMP_LINE | read --tokenize --array COMP_WORDS
    if string match --quiet --regex '.*\s$' $COMP_LINE
        set COMP_CWORD (math (count $COMP_WORDS) + 1)
    else
        set COMP_CWORD (count $COMP_WORDS)
    end

    set --local literals move-mouse --count -v smart macos-native-fullscreen mute-toggle height toggle all-monitors-outer-frame h_accordion all --window-id monitor-force-center list-apps flatten-workspace-tree mode width summon-workspace focus-back-and-forth list-monitors h_tiles prev window-force-center trigger-binding -h move-node-to-workspace wrap-around-the-workspace enable --ignore-floating --visible close-all-windows-but-current --help --macos-native-hidden off move-workspace-to-monitor --boundaries set workspace-back-and-forth --quit-if-last-window window-lazy-center workspace --major-keys accordion --focused tiling --app-bundle-id --mouse balance-sizes opposite on --auto-back-and-forth --version --json join-with reload-config --workspace floating --swap-focus --mode --boundaries-action resize visible close up layout --fail-if-noop list-exec-env-vars fail --monitor --focus-follows-window split --pid mute-on v_tiles monitor-lazy-center --keys wrap-around-all-monitors --wrap-around horizontal create-implicit-container config --no-outer-gaps focused mute-off --all-keys --all left right swap --config-path --get --empty tiles dfs-next --no-gui smart-opposite --format list-modes --dry-run move-node-to-monitor dfs-prev move focus down list-workspaces volume no stop debug-windows macos-native-minimize list-windows mouse next --dfs-index fullscreen focus-monitor --current v_accordion vertical

    set --local descriptions

    set --local literal_transitions
    set literal_transitions[1] "set inputs 1 3 54 55 35 5 38 61 89 63 98 14 41 65 67 15 100 71 20 16 19 102 103 18 24 25 105 26 106 109 110 111 28 48 81 31 52 115 32 116; set tos 111 3 114 115 116 62 3 86 74 65 102 73 95 117 3 5 118 119 41 93 3 35 70 112 53 3 120 121 90 52 52 14 122 5 10 76 3 123 3 77"
    set literal_transitions[4] "set inputs 97 2 53; set tos 2 3 3"
    set literal_transitions[5] "set inputs 56; set tos 6"
    set literal_transitions[7] "set inputs 12 66; set tos 8 7"
    set literal_transitions[10] "set inputs 85 42 76 53 91 90; set tos 3 3 11 11 12 3"
    set literal_transitions[11] "set inputs 53 91 76; set tos 11 12 11"
    set literal_transitions[13] "set inputs 10 21 57 79 93 45 74 43 118 119; set tos 13 13 13 13 13 13 13 13 13 13"
    set literal_transitions[14] "set inputs 72 2 56 97 44 86 46 53 69; set tos 15 16 17 18 4 4 19 16 20"
    set literal_transitions[16] "set inputs 72 2 56 97 44 86 46 53 69; set tos 15 80 17 81 4 4 19 80 20"
    set literal_transitions[17] "set inputs 62 83; set tos 85 85"
    set literal_transitions[20] "set inputs 11 112 83; set tos 91 91 91"
    set literal_transitions[21] "set inputs 36 60 87 88 104 29 64; set tos 22 23 24 24 24 21 24"
    set literal_transitions[22] "set inputs 9 41; set tos 21 21"
    set literal_transitions[23] "set inputs 108 27 68 77; set tos 21 21 21 21"
    set literal_transitions[24] "set inputs 36 60 29; set tos 132 43 24"
    set literal_transitions[27] "set inputs 82 66 12 50; set tos 27 27 28 29"
    set literal_transitions[29] "set inputs 12 82 66; set tos 109 29 29"
    set literal_transitions[30] "set inputs 82 66 12 34 50; set tos 27 27 28 31 29"
    set literal_transitions[31] "set inputs 12 66; set tos 9 3"
    set literal_transitions[33] "set inputs 82 66 12 34 50; set tos 106 27 105 31 29"
    set literal_transitions[35] "set inputs 36 60 87 88 12 104 64; set tos 71 55 47 47 34 47 47"
    set literal_transitions[37] "set inputs 12 58 78; set tos 36 37 37"
    set literal_transitions[38] "set inputs 51 66; set tos 38 38"
    set literal_transitions[39] "set inputs 51 66; set tos 39 39"
    set literal_transitions[40] "set inputs 107 2 97 53 47 44; set tos 41 41 42 41 40 40"
    set literal_transitions[41] "set inputs 2 97 53 47 44; set tos 41 42 41 40 40"
    set literal_transitions[43] "set inputs 108 27 68 77; set tos 24 24 24 24"
    set literal_transitions[45] "set inputs 75 40 13 23; set tos 46 46 46 46"
    set literal_transitions[46] "set inputs 66; set tos 3"
    set literal_transitions[47] "set inputs 12 36 60; set tos 48 49 50"
    set literal_transitions[49] "set inputs 9 41; set tos 47 47"
    set literal_transitions[50] "set inputs 68 80 108; set tos 47 47 47"
    set literal_transitions[51] "set inputs 79 119 49; set tos 52 52 52"
    set literal_transitions[52] "set inputs 12; set tos 9"
    set literal_transitions[53] "set inputs 59; set tos 25"
    set literal_transitions[54] "set inputs 59; set tos 93"
    set literal_transitions[55] "set inputs 68 80 108; set tos 35 35 35"
    set literal_transitions[57] "set inputs 12 66 70; set tos 56 57 57"
    set literal_transitions[58] "set inputs 108 27 68 77; set tos 59 59 59 59"
    set literal_transitions[59] "set inputs 104 94 29 64 36 60 87 88 101; set tos 24 60 59 24 22 58 24 24 60"
    set literal_transitions[60] "set inputs 60 29; set tos 61 60"
    set literal_transitions[61] "set inputs 108 27 68 77; set tos 60 60 60 60"
    set literal_transitions[62] "set inputs 66 12 34 50; set tos 62 63 7 7"
    set literal_transitions[64] "set inputs 10 21 57 79 93 45 74 43 118 119; set tos 13 13 13 13 13 13 13 13 13 13"
    set literal_transitions[65] "set inputs 12 39; set tos 66 65"
    set literal_transitions[67] "set inputs 113 12 22 104 64 87 88 66 78 70; set tos 68 69 68 68 68 68 68 67 67 67"
    set literal_transitions[68] "set inputs 66 12 78 70; set tos 68 92 68 68"
    set literal_transitions[70] "set inputs 12 94 29 64 36 60 87 88 104 114 101; set tos 9 60 59 24 22 58 24 24 24 2 60"
    set literal_transitions[71] "set inputs 9 41; set tos 35 35"
    set literal_transitions[73] "set inputs 2 97 53 33; set tos 73 72 73 84"
    set literal_transitions[74] "set inputs 104 12 94 58 64 87 88 78 101; set tos 37 75 37 74 37 37 37 74 37"
    set literal_transitions[76] "set inputs 39; set tos 3"
    set literal_transitions[77] "set inputs 113 104 22 64 87 88 78; set tos 78 78 78 78 78 78 79"
    set literal_transitions[78] "set inputs 78; set tos 3"
    set literal_transitions[79] "set inputs 87 88 113 104 22 64; set tos 78 78 78 78 78 78"
    set literal_transitions[80] "set inputs 72 2 46 56 53 69 97; set tos 15 80 19 17 80 20 81"
    set literal_transitions[83] "set inputs 30 2 92 97 53 69; set tos 107 83 107 82 83 103"
    set literal_transitions[84] "set inputs 107 2 97 53 33; set tos 73 73 72 73 84"
    set literal_transitions[85] "set inputs 72 2 62 56 97 46 53 83 69; set tos 15 80 85 17 81 19 80 85 20"
    set literal_transitions[86] "set inputs 17 4 7 12 96; set tos 87 87 87 88 87"
    set literal_transitions[89] "set inputs 78 70; set tos 89 89"
    set literal_transitions[90] "set inputs 64 37 6 73 104 84; set tos 3 2 3 3 3 3"
    set literal_transitions[91] "set inputs 11 2 72 112 56 97 83 46 53 69; set tos 91 80 15 91 17 81 91 19 80 20"
    set literal_transitions[95] "set inputs 51 113 66 22 78; set tos 38 78 38 78 96"
    set literal_transitions[96] "set inputs 22 113; set tos 78 78"
    set literal_transitions[97] "set inputs 17 4 7 96; set tos 87 87 87 87"
    set literal_transitions[99] "set inputs 30 2 92 97 53; set tos 108 99 108 98 99"
    set literal_transitions[101] "set inputs 87 88 104 64; set tos 3 3 3 3"
    set literal_transitions[102] "set inputs 117 2 53; set tos 102 102 102"
    set literal_transitions[103] "set inputs 11 112 83; set tos 104 104 104"
    set literal_transitions[104] "set inputs 11 2 112 92 97 30 53 83; set tos 104 99 104 108 98 108 99 104"
    set literal_transitions[106] "set inputs 82 66 12 50; set tos 106 27 105 29"
    set literal_transitions[107] "set inputs 30 2 107 92 97 53 69; set tos 107 83 83 107 82 83 103"
    set literal_transitions[108] "set inputs 30 2 107 92 97 53; set tos 108 99 99 108 98 99"
    set literal_transitions[110] "set inputs 113 22 78 70; set tos 89 89 110 110"
    set literal_transitions[111] "set inputs 66 40 13 23 75; set tos 45 46 46 46 46"
    set literal_transitions[112] "set inputs 66; set tos 113"
    set literal_transitions[114] "set inputs 87 88 12 104 64; set tos 3 3 100 3 3"
    set literal_transitions[115] "set inputs 95 99; set tos 115 115"
    set literal_transitions[116] "set inputs 113 104 22 64 87 88 78; set tos 78 78 78 78 78 78 133"
    set literal_transitions[117] "set inputs 10 93 12 21 57 79 45 74 43 118 119; set tos 13 13 126 13 13 13 13 13 13 13 13"
    set literal_transitions[118] "set inputs 113 12 22 104 64 87 88 66 78 70; set tos 68 127 68 68 68 68 68 118 67 118"
    set literal_transitions[119] "set inputs 49 12 79 119; set tos 52 94 52 52"
    set literal_transitions[120] "set inputs 2 92 97 44 30 86 53 69; set tos 129 107 134 4 107 4 129 103"
    set literal_transitions[121] "set inputs 70 66 113 12 78 22; set tos 121 124 89 125 110 89"
    set literal_transitions[122] "set inputs 66 34 8 50; set tos 135 46 3 46"
    set literal_transitions[123] "set inputs 82 66 12 34 50; set tos 106 30 32 31 29"
    set literal_transitions[124] "set inputs 66 12 70; set tos 124 125 124"
    set literal_transitions[128] "set inputs 53 76; set tos 128 128"
    set literal_transitions[129] "set inputs 2 92 97 44 30 86 53 69; set tos 83 107 82 4 107 4 83 103"
    set literal_transitions[130] "set inputs 66 12 70; set tos 57 56 57"
    set literal_transitions[131] "set inputs 78; set tos 3"
    set literal_transitions[132] "set inputs 9 41; set tos 24 24"
    set literal_transitions[133] "set inputs 87 88 104 22 113 64; set tos 78 78 78 78 78 78"
    set literal_transitions[135] "set inputs 34 50; set tos 46 46"

    set --local match_anything_transitions_from 112 48 34 131 125 127 44 66 88 133 85 105 82 25 36 20 6 56 63 94 69 28 103 118 38 26 53 95 109 124 9 77 2 116 126 91 42 72 92 93 130 100 18 104 19 81 32 98 113 121 15 75 134 8 12 17
    set --local match_anything_transitions_to 46 47 35 131 124 118 44 65 97 131 85 106 83 26 37 91 3 57 62 51 67 27 104 130 39 3 54 39 29 57 3 44 3 131 64 91 41 73 68 3 130 101 16 104 80 80 33 99 46 57 80 74 129 7 128 85
    set subword_transitions[87] "set subword_ids 1; set tos 52"

    set --local state 1
    set --local word_index 2
    while test $word_index -lt $COMP_CWORD
        set --local -- word $COMP_WORDS[$word_index]

        if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
            set --local --erase inputs
            set --local --erase tos
            eval $literal_transitions[$state]

            if contains -- $word $literals
                set --local literal_matched 0
                for literal_id in (seq 1 (count $literals))
                    if test $literals[$literal_id] = $word
                        set --local index (contains --index -- $literal_id $inputs)
                        set state $tos[$index]
                        set word_index (math $word_index + 1)
                        set literal_matched 1
                        break
                    end
                end
                if test $literal_matched -ne 0
                    continue
                end
            end
        end

        if set --query subword_transitions[$state] && test -n $subword_transitions[$state]
            set --local --erase subword_ids
            set --local --erase tos
            eval $subword_transitions[$state]

            set --local subword_matched 0
            for subword_id in $subword_ids
                if _aerospace_subword_$subword_id matches "$word"
                    set subword_matched 1
                    set state $tos[$subword_id]
                    set word_index (math $word_index + 1)
                    break
                end
            end
            if test $subword_matched -ne 0
                continue
            end
        end

        if set --query match_anything_transitions_from[$state] && test -n $match_anything_transitions_from[$state]
            set --local index (contains --index -- $state $match_anything_transitions_from)
            set state $match_anything_transitions_to[$index]
            set word_index (math $word_index + 1)
            continue
        end

        return 1
    end

    if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
        set --local --erase inputs
        set --local --erase tos
        eval $literal_transitions[$state]
        for literal_id in $inputs
            if test -n $descriptions[$literal_id]
                printf '%s\t%s\n' $literals[$literal_id] $descriptions[$literal_id]
            else
                printf '%s\n' $literals[$literal_id]
            end
        end
    end

    if set --query subword_transitions[$state] && test -n $subword_transitions[$state]
        set --local --erase subword_ids
        set --local --erase tos
        eval $subword_transitions[$state]

        for subword_id in $subword_ids
            set --local function_name _aerospace_subword_$subword_id
            $function_name complete "$COMP_WORDS[$COMP_CWORD]"
        end
    end

    set command_states 93 85 130 112 26 109 53 95 105 124 48 34 100 18 104 19 81 131 82 25 9 32 98 113 121 36 77 125 127 2 116 15 75 44 134 20 6 8 126 66 56 88 63 94 91 42 12 69 28 72 103 118 38 133 92 17
    set command_ids 40 56 53 56 27 54 27 56 54 56 54 54 54 53 44 45 53 53 53 40 54 54 53 56 56 54 53 54 54 53 53 51 54 53 53 44 56 54 54 54 54 54 54 54 44 53 55 54 54 53 44 53 56 53 54 56
    if contains $state $command_states
        set --local index (contains --index $state $command_states)
        set --local function_id $command_ids[$index]
        set --local function_name _aerospace_$function_id
        set --local --erase inputs
        set --local --erase tos
        $function_name "$COMP_WORDS[$COMP_CWORD]"
    end

    return 0
end

complete --command aerospace --no-files --arguments "(_aerospace)"
