Install
-------

    git clone https://github.com/openfl/openfl
    haxelib dev openfl _your_path_to_OpenFL_build_
    haxelib install munit
    
Testing
-------------

First, change to the openfl tests directory:

    cd _your_path_to_OpenFL_build_\tests

Next, you can test HTML5 and Flash using munit:

    haxelib run munit test
    
Other targets can be tested using the normal OpenFL test commands and munit test command for specific target:

    lime test windows
    lime test windows -neko
    lime test mac
    lime test mac -neko
    lime test linux
    lime test linux -neko
    lime test ios
    lime test ios -simulator
    lime test android
    lime test blackberry
    lime test blackberry -simulator
	
	haxelib run munit test -js

Contributing
-------------

If you would like to contribute a test, create a fork of the repository, then make a pull request with your addition.

Tests are organized based upon the class, then the method or property which has been tested. This will help us validate across the full API, and when there are problems, will help identify exactly which property or method needs to be improved for the specific target. Remember to remove @Ignore when you finish a test.
