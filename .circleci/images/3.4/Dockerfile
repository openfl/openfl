FROM haxe:3.4

RUN apt-get update
RUN apt-get install -y libgl1-mesa-dev libglu1-mesa-dev g++ g++-multilib gcc-multilib libasound2-dev libx11-dev libxext-dev libxi-dev libxrandr-dev libxinerama-dev
RUN haxelib install hxcpp
RUN haxelib install format
RUN haxelib install mcover
RUN haxelib install hamcrest
RUN git clone https://github.com/jgranick/MassiveUnit ~/munit --depth 1
RUN haxelib dev munit ~/munit/src
RUN cd ~/munit/tool && haxe build.hxml
