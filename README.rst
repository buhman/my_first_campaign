=================
my_first_campaign
=================

An exploration in implementing a ~semi-generic virtual tabletop in `Wesnoth
<https://wesnoth.org>`_, as a multiplayer campaign.

why
---

Compared to roll20, Wesnoth has several features that I see as desirable enough
to make developing on it worthwile:

* robust event system (tabletop automation, traps, etc..)
* tile-based (runtime) map editing
* semantic vision obstruction (no separate lighting layer)
* variable terrain difficulty (tedious to compute by hand)
* unit pathing and movement restriction
* granular vision sharing (team pvp in roll20 is basically impossible)
* better performance
* better extensibility

features
--------

All of these are already implemented and work correctly in MP.

* expression evaluator with compound dice rolls (e.g: `2d20kh + 5` for an advantage roll with modifier)
* ad-hoc door manipulation
* ad-hoc scenario/map transitions
* ad-hoc unit placement
* initiative tracking with turn order enforcement
* distance measurement
* spellcasting (several abilities implemented)
* forced player movement (could be improved)
* character emote
* ad-hoc ability grants
