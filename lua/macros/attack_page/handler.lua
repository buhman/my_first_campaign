require "functional"

local dialog = require "dialogs/macros/attack_page" -- for buttons
local engine = require "eval/engine"
local show_results = require "macros/attack_page/result"

local attack_dice = {
   -- XXX meh hardcoded constants
   [1] = function(die) return "2" .. die .. "kh" end,
   [2] = function(die) return "1" .. die .. "s" end,
   [3] = function(die) return "2" .. die .. "kl" end,
}

local critical = {
   [20] = "success",
   [1] = "failure",
}
setmetatable(critical, {__index = function () return "regular" end})

local function repeat_roll(n, expr)
   return foldr(operator.add, 0, map(engine.eval_single, repeat_n(expr, n)))
end

local damage = {
   success = partial(repeat_roll, 2),
   failure = partial(repeat_roll, 0),
   regular = partial(repeat_roll, 1),
}

local function expr_add(n, expr)
   return table.concat(repeat_n(expr, n), " + ")
end

local damage_expr = {
   success = partial(expr_add, 2),
   failure = partial(expr_add, 0),
   regular = partial(expr_add, 1),
}

local damage_color = {
   success = "green",
   failure = "red",
}

local function single_attack(fields)
   local ad_expr = attack_dice[fields.advantage](fields.attack_die)

   local attack_roll = engine.eval_single(ad_expr)
   local success_type = critical[attack_roll]
   local damage_roll = damage[success_type](fields.damage_dice)

   local outcome = {
      --critical = success_type == "success",
      attack = {
         color = damage_color[success_type],
         value = attack_roll + engine.eval_single(fields.attack_mod),
      },
      damage = {
         value = damage_roll + engine.eval_single(fields.damage_mod),
      },
      extra = {
         value = engine.eval_single(fields.extra),
      }
   }

   return outcome
end

local function attack_handler(result)
   -- roll attack dice

   local fields = result.fields

   local attacks = map(single_attack, repeat_n(result.fields, result.fields.multiattack))

   local attack = attack_dice[fields.advantage](fields.attack_die) .. " + " .. fields.attack_mod
   local damage = "critical?(" .. fields.damage_dice .. ") + " .. fields.damage_mod
   local tooltips = {
      attack = attack,
      damage = damage,
      extra = fields.extra,
   }

   show_results(tooltips, attacks)
end

local function save_handler(result)
   wesnoth.message('save')
end

-- lua's table model is fucking stupid; luckly we don't need to iterate through this
local handlers = {
   [dialog.buttons.attack] = attack_handler,
   [dialog.buttons.save] = save_handler,
   -- default
   [-1] = attack_handler,
}

local function handler(return_code, result)
   --[[
      {
        tab_index = 1,
        fields = {
          attack_mod = "9",
          advantage = 2,
          multiattack = 2,
          extra = "1d8s",
          attack_die = "d20",
          damage_dice = "1d8s",
          damage_mod = "5 + (1d10s)d6s",
        }
      }
   ]]--

   -- handler dispatch
   handlers[return_code](result)
end

return handler
