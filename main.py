#!/usr/bin/env python3
import os
import sys
import argparse
import pandas as pd
import re
import shutil
import pygame
from pygame.locals import QUIT, MOUSEBUTTONDOWN
from openpyxl import load_workbook

import tools.tool_inspect

from tools.tool_extract import extract_segments
from tools.tool_inspect import inspect_source
from tools.tool_patch import patch_segments
from tools.tool_relabel import relabel_segments

# Initialize Pygame for command selection UI
def init_gui():
    pygame.init()
    surf = pygame.display.set_mode((400, 300))
    pygame.display.set_caption('Segment Tool Command')
    font = pygame.font.SysFont(None, 24)
    return surf, font

# Draw a button and handle hover
def draw_button(surf, font, rect, text, mouse_pos):
    color = (80,80,240) if rect.collidepoint(mouse_pos) else (50,50,200)
    pygame.draw.rect(surf, color, rect)
    txt = font.render(text, True, (255,255,255))
    surf.blit(txt, txt.get_rect(center=rect.center))

# Prompt user for command via clickable buttons
def pygame_prompt(options):
    surf, font = init_gui()
    # layout buttons
    w, h, sp = 120, 40, 10
    total = len(options)*(h+sp)-sp
    start_y = (300-total)//2
    buttons = []
    for i,opt in enumerate(options):
        rect = pygame.Rect((400-w)//2, start_y+i*(h+sp), w, h)
        buttons.append((rect,opt))
    while True:
        mouse = pygame.mouse.get_pos()
        surf.fill((30,30,30))
        for rect,opt in buttons:
            draw_button(surf,font,rect,opt.capitalize(),mouse)
        pygame.display.update()
        for ev in pygame.event.get():
            if ev.type==QUIT:
                pygame.quit(); sys.exit()
            if ev.type==MOUSEBUTTONDOWN and ev.button==1:
                for rect,opt in buttons:
                    if rect.collidepoint(ev.pos):
                        return opt

# Entry point
def main():
    parser = argparse.ArgumentParser(
        description="Segment tool: extract, patch, inspect, relabel"
    )
    sub = parser.add_subparsers(dest='cmd')

    extract_p = sub.add_parser('extract', help='Extract segments')
    extract_p.add_argument('-n', '--name', help='Filter segment name')
    extract_p.add_argument('--debug', action='store_true', help='Enable debug output')

    patch_p = sub.add_parser('patch', help='Patch segments')
    patch_p.add_argument('-n', '--name', help='Filter segment name')
    patch_p.add_argument('--debug', action='store_true', help='Enable debug output')

    inspect_p = sub.add_parser('inspect', help='Inspect segments')
    inspect_p.add_argument('-n', '--name', help='Filter segment name')
    inspect_p.add_argument('label', nargs='?', help='Filter by ASM label (exact match)')
    inspect_p.add_argument('--debug', action='store_true', help='Show head/tail bytes on failure')

    relabel_p = sub.add_parser('relabel', help='Relabel segments in ASM source')

    parser.add_argument('-m', '--master', default='BLOODWYCH439',
                        help='Master binary name (with extension)')
    parser.add_argument('-s', '--sheet', default='segments.xlsx',
                        help='Spreadsheet file (.xls, .xlsx or .csv)')

    args = parser.parse_args()

    cmd = args.cmd or pygame_prompt(['extract', 'patch', 'inspect', 'relabel'])
    pygame.quit()

    if cmd == 'extract':
        extract_segments(
            args.master,
            args.sheet,
            name_filter=getattr(args, 'name', None),
            debug=getattr(args, 'debug', False)
        )
    elif cmd == 'patch':
        patch_segments(
            args.master,
            args.sheet,
            name_filter=getattr(args, 'name', None),
            debug=getattr(args, 'debug', False)
        )
    elif cmd == 'inspect':
        inspect_source(
            args.master,
            args.sheet,
            name_filter=getattr(args, 'name', None),
            label_filter=getattr(args, 'label', None),
            debug=getattr(args, 'debug', False)
        )
    elif cmd == 'relabel':
        relabel_segments(args.master, args.sheet)
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
