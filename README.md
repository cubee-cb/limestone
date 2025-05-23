# limestone (internal name) / Midlink (working title)

It really has nothing to do with limestone, that's just the first name that came to mind cause the level is grey.

Release version is currently on commit `c4fd4b3`, [here on itch.io](https://pixelshock.itch.io/midlink?password=midlink), lacking:
- Couple new/edited rounds
- Some new items, some reworked/rebalanced items.
- Functional cannon enemy
- General fixes
- Etc...

Currently on the table:
- Modifying the player's "model", like adding accessories and replacing parts. Needs:
    - Proper player rendering. Needs:
        - Multispr editor for Picotron Multispr
- Proper player base attacks (punching, etc). Needs:
    - Proper hitboxes implementation
    - Arbitrary AABB function (current one specifically uses entity.hitbox)
- Create more enemies
- Add more rounds
- Implement more items
    - Finish more unimplemented upgrades
    - Create body part items

And future ideas:
- More "vessels" that change how the player behaves or what they can do, maybe even item pools, vessel-specific items.
- More arenas
- Different round lists

---

Anyway I'd call this a "horde defence" game.

It's kinda like if Vampire Survivors was a platformer but also had a tower to defend.

Takes elements from the following:
- Vampire Survivors
    - Points from enemies.
    - "Store" with upgrades.
- Bloons TD
    - Lives and leak rules.
    - Round structure.
- Towerfall
    - Randomised entrances.
    - Manual aiming.
- References
    - Gunboots
        - Based on Downwell's gunboots.
    - Nemesis
        - Cave Story: weapon of the same name, and hat.
            - needs the points to reduce its power or something to pay homage to the weapon properly.
        - Laser Bird (old prototype): laser projectile.
    - Charge Dash
        - Visual is based on Sonic's spin dash.
    - Revolver
        - It's specifically the one from BEATWISE TRIGGER.
    - Spectral Impulse
        - Based on Lilith's spirit power from 20 Minutes Till Dawn.
        - behaves like the Demond Ghosts from New Game+ mode in Ninja Cat Remewstered.
    - Blade Aura
        - Maelstrom ability from Bloons Tower Defence.
    - Big Rock
        - Yuuto Ichika's boulder from Super Ledgehop: Double Laser, and her Rivals of Aether mod.
    - Telefragger
        - Functionality based on Quake's telefrags and Sonic's Homing Attack.
            - It only "telefrags" enemies with less health that it does damage, but it has high damage to compensate.
        - Item graphic loosely based on Terrors of Nowhere's teleporter and the Gamblecore machine's button.
    - Strobe enemy
        - Head is based on the Sun from Oneshot.

