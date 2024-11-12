local wezterm = require "wezterm"

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Основные цвета терминала, курсора и выделения для комфорта при долгом использовании
config.colors = {
    foreground = "#CBE0F0",          -- Основной цвет текста: мягкий светло-голубой для легкого восприятия
    background = "#011423",          -- Фон терминала: темный, чтобы не напрягать глаза
    cursor_bg = "#47FF9C",           -- Цвет курсора: контрастный, чтобы его было легко найти
    cursor_border = "#47FF9C",       -- Граница курсора для визуального акцента
    cursor_fg = "#011423",           -- Цвет текста внутри курсора для читаемости
    selection_bg = "#033259",        -- Фон выделения: темно-синий, создающий легкий контраст
    selection_fg = "#CBE0F0",        -- Цвет текста при выделении для удобства чтения
    ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" }, -- Базовые цвета
    brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" }, -- Яркие цвета
}

-- Настройки цветовой схемы для панели вкладок, делая активные и неактивные вкладки легко различимыми
config.colors.tab_bar = {
    background = "#011423", -- Фон панели вкладок совпадает с фоном окна для визуального единства
    active_tab = {
        bg_color = "#2E8B57",    -- Фон активной вкладки: насыщенный зеленый для выделения
        fg_color = "#FFFFFF",    -- Белый текст активной вкладки для четкости
    },
    inactive_tab = {
        bg_color = "#3B3B3B",    -- Фон неактивных вкладок: темно-серый для приглушенного вида
        fg_color = "#A0C4FF",    -- Светло-голубой текст неактивных вкладок для различимости
    },
    inactive_tab_hover = {
        bg_color = "#47FF9C",    -- При наведении: контрастный зеленый, чтобы вкладка выделялась
        fg_color = "#011423",    -- Цвет текста при наведении для контраста с зеленым
    },
    new_tab = {
        bg_color = "#0FC5ED",    -- Кнопка новой вкладки: яркий синий для акцента
        fg_color = "#011423",    -- Цвет текста на кнопке новой вкладки
    },
    new_tab_hover = {
        bg_color = "#FFE073",    -- Цвет кнопки новой вкладки при наведении: золотой для акцента
        fg_color = "#011423",    -- Темный цвет текста на кнопке новой вкладки при наведении
    },
}

-- Прозрачность окна и размытие для macOS
config.window_background_opacity = 0.75      -- Прозрачность окна для приятного восприятия
config.macos_window_background_blur = 10     -- Размытие фона на macOS для мягкого эффекта

-- Настройки шрифта
config.font = wezterm.font("JetBrainsMono Nerd Font") -- Шрифт текста в терминале
config.font_size = 16                                -- Размер шрифта для удобства чтения

-- Параметры окна
config.window_decorations = "RESIZE"                 -- Включение возможности изменения размера окна

-- Горячие клавиши для управления вкладками и панелями
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 } -- Лидер-клавиша (CTRL+a)
config.keys = {
    { mods = "LEADER", key = "c", action = wezterm.action.SpawnTab "CurrentPaneDomain" },  -- Открытие новой вкладки
    { mods = "LEADER", key = "x", action = wezterm.action.CloseCurrentPane { confirm = true } }, -- Закрытие панели с подтверждением
    { mods = "LEADER", key = "b", action = wezterm.action.ActivateTabRelative(-1) },  -- Переключение на предыдущую вкладку
    { mods = "LEADER", key = "n", action = wezterm.action.ActivateTabRelative(1) },   -- Переключение на следующую вкладку
    { mods = "LEADER", key = "|", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } }, -- Горизонтальное разделение панели
    { mods = "LEADER", key = "-", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },   -- Вертикальное разделение панели
    { mods = "LEADER", key = "h", action = wezterm.action.ActivatePaneDirection "Left" },  -- Фокус на панели слева
    { mods = "LEADER", key = "j", action = wezterm.action.ActivatePaneDirection "Down" },  -- Фокус на панели снизу
    { mods = "LEADER", key = "k", action = wezterm.action.ActivatePaneDirection "Up" },    -- Фокус на панели сверху
    { mods = "LEADER", key = "l", action = wezterm.action.ActivatePaneDirection "Right" }, -- Фокус на панели справа
    { mods = "LEADER", key = "LeftArrow", action = wezterm.action.AdjustPaneSize { "Left", 5 } },    -- Изменение размера панели влево
    { mods = "LEADER", key = "RightArrow", action = wezterm.action.AdjustPaneSize { "Right", 5 } },  -- Изменение размера панели вправо
    { mods = "LEADER", key = "DownArrow", action = wezterm.action.AdjustPaneSize { "Down", 5 } },    -- Изменение размера панели вниз
    { mods = "LEADER", key = "UpArrow", action = wezterm.action.AdjustPaneSize { "Up", 5 } },        -- Изменение размера панели вверх
}

-- Клавиши для быстрого доступа к вкладкам по номеру
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i - 1), -- Переключение на вкладку по номеру
    })
end

-- Настройки панели вкладок и индексов
config.hide_tab_bar_if_only_one_tab = false -- Показывать панель вкладок, даже если открыта одна вкладка
config.tab_bar_at_bottom = true            -- Расположить панель вкладок внизу окна для удобства
config.use_fancy_tab_bar = false           -- Отключить декоративную панель вкладок для минимализма
config.tab_and_split_indices_are_zero_based = false -- Нумерация вкладок и панелей начинается с 1 для наглядности

-- Статусная панель для отображения лидер-режима и активного окна
wezterm.on("update-right-status", function(window, _)
    local prefix = ""
    local SOLID_LEFT_ARROW = ""
    local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }

    if window:leader_is_active() then
        prefix = " " .. utf8.char(0x1F9F2) -- Значок магнита для индикации лидер-режима
        SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    end

    if window:active_tab():tab_id() ~= 0 then
        ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } } -- Темный цвет стрелки, если активная вкладка не первая
    end

    window:set_left_status(wezterm.format {
        { Background = { Color = "#b7bdf8" } }, -- Фон для левой части статусной панели
        { Text = prefix },
        ARROW_FOREGROUND,
        { Text = SOLID_LEFT_ARROW }
    })
end)

return config
