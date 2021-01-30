resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
author 'P4NDA_GamingV2 & oSLaYN'
description 'esx_gym Adapted To 3QRP Skills by oSLaYN'

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua',
  'config.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'client/main.lua',
  'config.lua'
}

export "UpdateSkill"

dependecies {
  'es_extended',
  'slayn_notify'
}