## [5.0.0+1] - 11 December 2021

- Downgrade SDK constraints to fix pub rating
- Improve documentation

## [5.0.0] - 10 December 2021

- **BREAKING** - Changed the parameter type of `buttonSize` and `childrenButtonSize` from `double` to `Size`.
- Update constraints to flutter 2.8.0 and Dart 2.15 or newer.

## [4.6.6] - 30 October 2021

- Fix web, Platform is not defined
- Fix children buttons not aligned properly
- Update Example

## [4.6.4] - 29 October 2021

- Fix swipe to back not working on IOS due to WillPopScope due to https://github.com/flutter/flutter/issues/14203
- Add `closeDialOnPop` property

## [4.6.2] - 28 October 2021

- Align childrens for button size > 56.
- Automatically close speed dial(if open) on back press

## [4.6.0] - 27 October 2021

- Fix null check operator used on null value due to dialKey.globalPaintBounds being null.

## [4.5.0] - 23 October 2021

- Dispose overlay entry on exit

## [4.4.0+2] - 5 October 2021

- Added the RotationAngle for the Icon Animation

## [4.4.0+1] - 23 September 2021

- Update flutter sdk constraints

## [4.4.0] - 21 September 2021

- Fix lint errors
- Rename speeed dial direction to lowercase
- Disable tooltip if no tooltip is provided

## [4.3.0] - 27 August 2021

- Fix Animation assertion error when using more than 6 SpeedDialChild
- Fix SystemMouseCursors is undefined (#192)
- Fix widget state interaction after dispose (#193)

## [4.2.0] - 28 July 2021

- Fix closeManually
- Add click cursor on desktop and web when speed dial is opened
- Add tooltip to speed dial when overlay is on
- Fix overlay stale context brightness #184

## [4.1.0] - 10 July 2021

- Add isOpenOnStart property
- Fix closing animation not playing if we double click on fab
- Add spacing property to manage space b/w children and speed dial
- Add spaceBetweenChildren and childPadding property by @carlosfiori

## [4.0.0-dev.1] - 29 May 2021

- Update Exanple Project
- Add visibility parameter for SpeedDialChild.
- Fix dialRoot scaling on bigger screen devices.
- Add isOpenOnStart Porperty to set the visiblity of childrens at init ( WIP ).
- Refactor dialRoot to only accept (context, isOpen, toogleChildren), key and layerLink is not required

## [4.0.0-dev] - 19 May 2021

- Update Example Project
- Revamp Whole Codebase by using Overlays instead of stacks
- Update dialRoot and now you specify any widget other then FAB as DialRoot too
- Add Four Directions in SpeedDialDirection parameter namely Up, Down, Left, Right
- Add buttonSize and childrenButtonSize parameter's to set button size for main dial and its childrens
- Use Theme Colors When no color is specified
- Fix weird grey offset
- Fix useRotationAnimation not working
- Fix issues with child and activeChild
- Fix snackbar not visible with SpeedDial
- Fix FloatingActionButtonLocation not working with Speed Dial
- Fix speed Dial doesn't get docked with BottomNavigationBar and BottomAppBar
- Remove unnecessary files

By @prateekmedia and other contributers who helped me in finding the bugs and solving the issues.

## [3.0.5] - 12 Mar 2021

- Fix closing animation by @Amir-P
- Add two new parameters activeBackgroundColor and activeForegroundColor for SpeedDial by @Amir-P

## [3.0.0] - 09 Mar 2021

- Add null safety support by @michalisioak

## [2.3.5] - 06 Mar 2021

- Fix SpeedDial Alignment with respect to its childrens @lks-nbg
- Fix SpeedDialChild is not visible if buttonSize <=50.0 @lks-nbg
- Don't set state if not mounted, Add listeners for openCloseDial @lks-nbg

## [2.3.0] - 04 Mar 2021

- Add Gradient Support
- Fix unclickable FAB label error

## [2.2.0] - 14 Feb 2021

- Add child and activeChild
- Fixed animation b/w non-active and active child's
- Add useInkWell Property if you want to use Inkwell instead of GestureDetector
- Add dialRoot Property to let you specify the root instead of the standard FAB button
- Fixed formatting

## [2.1.1] - 07 Feb 2021

- README fixes

## [2.1.0] - 04 Feb 2021

- Add onLongPress support to SpeedDialChild by @m0veax
- Add key support for both Speed Dial and Speed Dial Child

## [2.0.0+1] - 31 Jan 2021

- Fix Rotation Animation
- Improve visibility and error related to it.
- Add default onTap property to LabelWidget by default by @wongzq.
- Add renderOverlay property to render overlay no matter what.

## [2.0.0] - 30 Jan 2021

- Add Label and activeLabel paramaters to SpeedDial
- Made icon animation work
- Add iconTheme
- Add RTL support by @jacklebbos
- Behave like FAB if no childrens are their by @Ionys320
- Add openCloseDial parameter to programmatically control open and close the dial by @shizambles
- Add option to customize orientation of the child buttons by @hinterlandsupplyco
- Add childMarginBottom and childMarginTop option by @emavgl

## [1.6.0] - 29 Jan 2021

- Updated example project to androidX
- Support borders other than CircularBorder by @m0veax
- buttonSize parameter which defaults to 56 by @dwach414
- Restrict Stack size to button size when closed by @tobilarscheid

## [1.5.0] - 28 Jan 2021

- icon and activeIcon instead of child
- iconTransitionBuilder for custom transitions b/w icons
- Add Dark Mode Support(@esieben1310) + Fix some issues related to it
- Centered child by @raviganwal
- Only Build Speed Dial if childrens are visible by @davidmartos96

## [1.3.0] - 16 Sept 2020

- Used clipBehavior instead of Overflow as This feature was deprecated after v1.22.0-12.0.pre by @irasekh3

## [1.2.5] - 07 Dec 2019

- Control Speed of Animations

## [1.2.4] - 28 Oct 2019

- Fix multiple heroes with same
- Make label non required

## [1.2.3] - 20 Oct 2019

- Fix Label Widget

## [1.2.2] - 18 Oct 2019

- Add Label Widget

## [1.2.1] - 05 June 2019

- Huge Optimization by removing unnecessary Animation Controllers
- Other fixes

## [1.2.0] - 28 May 2019

...

## [0.0.1] - 07 July 2018

- Initial Release
