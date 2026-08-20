"""Shared full-display Pygame window setup for the SuperApp surfaces."""

from __future__ import annotations


def set_scaled_fullscreen(pygame: object, logical_size: tuple[int, int]) -> object:
    """Open a full-display window while retaining logical UI coordinates.

    ``SCALED`` enlarges the fixed-size application surface to the current
    display and converts pointer coordinates back to the logical surface.  It
    keeps every existing viewer layout usable on desktop monitors and TVs.
    """
    flags = pygame.FULLSCREEN | getattr(pygame, "SCALED", 0)
    try:
        return pygame.display.set_mode(logical_size, flags)
    except pygame.error:
        # Older display drivers may not implement SCALED, but fullscreen still
        # provides a usable whole-display fallback at the logical resolution.
        return pygame.display.set_mode(logical_size, pygame.FULLSCREEN)
