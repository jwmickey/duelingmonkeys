---
layout: posts
title:  "BitmapToTiles"
date:   2010-03-14 01:12:01
author: "Mike Daly"
avatar: "willow_calm2"
---
I've been doing a lot of work lately on homemade content tools for [Karma Riot](/games/karma-riot-v1.html). It's really rewarding to create a tool and see it working, especially since I know other people can get the benefit from it too. Today, I'd like to go over some of the tools I've made for creating race tracks.

It's no secret that KR is directly inspired by [Super Mario Kart](http://en.wikipedia.org/wiki/Super_Mario_Kart). In SMK, if you take a look at the tracks from a top-down perspective and overlay a grid, you can see that the tracks are actually constructed out of a 128 by 128 grid of 8 by 8 pixel tiles.

![](https://content.duelingmonkeys.com/filespace/mike/karmariot_compileexample_smk.png)
_Exhibit A: 2x zoom of Mario Circuit 2 in the Mushroom Cup_


I want to do this as well. This way each track simply uses a 1024 by 1024 texture for rendering, so the challenge is how do we construct this texture from individual tiles?

Instead of creating a custom level editor, I decided to have track authors instead create a 128 by 128 image where each pixel in the image represents a tile the the full sized map. The images would use a small fixed palette of colors where each color represents a type of terrain. Basically, you just create the layout in MS Paint, or your image editor of choice. Creating the basic shape of maps in this way has a lot of advantages:

* Everyone already has a map editor
* Everyone already knows how to use the editor - no learning curve
* The editing process is simple and intuitive - just draw out a shape
* The editor comes with tools like undo, flood fill, lines, curves, shapes, and selection
* Some editors come with tools like magic wand, layers, and clone stamp (very useful)
* The editor reliably handles a known filetype - little to no chance of corruption, instability, or version mismatches
* I didn't have to create an editor that does any of these things

Once this image has been created, I have a processing tool that 'compiles' it into a high-resolution image. The compiler can make intelligent decisions about what tiles to use in each location based off of what the neighboring terrain types are. However, instead of just coding in a bunch of specific conditions that match a fixed tileset, I decided to make it data driven. The compiler is provided two things: a rule set, and a tile set.

The tile set is simply an image that contains an atlas of 8 by 8 tiles that you want to be used in the construction of your map. The tile set author can provide as many or as few tiles as they want and arrange them in any way they want. For example:
![](https://content.duelingmonkeys.com/filespace/mike/karmariot_mountaintiles.png)
_Exhibit B: 2x zoom of KR's &quot;mountains&quot; tile set_


The rule set is an XML file that contains an arbitrary number of rules where each rule basically just says: for the terrain type of this pixel and given a particular configuration of neighboring tiles, use this set of tiles from the associated tile set. I'm not going to get into the nitty gritty of how these patterns are defined but I am quite happy with the solution that I came up with. Rules are fairly compact and easy to read but also flexible enough where you can describe a lot of situations and you don't need a ton of rule duplication to describe similar situations. At the same time I made it very verbose about anything it encounters that is out of the usual, so it identifies any rule parsing errors and while processing the track clearly identifies any situations that aren't covered by the rules you gave it.

So with the compiler (called BitmapToTiles), you give it an input image, a rule set (which references a corresponding tile set), and an output filename and it churns away. Let's take another look at the SMK example segment from earlier:
![](https://content.duelingmonkeys.com/filespace/mike/karmariot_compileexample_base.png)
_Exhibit C: 16x zoom of how you would represent that track in the base layout image_

![](https://content.duelingmonkeys.com/filespace/mike/karmariot_compileexample_mountains.png)
_Exhibit D: 2x zoom of the compiled result_


Now the cool thing about using a compiler is that if you play the level and you want to make some quick edits, rebuilding is trivial - just change the base layout (which is also used for the game's driving simulation) and the high res image can be kept in sync. Another handy feature is that you can change track types easily. Here I've changed the same example to use the &quot;jungle&quot; tile set, which actually has a completely different layout and set of rules for how terrain types interact with each other:
![](https://content.duelingmonkeys.com/filespace/mike/karmariot_compileexample_jungle.png)
_Exhibit E: 2x zoom of the jungle version_


The BitmapToTiles program itself is fairly generic; it doesn't have any KR-specific assumptions. Each track also has an XML file that sets its name, tile set, numberof laps, music, etc. By creating another wrapper program for BitmapToTiles, I can just crawl through the track's XML and its references to figure out all of the arguments that need to be passed into BitmapToTiles. This wrapper, called TrackToTiles, only takes in the track XML file as a command line arg, which is mainly a convenience for compiling tracks. To further add to the convenience, I added it to my right click menu for XML files, so that compiling a track is super-easy!
![](https://content.duelingmonkeys.com/filespace/mike/karmariot_compileexample_menu.png)
_So easy!_


I had a blast making these tools, and I'm really proud of how they turned out. That being said, I realize that there would be tons and tons of additional work to get the tools and the tilesets to a point where I could just give them to some stranger and expect them to be able to make a map for the game. Fortunately, that's not a requirement (for now). In closing, I'll leave you with a preview of one of the tracks I put together. You'll have to use your imagination to figure out what it looks like in game:
![](https://content.duelingmonkeys.com/filespace/mike/karmariot_jungle1_layout.png)
_2x zoom of &quot;Jungle Rumble I&quot; (tentative title) base layout_

