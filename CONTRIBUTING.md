Contributing
------------

Thank you for helping contribute to OpenFL!

Every bug report and pull request helps make OpenFL better :grin:


Reporting Issues
----------------

If you discover any problems while using OpenFL, please let us know!

It is really helpful if you can share some of the following along with your report:

 * Example code we can use to reproduce the problem
 * A screen capture (if the issue is visual)
 * If you are using Haxelib, the current OpenFL, Lime and Haxe version on your system
 * If you are using NPM, the OpenFL version and language (ES6 JS, TS, Haxe, etc) you are using

We are also happy to discuss issues on the OpenFL [community forums](https://community.openfl.org) and on [Discord](https://discord.gg/tDgq8EE).


Writing Code
------------

The best place to start is joining the `#openfl-dev` channel in our [Discord](https://discord.gg/tDgq8EE) server. That's the best way to discuss not only the issue you are trying to solve, but also form a game plan for how to solve it.

As you make quality pull requests, over time we can add you as a contributor to the project. This will give you direct commit rights to the OpenFL `develop` branch on GitHub. Small and large contributions are welcome!


The Purpose of OpenFL
---------------------

Sometimes, there are changes to OpenFL that may raise some questions of the purpose of the library. "I have a neat idea for a new feature," or "I found a difference between Flash and OpenFL" are both important to consider.

We welcome ideas for new features, but often-times a new feature might work better in another library. We would love to discuss your ideas on Discord or the forums! We are careful about adding new features, but welcome the input.

Unimportant differences between OpenFL and Flash Player are considered bugs. We appreciate your help in discovering behaviors! We seek to create a similar environment between Flash and OpenFL, but it is important to know that has never been meant to be a Flash emulator. An emulator tries the duplicate the behavior of another system exactly -- even if it is slow or is considered a bad behavior.

We consider our HTML5 and native platforms to be "first-class citizens" in OpenFL development. As we continue to develop the platform, we want to continue to pursue an ideal working environment to deploy creative content to these platforms.

There are other supported platforms as well (such as AIR, Flash and Neko) which we regularly test, but may lack certain features or have reduced performance. For example, we have added OpenGL-specific features that are not available on Flash. This is okay. Other platforms are not officially supported, but are used by OpenFL developers and we can partner to help integrate important code changes.

As we continue to achieve synergy among our target platforms, we believe that the best contributions will continue to lead towards eliminating issues, improving performance, increasing our testing or the quality of the API documentation, and will move farther from broad feature changes.


Contributor Guidelines
----------------------

Below are some general guidelines we ask contributors to keep in mind in order to make contributing as smooth as possible:

 * Create a new branch off of the develop branch for all new work. This helps to isolate the work and prevent unintended errors from finding their way into develop or master… essentially the *Feature Branch workflow*.

 * When creating a new branch, please consider the following naming conventions:
    + feature/dash-separated-feature-name
    + bugfix/dash-separated-description
    + misc/dash-separated-description

 * Use Dox-friendly comments on all public properties and methods.

 * If new commits are made to develop branch that you require during your work, switch to develop branch, pull those changes, and then do an interactive rebase of your working branch onto develop. This will help to keep (often unrelated) merges from polluting your feature/bugfix branch. For example:

    > git checkout develop
    >
    > git pull
    >
    > git checkout \<your-feature-branch>
    >
    > git rebase -i develop

    If there are any conflict, resolve and add them, then continue the rebase:
    > git add \<file1> \<file2> ...
    >
    > git rebase --continue

 * If there is not a test which already covers the work you are doing and that work has good potential to break something, write a test if you can.

 * Use labels/tags where appropriate and useful.

 * When finished, do an interactive rebase onto develop and resolve any conflicts. Then submit a Pull Request. Be descriptive and include any issue numbers resolved by your PR.

 * Assign a reviewer for your PR if you happen to know another contributor who would be particularly suitable to review your contribution.

 * Once your PR is merged, please look for any outstanding issue reports which may be related and follow up to see if the issue is resolved.

 * At each official release, all merged PR branches which were included in the release should be purged, keeping the repo tidy. If your bugfix/feature branch was not removed, please notify the team.
