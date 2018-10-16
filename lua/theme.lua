-- global
mfc_campaign = {
   current_initiative = {}
}

-- shows initiative order when present
local old_unit_weapons = wesnoth.theme_items.unit_weapons

function wesnoth.theme_items.unit_weapons()
   local u = wesnoth.get_displayed_unit()
   if not u then return {} end

   local s = old_unit_weapons()

   local function display_initiative(initiative)
      s[#s+1] = {
         "element", {
            text = "\n<span color='#a69275'><i>Initiative</i></span>\n",
      }}

      for _, order in ipairs(initiative) do
         value, name, _ = table.unpack(order)
         s[#s+1] = {
            "element", {
               text = string.format("<span color='#f5e6c1'>  %s</span>: %s\n", name, value)
         }}
      end
   end

   if #mfc_campaign.current_initiative > 0 then
      display_initiative(mfc_campaign.current_initiative)
   end

   return s
end
