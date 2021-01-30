Config = {}

Config.UpdateFrequency = 1500

Config.Skills = {
    ["Stamina"] = {
        ["Current"] = 20,
        ["RemoveAmount"] = -0.3,
        ["Stat"] = "MP0_STAMINA"
    },

    ["Força"] = {
        ["Current"] = 10,
        ["RemoveAmount"] = -0.3,
        ["Stat"] = "MP0_STRENGTH"
    },

    ["Respiração"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.1,
        ["Stat"] = "MP0_LUNG_CAPACITY"
    },

    --[[["Disparar"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.1,
        ["Stat"] = "MP0_SHOOTING_ABILITY"
    },]] -- FUTURAMENTE

    ["Cavalinhos"] = {
        ["Current"] = 0,
        ["RemoveAmount"] = -0.2,
        ["Stat"] = "MP0_WHEELIE_ABILITY"
    }
}
