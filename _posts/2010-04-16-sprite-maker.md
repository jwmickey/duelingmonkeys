---
layout: posts
title:  "Sprite Maker"
date:   2010-04-16 22:33:55
author: "Mike Daly"
avatar: "willow_calm2"
---
Sprite Maker

One of my stylistic goals of [Karma Riot](/games/karma-riot-v1.html) is to have all the things in the game look like hand-made sprites. I would also like to have things viewable from many angles and have smooth animation. Since there are so many pixels that need to be produced to accomplish this latter goal, manually making each frame for each sprite is pretty much out the window. Instead I've decided to create 3d models and animations then try processing them so that they look like old hand-made sprites.

Behold; the sprite maker:

![](https://content.duelingmonkeys.com/filespace/mike/spritemaker1.png)
_The UI for Sprite Maker_

Sprite Maker is a utility that runs inside of [3ds Max](http://en.wikipedia.org/wiki/3ds_max). I wrote it in Max's built-in scripting language, MaxScript. I'm not going to go on about every little feature it has; just look at the options and use your imagination. The main point of the tool is that once I've created and animated a 3d scene:

![](https://content.duelingmonkeys.com/filespace/mike/spritemaker2.png)
_source scene in Max_

I tell this thing to go and it automatically takes rendered frames of the scene for each frame of animation in the sequence, each camera angle, and then composites the results into a single image, giving you something like this:

![](https://content.duelingmonkeys.com/filespace/mike/spritemaker3.png)
_The frame and angle counts are lowered here just to make the sheet fit nicely on the web_

In order to make the resulting sprite sheet look more like classic sprites, the Sprite Maker just passes the resulting image off to the Post Process Manager - another custom tool. The Post Process Manager simply takes in a config file and uses the config file to determine what external operations to perform on the input file. I've currently created two operations; the first is 'palettize':

![](https://content.duelingmonkeys.com/filespace/mike/spritemaker4.png)
_Getting there_

You can re-use the same configuration file for many sprites or create a custom configuration for some sprites that you want to process differently than others. All of the Sprite Manager settings including the configuration file to use are stored in the Max file. Anyway, here's the second image processor; the 'outliner':

![](https://content.duelingmonkeys.com/filespace/mike/spritemaker5.png)
_Now we are cooking with fire_

To get a sprite in the game, it's a matter of adding an entry to an XML file that indicates how many cells wide and high the sheet is along with a few other handy parameters. Now that my pipeline is complete, I should be able to start churning out effects.

![](https://content.duelingmonkeys.com/filespace/mike/spritemaker6.gif)
_A 2x zoom of the result_

Later
