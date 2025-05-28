import pygame
import map_tools, map_icons, bit_tools,palette


def redraw_screen(screen, game, this_dungeon, floor):
  screen.fill((0,0,0))

  font_type = 'font/SFNSDisplay-ThinG4.otf'
  font = pygame.font.Font(font_type, 12)
  text = font.render(game.tower_names[this_dungeon.tower], True, (255,255,255,0))
  screen.blit(text, (550, 10))


  draw_grid(screen, this_dungeon, floor)
  draw_map(screen, game, this_dungeon, floor)
  pygame.display.update()
  return


def draw_grid(screen,this_dungeon,floor):

  acol = palette.make_palette()
  
  for w in range(0 , this_dungeon.floor_width[floor]):
    for h in range(0, this_dungeon.floor_height[floor]):

      startx = w * 16
      starty = h * 16

      pygame.draw.rect(screen,(60,85,85,0),(startx+(this_dungeon.floor_offsetx[floor]*16),starty+(this_dungeon.floor_offsety[floor]*16),17,17),2)
  return()


def draw_map(screen,game,this_dungeon,floor):
  for w in range(0 , this_dungeon.floor_width[floor]):
    for h in range(0, this_dungeon.floor_height[floor]):

      startx = w * 16
      starty = h * 16
      ab = map_tools.get_data(game,this_dungeon,floor,w,h,0)
      cd = map_tools.get_data(game,this_dungeon,floor,w,h,1)
      inx = 2+startx+(this_dungeon.floor_offsetx[floor]*16)
      iny = 2+starty+(this_dungeon.floor_offsety[floor]*16)
      map_icons.draw_map_icon(screen,game,inx,iny,ab,cd)

  return