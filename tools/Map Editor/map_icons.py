import pygame, bit_tools, myfont, blocks, palette
  


def draw_map_icon(screen, game,inx,iny,ab,cd):

  aa = ab
  bb = ab
  cc = cd
  dd = cd
  
  cc = int(cc/16)
  aa = int(aa/16)

  for r in range(4,8):
    bb = bit_tools.clearBit(bb,r)
    dd = bit_tools.clearBit(dd,r)
  
  acol = palette.make_palette()
  fontcol = acol[3]
  bcol = acol[0]

  if dd == 0:
    this_block = blocks.Space(aa,bb,cc,dd)
  elif dd == 1:
    this_block = blocks.Walls(aa,bb,cc,dd)
  elif dd == 2:
    this_block = blocks.Wood(aa,bb,cc,dd)
  elif dd == 3:
    this_block = blocks.Misc(aa,bb,cc,dd)
  elif dd == 4:
    this_block = blocks.Stairs(aa,bb,cc,dd)
  elif dd == 5:
    this_block = blocks.Door(aa,bb,cc,dd)
  elif dd == 6:
    this_block = blocks.Pads(aa,bb,cc,dd)
  elif dd == 7:
    this_block = blocks.Magic(aa,bb,cc,dd)
  elif dd >= 8:
    this_block = blocks.TBC(aa,bb,cc,dd)

  this_block.draw_icon(screen,inx,iny)

  return