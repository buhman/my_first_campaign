require "functional"

local dialog = require "dialogs/macros"

local attack_page_dialog = require "macros/attack_page"
local attack_page_handler = require "macros/attack_page/handler"

local json = require "json"

--[[
This is documented terribly, the API isn't consistent at all, so I had to
RTFS. from scripting/lua_gui2.cpp:

   set_dialog_value : mp->select_page
   get_dialog_value : mp->get_selected_page
   add_dialog_tree_node : mp->add_page
   remove_dialog_item : mp->remove_page

   set_dialog_value : tvn->fold/unfold
   get_dialog_value : tvn->describe_path
]]--

local function select_page()
   local i = wesnoth.get_dialog_value("macro_list")
   wesnoth.set_dialog_value(i, "macro_pages")
end

local pages = {
   attack = {
      definition = "attack_page",
      dialog = attack_page_dialog,
      handler = attack_page_handler,
   }
}

local page_order = {"attack"}

-- XXX: dead code
local function set_defaults(page_index, defaults)
   for widget_id, value in pairs(defaults) do
      if type(value) == "string" then
         wesnoth.set_dialog_value(value, "macro_pages", page_index, widget_id)
      elseif type(value) == "table" then
         for ix, item in ipairs(value) do
            wesnoth.set_dialog_value(value, "macro_pages", page_index, widget_id, ix)
         end
      end
   end
end

local function preshow()
   for page_index, page_name in ipairs(page_order) do
      local page = pages[page_name]

      -- add_dialog_tree_node's api is bad wesnoth/wesnoth#3680
      wesnoth.add_dialog_tree_node(page.definition, page_index - 1, "macro_pages")
      wesnoth.set_dialog_value(page_name, "macro_list", page_index, "macro_name")

      -- page-specific preshow
      page.dialog.preshow(page_index)
   end

   wesnoth.set_dialog_callback(select_page, "macro_list")
   select_page()
end

local function postshow(result)
   -- prepare for dispatch to the macro page
   local page_index = wesnoth.get_dialog_value("macro_pages")
   local page_id = page_order[page_index]

   result.page_id = page_id

   -- create separate namespace for the page postshow
   result.page_result = {}
   pages[page_id].dialog.postshow(page_index, result.page_result)
end

function wml_actions.show_macros(cfg)
   local function show_macro_dialog()
      local result = {}
      result.return_code = wesnoth.show_dialog(dialog, preshow, partial(postshow, result))

      -- lol, luaW_toconfig doesn't support nested tables, zzz
      return { result = json.encode(result) }
   end

   local result_json = wesnoth.synchronize_choice("show_macros", show_macro_dialog)

   local result = json.decode(result_json.result)

   -- dialog cancelled
   if result.return_code == -2 then
      return
   end

   pages[result.page_id].handler(result.return_code, result.page_result)
end
