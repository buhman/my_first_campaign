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

local default_fields = {
   advantage = 2,
   multiattack = 2,
   attack_die = "d20",
   attack_mod = "9",
   damage_dice = "1d8s",
   damage_mod = "5 + (1d10s)d4s",
   extra = "",
}

local advantage_types = {"advantage", "normal", "disadvantage"}

-- helpers

local function get_fields(page_index)
   local fields = {}
   for _, field_id in ipairs(save_fields) do
      fields[field_id] = wesnoth.get_dialog_value("macro_pages", page_index, field_id)
   end
   return fields
end

-- profile variable access

local function save_profile(tab_index, fields)
   local profiles = wml.array_access.get("macro_attack_profiles", wesnoth.current.side)

   profiles[tab_index] = fields

   wml.array_access.set("macro_attack_profiles", profiles, wesnoth.current.side)

   return profiles
end

local function delete_profile(tab_index)
   local tabs = wml.array_access.get("macro_attack_tabs", wesnoth.current.side)
   local profiles = wml.array_access.get("macro_attack_profiles", wesnoth.current.side)

   tabs = filter_index(function (i) return tab_index ~= i end, tabs)
   profiles = filter_index(function (i) return tab_index ~= i end, profiles)

   wml.array_access.set("macro_attack_tabs", tabs, wesnoth.current.side)
   wml.array_access.set("macro_attack_profiles", profiles, wesnoth.current.side)

   return tabs, profiles
end

local function create_profile(tab_name, fields)
   local tabs = wml.array_access.get("macro_attack_tabs", wesnoth.current.side)
   local profiles = wml.array_access.get("macro_attack_profiles", wesnoth.current.side)

   table.insert(tabs, {name = tab_name})
   table.insert(profiles, fields)

   wml.array_access.set("macro_attack_tabs", tabs, wesnoth.current.side)
   wml.array_access.set("macro_attack_profiles", profiles, wesnoth.current.side)

   return tabs, profiles
end

-- callbacks

local function select_tab(page_index)
   local tab_index = wesnoth.get_dialog_value("macro_pages", page_index, "preset_tabs")
   local profiles = wml.array_access.get("macro_attack_profiles", wesnoth.current.side)
   local fields = profiles[tab_index]

   -- disable entry if no profile is selected
   if tab_index == 0 then
      for _, field_id in ipairs(save_fields) do
         if field_id == "multiattack" or field_id == "advantage" then
            wesnoth.set_dialog_value(2, "macro_pages", page_index, field_id)
         else
            wesnoth.set_dialog_value("", "macro_pages", page_index, field_id)
         end
         wesnoth.set_dialog_active(false, "macro_pages", page_index, field_id)
      end
   else
      for field_id, value in pairs(fields) do
         wesnoth.set_dialog_active(true, "macro_pages", page_index, field_id)
         wesnoth.set_dialog_value(value, "macro_pages", page_index, field_id)
      end
   end
end

local function create_tab(page_index)
   local dialog = make_dialog {
      id = "profile_name",
      label = "New profile name?",
   }

   local profile_name

   local function postshow()
      profile_name = wesnoth.get_dialog_value("profile_name")
   end

   wesnoth.show_dialog(dialog, function () end, postshow)

   local tabs, _ = create_profile(profile_name, default_fields)
   wesnoth.set_dialog_value(tabs[#tabs].name, "macro_pages", page_index, "preset_tabs", #tabs, "preset_tabs_label")
   -- also select the new tab
   wesnoth.set_dialog_value(#tabs, "macro_pages", page_index, "preset_tabs")
   select_tab(page_index)
end

local function delete_tab(page_index)
   local tab_index = wesnoth.get_dialog_value("macro_pages", page_index, "preset_tabs")
   if tab_index == 0 then
      -- no more tabs
      return
   end
   local tabs = wml.array_access.get("macro_attack_tabs", wesnoth.current.side)
   -- XXX seems like a wesnoth bug? deleting the last item in a listmenu has odd behavior
   if #tabs == 1 then
      -- don't delete last tab
      return
   end

   wesnoth.remove_dialog_item(tab_index, 1, "macro_pages", page_index, "preset_tabs")

   delete_profile(tab_index)
   select_tab(page_index)
end

local function save_tab(page_index)
   local tab_index = wesnoth.get_dialog_value("macro_pages", page_index, "preset_tabs")

   local fields = get_fields(page_index)

   save_profile(tab_index, fields)
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
   -- create a default profile if they don't already have one
   local tabs = wml.array_access.get("macro_attack_tabs", wesnoth.current.side)
   if #tabs == 0 then
      -- I hate lua
      tabs = create_profile("monk", default_fields)
   end

   for i, tab in ipairs(tabs) do
      wesnoth.set_dialog_value(tab.name, "macro_pages", page_index, "preset_tabs", i, "preset_tabs_label")
   end
end

local function preshow(page_index)
   local st = partial(select_tab, page_index)
   local svt = partial(save_tab, page_index)
   local dt = partial(delete_tab, page_index)
   local ct = partial(create_tab, page_index)

   preshow_advantage(page_index)
   preshow_presets(page_index)

   -- callbacks

   wesnoth.set_dialog_callback(st, "macro_pages", page_index, "preset_tabs")
   st()

   wesnoth.set_dialog_callback(svt, "macro_pages", page_index, "save_profile")
   wesnoth.set_dialog_callback(ct, "macro_pages", page_index, "create_profile")
   wesnoth.set_dialog_callback(dt, "macro_pages", page_index, "delete_profile")
end

-- postshow

local function postshow(page_index, result)
   local tab_index = wesnoth.get_dialog_value("macro_pages", page_index, "preset_tabs")
   -- XXX maybe we want to store a "tab_id" instead?
   result.tab_index = tab_index

   result.fields = get_fields(page_index)
end

--

return {
   preshow = preshow,
   postshow = postshow,
}
