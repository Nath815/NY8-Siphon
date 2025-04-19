
lua54 'yes'
fx_version 'cerulean'
game 'gta5'

description 'Siphonnage de véhicule via ox_target'
author 'nath_815'
version '1.0.0'

shared_script '@ox_lib/init.lua'

client_scripts {
    'client/siphon.lua'
}

server_scripts {
    '@es_extended/imports.lua',
    'server/siphon.lua'
}
