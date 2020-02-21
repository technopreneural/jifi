# Recoverify
Script that automates creation of a Raspbian SD Card image with a recovery partiion

## Motivation and Rationale
Quickly switch to a freshly installed operating system without having to shutdown the pi, pull out the SD card,
and flash a fresh system image onto it. Especially when the pi is deployed already, a lot of time can be saved
by avoiding the trip to the deployment location of your pi to retrieve the SD card, reflash it, and redeploy.

## Usage
The script can be run using the following command usage pattern
```./recoverify.sh <source_image> <target_image>

## Changes

## To do
Fix fstab
Recovery script - script to trigger system recovery
Push button trigger - script to detect push button trigger for system recovery (i.e. factory reset)

