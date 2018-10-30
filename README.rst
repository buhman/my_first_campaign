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

what's next
-----------

Some of this code is reusable, but much needs to be reworked (like emote, for
example). The ugliest part is is the wml <-> lua (<-> lisp) boundary, and I'd
like to escape the everything-is-a-wml_action pattern I overused here.

There are several engine limitations that might be hard to fix; namely:

* no simultaneous turns
* spellcasting could be so much better if the selection api allowed more than movement
* similarly, ranged attacks aren't possible

Modifying Wesnoth itself to accomodate these might be not terribly hard, but
then there are other lesser issues to consider:

* 72x72 is a bit limiting
* Lua API could be better (and is getting better in 1.15)
* UI modification is a bit limited outside of the dialog API

Worth considering might be to ground-up write exactly what I want from a more
generic game engine, but also is a lot of work.
