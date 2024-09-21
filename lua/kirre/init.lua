local function init()
    require 'kirre.vim'.init()
    require 'kirre.theme'.init()
    require 'kirre.languages'.init()
    require 'kirre.chatgpt'.init()
    require 'kirre.floaterm'.init()
    require 'kirre.noice'.init()
    require 'kirre.telescope'.init()
    require 'kirre.cmp'.init()
end

return {
    init = init,
}
