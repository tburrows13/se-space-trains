local space_train_light_color = {
    r = 0.25,
    g = 0.25,
    b = 0.8,
    a = 0.25
}
local train_scale = 0.425
local fluid_wagon_scale = 0.375
local cargo_wagon_scale = 0.4
local wagon_vertical_shift = -0.8
local connection_length = 3
local train_speed = 2.4
local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

function space_accumulator_picture(tint, repeat_count)
    return {
        layers = {{
            filename = "__se-space-trains__/graphics/entity/space-train-charging-station/space_charging_station.png",
            priority = "high",
            width = 64,
            height = 96,
            repeat_count = repeat_count,
            shift = util.by_pixel(0, -16),
            tint = tint,
            animation_speed = 0.5,
            scale = 1,
            hr_version = {
                filename = "__se-space-trains__/graphics/entity/space-train-charging-station/hr_space_charging_station.png",
                priority = "high",
                width = 128,
                height = 192,
                repeat_count = repeat_count,
                shift = util.by_pixel(0, -16),
                tint = tint,
                animation_speed = 0.5,
                scale = 0.5
            }
        }, {
            filename = "__se-space-trains__/graphics/entity/space-train-charging-station/space_charging_station_shadow.png",
            priority = "high",
            width = 144,
            height = 45,
            repeat_count = repeat_count,
            shift = util.by_pixel(32, 11),
            draw_as_shadow = true,
            scale = 1,
            hr_version = {
                filename = "__se-space-trains__/graphics/entity/space-train-charging-station/hr_space_charging_station_shadow.png",
                priority = "high",
                width = 285,
                height = 91,
                repeat_count = repeat_count,
                shift = util.by_pixel(32, 11),
                draw_as_shadow = true,
                scale = 0.5
            }
        }}
    }
end

function space_accumulator_charge()
    return {
        layers = {space_accumulator_picture({
            r = 1,
            g = 1,
            b = 1,
            a = 1
        }, 30), {
            filename = "__se-space-trains__/graphics/entity/space-train-charging-station/space_charging_station_lightning.png",
            priority = "high",
            width = 64,
            height = 96,
            line_length = 6,
            frame_count = 30,
            draw_as_glow = true,
            shift = util.by_pixel(0, -16),
            scale = 1,
            animation_speed = 3,
            hr_version = {
                filename = "__se-space-trains__/graphics/entity/space-train-charging-station/hr_space_charging_station_lightning.png",
                priority = "high",
                width = 128,
                height = 192,
                line_length = 6,
                frame_count = 30,
                draw_as_glow = true,
                shift = util.by_pixel(0, -16),
                scale = 0.5,
                animation_speed = 3
            }
        }}
    }
end

space_train_wheels = {
    priority = "very-low",
    width = 250,
    height = 150,
    direction_count = 256,
    filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/maglev_cushions_1.png",
                 "__se-space-trains__/graphics/entity/vehicles/space-trains/maglev_cushions_2.png"},
    line_length = 8,
    lines_per_file = 16,
    scale = 1.4 / 2,
    hr_version = {
        priority = "very-low",
        width = 500,
        height = 300,
        direction_count = 256,
        filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_maglev_cushions_1.png",
                     "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_maglev_cushions_2.png",
                     "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_maglev_cushions_3.png",
                     "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_maglev_cushions_4.png",
                     "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_maglev_cushions_5.png",
                     "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_maglev_cushions_6.png",
                     "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_maglev_cushions_7.png",
                     "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_maglev_cushions_8.png"},
        line_length = 4,
        lines_per_file = 8,
        shift = {0, 0.1}, -- original shifting from spritesheeter (likely needs doubling or halving)
        scale = 0.775 / 2
    }
}

data:extend({ -- Battery charging interface
{
    type = "assembling-machine",
    name = "space-train-battery-charging-station",
    icon = "__se-space-trains__/graphics/icons/space-train-charging-station.png",
    icon_size = 128,
    flags = {"placeable-neutral", "player-creation"},
    minable = {
        mining_time = 0.1,
        result = "space-train-battery-charging-station"
    },
    max_health = 150,
    resistances = {{
        type = "fire",
        percent = 70
    }},
    corpse = "accumulator-remnants",
    dying_explosion = "accumulator-explosion",
    collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
    selection_box = {{-1, -1}, {1, 1}},
    damaged_trigger_effect = hit_effects.entity(),
    drawing_box = {{-1, -1.5}, {1, 1}},
    energy_source = {
        type = "electric",
        buffer_capacity = "20MJ",
        usage_priority = "primary-input",
        input_flow_limit = "10MW",
        output_flow_limit = "0kW",
        drain = "500W"
    },
    fast_replaceable_group = "assembling-machine",
    always_draw_idle_animation = true,
    idle_animation = space_accumulator_picture(),
    working_visualisations = {{
        effect = "flicker",
        fadeout = true,
        light = {
            intensity = 0.2,
            size = 9.9,
            shift = {0.0, 0.0},
            color = {
                r = 0.25,
                g = 0.25,
                b = 0.8
            }
        }
    }, {
        effect = "flicker",
        fadeout = true,
        draw_as_light = true,
        animation = space_accumulator_charge()
    }},

    water_reflection = accumulator_reflection(),

    energy_usage = "1.7MW",
    crafting_categories = {"electrical"},
    crafting_speed = 1,
    fixed_recipe = "space-train-battery-pack-recharge",
    show_recipe_icon = false,

    vehicle_impact_sound = sounds.generic_impact,
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    working_sound = {
        sound = {
            filename = "__se-space-trains__/sound/space-charging-sound.ogg",
            volume = 0.35
        },
        idle_sound = {
            filename = "__base__/sound/accumulator-idle.ogg",
            volume = 0.3
        },
        -- persistent = true,
        max_sounds_per_type = 3,
        audible_distance_modifier = 0.5,
        fade_in_ticks = 4,
        fade_out_ticks = 20
    }
}, -- Actual Space Trains now
{
    type = "locomotive",
    name = "space-locomotive",
    icon = "__se-space-trains__/graphics/icons/space-locomotive.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
    minable = {
        mining_time = 1,
        result = "space-locomotive"
    },
    mined_sound = {
        filename = "__core__/sound/deconstruct-medium.ogg"
    },
    max_health = 1500,
    corpse = "locomotive-remnants",
    dying_explosion = "locomotive-explosion",
    collision_box = {{-0.6, -2.6}, {0.6, 2.6}},
    selection_box = {{-1, -3}, {1, 3}},
    drawing_box = {{-1, -4}, {1, 3}},
    alert_icon_shift = util.by_pixel(0, -24),
    damaged_trigger_effect = hit_effects.entity(),
    weight = 12000,
    max_speed = train_speed,
    max_power = "4MW",
    reversing_power_modifier = 1.0,
    braking_force = 40,
    friction_force = 0.50,
    vertical_selection_shift = -0.5,
    air_resistance = 0.0025, -- this is a percentage of current speed that will be subtracted
    connection_distance = connection_length,
    joint_distance = 4,
    energy_per_hit_point = 5,
    resistances = {{
        type = "fire",
        decrease = 20,
        percent = 75
    }, {
        type = "physical",
        decrease = 15,
        percent = 30
    }, {
        type = "impact",
        decrease = 50,
        percent = 75
    }, {
        type = "explosion",
        decrease = 15,
        percent = 30
    }, {
        type = "acid",
        decrease = 5,
        percent = 25
    }},
    burner = {
        fuel_category = "electrical",
        effectivity = 0.95,
        fuel_inventory_size = 3,
        burnt_inventory_size = 1
    },
    front_light = {{
        type = "oriented",
        minimum_darkness = 0.3,
        picture = {
            filename = "__core__/graphics/light-cone.png",
            priority = "extra-high",
            flags = {"light"},
            scale = 2,
            width = 200,
            height = 200
        },
        shift = {-0.6, -16},
        size = 2,
        intensity = 0.8,
        color = space_train_light_color
    }, {
        type = "oriented",
        minimum_darkness = 0.3,
        picture = {
            filename = "__core__/graphics/light-cone.png",
            priority = "extra-high",
            flags = {"light"},
            scale = 2,
            width = 200,
            height = 200
        },
        shift = {0.6, -16},
        size = 2,
        intensity = 0.8,
        color = space_train_light_color
    }},
    back_light = rolling_stock_back_light(),
    stand_by_light = rolling_stock_stand_by_light(),
    color = {
        r = 0.92,
        g = 0.07,
        b = 0,
        a = 0.5
    },
    pictures = {
        layers = {{
            dice = 4,
            priority = "very-low",
            width = 500,
            height = 300,
            direction_count = 256,
            allow_low_quality_rotation = true,
            filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_1.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_2.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_3.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_4.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_5.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_6.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_7.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_8.png"},
            line_length = 4,
            lines_per_file = 8,
            shift = {0, wagon_vertical_shift},
            scale = train_scale * 2,
            hr_version = {
                priority = "very-low",
                dice = 4,
                width = 1000,
                height = 600,
                direction_count = 256,
                allow_low_quality_rotation = true,
                filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_1.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_2.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_3.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_4.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_5.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_6.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_7.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_8.png"},
                line_length = 4,
                lines_per_file = 8,
                shift = {0, wagon_vertical_shift},
                scale = train_scale
            }
        }, {
            priority = "very-low",
            flags = {"mask"},
            dice = 4,
            width = 500,
            height = 300,
            direction_count = 256,
            allow_low_quality_rotation = true,
            filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_mask_1.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_mask_2.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_mask_3.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_mask_4.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_mask_5.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_mask_6.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_mask_7.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_mask_8.png"},
            line_length = 4,
            lines_per_file = 8,
            shift = {0, wagon_vertical_shift},
            apply_runtime_tint = true,
            scale = train_scale * 2,
            hr_version = {
                priority = "very-low",
                flags = {"mask"},
                dice = 4,
                width = 1000,
                height = 600,
                direction_count = 256,
                allow_low_quality_rotation = true,
                filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_mask_1.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_mask_2.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_mask_3.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_mask_4.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_mask_5.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_mask_6.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_mask_7.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_mask_8.png"},
                line_length = 4,
                lines_per_file = 8,
                shift = {0, wagon_vertical_shift},
                apply_runtime_tint = true,
                scale = train_scale
            }
        }, {
            priority = "very-low",
            dice = 4,
            flags = {"shadow"},
            width = 500,
            height = 300,
            direction_count = 256,
            draw_as_shadow = true,
            allow_low_quality_rotation = true,
            filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_shadows_1.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_shadows_2.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_shadows_3.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_shadows_4.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_shadows_5.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_shadows_6.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_shadows_7.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_shadows_8.png"},
            line_length = 4,
            lines_per_file = 8,
            shift = {0, wagon_vertical_shift},
            scale = train_scale * 2,
            hr_version = {
                priority = "very-low",
                flags = {"shadow"},
                width = 1000,
                height = 600,
                direction_count = 256,
                draw_as_shadow = true,
                allow_low_quality_rotation = true,
                filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_shadows_1.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_shadows_2.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_shadows_3.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_shadows_4.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_shadows_5.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_shadows_6.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_shadows_7.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_shadows_8.png"},
                line_length = 4,
                lines_per_file = 8,
                shift = {0, wagon_vertical_shift},
                scale = train_scale
            }
        }}
    },
    front_light_pictures = {
        layers = {{
            priority = "very-low",
            blend_mode = "additive",
            draw_as_light = true,
            tint = {
                r = 1.0,
                g = 1.0,
                b = 1.0,
                a = 0.25
            },
            width = 500,
            height = 300,
            direction_count = 256,
            allow_low_quality_rotation = true,
            filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_lights_front_1.png",
                        "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_lights_front_2.png",
                        "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_lights_front_3.png",
                        "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_lights_front_4.png",
                        "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_lights_front_5.png",
                        "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_lights_front_6.png",
                        "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_lights_front_7.png",
                        "__se-space-trains__/graphics/entity/vehicles/space-trains/space_locomotive_lights_front_8.png"},
            line_length = 4,
            lines_per_file = 8,
            shift = {0, wagon_vertical_shift},
            scale = train_scale * 2,
            hr_version = {
                priority = "very-low",
                blend_mode = "additive",
                draw_as_light = true,
                tint = {
                    r = 1.0,
                    g = 1.0,
                    b = 1.0,
                    a = 0.25
                },
                width = 1000,
                height = 600,
                direction_count = 256,
                allow_low_quality_rotation = true,
                filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_lights_front_1.png",
                            "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_lights_front_2.png",
                            "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_lights_front_3.png",
                            "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_lights_front_4.png",
                            "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_lights_front_5.png",
                            "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_lights_front_6.png",
                            "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_lights_front_7.png",
                            "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_locomotive_lights_front_8.png"},
                line_length = 4,
                lines_per_file = 8,
                shift = {0, wagon_vertical_shift},
                scale = train_scale
            }
        }}
    },
    minimap_representation = {
        filename = "__se-space-trains__/graphics/entity/vehicles/space-trains/space-locomotive-minimap-representation.png",
        flags = {"icon"},
        size = {20, 40},
        scale = 0.5
    },
    selected_minimap_representation = {
        filename = "__se-space-trains__/graphics/entity/vehicles/space-trains/space-locomotive-selected-minimap-representation.png",
        flags = {"icon"},
        size = {20, 40},
        scale = 0.5
    },
    wheels = space_train_wheels,
    stop_trigger = { -- left side
    {
        type = "create-trivial-smoke",
        repeat_count = 125,
        smoke_name = "smoke-train-stop",
        initial_height = 0,
        -- smoke goes to the left
        speed = {-0.03, 0},
        speed_multiplier = 0.75,
        speed_multiplier_deviation = 1.1,
        offset_deviation = {{-0.75, -2.7}, {-0.3, 2.7}}
    }, -- right side
    {
        type = "create-trivial-smoke",
        repeat_count = 125,
        smoke_name = "smoke-train-stop",
        initial_height = 0,
        -- smoke goes to the right
        speed = {0.03, 0},
        speed_multiplier = 0.75,
        speed_multiplier_deviation = 1.1,
        offset_deviation = {{0.3, -2.7}, {0.75, 2.7}}
    }, {
        type = "play-sound",
        sound = sounds.train_brakes
    }},
    --drive_over_tie_trigger = drive_over_tie(),
    --tie_distance = 50,
    vehicle_impact_sound = sounds.generic_impact,
    working_sound = {
        sound = {
            filename = "__se-space-trains__/sound/space-train-engine.ogg",
            volume = 0.4
        },
        match_speed_to_activity = true,
        max_sounds_per_type = 2
    },
    open_sound = {
        filename = "__base__/sound/train-door-open.ogg",
        volume = 0.5
    },
    close_sound = {
        filename = "__base__/sound/train-door-close.ogg",
        volume = 0.4
    },
    sound_minimum_speed = 0.5,
    water_reflection = locomotive_reflection()
}, {
    type = "cargo-wagon",
    name = "space-cargo-wagon",
    icon = "__se-space-trains__/graphics/icons/space-cargo-wagon.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
    inventory_size = 50,
    minable = {
        mining_time = 0.5,
        result = "space-cargo-wagon"
    },
    mined_sound = {
        filename = "__core__/sound/deconstruct-large.ogg",
        volume = 0.8
    },
    max_health = 600,
    corpse = "cargo-wagon-remnants",
    dying_explosion = "cargo-wagon-explosion",
    collision_box = {{-0.6, -2.4}, {0.6, 2.4}},
    selection_box = {{-1, -2.703125}, {1, 3.296875}},
    damaged_trigger_effect = hit_effects.entity(),
    vertical_selection_shift = -0.796875,
    weight = 1000,
    max_speed = train_speed,
    braking_force = 3,
    friction_force = 0.50,
    air_resistance = 0.01,
    connection_distance = connection_length,
    joint_distance = 4,
    energy_per_hit_point = 5,
    resistances = {{
        type = "fire",
        decrease = 15,
        percent = 50
    }, {
        type = "physical",
        decrease = 15,
        percent = 30
    }, {
        type = "impact",
        decrease = 50,
        percent = 60
    }, {
        type = "explosion",
        decrease = 15,
        percent = 30
    }, {
        type = "acid",
        decrease = 3,
        percent = 20
    }},
    back_light = rolling_stock_back_light(),
    stand_by_light = rolling_stock_stand_by_light(),
    color = {
        r = 0.43,
        g = 0.23,
        b = 0,
        a = 0.5
    },
    pictures = {
        layers = {{
            priority = "very-low",
            dice = 4,
            width = 500,
            height = 300,
            back_equals_front = true,
            direction_count = 128,
            allow_low_quality_rotation = true,
            filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_1.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_2.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_3.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_4.png"},
            line_length = 4,
            lines_per_file = 8,
            shift = {0, wagon_vertical_shift},
            scale = cargo_wagon_scale * 2,
            hr_version = {
                priority = "very-low",
                dice = 4,
                width = 1000,
                height = 600,
                back_equals_front = true,
                direction_count = 128,
                allow_low_quality_rotation = true,
                filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_1.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_2.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_3.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_4.png"},
                line_length = 4,
                lines_per_file = 8,
                shift = {0, wagon_vertical_shift},
                scale = cargo_wagon_scale
            }
        }, {
            flags = {"mask"},
            priority = "very-low",
            dice = 4,
            width = 500,
            height = 300,
            direction_count = 128,
            allow_low_quality_rotation = true,
            back_equals_front = true,
            apply_runtime_tint = true,
            shift = {0, wagon_vertical_shift},
            filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_mask_1.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_mask_2.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_mask_3.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_mask_4.png"},
            line_length = 4,
            lines_per_file = 8,
            scale = cargo_wagon_scale * 2,
            hr_version = {
                flags = {"mask"},
                priority = "very-low",
                dice = 4,
                width = 1000,
                height = 600,
                direction_count = 128,
                allow_low_quality_rotation = true,
                back_equals_front = true,
                apply_runtime_tint = true,
                shift = {0, wagon_vertical_shift},
                filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_mask_1.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_mask_2.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_mask_3.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_mask_4.png"},
                line_length = 4,
                lines_per_file = 8,
                scale = cargo_wagon_scale
            }
        }, {
            flags = {"shadow"},
            priority = "very-low",
            dice = 4,
            width = 500,
            height = 300,
            back_equals_front = true,
            draw_as_shadow = true,
            direction_count = 128,
            allow_low_quality_rotation = true,
            filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_shadows_1.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_shadows_2.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_shadows_3.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_cargo_wagon_shadows_4.png"},
            line_length = 4,
            lines_per_file = 8,
            shift = {0.8, wagon_vertical_shift},
            scale = cargo_wagon_scale * 2,
            hr_version = {
                flags = {"shadow"},
                priority = "very-low",
                dice = 4,
                width = 1000,
                height = 600,
                back_equals_front = true,
                draw_as_shadow = true,
                direction_count = 128,
                allow_low_quality_rotation = true,
                filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_shadows_1.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_shadows_2.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_shadows_3.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_cargo_wagon_shadows_4.png"},
                line_length = 4,
                lines_per_file = 8,
                shift = {0.8, wagon_vertical_shift},
                scale = cargo_wagon_scale
            }
        }}
    },
    minimap_representation = {
        filename = "__base__/graphics/entity/cargo-wagon/cargo-wagon-minimap-representation.png",
        flags = {"icon"},
        size = {20, 40},
        scale = 0.5
    },
    selected_minimap_representation = {
        filename = "__base__/graphics/entity/cargo-wagon/cargo-wagon-selected-minimap-representation.png",
        flags = {"icon"},
        size = {20, 40},
        scale = 0.5
    },
    wheels = space_train_wheels,
    --drive_over_tie_trigger = drive_over_tie(),
    --tie_distance = 50,
    working_sound = {
        sound = {
            filename = "__base__/sound/train-wheels.ogg",
            volume = 0.3
        },
        match_volume_to_activity = true
    },
    crash_trigger = crash_trigger(),
    open_sound = sounds.cargo_wagon_open,
    close_sound = sounds.cargo_wagon_close,
    sound_minimum_speed = 1,
    vehicle_impact_sound = sounds.generic_impact,
    water_reflection = locomotive_reflection()
}, {
    type = "fluid-wagon",
    name = "space-fluid-wagon",
    icon = "__se-space-trains__/graphics/icons/space-fluid-wagon.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
    minable = {
        mining_time = 0.5,
        result = "space-fluid-wagon"
    },
    mined_sound = {
        filename = "__core__/sound/deconstruct-large.ogg",
        volume = 0.8
    },
    max_health = 600,
    capacity = 30000,
    corpse = "fluid-wagon-remnants",
    dying_explosion = "fluid-wagon-explosion",
    collision_box = {{-0.6, -2.4}, {0.6, 2.4}},
    selection_box = {{-1, -2.703125}, {1, 3.296875}},
    damaged_trigger_effect = hit_effects.entity(),
    vertical_selection_shift = -0.796875,
    weight = 1000,
    max_speed = train_speed,
    braking_force = 3,
    friction_force = 0.50,
    air_resistance = 0.01,
    connection_distance = connection_length,
    joint_distance = 4,
    energy_per_hit_point = 6,
    resistances = {{
        type = "fire",
        decrease = 15,
        percent = 50
    }, {
        type = "physical",
        decrease = 15,
        percent = 30
    }, {
        type = "impact",
        decrease = 50,
        percent = 60
    }, {
        type = "explosion",
        decrease = 15,
        percent = 30
    }, {
        type = "acid",
        decrease = 3,
        percent = 20
    }},
    back_light = rolling_stock_back_light(),
    stand_by_light = rolling_stock_stand_by_light(),
    color = {
        r = 0.43,
        g = 0.23,
        b = 0,
        a = 0.5
    },
    pictures = {
        layers = {{
            priority = "very-low",
            dice = 4,
            width = 500,
            height = 300,
            back_equals_front = true,
            direction_count = 128,
            allow_low_quality_rotation = true,
            filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/space_fluid_wagon_1.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_fluid_wagon_2.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_fluid_wagon_3.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_fluid_wagon_4.png"},
            line_length = 4,
            lines_per_file = 8,
            shift = {0, -0.7},
            scale = train_scale * 2,
            hr_version = {
                priority = "very-low",
                dice = 4,
                width = 1000,
                height = 600,
                back_equals_front = true,
                direction_count = 128,
                allow_low_quality_rotation = true,
                filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_fluid_wagon_1.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_fluid_wagon_2.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_fluid_wagon_3.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_fluid_wagon_4.png"},
                line_length = 4,
                lines_per_file = 8,
                shift = {0, -0.7},
                scale = fluid_wagon_scale
            }
        }, {
            flags = {"shadow"},
            priority = "very-low",
            dice = 4,
            width = 500,
            height = 300,
            back_equals_front = true,
            draw_as_shadow = true,
            direction_count = 128,
            allow_low_quality_rotation = true,
            filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/space_fluid_wagon_shadows_1.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_fluid_wagon_shadows_2.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_fluid_wagon_shadows_3.png",
                         "__se-space-trains__/graphics/entity/vehicles/space-trains/space_fluid_wagon_shadows_4.png"},
            line_length = 4,
            lines_per_file = 8,
            shift = {0, -0.7},
            scale = train_scale * 2,
            hr_version = {
                flags = {"shadow"},
                priority = "very-low",
                dice = 4,
                width = 1000,
                height = 600,
                back_equals_front = true,
                draw_as_shadow = true,
                direction_count = 128,
                allow_low_quality_rotation = true,
                filenames = {"__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_fluid_wagon_shadows_1.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_fluid_wagon_shadows_2.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_fluid_wagon_shadows_3.png",
                             "__se-space-trains__/graphics/entity/vehicles/space-trains/hr_space_fluid_wagon_shadows_4.png"},
                line_length = 4,
                lines_per_file = 8,
                shift = {0, -0.7},
                scale = fluid_wagon_scale
            }
        }}
    },
    minimap_representation = {
        filename = "__base__/graphics/entity/fluid-wagon/fluid-wagon-minimap-representation.png",
        flags = {"icon"},
        size = {20, 40},
        scale = 0.5
    },
    selected_minimap_representation = {
        filename = "__base__/graphics/entity/fluid-wagon/fluid-wagon-selected-minimap-representation.png",
        flags = {"icon"},
        size = {20, 40},
        scale = 0.5
    },
    wheels = space_train_wheels,
    --drive_over_tie_trigger = drive_over_tie(),
    --tie_distance = 50,
    working_sound = {
        sound = {
            filename = "__base__/sound/train-wheels.ogg",
            volume = 0.3
        },
        match_volume_to_activity = true
    },
    crash_trigger = crash_trigger(),
    sound_minimum_speed = 0.1,
    vehicle_impact_sound = sounds.generic_impact,
    water_reflection = locomotive_reflection()
}})
