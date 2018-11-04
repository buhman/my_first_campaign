require "functional"

local save_fields = {
   "advantage",
   "multiattack",
   "attack_die",
   "attack_mod",
   "damage_dice",
   "damage_mod",
   "extra",
}

local defaults = {
   tab_order = {"monk", "generic"},
   tab_defaults = {
      monk = {
         advantage = 2,
         multiattack = 2,
         attack_die = "d20",
         attack_mod = "9",
         damage_dice = "1d8s",
         damage_mod = "5 + (1d10s)d4s",
         extra = "1d8s",
      },
   }
}

local advantage_types = {"advantage", "normal", "disadvantage"}

-- callbacks

local function select_tab(page_index)
   local tab_index = wesnoth.get_dialog_value("macro_pages", page_index, "preset_tabs")
   local tab_id = defaults.tab_order[tab_index]
   local tab_defaults = defaults.tab_defaults[tab_id]

   for field_id, value in pairs(tab_defaults) do
      wesnoth.set_dialog_value(value, "macro_pages", page_index, field_id)
   end
end

-- preshows

local function preshow_advantage(page_index)
   -- presets depends on advantage being initialized
   -- XXX just do this with list_data?
   for i, s in ipairs(advantage_types) do
      wesnoth.set_dialog_value(s, "macro_pages", page_index, "advantage", i, "advantage_label")
   end
end

local function preshow_presets(page_index)
   for i, s in ipairs(defaults.tab_order) do
      wesnoth.set_dialog_value(s, "macro_pages", page_index, "preset_tabs", i, "preset_tabs_label")
   end
end

local function preshow(page_index)
   local st = partial(select_tab, page_index)

   preshow_advantage(page_index)
   preshow_presets(page_index)

   -- callbacks

   wesnoth.set_dialog_callback(st, "macro_pages", page_index, "preset_tabs")
   st()
end

-- postshow

local function postshow(page_index, result)
   local tab_index = wesnoth.get_dialog_value("macro_pages", page_index, "preset_tabs")
   -- XXX maybe we want to store a "tab_id" instead?
   result.tab_index = tab_index

   result.fields = {}
   for _, field_id in ipairs(save_fields) do
      result.fields[field_id] = wesnoth.get_dialog_value("macro_pages", page_index, field_id)
   end
end

--

return {
   preshow = preshow,
   postshow = postshow,
}
