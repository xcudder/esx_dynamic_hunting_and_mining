fx_version 'adamant'

game 'gta5'

description 'Hunting'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
}

client_scripts {
	'helpers.lua',
	'rocks.lua',
	'drops.lua',
	'buyers.lua',
	'license_giver.lua',
}

dependencies {
    'es_extended',
    'ox_inventory'
}