require("Object")

Actor = Object:extend()

function Actor:hook_gameTick()
    -- Default behaviour: Do nothing.
end

function hook_playerInput(key)
    -- Default behaviour: Do nothing.
    -- Only keys meant to control the player snake will reach this.
    -- These are currently: "up", "down", "left" and "right".
end

function Actor:hook_cellDestroyed(cell, destroyer)
    -- Default behaviour: Do nothing.
end

function Actor:hook_cellClaimRequest(cell)
    -- Default behaviour: Do nothing.

    -- Called when another Actor requests a cell owned by this Actor.
    -- If this Actor is willing to release the cell, this function must
    -- do so. This Actor is responsible for any cleanup it might need to do
    -- as a result of releasing the cell, just as when releasing it normally.
end

function Actor:hook_pellet()
    -- Default behaviour: Do nothing.

    -- Called when the actor picks up (destroys) a pellet.
end

function Actor:hook_teleport(cell, direction)
    -- Default behaviour: Do nothing (return the same cell).

    -- Called by a cell when something checks for a teleport through it.
    -- You get the cell that was checked and, if applicable, the direction a
    -- thing expects to go through it. The direction is NOT guaranteed to be
    -- supplied.
    return cell
end

function Actor:hook_powerup(power)
    -- Default behaviour: Do nothing.

    -- Called when the actor gets a powerup (e.g. by getting a power pellet).
    -- The name of the powerup will be given.
end

function Actor:hook_cleanup()
    -- Default behaviour: Release all cells belonging to this actor.

    -- Called when an actor is being removed from the board for whatever reason.
    -- Usually this will be at the actor's own request, but other effects can
    -- cause this to happen. The actor is expected to release all its cells.
    -- The default implementation does this, but if naïvely releasing everything
    -- is not desired (e.g. some processing is required first), this function
    -- can be implemented.
    Game.board:releaseAllCells(self)
end