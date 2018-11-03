require "functional"

local dialog = require "dialogs/macros/attack_page" -- for buttons
local engine = require "eval/engine"

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

local function single_attack(result)
   local ad_expr = attack_dice[result.fields.advantage](result.fields.attack_die)

   wesnoth.message(ad_expr)

   local attack_roll = engine.eval_single(ad_expr)
   local success_type = critical[attack_roll]
   local damage_roll = damage[success_type](result.fields.damage_dice)

   local outcome = {
      critical = success_type == "success",
      attack = attack_roll + engine.eval_single(result.fields.attack_mod),
      damage = damage_roll + engine.eval_single(result.fields.damage_mod),
      extra = engine.eval_single(result.fields.extra),
   }

   return outcome
end

local function attack_handler(result)
   -- roll attack dice

   local res = map(single_attack, repeat_n(result, result.fields.multiattack))
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
