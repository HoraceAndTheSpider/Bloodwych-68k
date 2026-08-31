"""Reusable Pygame data actions and local binary/save catalogue."""
from __future__ import annotations
from pathlib import Path

from tools.tool_common import WHDLOAD_DIR, ToolError


class SessionPanel:
    VISIBLE_ROWS = 5

    def __init__(self, session, section_names=None, *, section_label=None):
        self.session = session
        self.section_names = section_names
        self.section_label = section_label
        self.help_action = "RELOAD"
        self.open = False
        self.message = "Changes stay live across viewers. Originals are never overwritten."
        self.path_text = ""
        self.editing_path = False
        self.armed = None
        self.load_error = None
        self.catalog_kind = "BINARIES"
        self.catalog = []
        self.catalog_offset = 0
        self.selected = None
        self.rects = {}
        self.rows = []
        self._catalogue()

    def _catalogue(self):
        self.unmapped_paths = set()
        if self.catalog_kind == "BINARIES":
            from tools.binary_identity import binary_catalog
            self.catalog = []
            for path, identity, reason in binary_catalog():
                mapped = identity is not None and identity.layout_compatible
                family = identity.family if identity else "unknown"
                self.catalog.append((path, f"{path.name}  —  {family}" + ("  [UNMAPPED]" if not mapped else ""), reason))
                if not mapped:
                    self.unmapped_paths.add(path)
        else:
            paths = sorted(set(WHDLOAD_DIR.glob("*save*")) | set((self.session.modified_root / "whdload").glob("*save*")))
            self.catalog = [(p, f"{p.name}  —  {p.parent.name}", "SPS 439 save layout is validated when loaded")
                            for p in paths if p.is_file()]
        self.catalog_offset = 0
        self.selected = None

    def row_colour(self, index):
        return (255, 135, 135) if self.catalog[index][0] in self.unmapped_paths else (215, 223, 232)

    def scroll_catalogue(self, amount):
        self.catalog_offset = max(0, min(max(0, len(self.catalog) - self.VISIBLE_ROWS),
                                         self.catalog_offset + amount))

    def reload_names(self):
        if self.section_names is None:
            return ()
        return tuple(name for name in self.section_names()
                     if name in self.session.specs and not self.session.specs[name].extract_only)

    def reload_label(self):
        if not self.reload_names():
            return ("Unavailable from the front menu: open a viewer/editor section first."
                    if self.section_names is None else "No reloadable data in the current selection.")
        if self.section_label is not None:
            return self.section_label() if callable(self.section_label) else self.section_label
        return ", ".join(self.reload_names())

    def action_label(self, action):
        if action == "USE SELECTED":
            return "LOAD SAVE" if self.catalog_kind == "SAVES" else "LOAD BINARY"
        if action == "SAVE DATA":
            return "SAVE DATA: ON" if self.session.save_path else "SAVE DATA: OFF"
        return action

    def disabled_reason(self, action):
        if action == "SCROLL UP" and self.catalog_offset == 0:
            return "At the start of the file list."
        if action == "SCROLL DOWN" and self.catalog_offset >= max(0, len(self.catalog) - self.VISIBLE_ROWS):
            return "At the end of the file list."
        if action == "RELOAD" and not self.reload_names():
            return self.reload_label()
        if action == "USE SELECTED" and self.selected is None:
            return "Select a file in the list first. Selecting it does not load it."
        if action == "USE SELECTED" and self.catalog[self.selected][0] in self.unmapped_paths:
            return "Cannot load this unmapped binary: " + self.catalog[self.selected][2]
        if action == "SAVE DATA" and self.session.last_save_path is None:
            return "Save Data is OFF. Choose a save from SAVES and click LOAD SAVE first. This toggle changes the data being edited; it never writes to disk."
        if action == "PATCH":
            blockers = self.session.patch_blockers()
            if blockers:
                return blockers[0]
            if not self.session.has_changes:
                return "No changes to patch. Import or edit data first."
        return None

    def help_text(self, action):
        disabled = self.disabled_reason(action)
        if disabled:
            return disabled
        baseline = f"the original {self.session.family} binary"
        if self.session.save_path:
            baseline += f" / the loaded {self.session.save_path.name} save baseline"
        save_name = self.session.last_save_path.name if self.session.last_save_path else "a selected save"
        explanations = {
            "RESET": f"Restore ALL sections from the original {self.session.family} binary and reread the loaded save, if any. Discards in-memory edits and imported changes. Exported files stay on disk. Click twice to confirm.",
            "RELOAD": f"Restore {self.reload_label()} from {baseline}. Other sections keep their edits. This restores baseline data, not a previous export. Click twice to confirm.",
            "EXPORT": "Save the whole session's changed resource files and resume data in the Export folder above. This is NOT the front-menu Extract, which reads binary resources into clean data. No executable/save is patched. Earlier exports can be replaced; click twice to confirm.",
            "PATCH": "Write a separate modified save copy after validating every change. The loaded save stays untouched. Click twice to confirm." if self.session.save_path else "Write a separate modified binary after validating every change fits. This uses the whole live session, not files left on disk. The loaded binary and existing outputs stay untouched.",
            "IMPORT": "Load the Import source below into memory: a resource folder or a binary (a save when browsing SAVES). Loading a binary selects its own -modified Export folder; importing resources or saves keeps the current folder. An empty field resumes the Export folder. Click twice to confirm replacing session data.",
            "USE SELECTED": ("Load the selected save over the binary resources; keep the binary project's Export folder." if self.catalog_kind == "SAVES" else "Load the selected binary and use its own -modified Export folder. Previously exported files stay where they are; no existing exports are loaded automatically.") + " Loaded input updates after confirmation. Click twice to confirm replacing session data.",
            "SAVE DATA": ("Switch OFF to use the loaded binary's data." if self.session.save_path else f"Switch ON to reread {save_name} over the binary's data.") + " Switching discards in-memory edits; export first if needed. This only changes the data being edited, never writes to disk. PATCH separately creates a modified copy. Click twice to confirm.",
            "BINARIES": "Choose a row to fill Import source, then LOAD BINARY. Red [UNMAPPED] files lack a supported resource layout and cannot be loaded. Browsing does not change the active session.",
            "SAVES": "Browse available WHDLoad saves. Choose a row to fill Import source, then LOAD SAVE. Only the mapped SPS 439 save layout is supported; ADF import is not yet available.",
            "SCROLL UP": "Scroll the file list up one row. The selected file and loaded data stay unchanged. The mouse wheel also works.",
            "SCROLL DOWN": "Scroll the file list down one row. The selected file and loaded data stay unchanged. The mouse wheel also works.",
            "CLOSE": "Return to the viewer or front menu. In-memory edits stay shared across viewers. Export before quitting the application; there is no autosave.",
        }
        return explanations.get(action, explanations["RELOAD"])

    @staticmethod
    def _wrapped(font, text, width):
        lines = []
        line = ""
        for word in text.split():
            if line and font.size(line + " " + word)[0] > width:
                lines.append(line)
                line = ""
            # Long paths must not run outside the help/status card.
            for character in ((" " if line else "") + word):
                if font.size(line + character)[0] > width:
                    lines.append(line)
                    line = ""
                line += character
        if line:
            lines.append(line)
        return lines

    @staticmethod
    def _fit_path(font, text, width):
        if font.size(text)[0] <= width:
            return text
        left, right = len(text) // 2, len(text) // 2
        while left + right and font.size(text[:left] + " ... " + (text[-right:] if right else ""))[0] > width:
            if left >= right:
                left -= 1
            else:
                right -= 1
        return text[:left] + " ... " + (text[-right:] if right else "")

    def draw(self, pygame, screen):
        font = pygame.font.SysFont(None, 20)
        small = pygame.font.SysFont(None, 18)
        width, height = screen.get_size()
        self.button = pygame.Rect(width - 188, 12, 116, 28)
        pygame.draw.rect(screen, (52, 88, 122), self.button, border_radius=4)
        screen.blit(small.render("DATA / FILES", True, (245, 245, 250)), (self.button.x + 10, self.button.y + 7))
        if not self.open:
            return
        shade = pygame.Surface((width, height), pygame.SRCALPHA)
        shade.fill((0, 0, 0, 170))
        screen.blit(shade, (0, 0))
        box = pygame.Rect((width - 1000) // 2, (height - 710) // 2, 1000, 710)
        pygame.draw.rect(screen, (32, 37, 47), box, border_radius=8)
        x, y, inner = box.x + 20, box.y + 16, 960
        self.rects = {}
        mode = "SAVE DATA" if self.session.save_path else "BINARY DATA"
        name = self.session.save_path.name if self.session.save_path else self.session.binary_name
        title = self._fit_path(font, f"EDITING {mode}: {name}  |  {self.session.family}", inner)
        screen.blit(font.render(title, True, (234, 220, 134)), (x, y))
        source = self.session.save_path or self.session.binary_source
        for label, value, offset in (("Loaded input:", str(source), 27), ("Export folder:", str(self.session.modified_root), 50)):
            screen.blit(small.render(label, True, (154, 170, 190)), (x, y + offset))
            screen.blit(small.render(self._fit_path(small, value, inner - 104), True, (220, 226, 234)), (x + 104, y + offset))
        count = len(self.session.changed_resources)
        screen.blit(small.render(f"{count} changed resource files  |  All viewers share these edits. Export before quitting.", True, (183, 194, 207)), (x, y + 76))
        mouse = pygame.mouse.get_pos()

        def button(action, rect):
            self.rects[action] = rect
            enabled = self.disabled_reason(action) is None
            colour = (67, 105, 142) if rect.collidepoint(mouse) or action == self.catalog_kind else (53, 83, 113)
            pygame.draw.rect(screen, colour if enabled else (49, 52, 60), rect, border_radius=4)
            text = font.render(self.action_label(action), True, (240, 241, 246) if enabled else (116, 121, 130))
            if action in ("SCROLL UP", "SCROLL DOWN"):
                direction = -1 if action == "SCROLL UP" else 1
                cx, cy = rect.center
                pygame.draw.polygon(screen, (240, 241, 246) if enabled else (116, 121, 130),
                                    ((cx, cy + direction * 6), (cx - 7, cy - direction * 5),
                                     (cx + 7, cy - direction * 5)))
            elif action == "SAVE DATA":
                screen.blit(text, text.get_rect(midleft=(rect.x + 12, rect.centery)))
                toggle = pygame.Rect(rect.right - 48, rect.centery - 9, 36, 18)
                pygame.draw.rect(screen, (62, 150, 105) if self.session.save_path else (82, 86, 96), toggle, border_radius=9)
                pygame.draw.circle(screen, (230, 235, 242) if enabled else (130, 135, 145),
                                   (toggle.right - 9 if self.session.save_path else toggle.x + 9, toggle.centery), 6)
            else:
                screen.blit(text, text.get_rect(center=rect.center))

        for index, action in enumerate(("RESET", "RELOAD", "EXPORT", "PATCH", "IMPORT", "CLOSE")):
            button(action, pygame.Rect(x + index * 161, y + 100, 153, 34))
        for index, line in enumerate(self._wrapped(small, "RELOAD SCOPE: " + self.reload_label(), inner)[:2]):
            screen.blit(small.render(line, True, (171, 209, 233)), (x, y + 148 + index * 20))
        screen.blit(small.render("IMPORT SOURCE: select a file below, type a file/folder path, or leave blank to resume the Export folder.", True, (186, 198, 215)), (x, y + 202))
        self.path_rect = pygame.Rect(x, y + 225, inner, 30)
        pygame.draw.rect(screen, (18, 22, 30), self.path_rect)
        pygame.draw.rect(screen, (104, 153, 201) if self.editing_path else (73, 82, 97), self.path_rect, 1)
        value = self.path_text or str(self.session.modified_root)
        screen.blit(small.render(self._fit_path(small, value, inner - 16), True, (210, 220, 235)), (x + 8, y + 233))
        for index, action in enumerate(("BINARIES", "SAVES", "USE SELECTED", "SAVE DATA")):
            button(action, pygame.Rect(x + index * 242, y + 270, 234, 30))
        self.rows = []
        list_width = inner - 44
        for index, (_, label, _) in enumerate(self.catalog[self.catalog_offset:self.catalog_offset + self.VISIBLE_ROWS], self.catalog_offset):
            rect = pygame.Rect(x, y + 312 + (index - self.catalog_offset) * 26, list_width, 24)
            pygame.draw.rect(screen, (63, 91, 126) if index == self.selected else (41, 47, 59), rect)
            screen.blit(small.render(self._fit_path(small, label, list_width - 16), True, self.row_colour(index)), (rect.x + 8, rect.y + 5))
            self.rows.append((rect, index))
        button("SCROLL UP", pygame.Rect(x + inner - 36, y + 312, 36, 32))
        button("SCROLL DOWN", pygame.Rect(x + inner - 36, y + 312 + self.VISIBLE_ROWS * 26 - 34, 36, 32))
        hovered = next((action for action, rect in self.rects.items() if rect.collidepoint(mouse)), None)
        action = hovered or self.help_action
        help_box = pygame.Rect(x, y + 452, inner, 112)
        pygame.draw.rect(screen, (22, 30, 40), help_box, border_radius=5)
        screen.blit(small.render("ACTION HELP: " + self.action_label(action), True, (145, 191, 229)), (x + 10, y + 461))
        for index, line in enumerate(self._wrapped(font, self.help_text(action), inner - 20)[:4]):
            screen.blit(font.render(line, True, (226, 232, 240)), (x + 10, y + 483 + index * 19))
        screen.blit(small.render("STATUS / CONFIRMATION", True, (215, 173, 103)), (x, y + 576))
        for index, line in enumerate(self._wrapped(font, self.message, inner)[:4]):
            screen.blit(font.render(line, True, (243, 200, 137)), (x, y + 598 + index * 18))
        screen.blit(small.render("Hover any button for help, including disabled buttons. Use the arrows or mouse wheel to scroll the file list.", True, (157, 168, 185)), (x, y + 677))

    def handle(self, pygame, event):
        if event.type == pygame.QUIT:
            return False
        if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1 and not self.open:
            if hasattr(self, "button") and self.button.collidepoint(event.pos):
                self.open = True
                return True
        if not self.open:
            return False
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                self.open = bool(self.load_error)
                self.armed = None
            elif self.editing_path:
                self.armed = None
                self.selected = None
                if event.key == pygame.K_BACKSPACE:
                    self.path_text = self.path_text[:-1]
                elif event.key == pygame.K_a and event.mod & (pygame.KMOD_CTRL | pygame.KMOD_META):
                    self.path_text = ""
                elif event.key == pygame.K_v and event.mod & (pygame.KMOD_CTRL | pygame.KMOD_META):
                    try:
                        if not pygame.scrap.get_init():
                            pygame.scrap.init()
                        pasted = pygame.scrap.get(pygame.SCRAP_TEXT)
                        if pasted:
                            self.path_text += pasted.decode("utf-8").rstrip("\0").strip()
                    except (pygame.error, UnicodeError):
                        self.message = "Clipboard unavailable; type the path or use the catalogue."
                elif event.key not in (pygame.K_RETURN, pygame.K_TAB):
                    self.path_text += getattr(event, "unicode", "")
            return True
        if event.type == pygame.MOUSEWHEEL:
            self.scroll_catalogue(-event.y)
        if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
            if not hasattr(self, "path_rect"):
                return True  # Ignore queued clicks until the newly opened panel is drawn.
            self.editing_path = self.path_rect.collidepoint(event.pos)
            for rect, index in self.rows:
                if rect.collidepoint(event.pos):
                    self.selected = index
                    self.armed = None
                    self.path_text = str(self.catalog[index][0])
                    self.help_action = "USE SELECTED"
                    self.message = "Selected, not loaded: " + self.catalog[index][2]
            for action, rect in self.rects.items():
                if rect.collidepoint(event.pos):
                    self.perform(action)
                    break
        return True

    def perform(self, action):
        self.help_action = action
        if action == "CLOSE":
            self.open = bool(self.load_error)
            self.armed = None
            return
        if action in ("BINARIES", "SAVES"):
            self.catalog_kind = action
            self.armed = None
            self.path_text = ""
            self._catalogue()
            return
        disabled = self.disabled_reason(action)
        if disabled:
            self.message = disabled
            self.armed = None
            return
        if action in ("SCROLL UP", "SCROLL DOWN"):
            self.scroll_catalogue(-1 if action == "SCROLL UP" else 1)
            return
        names = self.reload_names() if action == "RELOAD" else ()
        confirmation = (action, self.path_text, self.selected, self.catalog_kind, names, self.session.revision)
        if action in ("RESET", "RELOAD", "EXPORT", "IMPORT", "USE SELECTED", "SAVE DATA") or (action == "PATCH" and self.session.save_path):
            if self.armed != confirmation:
                self.armed = confirmation
                self.open = True
                detail = {
                    "RELOAD": f"restore {self.reload_label()}. Other sections keep their edits",
                    "RESET": "discard edits across ALL sections and restore original binary / loaded save data",
                    "EXPORT": f"write the whole session's changed resources to {self.session.modified_root}. Previous exports there may be replaced",
                    "SAVE DATA": "discard in-memory edits and " + ("switch Save Data OFF, returning to the loaded binary's data" if self.session.save_path else f"switch Save Data ON, rereading {self.session.last_save_path}"),
                    "PATCH": "write a separate modified save copy; the loaded save stays untouched",
                }.get(action, "replace in-memory session data with this import; export first if needed")
                self.message = f"Click {self.action_label(action)} again to confirm: {detail}."
                return
        self.armed = None
        try:
            if action == "RESET":
                self.session.reset()
                self.message = "Restored ALL sections from the original binary and reread the selected save. Exported files are untouched."
            elif action == "RELOAD":
                self.session.reload(names)
                self.message = f"Restored {self.reload_label()} from baseline data. Other sections are unchanged."
            elif action == "EXPORT":
                paths = self.session.export()
                self.message = f"Exported {len(paths)} changed resource files plus resume metadata to {self.session.modified_root}. No binary or save was patched."
            elif action == "PATCH":
                path = self.session.patch(confirm_save=True)
                self.message = f"Wrote {path}. Original inputs are untouched."
            elif action == "IMPORT":
                path = Path(self.path_text).expanduser() if self.path_text.strip() else self.session.modified_root
                if path.is_dir():
                    self.session.import_modified(path)
                elif self.catalog_kind == "SAVES":
                    self.session.select_save(path)
                else:
                    self.session.import_binary(path)
                self.message = f"Imported {path.name} into the shared session. Export folder: {self.session.modified_root}."
            elif action == "USE SELECTED":
                path = self.catalog[self.selected][0]
                if self.catalog_kind == "SAVES":
                    self.session.select_save(path)
                else:
                    if self.session.save_path:
                        raise ToolError("Switch Save Data OFF before loading a binary; export save edits first if needed")
                    self.session.import_binary(path)
                self.path_text = str(path)
                self.message = f"Loaded {path.name}. Export folder: {self.session.modified_root}."
            elif action == "SAVE DATA":
                self.session.select_save(None if self.session.save_path else self.session.last_save_path)
                self.path_text = str(self.session.save_path or self.session.binary_source)
                self.selected = None
                self.message = (f"Save Data ON: reread {self.session.save_path.name}." if self.session.save_path else f"Save Data OFF: now editing {self.session.binary_name} binary data.") + " No files were written. PATCH writes a separate modified copy."
        except (OSError, ValueError, KeyError, ToolError) as error:
            self.message = str(error)


def launch_session_browser(session):
    import pygame
    from tools.pygame_window import set_display_mode
    from tools.joypad_panel import JoypadControls
    pygame.init()
    try:
        screen = set_display_mode(pygame, (1200, 760))
        joypad = JoypadControls(pygame)
        pygame.display.set_caption("Bloodwych ReSource — Binaries / Saves / Data")
        panel = SessionPanel(session)
        panel.open = True
        clock = pygame.time.Clock()
        while panel.open:
            screen.fill((24, 26, 31))
            panel.draw(pygame, screen)
            joypad.draw(screen)
            pygame.display.flip()
            for event in joypad.events(pygame.event.get(), screen):
                if event.type == pygame.QUIT:
                    return
                panel.handle(pygame, event)
            clock.tick(30)
    finally:
        pygame.quit()
