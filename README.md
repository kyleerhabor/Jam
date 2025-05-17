# Jam

Seek forward/back the now playing media by a set duration.

## Rationale

Mac computers provide a number of ways to interact with media:
- Non-Touch Bar Macs have media keys for playing the next or previous media, as well as pausing the current media
- Touch Bar Macs display an icon for playing and pausing media, as well as a scrubber for seeking to a position
- The Now Playing icon in the menu bar provides a similar interface to the Touch Bar's, as well as a list of media to manipulate

Jam is an application that allows you to control media, except with a subset of features:
- It relies on keyboard shortcuts to control media
- It seeks forward/back the current media by a configurable duration
- ~~It's app-agnostic, supporting any app that can broadcast media (music player, browser, chat app, etc.)~~

> [!IMPORTANT]
>
> As of Jam 1.1, the app is no longer app-agnostic due to macOS Sequoia 15.5 revoking that behavior.
>
> Jam supports [Doppler](https://brushedtype.co/doppler).

## Installation

Go to the [Releases][releases] page and download the app, or build from source in Xcode.

The app will open without a UI on launch. Open it again to configure settings. 

[releases]: https://github.com/KyleErhabor/Jam/releases
