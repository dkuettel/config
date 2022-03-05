" TODO virtual text to the right with the highlight applied would be nice


" colors
let _ = -1

let base01 = 10
let comments = base01
let secondary = base01

let base02 = 0
let bg_highlight = base02

let base0 = 12
let body = base0
let default = base0
let primary = base0

let base1 = 14
let emphasized = base1

let yellow = 3
let orange = 9
let red = 1
let magenta = 5
let violet = 13
let blue = 4
let cyan = 6
let green = 2


" highlights
let highlights = {}
let highlights['String'] = [secondary, _, _]
let highlights['Comment'] = [comments, _, 'italic']

let highlights['Def'] = [green, _, 'bold']
let highlights['DefName'] = [blue, _, 'bold']
let highlights['DefReturnType'] = [green, _, 'nocombine,bold']
let highlights['DefParameter'] = [_, _, 'underline,bold']
let highlights['DefParameterType'] = [secondary, _, 'nocombine']
let highlights['DefParameterValue'] = [secondary, _, 'nocombine,italic']
let highlights['DefDocString'] = [comments, _, _]
let highlights['DefReturn'] = [green, _, 'bold']
let highlights['Decorator'] = [secondary, _, 'italic']

let highlights['CallTarget'] = [blue, _, 'nocombine,NONE']
let highlights['CallParenthesis'] = [blue, _, 'NONE']
let highlights['CallComma'] = [blue, _, 'NONE']
let highlights['CallArgumentName'] = [secondary, _, 'NONE']
let highlights['CallArgumentEqual'] = [secondary, _, 'NONE']
let highlights['CallArgumentValue'] = [primary, _, 'nocombine,NONE']

let highlights['AssignmentLeft'] = [primary, _, 'nocombine,italic']

let highlights['If'] = [yellow, _, 'NONE']
let highlights['Elif'] = [yellow, _, 'NONE']
let highlights['Else'] = [yellow, _, 'NONE']


" apply
for key in keys(highlights)
    let [fg, bg, style] = highlights[key]
    let args = []
    if fg != _
        let args += ['ctermfg='.fg]
    endif
    if bg != _
        let args += ['ctermbg='.bg]
    endif
    if style != _
        let args += ['cterm='.style]
    endif
    execute 'highlight clear '.key
    if len(args) > 0
        execute 'highlight '.key.' '.join(args, ' ')
    endif
endfor
