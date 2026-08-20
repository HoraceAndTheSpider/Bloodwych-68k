"""Shared full-display Pygame window setup for the SuperApp surfaces."""

from __future__ import annotations

DISPLAY_FULLSCREEN = True


def is_fullscreen() -> bool:
    return DISPLAY_FULLSCREEN


def set_display_mode(pygame: object, logical_size: tuple[int, int]) -> object:
    """Open a viewer using the application's currently selected display mode."""

    if DISPLAY_FULLSCREEN:
        return set_scaled_fullscreen(pygame, logical_size)
    return set_windowed(pygame, logical_size)

def set_scaled_fullscreen(pygame: object, logical_size: tuple[int, int]) -> object:
    """Open a full-display window while retaining logical UI coordinates.

    ``SCALED`` enlarges the fixed-size application surface to the current
    display and converts pointer coordinates back to the logical surface.  It
    keeps every existing viewer layout usable on desktop monitors and TVs.
    """
    global DISPLAY_FULLSCREEN
    DISPLAY_FULLSCREEN = True
    flags = pygame.FULLSCREEN | getattr(pygame, "SCALED", 0)
    try:
        return pygame.display.set_mode(logical_size, flags)
    except pygame.error:
        # Older display drivers may not implement SCALED, but fullscreen still
        # provides a usable whole-display fallback at the logical resolution.
        return pygame.display.set_mode(logical_size, pygame.FULLSCREEN)


def set_windowed(pygame: object, logical_size: tuple[int, int]) -> object:
    """Open a resizable window while retaining the logical UI coordinates."""

    global DISPLAY_FULLSCREEN
    DISPLAY_FULLSCREEN = False
    flags = getattr(pygame, "SCALED", 0) | getattr(pygame, "RESIZABLE", 0)
    try:
        return pygame.display.set_mode(logical_size, flags)
    except pygame.error:
        # Some SDL renderers cannot combine SCALED and RESIZABLE.
        return pygame.display.set_mode(logical_size, getattr(pygame, "RESIZABLE", 0))
