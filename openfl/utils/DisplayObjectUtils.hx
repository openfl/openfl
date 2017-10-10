package openfl.utils;

import openfl.display.DisplayObject;
import openfl.utils.UnshrinkableArray;

class DisplayObjectUtils {

    public static function applyToAllChildren (displayObject:DisplayObject, f:DisplayObject -> Void) {

        var toProcessTable = new UnshrinkableArray<DisplayObject> ();
        toProcessTable.push (displayObject);

        while (toProcessTable.length > 0) {
            var current = toProcessTable.pop ();

            f (current);

            if(@:privateAccess current.__children != null)
            {
                toProcessTable.concat (@:privateAccess current.__children);
            }
        }

    }

    public static function stopAllChildren (displayObject:DisplayObject) {

        applyToAllChildren( displayObject, function (child) {
            if (Reflect.field (child, "__playing") == true) {
                Reflect.callMethod (child, Reflect.field (child, "stop"), []);
            }});
    }
}