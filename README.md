# Let's Party Today
(LPI reimagined)

Keep in mind I didn't include some of the stuff like materials on the repository itself because of the size limitations. Project probably needs to be repackaged when imported to Godot.

This is a project that I've worked on for about two months, but I've come to see it's biting off more than I can chew so I decided to just post it on here for whoever might care, maybe I'll come back to it maybe I won't. Feel free to expand upon it or use it for something, although with due credit. Made in Godot, of course.
Let's Part Infinite (LPI) is a Roblox game made in 2016 by FoxBin about an island with hundreds of items and weapons to use including building tools. It's centered around anarchy.
https://www.roblox.com/games/391104146/Lets-Party-Gear-Testing-Edition-READ-THE-DESC 

Basic tasklist:

# Item Function and basic XYZ system

- [x] Basic Slot UI and Item Template
- [x] Rework the pointer and active slot system
- [x] Inventory Manager can insert Slots evenly and they have the correct info
- [x] Inventory Manager can equip and unequip items, this being reflected in the slot's graphic
- [x] Polish and Debug with multiple objects and tweak limits and parameters
- [x] Setup XYZ item UI and code, with keybinds, as it doesn't follow other item norms
- [x] Make the XYZ UI have a tab system to add the technical modules in there
- [x] Make the XYZ be able to select and add restrictions to this
- [x] Make the XYZ be able to instance cubes with independent shader properties 
-

# Player Stuff

- [x] Health and Death
- [x] Respawning in the proper spawn positions
- [x] Chatting, and chat logging

# UI

- [x] Make a Main Menu base
- [x] Add a pause menu 
- [x] Add reputation stat plus a dynamic list of players
- [x] Add player UI like health, , name, etc.

# AI Players Part I

- [x] Make a sample player that can walk to people 
- [x] Implement a personality and behavior system
- [x] Implement the first, no talk and random walk personality, very quiet and calm.
- [x] Implement the second, doesn't talk but does try explore more proactively and is able to go into build or kill behaviors, which may or may not include betraying

# Combat and streamlined movement

- [x] Make a sword that feels nice to swing at people and combaty
- [x] Make a punch item that also works decently
- [x] Flying
- [x] Few items
- [x] Guns 
- [x] Fix dying
- [x] Figure out how items can have behavior that works with both the ai and the player seamlessly
- [x] Setup some sort of inventory system bots can use
- [x] Fix human to character compat

# AI Players Part II

- [x] Implement the third, who talks, explores, and does stuff as well. 
- [x] Uses at least for now gemini's API for talking 
- [x] and can use basic reason based on what is said by giving the LLM an interface through certain keywords or characters it can use to signal triggering a behavior. 
- [x] Test a bit

# Final touches to the player

- [x] Study movement physics to see how to make it feel nicer
- [x] Add wallrun + walljump

# Chill for a second

- [x] Do whatever may come to mind that I'd like to do next 
- [x] Add a cool day night cycle with lens flares and stuf
- [x] Make the testing map prettier (model it in blender for fuck's sake)
- [ ] Add a menu where you can access every single item in the game and give it to yourself instantly
  - [ ] fix inventory updating so they can update in real time1
- [ ] Test performance and do performance focused stuff
- [ ] Send the game to somebody to test things further (keep on with the list while waiting)
- [ ] Add better character customization gui and stuff on the main menu
- [ ] Optimize the testing map so it looks nice but it's also effective so I can test whatever I may need in terms of physics, AI, etc
- [ ] Add toys and funny stuff
- [ ] Enhance the UI
- [ ] Add a photo mode where the main GUI is hidden and every graphical effect is enabled (or user's choice)
- [ ] Compose a cool bgm for the main menu
- [ ] Make the main menu have a screenshot of the testing map
- [ ] Make the XYZ be able to rotate scale and displace.
- [ ] Make the XYZ be able to import simple models and restrict it
- [ ] Make the XYZ be able to delete
- [ ] xyz UI

# Burnout

- [ ] XYZ v2
  - [ ] Add undo and redo (hell)
  - [ ] Implement schematics as files you can download of XYZ contraptions or builds, using reputation to balance
  - [ ] Implement a few modules as shit you can at least spawn (A lever and piston module)
  - [ ] Connection
  - [ ] Make the XYZ be able to handle different shapes of objects like capsules or spheres
  - [ ] Fix the shader's UV problem so the instances can be made physical
  - [ ] Check QOL stuff and make it comfy for both platforms.
  - [ ] Make the XYZ be able to change these properties through a color and material tool
  - [ ] Add the graphics and models for the XYZ
  - [ ] Test whether they work both individually and together with different contraptions
  - [ ] Implement a whole lot of these modules (Say at least 30)
  - [ ] Add the icons and UI for them on the interface
  - [ ] Proof test more with the new modules
  - [ ] Upgrade schematics to include this
  - [ ] Make sure everything works together again
- [ ] AI Player Part III
  - [ ] Add the rest of interactions (like leaving the game, proper dancing which they can do through actions and you can do through parsing your text messages)
  - [ ] Add a few cool dances (both for player and machine)
  - [ ] Weight all of the probabilities properly
  - [ ] Make the AI do stuff independently while awaiting messages so it doesn't just stand still soulless when it's not actively speaking
  - [ ] Adapt the LLM for the new API
  - [ ] Figure out how to make a wave function collapse algorithm in general
  - [ ] Figure out how to make it generate different types of structures
  - [ ] Decide on which to add and how
  - [ ] Figure out how to make it sequenced so it's bit by bit
  - [ ] Turn it into a function for the AI to use build(structure type) and buildRand()
  - [ ] It may or may not be given the opportunity to see as well (attaching a screenshot from its pov)
  - [ ] Train the AI to generally be able to work itself with a few gears and switch to them based on dynamic needs
  - [ ] Implement reactions, like if 5 or more people in a 50 unit radius are actively taking damage then panic and try to exit either by flying or walking or start targeting everything and everyone, along with other reactions like exploiters joining or someone being close by with a flying item equipped, signaling he will give it to someone
  - [ ] Implement a fourth type which would be exploiters, who talk but rarely, and only spawn if anybody has had access to the island for a pretty long time, and it's also about chance
  - [ ] Train the AI to handle all of this
  - [ ] Debug everything somehow?????????
  - [ ] Figure out dynamic navmesh and using the entire range of movement capabilities
  - [ ] Document
- [ ] Multiplayer
  - [ ] Ensure multiplayer compatibilty 
    - [ ] Make a link between server and player so that they interact with each other in order to execute actions somehow???

# The Tutorial 

- [ ] Have a basic geometry for it
- [ ] Make the tutorial work at least in its basics, probably make the "STORY" fork of the player so that I can disable the chat and stuff without godot having a stroke and a tantrum at the same time

# Content + Branding + Gameplay

- [ ] Play PVE for a bit with a few items to see how hard it sucks
- [ ] Limit the chatlogs to 100 lines
- [ ] Build an inventory UI where items outside the hotbar are stored
- [ ] Make buttons clickable
- [ ] Add climbing up (mantle walrun copy)
- [ ] Rework the island (trenchbroom) and set up the item cube mechanic, having cubes for different categories of items plus maybe a few sample ones.
  - [ ] Have an idea of what its design will look like by breaking down the design and gameplay features the original has (overthink the shit out of it)
  - [ ] Try making a rough thing in blender and play around it to see how well it holds up
- [ ] See if betraying works in a way?
- [ ] Implement changing the sky or base plate color and material (AKA the "Island Terminal" Room)
- [ ] Add ways to use reputation like a few exclusive items
- [ ] Add animations to the character model for the parkour interactions, 
- [ ] Brand the game as alpha 0.3, releasing the demo to itch.io
- [ ] Implement parrying with another attack for a few items because it would be kewl
- [ ] 10 items
- [ ] 20 items
- [ ] 30 items
- [ ] 40 items
- [ ] 50 items
- [ ] playtest and debug
- [ ] 60 items
- [ ] 70 items
- [ ] 80 items
- [ ] 90 items
- [ ] 100 items

# make the gameplay loop 

- [ ] add the players leaving and joining)
- [ ] check if the AI feels like a player or is at least fun
  - [ ] AI Players Part IV
    - [ ] cry

# Final touches before beta release

- [ ] Implement options changing stuff in the game itself like sensitivity or graphics
- [ ] Investigate performance and adapt things
- [ ] Play at least ten hours and write down any bugs
- [ ] The slots are clickable
- [ ] Make sure the game is well packaged and fix any quirks left, while testing on different platforms.

# Beta!!!

- [ ] Check if any bugs are reported and fix them
- [ ] Celebrate

# Story Mode

- [ ] Start formulating story mode, as well as checking on the save feature.
- [ ] Write its story and flow
- [ ] Get the basic setup to transition through different sections
- [ ] program NPC's that work well for the characters.
- [ ] Begin to make the rough sketches of the story areas and their gameplay
- [ ] Work on stuff like the graphics, the scenery
- [ ] Model the final boss
- [ ] Code the final boss
- [ ] Get its graphics done
- [ ] Improve general visuals

# Rework

- [ ] Make the scripts more robust if they aren't already, and make sure there aren't any loopholes gameplay wise.
- [ ] Make the physics and game feel smooth and polished

# New Features

- [ ] Add scriptable XYZ with a node logic system
- [ ] Add a weapon creator that is encoded in a file you can retrieve to reuse
