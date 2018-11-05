require "functional"

local function unit_for_side(side)
   local units = wesnoth.get_units {
      side = side,
      canrecruit = true,
   }

   return units[1]
end

local function side_list()
   local t = {}
   for i, _ in ipairs(wesnoth.sides) do
      table.insert(t, i)
   end

   return t
end

local function swap_keys(tbl)
   local t = {}
   for k, v in pairs(tbl) do
      t[v] = k
   end
   return t
end

function get_tag(tag_name, wml)
   local t = filter(function (v) return v[1] == tag_name end, wml)
   local t = map(function(i) return i[2] end, t)
   assert(#t == 1)
   return t[1]
end

function unit_halo_oneshot(unit, image, effect_id)
   local frame = T.extra_frame {
      start_time = 0,
      image = image,
   }
   local effects = {
      id = effect_id,
      T.effect {
         apply_to = "new_animation",
         T.extra_anim {
            flag = effect_id,
            frame,
         },
      }
   }

   wesnoth.add_modification(unit, "object", effects)

   wml_actions.animate_unit {
      T.filter {
         id = unit.id,
      },
      with_bars = true,
      flag = effect_id,
   }
end

return {
   unit_for_side = unit_for_side,
   side_list = side_list,
   swap_keys = swap_keys,
   get_tag = get_tag,
}
