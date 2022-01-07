# PetJam2022
A Public Repository for Team Dogpit's Pet Jam 2022.

## Game Design Doc 
##### (or should I say 'game design *dog*' haha we have fun here)

## MVP - Possible Spoilers Ahead:

You train your cat and every day the resident monitor checks to see if the can knows enough tricks and is well behaved enough.

If the cat is well behaved enough, it gets adopted.

## Input

Input is largely (only?) mouse driven.  The camera moves slightly with the mouse as it reaches the edge of the screen.  A command wheel pops up when right clicking and provides the following options:

- Pet
- Call
- Treat
- Scold
- Command
- Play

The Command submenu has a few tricks:

- Sit
- Speak
- Roll over
- Spin
- Stand
- Jump

## How Cat AI Works

### Simple, probably guaranteed to work version:

A cat has happiness that starts as zero.  Every time a command is issued, the cat has an x% chance to ignore the command, where X is the happiness.
Happiness increases as long as the pet's needs are within a safe margin.  Those needs are hunger, thirst, play, sleep, and attention.

### More complicated and more interesting:

A cat has a bucket of world state that accumulates and gets added to a rolling back-buffer, diminishing with time.  The back-buffer and current state are used to predict a next output action that maximizes a reward.

### Probably impossible given the time constraints:

A full reinforcement learning system.  :getin:

## Action Plan

- Make a command wheel.  Decide on whether it should be stateful or not.  Probably stateful.
- Make a basic cat component with placeholder stuff that can receive commands.
- Make a basic cube room with some colliders to prevent the cat from going OOB.
- Make an 'exam' which gives the user a challenge: issue each command and see if the animal (a) obeys within a certain amount of time and (b) does not require a re-issue of the order.
