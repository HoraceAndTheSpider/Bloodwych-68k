import pygame
import datafile, tower, viewer
import gfx_viewer

def side_panel(maude):

	return


#================================
pygame.display.init()
pygame.font.init()

dispx = 640
dispy = 512

dispsize = (dispx, dispy)

screen = pygame.display.set_mode(dispsize, flags=pygame.SCALED | pygame.FULLSCREEN) #
pygame.display.set_caption("Bloodwych Map Viewer")


# ================================
# pick a game, identify it, and load in a data-map
game = datafile.GameSetup("data/BLOODWYCH439")
game.GetLocations()


#a = gfx_viewer.my_code()
#pygame.quit()
#raise SystemExit()

# this is the normal  
# pick a tower, and load in a Tower object
scaled = True
dungeon = 0
floor = 4
this_dungeon = tower.DungeonTower(game)
this_dungeon.GetDungeon(game, dungeon)
viewer.redraw_screen(screen, game, this_dungeon, floor)




while 1 != 0:
	pygame.display.flip()
	for event in pygame.event.get():
		done = True   
		if event.type == pygame.QUIT:
			break
		if event.type == pygame.KEYDOWN:

			# Switch Dungeon
			if event.key == pygame.K_COMMA:
				dungeon -= 1
				dungeon %= len(game.tower_names)
				this_dungeon.GetDungeon(game, dungeon)
				viewer.redraw_screen(screen, game, this_dungeon, floor)
			if event.key == pygame.K_PERIOD:
				dungeon += 1
				dungeon %= len(game.tower_names)
				this_dungeon.GetDungeon(game, dungeon)
				viewer.redraw_screen(screen, game, this_dungeon, floor)

			# Switch Floor
			if event.key == pygame.K_TAB:
				floor += 1
				floor %= 8
			if event.key == pygame.K_F1:
				floor = 0
			if event.key == pygame.K_F2:
				floor = 1
			if event.key == pygame.K_F3:
				floor = 2
			if event.key == pygame.K_F4:
				floor = 3
			if event.key == pygame.K_F5:
				floor = 4
			if event.key == pygame.K_F6:
				floor = 5
			if event.key == pygame.K_F7:
				floor = 6
			if event.key == pygame.K_F8:
				floor = 7

			viewer.redraw_screen(screen, game, this_dungeon, floor)

		# change between standard window and scaled window
		if event.type == pygame.MOUSEBUTTONDOWN and pygame.mouse.get_pos()[0] >= dispx-8 and pygame.mouse.get_pos()[1] >= dispy-8 :

			if scaled == True:
				scaled = False
				screen = pygame.display.set_mode(dispsize)
			else:
				scaled = True
				screen = pygame.display.set_mode(dispsize, flags=pygame.SCALED | pygame.FULLSCREEN)
			pygame.display.update
			viewer.redraw_screen(screen, game, this_dungeon, floor)
	
pygame.quit()
