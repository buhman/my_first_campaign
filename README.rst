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

todo
----

dungeon mastering
^^^^^^^^^^^^^^^^^

From a GM perspective, there are a few ~critical things that are missing by
default; most of these should probably be done before using this in a "real"
game:

* ad-hoc terrain modification(?)
* ad-hoc item placement
* forced player movement (need to check for walkable destination)
* emote-as (also emote for players)

These are, mechanically very easy. The hardest part of most of these will be
building sane UI, which no doubt after doing all of these I will very learned
in.

playing
^^^^^^^

* blink/misty step

I could also just use the surprise rules instead of initiative, which might be
ok, actually.

maps
^^^^

Map-making is ridiculously hard. You not only want something that looks good,
but it also needs to have a correct/consistent scale for combat, etc..

It would be an interesting experiment, if combat always transitioned to a
separate battle map, while exploration was always on an "overworld".
